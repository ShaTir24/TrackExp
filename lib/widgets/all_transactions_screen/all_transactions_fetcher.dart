import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/all_transactions_screen/all_transactions_list.dart';
import 'package:trackexp/widgets/all_transactions_screen/transaction_search.dart';
import '../../models/database_provider.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: const [
                  TransactionSearch(),
                  Expanded(child: AllTransactionsList()),
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
