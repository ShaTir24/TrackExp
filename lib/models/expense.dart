import 'package:intl/intl.dart';

class Expense {
  final int id; // unique id for every expense
  final String title; // what are we spending on
  final double amount; // how much are we spending
  final DateTime date; // when are we spending
  final String category; // which category on we spending
  final String notes; //additional notes on the expense

  // constructor
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
  });

  // 'Expense' to 'Map'
  Map<String, dynamic> toMap() => {
        // id will generate automatically
        'title': title,
        'amount': amount.toString(),
        'notes': notes,
        'date': date.toString(),
        'category': category,
      };

  // 'Map' to 'Expense'
  factory Expense.fromString(Map<String, dynamic> value) => Expense(
      id: value['id'],
      title: value['title'],
      amount: double.parse(value['amount']),
      notes: value['notes'],
      date: DateTime.parse(value['date']),
      category: value['category']);

  String getIndex(int col) {
    switch(col) {
      case 0:
        return DateFormat('MMMM dd, yyyy').format(date);
      case 1:
        return title;
      case 2:
        return category;
      case 3:
        return notes;
      case 4:
        return NumberFormat.currency(locale: 'en_IN', symbol: 'Rs.').format(amount);
      default:
        return '';
    }
  }
}