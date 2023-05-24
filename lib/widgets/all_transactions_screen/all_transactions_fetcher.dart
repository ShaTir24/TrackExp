import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/all_transactions_screen/all_transactions_list.dart';
import 'package:trackexp/widgets/all_transactions_screen/transaction_search.dart';
import '../../models/database_provider.dart';
import '../../screens/all_names.dart';

class AllTransactionsFetcher extends StatefulWidget {
  const AllTransactionsFetcher({super.key});

  @override
  State<AllTransactionsFetcher> createState() => _AllTransactionsFetcherState();
}

class _AllTransactionsFetcherState extends State<AllTransactionsFetcher> {
  late Future _allTransactionsList;

  Future _getAllTransactions() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllLendings();
  }

  @override
  void initState() {
    super.initState();
    _allTransactionsList = _getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allTransactionsList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 70.0),
              child: Column(
                children: [
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
                  const TransactionSearch(),
                  const Expanded(child: AllTransactionsList()),
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
