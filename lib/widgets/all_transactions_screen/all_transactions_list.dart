import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../lending_screen/lending_card.dart';

class AllTransactionsList extends StatelessWidget {
  const AllTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.lendings;
        return list.isNotEmpty
            ? ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: list.length,
          itemBuilder: (_, i) => LendingCard(list[i]),
        )
            : const Center(
          child: Text('No Entries Found'),
        );
      },
    );
  }
}
