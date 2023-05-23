import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/transactions.dart';
import '../models/database_provider.dart';
import '../constants/icons.dart';
import '../models/expense.dart';
import '../models/lendings.dart';

class LendingForm extends StatefulWidget {
  const LendingForm({super.key});

  @override
  State<LendingForm> createState() => _LendingFormState();
}

class _LendingFormState extends State<LendingForm> {
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _date;
  String _initialValue = 'Gift';

  //
  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // title
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name of Person',
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount of transaction',
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _notes,
              decoration: const InputDecoration(
                labelText: 'Notes',
              ),
            ),
            const SizedBox(height: 20.0),
            // date picker
            Row(
              children: [
                Expanded(
                  child: Text(_date != null
                      ? DateFormat('MMMM dd, yyyy').format(_date!)
                      : 'Select Date'),
                ),
                IconButton(
                  onPressed: () => _pickDate(),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // category
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(child: Text('Category')),
                Expanded(
                  child: DropdownButton(
                    items: transactions.keys
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                        .toList(),
                    value: _initialValue,
                    onChanged: (newValue) {
                      setState(() {
                        _initialValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                if (_name.text != '' && _amount.text != '') {
                  // create an expense
                  final file = Lendings(
                    id: 0,
                    name: _name.text,
                    amount: double.parse(_amount.text),
                    notes: _notes.text,
                    date: _date != null ? _date! : DateTime.now(),
                    category: _initialValue,
                  );
                  // add it to database.
                  provider.addLending(file);
                  // close the bottom sheet
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Information'),
            ),
          ],
        ),
      ),
    );
  }
}
