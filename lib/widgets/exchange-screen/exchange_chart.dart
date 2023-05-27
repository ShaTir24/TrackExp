import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/database_provider.dart';

class ExchangeChart extends StatefulWidget {
  final String category;
  const ExchangeChart(this.category, {super.key});

  @override
  State<ExchangeChart> createState() => _ExchangeChartState();
}

class _ExchangeChartState extends State<ExchangeChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var maxY = db.calculateTxAndAmount(widget.category)['totalAmount'];
      var list = db.calculateWeekTransactions().reversed.toList();
      return BarChart(
        BarChartData(
          minY: 0,
          maxY: maxY + 10.0,
          backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
          barGroups: [
            ...list.map(
                  (e) => BarChartGroupData(
                x: list.indexOf(e),
                barRods: [
                  BarChartRodData(
                    toY: e['amount'],
                    width: 20.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ],
              ),
            ),
          ],
          alignment: BarChartAlignment.spaceEvenly,
          gridData:
          FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              drawBehindEverything: true,
            ),
            leftTitles: AxisTitles(
              drawBehindEverything: true,
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 38.0
                ),
            ),
            rightTitles: AxisTitles(
              drawBehindEverything: true,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) =>
                    Text(DateFormat.E().format(list[value.toInt()]['day']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
              ),
            ),
          ),
        ),
      );
    });
  }
}