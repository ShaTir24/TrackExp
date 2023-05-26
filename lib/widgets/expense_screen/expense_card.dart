import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/icons.dart';
import '../../models/expense.dart';
import './confirm_box.dart';

class ExpenseCard extends StatelessWidget {
  final Expense exp;
  const ExpenseCard(this.exp, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(exp.id),
      confirmDismiss: (_) async {
        showDialog(
          context: context,
          builder: (_) => ConfirmBox(exp: exp),
        );
      },
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        iconColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icons[exp.category]),
        ),
        title: Text(exp.title),
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          color: Colors.black87,
        ),
        titleAlignment: ListTileTitleAlignment.center,
        subtitle: Text("${DateFormat('MMMM dd, yyyy').format(exp.date)}\n${exp.notes}"),
        subtitleTextStyle: const TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.italic
        ),
        //subtitle: Text(DateFormat('MMMM dd, yyyy').format(exp.date)),
        onLongPress: () => {ConfirmBox(exp: exp)},
        isThreeLine: true,
        dense: false,
        leadingAndTrailingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColorDark.withOpacity(0.7),
          fontSize: 20.0,
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(NumberFormat.currency(locale: 'en_IN', symbol: '₹')
              .format(exp.amount)),
        ),
      ),
    );
  }
}
