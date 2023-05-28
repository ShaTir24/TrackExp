import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../all_transactions_screen/transaction_search.dart';
import 'all_names_list.dart';

class AllNamesFetcher extends StatefulWidget {
  const AllNamesFetcher({super.key});

  @override
  State<AllNamesFetcher> createState() => _AllNamesFetcherState();
}

class _AllNamesFetcherState extends State<AllNamesFetcher> {
  late Future _allNamesList;

  Future _getAllNames() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchPersonNames();
  }

  @override
  void initState() {
    super.initState();
    _allNamesList = _getAllNames();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allNamesList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Stack(
              children: [
                const Positioned(child: Padding(
                  padding: EdgeInsets.only(
                      top: 70.0
                  ),
                  child: AllNamesList(),
                )),
                Positioned(child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        color: Colors.white,
                        child: const TransactionSearch()),
                  ),
                )),
              ],
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}