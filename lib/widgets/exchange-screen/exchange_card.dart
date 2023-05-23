import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackexp/constants/transactions.dart';
import 'package:trackexp/models/lendings.dart';
import '../lending_screen/confirm_box.dart';

class ExchangeCard extends StatelessWidget {
  final Lendings len;

  const ExchangeCard(this.len, {super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor = (len.category == 'Lend or Given')
        ? Colors.green
        : ((len.category == 'Gift') ? Colors.black45 : Colors.red);
    return Dismissible(
      key: ValueKey(len.id),
      confirmDismiss: (_) async {
        showDialog(
          context: context,
          builder: (_) => ConfirmBox(len: len),
        );
      },
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            transactions[len.category],
            color: textColor,
          ),
        ),
        title: Text(len.name),
        subtitle: Text(
            "${DateFormat('MMMM dd, yyyy').format(len.date)}\n${len.notes}"),
        //subtitle: Text(DateFormat('MMMM dd, yyyy').format(exp.date)),
        onLongPress: () => {ConfirmBox(len: len)},
        trailing: Text(
          NumberFormat.currency(locale: 'en_IN', symbol: '₹')
              .format(len.amount),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
