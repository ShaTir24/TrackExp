import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/savings_screen/savings_fetcher.dart';

class Savings extends StatefulWidget {
  const Savings({super.key});

  static const name = '/savings';

  @override
  State<Savings> createState() => _Savings();
}

class _Savings extends State<Savings> {
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
              backgroundColor:
                  Theme.of(context).primaryColorDark.withOpacity(0.7),
              title: const Text('Today\'s Expense Report'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: const SavingsFetcher(),
    );
  }
}
