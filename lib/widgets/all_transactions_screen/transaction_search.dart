import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class TransactionSearch extends StatefulWidget {
  const TransactionSearch({super.key});

  @override
  State<TransactionSearch> createState() => _TransactionSearchState();
}

class _TransactionSearchState extends State<TransactionSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = value;
      },
      decoration: InputDecoration(
        labelText: 'Search Transactions',
          labelStyle: const TextStyle(
            fontSize: 20,
          ),
          hintText: 'Enter Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          )
      ),
    );
  }
}
