import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackexp/constants/transactions.dart';
import 'package:trackexp/models/tx_category.dart';
import '../constants/icons.dart';
import './ex_category.dart';
import './expense.dart';
import 'lendings.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
    // when the value of the search text changes it will notify the widgets.
  }

  double _dailyLimit = 0.0;
  double get dailyLimit => _dailyLimit;

  void updateDailyLimit(double value) {
    _dailyLimit = value;
    notifyListeners();
  }

  double _monthlyLimit = 0.0;
  double get monthlyLimit => _monthlyLimit;

  void updateMonthlyLimit(double value) {
    _monthlyLimit = value;
    notifyListeners();
  }

  // in-app memory for holding the Expense categories temporarily
  List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  List<TransactionCategory> _txCategories = [];

  List<TransactionCategory> get txCategories => _txCategories;

  List<String> _names = [];
  List<String> get names => _names;

  List<Expense> _expenses = [];

  List<Expense> _present = [];
  List<Expense> get present => _present;

  // when the search text is empty, return whole list, else search for the value
  List<Expense> get expenses {
    return _searchText != ''
        ? _expenses
            .where((e) =>
                e.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _expenses;
  }

  List<Lendings> _lending = [];

  List<Map<String, dynamic>> _toDelete = [];

  //when the search text is empty, return the whole list, else search for the name
  List<Lendings> get lendings {
    return _searchText != ''
        ? _lending
            .where(
                (e) => e.name.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _lending;
  }

  Database? _database;

  Future<Database> get database async {
    // database directory
    final dbDirectory = await getDatabasesPath();
    // database name
    const dbName = 'expense_tc.db';
    // full path
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb, // will create this separately
    );

    return _database!;
  }

  // _createDb function
  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';
  static const tTable = 'transactionCategoryTable';
  static const lTable = 'lendingTable';

  Future<void> _createDb(Database db, int version) async {
    // this method runs only once. when the database is being created
    // so create the tables here and if you want to insert some initial values
    // insert it in this function.

    await db.transaction((txn) async {
      // category table
      await txn.execute('''CREATE TABLE $cTable(
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
      )''');
      //transaction category table
      await txn.execute('''CREATE TABLE $tTable(
        name TEXT,
        entries INTEGER,
        totalAmount TEXT
        )''');
      // expense table
      await txn.execute('''CREATE TABLE $eTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        notes TEXT,
        date TEXT,
        category TEXT
      )''');
      //lending table
      await txn.execute('''CREATE TABLE $lTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount TEXT,
        notes TEXT,
        date TEXT,
        category TEXT
      )''');

      // insert the initial categories.
      // this will add all the categories to category table and initialize the 'entries' with 0 and 'totalAmount' to 0.0
      for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }

      // insert the initial categories.
      // this will add all the categories to transactions table and initialize the 'entries' with 0 and 'totalAmount' to 0.0
      for (int i = 0; i < transactions.length; i++) {
        await txn.insert(tTable, {
          'name': transactions.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }
    });
  }

  // method to fetch categories

  Future<List<ExpenseCategory>> fetchCategories() async {
    // get the database
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(cTable).then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'ExpenseCategory' from every 'map' in this 'converted'
        List<ExpenseCategory> nList = List.generate(converted.length,
            (index) => ExpenseCategory.fromString(converted[index]));
        // set the value of 'categories' to 'nList'
        _categories = nList;
        // return the '_categories'
        return _categories;
      });
    });
  }

  Future<List<TransactionCategory>> fetchTxCategories() async {
    // get the database
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(tTable).then((data) {
        // 'data' is our fetched value
        // convert it from "Map<String, object>" to "Map<String, dynamic>"
        final converted = List<Map<String, dynamic>>.from(data);
        // create a 'TransactionCategory' from every 'map' in this 'converted'
        List<TransactionCategory> nList = List.generate(converted.length,
            (index) => TransactionCategory.fromString(converted[index]));
        // set the value of 'categories' to 'nList'
        _txCategories = nList;
        // return the '_categories'
        return _txCategories;
      });
    });
  }

  Future<void> updateCategory(
    String category,
    int nEntries,
    double nTotalAmount,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .update(
        cTable, // category table
        {
          'entries': nEntries, // new value of 'entries'
          'totalAmount': nTotalAmount.toString(), // new value of 'totalAmount'
        },
        where: 'title == ?', // in table where the title ==
        whereArgs: [category], // this category.
      )
          .then((_) {
        // after updating in database. update it in our in-app memory too.
        var file =
            _categories.firstWhere((element) => element.title == category);
        file.entries = nEntries;
        file.totalAmount = nTotalAmount;
        notifyListeners();
      });
    });
  }

  Future<void> updateTxCategory(
    String category,
    int nEntries,
    double nTotalAmount,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .update(
        tTable, // transaction table
        {
          'entries': nEntries, // new value of 'entries'
          'totalAmount': nTotalAmount.toString(), // new value of 'totalAmount'
        },
        where: 'name == ?', // in table where the title ==
        whereArgs: [category], // this category.
      )
          .then((_) {
        // after updating in database. update it in our in-app memory too.
        var file =
            _txCategories.firstWhere((element) => element.name == category);
        file.entries = nEntries;
        file.totalAmount = nTotalAmount;
        notifyListeners();
      });
    });
  }

  // method to add an expense to database

  Future<void> addExpense(Expense exp) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(
        eTable,
        exp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) {
        // after inserting in a database. we store it in in-app memory with new expense with generated id
        final file1 = Expense(
            id: generatedId,
            title: exp.title,
            amount: exp.amount,
            notes: exp.notes,
            date: exp.date,
            category: exp.category);
        // add it to '_expenses'

        _expenses.add(file1);
        // notify the listeners about the change in value of '_expenses'
        notifyListeners();
        // after we inserted the expense, we need to update the 'entries' and 'totalAmount' of the related 'category'
        var ex = findCategory(exp.category);

        updateCategory(
            exp.category, ex.entries + 1, ex.totalAmount + exp.amount);
      });
    });
  }

  Future<void> addLending(Lendings len) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(
        lTable,
        len.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) async {
        // after inserting in a database. we store it in in-app memory with new expense with generated id
        final file2 = Lendings(
            id: generatedId,
            name: len.name,
            amount: len.amount,
            notes: len.notes,
            date: len.date,
            category: len.category);
        // add it to '_lending'

        _lending.add(file2);
        // notify the listeners about the change in value of '_expenses'
        notifyListeners();
        // after we inserted the expense, we need to update the 'entries' and 'totalAmount' of the related 'category'
        var ex = findTxCategory(len.category);
        updateTxCategory(
            len.category, ex.entries + 1, ex.totalAmount + len.amount);

      });
    });
  }

  Future<void> deleteExpense(int expId, String category, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(eTable, where: 'id == ?', whereArgs: [expId]).then((_) {
        // remove from in-app memory too
        _expenses.removeWhere((element) => element.id == expId);
        notifyListeners();
        // we have to update the entries and total amount too
        var ex = findCategory(category);
        updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
      });
    });
  }

  Future<void> deleteLending(
      int lenId, String category, String name, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .delete(lTable, where: 'id == ?', whereArgs: [lenId]).then((_) async {
        // remove from in-app memory too
        _lending.removeWhere((element) => element.id == lenId);
        notifyListeners();
        // we have to update the entries and total amount too
        var ex = findTxCategory(category);
        updateTxCategory(category, ex.entries - 1, ex.totalAmount - amount);
      });
    });
  }

  Future<void> getAndDeletePersonData(String name) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.query(lTable, where: 'name = ?', whereArgs: [name]).then ((data) async {
        final converted = List<Map<String, dynamic>>.from(data);
        _toDelete = converted;
        for (var e in _toDelete) {
          deleteLending(e['id'], e['category'], name, double.parse(e['amount']));
        }
        _toDelete.clear();
        _names.remove(name);
      });
    });
  }

  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable,
          where: 'category == ?', whereArgs: [category]).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        //
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  Future<List<Expense>> fetchDayExpenses(DateTime current) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable,
          where: 'date == ?', whereArgs: [current.toString()]).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        //
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _present = nList;
        return _present;
      });
    });
  }

  Future<List<Lendings>> fetchTransactions(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(lTable,
          where: 'category == ?', whereArgs: [category]).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Lendings> nList = List.generate(
            converted.length, (index) => Lendings.fromString(converted[index]));
        _lending = nList;
        return _lending;
      });
    });
  }

  Future<List<String>> fetchPersonNames() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(lTable, distinct: true, columns: ['name']).then(
          (data) {
            final converted = List<Map<String, dynamic>>.from(data);
            List<String> nList = List.generate(
              converted.length, (index) => converted[index]['name'] as String);
            _names = nList;
            return _names;
          });
    });
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.rawQuery('SELECT * FROM $eTable ORDER BY date DESC').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  Future<List<Lendings>> fetchAllLendings() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(lTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Lendings> nList = List.generate(
            converted.length, (index) => Lendings.fromString(converted[index]));
        _lending = nList;
        return _lending;
      });
    });
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  TransactionCategory findTxCategory(String name) {
    return _txCategories.firstWhere((element) => element.name == name);
  }

  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;
    var list = _expenses.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  Map<String, dynamic> calculateTxAndAmount(String category) {
    double total = 0.0;
    var list = _lending.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  Map<String, dynamic> calculateTransactionPerPerson(
      String name, String category) {
    double total = 0.0;
    var list = _lending.where(
        (element) => element.name == name && element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  double calculateTotalExpenses() {
    return _categories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  double calculateTotalTransactions() {
    return _txCategories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  double calculateDayExpense(DateTime weekDay) {
    double total = 0.0;
    for (int j = 0; j < _expenses.length; j++) {
      if (_expenses[j].date.year == weekDay.year &&
          _expenses[j].date.month == weekDay.month &&
          _expenses[j].date.day == weekDay.day) {
        // if found then add the amount to total
        total += _expenses[j].amount;
      }
    }
    return total;
  }

  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    // we know that we need 7 entries
    for (int i = 0; i < 7; i++) {
      // 1 total for each entry
      double total = 0.0;
      // subtract i from today to get previous dates.
      final weekDay = DateTime.now().subtract(Duration(days: i));

      // check how many expenses happened that day
      total = calculateDayExpense(weekDay);
      // add to a list
      data.add({'day': weekDay, 'amount': total});
    }
    // return the list
    return data;
  }

  List<Map<String, dynamic>> calculateWeekTransactions() {
    List<Map<String, dynamic>> data = [];

    // we know that we need 7 entries
    for (int i = 0; i < 7; i++) {
      // 1 total for each entry
      double total = 0.0;
      // subtract i from today to get previous dates.
      final weekDay = DateTime.now().subtract(Duration(days: i));

      // check how many transactions happened that day
      for (int j = 0; j < _lending.length; j++) {
        if (_lending[j].date.year == weekDay.year &&
            _lending[j].date.month == weekDay.month &&
            _lending[j].date.day == weekDay.day) {
          // if found then add the amount to total
          total += _lending[j].amount;
        }
      }
      // add to a list
      data.add({'day': weekDay, 'amount': total});
    }
    // return the list
    return data;
  }
}
