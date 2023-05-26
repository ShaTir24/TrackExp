import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/transaction_screen/transaction_card.dart';
import '../../models/database_provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        // get the categories
        var list = db.txCategories;
        return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics()),
            itemCount: list.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: TransactionCard(list[i]),
            ));
      },
    );
  }
}
