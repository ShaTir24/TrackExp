import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/models/database_provider.dart';
import '../../models/lendings.dart';

class NameCard extends StatefulWidget {
  final Lendings len;

  const NameCard(this.len, {super.key});

  @override
  State<NameCard> createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  @override
  Widget build(BuildContext context) {

    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var namesList = db.names;
      double getTransactionPerPerson(String name, String category) {
        return db.calculateTransactionPerPerson(name, category)['totalAmount'];
      }
      return Row(children: [
        Expanded(
          flex: 60,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                ...namesList.map((e) => ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_rounded),
                      ),
                      title: Text(e.name),
                      subtitle: RichText(
                          text: TextSpan(
                          text: 'Transactions:\n',
                          style: const TextStyle(color: Colors.black45),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Total Credit (to take): ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(getTransactionPerPerson(e.name, "Lend or Given"))}",
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: "\nTotal Debit (to give): ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(getTransactionPerPerson(e.name, "Debit or Due"))}\n",
                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                            )
                          ]))
                    ))
              ]),
        )
      ]);
    });
  }
}
