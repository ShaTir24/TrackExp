import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../constants/transactions.dart';
import '../models/database_provider.dart';
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
              controller: _name,
              decoration: InputDecoration(
                  labelText: 'Name of Person',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Amount of transaction',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
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
                  )),
            ),
            const SizedBox(height: 20.0),
            // date picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _date != null
                      ? DateFormat('MMMM dd, yyyy').format(_date!)
                      : 'Select Date',
                  style: const TextStyle(fontSize: 20.0, color: Colors.black87),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                    child: Text(
                  'Category',
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                )),
                DropdownButton(
                  items: transactions.keys
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
              icon: const Icon(Icons.add, size: 30,),
              label: const Text('Add Information',
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
