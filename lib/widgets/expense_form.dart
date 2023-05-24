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
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
        gradient: const LinearGradient(
          colors: [Colors.white54, Colors.white70],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // title
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: 'Title of expense',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount of expense',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _notes,
              decoration: InputDecoration(
                labelText: 'Notes',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Note',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )
              ),
            ),
            const SizedBox(height: 20.0),
            // date picker
            Row(
              children: [
                Expanded(
                  child: Text(_date != null
                      ? DateFormat('MMMM dd, yyyy').format(_date!)
                      : 'Select Date',
                    style: const TextStyle(fontSize: 20.0, color: Colors.black87),
                  ),
                ),
                IconButton(
                  onPressed: () => _pickDate(),
                  icon: const Icon(Icons.calendar_month_rounded),
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
                    dropdownColor: Color.fromARGB(220, 255, 255, 255),
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
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                if (_title.text != '' && _amount.text != '') {
                  // create an expense
                  final file = Expense(
                    id: 0,
                    title: _title.text,
                    amount: double.parse(_amount.text),
                    notes: _notes.text,
                    date: _date != null ? _date! : DateTime.now(),
                    category: _initialValue,
                  );
                  // add it to database.
                  provider.addExpense(file);
                  // close the bottom sheet
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.add),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
