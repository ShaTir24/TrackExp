import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/database_provider.dart';
import '../constants/icons.dart';
import '../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _date;
  String _initialValue = 'Other';

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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 75.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.5),
        ),
        child: Column(
          children: [
            const Text(
              "Add an Expense",
              style: TextStyle(
                fontSize: 25.0,
                fontFamily: 'Roboto'
              ),
            ),
            const SizedBox(height: 20.0),
            // title
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: 'Title of expense',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                icon: const Icon(Icons.account_balance_wallet_rounded),
                iconColor: Theme.of(context).primaryColorDark
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount of expense',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  icon: const Icon(Icons.currency_rupee_rounded),
                  iconColor: Theme.of(context).primaryColorDark
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _notes,
              decoration: InputDecoration(
                labelText: 'Notes',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Note',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  icon: const Icon(Icons.notes),
                  iconColor: Theme.of(context).primaryColorDark
              ),
            ),
            const SizedBox(height: 20.0),
            // date picker
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: IconButton(
                    onPressed: () => _pickDate(),
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Theme.of(context).primaryColorDark.withOpacity(0.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      child: Text(_date != null
                          ? DateFormat('MMMM dd, yyyy').format(_date!)
                          : 'Select Date',
                        style: const TextStyle(fontSize: 20.0, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // category
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(child: Text('Category',
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                )),
                Expanded(
                  child: DropdownButton(
                    items: icons.keys
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    elevation: 4,
                    dropdownColor: const Color.fromARGB(220, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
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
            const SizedBox(height: 50.0),
            ElevatedButton.icon(
              onPressed: () {
                if (_title.text != '' && _amount.text != '') {
                  // create an expense
                  DateTime finalDate = DateTime(_date!.year, _date!.month, _date!.day);
                  final file = Expense(
                    id: 0,
                    title: _title.text,
                    amount: double.parse(_amount.text),
                    notes: _notes.text,
                    date: _date != null ? finalDate : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    category: _initialValue,
                  );
                  // add it to database.
                  provider.addExpense(file);
                  // close the bottom sheet
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Expense',
                style: TextStyle(
                  fontSize: 20,
                ),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColorDark.withOpacity(0.7)
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
