import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/transactions.dart';
import '../../models/lendings.dart';
import './confirm_box.dart';

class LendingCard extends StatelessWidget {
  final Lendings len;
  const LendingCard(this.len, {super.key});

  @override
  Widget build(BuildContext context) {
    Color textColor = (len.category == 'Lend or Given')
        ? Colors.green
        : ((len.category == 'Gift') ? Theme.of(context).primaryColorDark.withOpacity(0.7) : Colors.red);
    return Dismissible(
      key: ValueKey(len.id),
      confirmDismiss: (_) async {
        showDialog(
          context: context,
          builder: (_) => ConfirmBox(len: len),
        );
      },
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        iconColor: textColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(transactions[len.category],),
        ),
        title: Text(len.name),
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          color: Colors.black87,
        ),
        subtitle: Text(
            "${DateFormat('MMMM dd, yyyy').format(len.date)}\n${len.notes}"),
        subtitleTextStyle: const TextStyle(
            fontSize: 16.0,
            fontStyle: FontStyle.italic
        ),
        onLongPress: () => {ConfirmBox(len: len)},
        isThreeLine: true,
        dense: false,
        leadingAndTrailingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColorDark.withOpacity(0.7),
          fontSize: 20.0,
        ),
        trailing: Text(
            NumberFormat.currency(locale: 'en_IN', symbol: '₹')
                .format(len.amount),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold
            )),
      ),
    );
  }
}