import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/limits_box.dart';
import '../../models/database_provider.dart';

class TotalChart extends StatefulWidget {
  const TotalChart({super.key});

  @override
  State<TotalChart> createState() => _TotalChartState();
}

class _TotalChartState extends State<TotalChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var list = db.categories;
      var total = db.calculateTotalExpenses();
      var dailyLimit = db.dailyLimit;
      var monthlyLimit = db.monthlyLimit;
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(
              flex: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Total Expenses: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(total)}',
                      textScaleFactor: 1.25,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...list.map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Container(
                            width: 8.0,
                            height: 8.0,
                            color: Colors.primaries[list.indexOf(e)],
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            e.title,
                          ),
                          const SizedBox(width: 5.0),
                          Text(total == 0
                              ? '0%'
                              : '${((e.totalAmount / total) * 100).toStringAsFixed(2)}%'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 40,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(context: context, builder: (_) => LimitsBox());
                    },
                    icon: const Icon(Icons.currency_rupee_rounded),
                    label: const Text("Set Limits"),
                  ),
                  Expanded(
                    flex: 75,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 20.0,
                        sections: total != 0
                            ? list
                                .map(
                                  (e) => PieChartSectionData(
                                    showTitle: false,
                                    value: e.totalAmount,
                                    color: Colors.primaries[list.indexOf(e)],
                                  ),
                                )
                                .toList()
                            : list
                                .map(
                                  (e) => PieChartSectionData(
                                    showTitle: false,
                                    color: Colors.primaries[list.indexOf(e)],
                                  ),
                                )
                                .toList(),
                      ),
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
