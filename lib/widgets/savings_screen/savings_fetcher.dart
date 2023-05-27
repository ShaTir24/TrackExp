import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    var _dailyLimit = TextEditingController();
    return FutureBuilder(
        future: _allExpensesList,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              DateFormat('MMMM dd, yyyy').format(DateTime.now()),
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                            ),
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(250, 180, 220, 255),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              final provider = Provider.of<DatabaseProvider>(
                                  context,
                                  listen: false);
                              provider
                                  .setLimitValue(double.parse(_dailyLimit.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  dismissDirection: DismissDirection.startToEnd,
                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                  closeIconColor: Theme.of(context).primaryColorLight,
                                  backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
                                  content: const Text('Limit Set Successfully',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),),
                                  elevation: 5,
                                  showCloseIcon: true,
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Set Limit',
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
                    ),
                    const SizedBox(
                      height: 280,
                        child: SavingsStats()
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Expanded(
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
