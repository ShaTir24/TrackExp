import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/models/lendings.dart';
import '../../models/database_provider.dart';

class ConfirmBox extends StatelessWidget {
  const ConfirmBox({
    Key? key,
    required this.len,
  }) : super(key: key);

  final Lendings len;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      title: Text('Delete Transaction related to ${len.name} ?'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // dont delete
            },
            child: const Text('Don\'t delete'),
          ),
          const SizedBox(width: 5.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // delete
              provider.deleteLending(len.id, len.category, len.name, len.amount);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
