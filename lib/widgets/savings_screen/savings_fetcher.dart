import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/savings_screen/savings_stats.dart';

import '../../models/database_provider.dart';
import '../../screens/records_screen.dart';
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
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
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
                                color: Theme.of(context).primaryColorDark.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              margin: const EdgeInsets.only(
                                left: 5.0
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
                                      backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.9),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                                'View History',
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
                      height: 10.0,
                    ),
                    const SizedBox(
                      height: 190,
                       child: SavingsStats()
                    ),
                    const SizedBox(
                      height: 10.0,
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
