import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ex_category.dart';
import '../../screens/expense_screen.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  const CategoryCard(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          ExpenseScreen.name,
          arguments: category.title, // for expenses screen.
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      iconColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(category.icon),
      ),
      title: Text(category.title),
      titleTextStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.black87,
      ),
      titleAlignment: ListTileTitleAlignment.center,
      subtitle: Text('entries: ${category.entries}'),
      subtitleTextStyle: const TextStyle(
          fontSize: 18.0,
          fontStyle: FontStyle.italic
      ),
      isThreeLine: false,
      leadingAndTrailingTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColorDark.withOpacity(0.7),
        fontSize: 20.0,
      ),
      trailing: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹')
            .format(category.totalAmount)),
      ),
    );
  }
}
