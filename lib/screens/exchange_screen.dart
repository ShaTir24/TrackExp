import 'dart:ui';

import 'package:flutter/material.dart';
import '../widgets/exchange-screen/exchange_fetcher.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key});
  static const name = '/exchange_screen';
  @override
  Widget build(BuildContext context) {
    // get the argument passed from category_card.
    final category = ModalRoute.of(context)!.settings.arguments as String;
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
              title: Text('Your $category'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: ExchangeFetcher(category),
    );
  }
}
