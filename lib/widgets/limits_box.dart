import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class LimitsBox extends StatelessWidget {
  const LimitsBox({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    var _dailyLimit = TextEditingController();
    return AlertDialog(
      backgroundColor: const Color.fromARGB(200, 255, 255, 255),
      elevation: 5,
      title: const Text('Set Limit:'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height*0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _dailyLimit,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Limit',
                labelStyle: const TextStyle(
                  fontSize: 16,
                ),
                hintText: 'Enter Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel',
                    style: TextStyle(
                        fontSize: 20
                    ),),
                ),
                const SizedBox(width: 5.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    provider.setLimitValue(double.parse(_dailyLimit.text));
                  },
                  child: const Text('Set Limit',
                    style: TextStyle(
                        fontSize: 20
                    ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
