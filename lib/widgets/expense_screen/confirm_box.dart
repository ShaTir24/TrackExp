import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../../models/expense.dart';

class ConfirmBox extends StatelessWidget {
  const ConfirmBox({
    Key? key,
    required this.exp,
  }) : super(key: key);

  final Expense exp;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      backgroundColor: Color.fromARGB(200, 255, 255, 255),
      elevation: 5,
      title: Text('Delete ${exp.title} ?'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // dont delete
            },
            child: const Text('Don\'t delete',
              style: TextStyle(
                  fontSize: 20
              ),),
          ),
          const SizedBox(width: 5.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // delete
              provider.deleteExpense(exp.id, exp.category, exp.amount);
            },
            child: const Text('Delete',
              style: TextStyle(
                  fontSize: 20
              ),),
          ),
        ],
      ),
    );
  }
}
