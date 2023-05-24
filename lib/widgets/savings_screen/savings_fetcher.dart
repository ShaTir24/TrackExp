import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/savings_screen/savings_stats.dart';
import 'package:trackexp/widgets/savings_screen/today_expenses_list.dart';

import '../../models/database_provider.dart';
import '../all_expenses_screen/expense_search.dart';

class SavingsFetcher extends StatefulWidget {
  final DateTime current;

  const SavingsFetcher(this.current, {super.key});

  @override
  State<SavingsFetcher> createState() => _SavingsFetcherState();
}

class _SavingsFetcherState extends State<SavingsFetcher> {
  late Future _expenseList;

  Future _getCurrentValue() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return _expenseList = provider.fetchDayExpenses(widget.current);
  }

  @override
  void initState() {
    super.initState();
    _expenseList = _getCurrentValue();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _expenseList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
              child: Column(
                children: [
                  const ExpenseSearch(),
                  SizedBox(height: 250, child: SavingsStats(widget.current)),
                  const Expanded(child: TodayExpensesList()),
                ],
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
