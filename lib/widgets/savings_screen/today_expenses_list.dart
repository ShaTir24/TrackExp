import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../expense_screen/expense_card.dart';

class TodayExpensesList extends StatelessWidget {
  const TodayExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.present;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (_, i) => ExpenseCard(list[i]),
              )
            : const Center(
                child: Text('No Entries Found'),
              );
      },
    );
  }
}
