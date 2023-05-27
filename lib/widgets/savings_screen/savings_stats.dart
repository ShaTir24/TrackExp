import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../../screens/records_screen.dart';

class SavingsStats extends StatefulWidget {
  const SavingsStats({super.key});

  @override
  State<SavingsStats> createState() => _SavingsStatsState();
}

class _SavingsStatsState extends State<SavingsStats> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      double dailyLimit = db.dailyLimit;
      String message = 'Set the Expense Limits to view the Savings Stats.';
      Color disp = Theme.of(context).primaryColorDark;
      Color backCol = Theme.of(context).primaryColorLight.withOpacity(0.5);
      var currentExpenses = db.calculateDayTotalExpense();

      if (dailyLimit != 0.0) {
        double diff = dailyLimit - currentExpenses;
        if (diff > 0) {
          message =
              'You\'re within the Budget!\nYour Savings are: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff)}';
          disp = Colors.green;
          backCol = const Color.fromARGB(220, 190, 250, 190);
        } else if (diff < 0) {
          message =
              'You\'re tight with your Budget!\nYour Overspent amount is: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff * -1)}';
          disp = Colors.red;
          backCol = const Color.fromARGB(220, 250, 190, 190);
        }
      }

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(200, 220, 220, 220),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: Text(message,
                                textScaleFactor: 1.25,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: disp,
                                    fontSize: 20.0)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(250, 180, 220, 255),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(Records.name);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'View Past Days\' History',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
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
