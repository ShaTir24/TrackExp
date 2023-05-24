import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/models/database_provider.dart';
import './confirm_box.dart';

class NameCard extends StatefulWidget {
  final String name;

  const NameCard(this.name, {super.key});

  @override
  State<NameCard> createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var totalCredit = db.calculateTransactionPerPerson(
          widget.name, 'Lend or Given')['totalAmount'];
      var totalDebit = db.calculateTransactionPerPerson(
          widget.name, 'Debit or Due')['totalAmount'];
      var totalGift =
          db.calculateTransactionPerPerson(widget.name, 'Gift')['totalAmount'];

      double diff = totalCredit - totalDebit;
      String message = 'Clear';
      Color textColor = Colors.lightBlue;
      IconData disp = Icons.thumb_up_rounded;
      if (diff > 0) {
        message =
            '+${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff)}';
        textColor = Colors.green;
        disp = Icons.call_received_rounded;
      } else if (diff < 0) {
        message =
            '${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff)}';
        textColor = Colors.red;
        disp = Icons.call_made_rounded;
      }

      return Dismissible(
          key: ValueKey(widget.name),
          confirmDismiss: (_) async {
            showDialog(
              context: context,
              builder: (_) => ConfirmBox(name: widget.name),
            );
          },
          child: Row(children: [
            Expanded(
              flex: 60,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_rounded),
                      ),
                      title: Text(widget.name),
                      subtitle: RichText(
                          text: TextSpan(
                              text: 'Transactions:\n',
                              style: const TextStyle(color: Colors.black45),
                              children: <TextSpan>[
                            TextSpan(
                                text:
                                    "Total Credit (to take): ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(totalCredit)}",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "\nTotal Debit (to give): ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(totalDebit)}\n",
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "Total Gift (donated): ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(totalGift)}\n",
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold)),
                            // TextSpan(
                            //     text: '$message\n',
                            //     style: TextStyle(
                            //         color: textColor,
                            //         fontWeight: FontWeight.bold))
                          ])),
                      trailing: Column(
                        children: [
                          Icon(
                            disp,
                            color: textColor,
                          ),
                          Text(
                            message,
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  ]),
            )
          ]));
    });
  }
}
