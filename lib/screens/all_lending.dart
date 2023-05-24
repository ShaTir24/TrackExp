import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trackexp/widgets/all_transactions_screen/all_transactions_fetcher.dart';

import '../widgets/lending_form.dart';

class AllLending extends StatefulWidget {
  const AllLending({super.key});
  static const name = '/all_lending';

  @override
  State<AllLending> createState() => _AllLendingState();
}

class _AllLendingState extends State<AllLending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 5),
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
              title: const Text('All Transactions'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: const AllTransactionsFetcher(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const LendingForm(),
          );
        },
        child: const Icon(Icons.currency_rupee_rounded),
      ),
    );
  }
}
