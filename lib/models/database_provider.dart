import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trackexp/constants/transactions.dart';
import 'package:trackexp/models/tx_category.dart';
import '../constants/icons.dart';
import './ex_category.dart';
import './expense.dart';
import 'lendings.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

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

  // in-app memory for holding the Expense categories temporarily
  List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  List<TransactionCategory> _txCategories = [];

  List<TransactionCategory> get txCategories => _txCategories;

  List<Expense> _expenses = [];

  List<Expense> _present = [];

  List<Expense> get present => _present;

  List<DateTime> _dates = [];

  // when the search text is empty, return whole list, else search for the value
  List<Expense> get expenses {
    return _searchText != ''
        ? _expenses
            .where((e) =>
                e.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _expenses;
  }

  List<DateTime> get dates {
    return _searchText != ''
        ? _dates.where((e) => e.toString().contains(_searchText)).toList()
        : _dates;
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

  List<String> _names = [];

  List<String> get names {
    return _searchText != ''
        ? _names
            .where((e) => e.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _names;
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
      await txn.query(lTable, where: 'name = ?', whereArgs: [name]).then(
          (data) async {
        final converted = List<Map<String, dynamic>>.from(data);
        _toDelete = converted;
        for (var e in _toDelete) {
          deleteLending(
              e['id'], e['category'], name, double.parse(e['amount']));
        }
        _toDelete.clear();
        _names.remove(name);
      });
    });
  }

  Future<void> getAndDeleteDayExpense(DateTime date) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.query(eTable,
          where: 'date = ?', whereArgs: [date.toString()]).then((data) async {
        final converted = List<Map<String, dynamic>>.from(data);
        _toDelete = converted;
        for (var e in _toDelete) {
          deleteExpense(e['id'], e['category'], double.parse(e['amount']));
        }
        _toDelete.clear();
        _dates.remove(date);
      });
    });
  }

  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable,
          where: 'category == ?',
          orderBy: 'date DESC',
          whereArgs: [category]).then((data) {
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
    _present.clear();
    _present.addAll(_expenses.where((element) => element.date == current));
    return _present;
  }

  Future<void> setLimitValue(double limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('dailyLimit', limit);
    _dailyLimit = prefs.getDouble('dailyLimit')!;
    //print(_dailyLimit);
    notifyListeners();
  }

  Future<List<Lendings>> fetchTransactions(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(lTable,
          where: 'category == ?',
          orderBy: 'date DESC',
          whereArgs: [category]).then((data) {
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
      return await txn
          .query(lTable,
              distinct: true, columns: ['name'], orderBy: 'date DESC')
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<String> nList = List.generate(
            converted.length, (index) => converted[index]['name'] as String);
        _names = nList;
        return _names;
      });
    });
  }

  Future<List<DateTime>> fetchDates() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn
          .query(eTable,
              distinct: true, columns: ['date'], orderBy: 'date DESC')
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<DateTime> nList = List.generate(converted.length,
            (index) => DateTime.parse(converted[index]['date']));
        _dates = nList;
        return _dates;
      });
    });
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn
          .rawQuery('SELECT * FROM $eTable ORDER BY date DESC')
          .then((data) {
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
      return await txn.query(lTable, orderBy: 'date DESC').then((data) {
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

  double calculateDayTotalExpense() {
    return _present.fold(
        0.0, (previousValue, element) => previousValue + element.amount);
  }

  double calculateDayExpenses(DateTime weekDay) {
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

  double calculateExpenses() {
    double total = 0.0;
    for (int i = 0; i < _dates.length; i++) {
      total += calculateDayExpenses(_dates[i]);
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
      total = calculateDayExpenses(weekDay);
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

  //PDF generation
  final PdfColor baseColor = PdfColor.fromHex('#065785F5');
  final PdfColor accentColor = PdfColors.blueGrey900;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.blueGrey100;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _totalExp =>
      _expenses.map<double>((p) => p.amount).reduce((a, b) => a + b);

  Future<Uint8List> generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    // final databasePath = await getDatabasesPath();
    // final database = await openDatabase('$databasePath/expense_tc.db');
    // final tableData = await database.query(eTable);

    //generating pdf content
    pdf.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          format,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
        ],
        footer: _buildFooter,
      ),
    );
    //return the pdf file content
    return pdf.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Container(
          height: 50,
          alignment: pw.Alignment.center,
          child: pw.Text(
            'Expense List',
            style: pw.TextStyle(
              color: baseColor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
        pw.Container (
          padding: const pw.EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('TrackExp',
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColors.black,
              ),),
            pw.Text('Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColors.black,
              ),),
          ],
        ),
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.black,
          ),
        ),
        pw.Text(
          '© Copyright, 2023 - Tirth Shah',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(horizontal: 20),
      alignment: pw.Alignment.center,
      height: 45,
      child: pw.FittedBox(
        child: pw.Text(
          'Total: ${NumberFormat.currency(locale: 'en_IN', symbol: 'Rs.').format(_totalExp)}',
          style: pw.TextStyle(
            color: baseColor,
            fontStyle: pw.FontStyle.italic,
            fontSize: 25
          ),
        ),
      ),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Date',
      'Title',
      'Category',
      'Notes',
      'Amount'
    ];

    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _accentTextColor,
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        _expenses.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => _expenses[row].getIndex(col),
        ),
      ),
    );
  }

}

