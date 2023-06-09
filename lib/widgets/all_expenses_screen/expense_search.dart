import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class ExpenseSearch extends StatefulWidget {
  const ExpenseSearch({super.key});

  @override
  State<ExpenseSearch> createState() => _ExpenseSearchState();
}

class _ExpenseSearchState extends State<ExpenseSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = value;
      },
      decoration: InputDecoration(
        labelText: 'Search Expenses',
          labelStyle: const TextStyle(
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          hintText: 'Enter Title',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
