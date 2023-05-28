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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 75.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.5),
        ),
        child: Column(
          children: [
            const Text(
              "Add a Transaction",
              style: TextStyle(fontSize: 25.0, fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 20.0),
            // title
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Name of Person',
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
                hintText: 'Enter Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                icon: const Icon(Icons.person_rounded),
                iconColor: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 20.0),
            // amount
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount of transaction',
                labelStyle: const TextStyle(
                  fontSize: 20,
                ),
                hintText: 'Enter Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                icon: const Icon(Icons.currency_rupee_rounded),
                iconColor: Theme.of(context).primaryColorDark,
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
                iconColor: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 20.0),
            // date picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color:
                    Theme.of(context).primaryColorDark.withOpacity(0.4),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    child: Text(
                      _date != null
                          ? DateFormat('MMMM dd, yyyy').format(_date!)
                          : 'Select Date',
                      style: const TextStyle(
                          fontSize: 20.0, color: Colors.black87),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _pickDate(),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(15.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColorDark.withOpacity(0.7)),
                    ),
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: const Text(
                      'Pick Date',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
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
                  dropdownColor: const Color.fromARGB(200, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30.0),
                  value: _initialValue,
                  onChanged: (newValue) {
                    setState(() {
                      _initialValue = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 35.0),
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
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
              label: const Text(
                'Add Information',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.all(15.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColorDark.withOpacity(0.7)),
              ),
            ),
            const SizedBox(
              height: 35.0,
            )
          ],
        ),
      ),
    );
  }
}
