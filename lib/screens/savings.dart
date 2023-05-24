import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackexp/widgets/expense_form.dart';
import '../widgets/savings_screen/savings_fetcher.dart';

class Savings extends StatefulWidget {
  const Savings({super.key});

  static const name = '/savings';

  @override
  State<Savings> createState() => _Savings();
}

class _Savings extends State<Savings> {
  DateTime _date = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 5),
            child: AppBar(
              backgroundColor:
                  Theme.of(context).primaryColorDark.withOpacity(0.7),
              title: const Text('Your Savings'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM dd, yyyy').format(_date),
                style: const TextStyle(fontSize: 20.0, color: Colors.black87),
              ),
              IconButton(
                onPressed: () => _pickDate(),
                icon: const Icon(Icons.calendar_month_rounded),
              ),
            ],
          ),
          SavingsFetcher(_date),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const ExpenseForm(),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
