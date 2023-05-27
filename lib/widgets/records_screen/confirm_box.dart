import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class ConfirmBox extends StatelessWidget {
  const ConfirmBox({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      backgroundColor: const Color.fromARGB(200, 255, 255, 255),
      elevation: 5,
      title: Text('Delete All Expenses on ${DateFormat('MMMM dd, yyyy').format(date)} ?'),
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
              provider.getAndDeleteDayExpense(DateTime(date.year, date.month, date.day));
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
