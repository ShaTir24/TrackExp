import 'package:flutter/material.dart';
import '../widgets/lending_form.dart';
import '../widgets/transaction_screen/transaction_fetcher.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});
  static const name = '/transaction_screen'; // for routes
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const TransactionFetcher(),
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
