class Lendings {
  final int id; // unique id for every expense
  final String name; // what are we spending on
  final double amount; // how much are we spending
  final DateTime date; // when are we spending
  final String category; // which category on we spending
  final String notes; //additional notes on the expense

  // constructor
  Lendings({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
  });

  // 'Expense' to 'Map'
  Map<String, dynamic> toMap() => {
    // id will generate automatically
    'name': name,
    'amount': amount.toString(),
    'notes': notes,
    'date': date.toString(),
    'category': category,
  };

  // 'Map' to 'Expense'
  factory Lendings.fromString(Map<String, dynamic> value) => Lendings(
      id: value['id'],
      name: value['name'],
      amount: double.parse(value['amount']),
      notes: value['notes'],
      date: DateTime.parse(value['date']),
      category: value['category']);
}