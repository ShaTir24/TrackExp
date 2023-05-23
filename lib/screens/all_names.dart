import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/all_names_screen/all_names_fetcher.dart';

class AllNames extends StatefulWidget {
  const AllNames({super.key});
  static const name = '/all_names';

  @override
  State<AllNames> createState() => _AllNamesState();
}

class _AllNamesState extends State<AllNames> {
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
              title: const Text('People'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: const AllNamesFetcher(),
    );
  }
}
