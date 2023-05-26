import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/savings_screen/savings_stats.dart';

import '../../models/database_provider.dart';
import 'current_expense_list.dart';

class SavingsFetcher extends StatefulWidget {
  const SavingsFetcher({super.key});

  @override
  State<SavingsFetcher> createState() => _SavingsFetcherState();
}

class _SavingsFetcherState extends State<SavingsFetcher> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchDayExpenses(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = _getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _allExpensesList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(child: SavingsStats()),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: CurrentExpenseList(),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
