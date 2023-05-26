import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class SavingsStats extends StatefulWidget {

  const SavingsStats({super.key});

  @override
  State<SavingsStats> createState() => _SavingsStatsState();
}

class _SavingsStatsState extends State<SavingsStats> {

  @override
  Widget build(BuildContext context) {

    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var _dailyLimit = TextEditingController();
      double dailyLimit = 0.0;
      String message = 'Set the Expense Limits to view the Savings Stats.';
      Color disp = Theme.of(context).primaryColorDark;
      Color backCol = Theme.of(context).primaryColorLight.withOpacity(0.5);
      var currentExpenses = db.calculateDayTotalExpense();
      bool setVisibility = false;

      void setMessages() {
        if (dailyLimit != 0.0) {
          double diff = dailyLimit - currentExpenses;
          if (diff > 0) {
            message =
            'You\'re within the Budget!\nYour Savings are: ${NumberFormat
                .currency(locale: 'en_IN', symbol: '₹').format(diff)}';
            disp = Colors.green;
            backCol = const Color.fromARGB(220, 190, 250, 190);
          } else if (diff < 0) {
            message =
            'You\'re tight with your Budget!\nYour Overspent amount is: ${NumberFormat
                .currency(locale: 'en_IN', symbol: '₹').format(diff * -1)}';
            disp = Colors.red;
            backCol = const Color.fromARGB(220, 250, 190, 190);
          }
        }
      }

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(250, 180, 220, 255),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      DateFormat('MMMM dd, yyyy')
                          .format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _dailyLimit,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Daily Limit',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(Icons.currency_rupee_rounded),
                    ),
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context)
                        .primaryColorDark
                        .withOpacity(0.7),
                  ),
                ),
                onPressed: () async {
                  db.setLimitValue(double.parse(_dailyLimit.text));
                  setVisibility = true;
                },
                icon: const Icon(
                  Icons.add_task_rounded,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Set Limit",
                    style: TextStyle(fontSize: 20.0,),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(200, 220, 220, 220),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Expenses Today: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(currentExpenses)}',
                          textScaleFactor: 1.25,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      if(setVisibility)
                      FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Daily Limit: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(dailyLimit)}',
                          textScaleFactor: 1.25,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        child: Container(
                          decoration: BoxDecoration(
                            color: backCol,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(message,
                                textScaleFactor: 1.25,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: disp,
                                    fontSize: 20.0)),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      );
    });
  }
}
