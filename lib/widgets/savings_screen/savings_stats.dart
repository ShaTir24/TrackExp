import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../limits_box.dart';

class SavingsStats extends StatefulWidget {
  final DateTime current;

  const SavingsStats(this.current, {super.key});

  @override
  State<SavingsStats> createState() => _SavingsStatsState();
}

class _SavingsStatsState extends State<SavingsStats> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var total = db.calculateTotalExpenses();
      var dailyLimit = db.dailyLimit;
      var monthlyLimit = db.monthlyLimit;
      var currentExpenses = db.calculateDayExpense(widget.current);
      var diff = dailyLimit - currentExpenses;
      String message = '';
      Color disp = Colors.indigo;
      if(diff > 0) {
        message = 'You are within your budget!\nYour Savings amount: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff)}.\n';
        disp = Colors.green;
      } else if(diff < 0) {
        message = 'You are exceeding your budget by ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(diff*-1)}\nConsidering spending less!\n';
        disp = Colors.red;
      } else {
        message = 'You are on your budget, Neither saving nor overspending!\n';
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(
              flex: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Savings for ${DateFormat('MMMM dd, yyyy').format(widget.current)}',
                      textScaleFactor: 1.25,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Total Expenses(till date): ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(total)}',
                      textScaleFactor: 1.25,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Daily Limit: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(dailyLimit)}',
                      textScaleFactor: 1.25,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Monthly Limit: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(monthlyLimit)}',
                      textScaleFactor: 1.25,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    flex: 50,
                    child: Column(
                      children: [
                        FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(context: context, builder: (_) => LimitsBox());
                            },
                            icon: const Icon(Icons.currency_rupee_rounded),
                            label: const Text("Set Limits"),
                          ),
                        ),
                        FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            message,
                            textScaleFactor: 1.25,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: disp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
