import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/tx_category.dart';
import '../../screens/exchange_screen.dart';

class TransactionCard extends StatelessWidget {
  final TransactionCategory category;

  const TransactionCard(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor = (category.name == 'Lend or Given')
        ? Colors.green
        : ((category.name == 'Gift') ? Colors.black45 : Colors.red);
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          ExchangeScreen.name,
          arguments: category.name, // for transaction screen.
        );
      },
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          category.icon,
          color: textColor,
        ),
      ),
      title: Text(category.name),
      subtitle: Text('entries: ${category.entries}'),
      trailing: Text(
        NumberFormat.currency(locale: 'en_IN', symbol: '₹')
            .format(category.totalAmount),
        style: TextStyle(color: textColor),
      ),
    );
  }
}
