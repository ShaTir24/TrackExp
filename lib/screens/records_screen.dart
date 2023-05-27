import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/records_screen/records_fetcher.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  static const name = '/records';

  @override
  State<Records> createState() => _Records();
}

class _Records extends State<Records> {
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
              title: const Text('Expense History'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: const RecordsFetcher(),
    );
  }
}
