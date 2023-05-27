import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/models/database_provider.dart';
import 'package:trackexp/widgets/records_screen/confirm_box.dart';

class RecordCard extends StatefulWidget {
  final DateTime date;

  const RecordCard(this.date, {super.key});

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {

      var dayExpense = db.calculateDayExpenses(widget.date);
      var dailyLimit = db.dailyLimit;

      double diff = dailyLimit - dayExpense;
      String message = 'N/A';
      Color textColor = Theme.of(context).primaryColorDark.withOpacity(0.7);
      Color backgroundCol = Theme.of(context).primaryColorLight.withOpacity(0.5);
      IconData disp = Icons.not_interested_rounded;
      if (dailyLimit > 0) {
        if (diff > 0) {
          message =
          '+${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff)}';
          textColor = Colors.green;
          backgroundCol = const Color.fromARGB(200, 180, 255, 180);
          disp = Icons.arrow_upward_rounded;
        } else if (diff < 0) {
          message =
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff);
          textColor = Colors.red;
          backgroundCol = const Color.fromARGB(200, 255, 180, 180);
          disp = Icons.arrow_downward_rounded;
        }
      }

      return Dismissible(
          key: ValueKey(widget.date),
          confirmDismiss: (_) async {
            showDialog(
              context: context,
              builder: (_) => ConfirmBox(date: widget.date),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      tileColor: backgroundCol,
                      titleAlignment: ListTileTitleAlignment.center,
                      iconColor: textColor,
                      leading: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.calendar_today_rounded),
                      ),
                      title: Text(DateFormat('MMMM dd, yyyy').format(widget.date),),
                      titleTextStyle: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.black87,
                      ),
                      subtitle: RichText(
                          text: TextSpan(
                              text: 'Details:\n',
                              style: const TextStyle(color: Colors.black45),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                    "Daily Limit: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(dailyLimit)}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                    "\nDaily Expense: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(dayExpense)}",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ])),
                      isThreeLine: true,
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
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
                      ),
                    )
                  ]),
            )
          ]));
    });
  }
}
