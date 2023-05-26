import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/database_provider.dart';
import 'exchange_chart.dart';
import 'exchange_list.dart';

class ExchangeFetcher extends StatefulWidget {
  final String category;
  const ExchangeFetcher(this.category, {super.key});

  @override
  State<ExchangeFetcher> createState() => _ExchangeFetcherState();
}

class _ExchangeFetcherState extends State<ExchangeFetcher> {
  late Future _exchangeList;
  Future _getExpenseList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchTransactions(widget.category);
  }

  @override
  void initState() {
    super.initState();
    _exchangeList = _getExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _exchangeList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 250.0,
                    child: ExchangeChart(widget.category),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Expanded(child: ExchangeList()),
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