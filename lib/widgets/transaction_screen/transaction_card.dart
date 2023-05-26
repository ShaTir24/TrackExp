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
        : ((category.name == 'Gift') ? Theme.of(context).primaryColorDark.withOpacity(0.7) : Colors.red);

    Color backColor = (category.name == 'Lend or Given')
        ? const Color.fromARGB(200, 180, 255, 180)
        : ((category.name == 'Gift') ? Theme.of(context).primaryColorLight.withOpacity(0.5)
        : const Color.fromARGB(200, 255, 180, 180));

    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          ExchangeScreen.name,
          arguments: category.name, // for transaction screen.
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      iconColor: textColor,
      tileColor: backColor,
      titleAlignment: ListTileTitleAlignment.center,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          category.icon,
        ),
      ),
      title: Text(category.name),
      titleTextStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.black87,
      ),
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
      trailing: Text(
        NumberFormat.currency(locale: 'en_IN', symbol: '₹')
            .format(category.totalAmount),
        style: TextStyle(color: textColor),
      ),
    );
  }
}
