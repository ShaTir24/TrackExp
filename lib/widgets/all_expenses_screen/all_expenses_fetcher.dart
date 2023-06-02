import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/screens/printing_screen.dart';
import '../../models/database_provider.dart';
import '../../screens/savings.dart';
import './all_expenses_list.dart';
import './expense_search.dart';

class AllExpensesFetcher extends StatefulWidget {
  const AllExpensesFetcher({super.key});

  @override
  State<AllExpensesFetcher> createState() => _AllExpensesFetcherState();
}

class _AllExpensesFetcherState extends State<AllExpensesFetcher> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllExpenses();
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
            return Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 50.0),
              child: Column(
                children: [
                  const ExpenseSearch(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 100, 150, 200),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Track Daily Expenses',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(250, 180, 220, 255),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(Savings.name);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'View Savings',
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
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Expanded(child: AllExpensesList()),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(PrintingScreen.name);
                      },
                      icon: const Icon(Icons.picture_as_pdf_rounded),
                      label: const Text(
                        "Generate PDF",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(15.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColorDark.withOpacity(0.7)),
                    ),
                  )
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
