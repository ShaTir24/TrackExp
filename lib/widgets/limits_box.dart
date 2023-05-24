import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class LimitsBox extends StatelessWidget {

  final _daily = TextEditingController();
  final _monthly = TextEditingController();

  LimitsBox({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      title: const Text('Enter the Value to Set Expense Limits?'),
      content: SizedBox(
        height: 226,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _daily,
              decoration: InputDecoration(
                label: const Text('Daily Expense Limit:'),
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                )
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _monthly,
              decoration: InputDecoration(
                  label: const Text('Monthly Expense Limit:'),
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // dont delete
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      provider.updateDailyLimit(double.parse(_daily.text));
                      provider.updateMonthlyLimit(double.parse(_monthly.text));
                    },
                    icon: const Icon(
                      Icons.check_circle_rounded
                    ),
                    label: const Text('Set Limits')),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      )
    );
  }
}
