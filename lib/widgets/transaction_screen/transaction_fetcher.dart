import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/screens/all_lending.dart';
import 'package:trackexp/widgets/transaction_screen/transaction_list.dart';
import '../../models/database_provider.dart';
import '../../screens/all_names.dart';
import './total_chart.dart';

class TransactionFetcher extends StatefulWidget {
  const TransactionFetcher({super.key});

  @override
  State<TransactionFetcher> createState() => _TransactionFetcherState();
}

class _TransactionFetcherState extends State<TransactionFetcher> {
  late Future _categoryList;

  Future _getTxCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchTxCategories();
  }

  @override
  void initState() {
    super.initState();
    // fetch the list and set it to _categoryList
    _categoryList = _getTxCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // if connection is done then check for errors or return the result
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 250.0,
                    child: TotalChart(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transactions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AllLending.name);
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transactions by Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AllNames.name);
                        },
                        child: const Text('View Names'),
                      ),
                    ],
                  ),
                  const Expanded(child: TransactionList()),
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
