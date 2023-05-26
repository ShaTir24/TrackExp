import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import './expense_card.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var exList = db.expenses;
        return exList.isNotEmpty
            ? ListView.builder(
                itemCount: exList.length,
                itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpenseCard(exList[i]),
                    ))
            : const Center(
                child: Column(
                children: [
                  Icon(
                    Icons.not_interested_rounded,
                    size: 150,
                    color: Colors.black38,
                  ),
                  Text(
                    'No Expenses Found',
                    style: TextStyle(fontSize: 25.0, color: Colors.black45),
                  ),
                ],
              ));
      },
    );
  }
}
