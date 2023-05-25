import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/savings_screen/savings_stats.dart';

import '../../models/database_provider.dart';
import '../all_expenses_screen/expense_search.dart';
import '../limits_box.dart';

class SavingsFetcher extends StatefulWidget {
  const SavingsFetcher({super.key});

  @override
  State<SavingsFetcher> createState() => _SavingsFetcherState();
}

class _SavingsFetcherState extends State<SavingsFetcher> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchDayExpenses(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = _getAllExpenses();
  }

  DateTime _date = DateTime.now();
  bool showStats = false;

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
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
              return Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          DateFormat('MMMM dd, yyyy').format(_date),
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black87),
                        ),
                        IconButton(
                          onPressed: () {
                            _pickDate();
                            setState(() {
                              showStats = true;
                            });
                          },
                          icon: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                    FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context, builder: (_) => LimitsBox());
                        },
                        icon: const Icon(Icons.currency_rupee_rounded),
                        label: const Text("Set Limits"),
                      ),
                    ),
                    const ExpenseSearch(),
                    SavingsStats(_date),
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
