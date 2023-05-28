import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class RecordsSearch extends StatefulWidget {
  const RecordsSearch({super.key});

  @override
  State<RecordsSearch> createState() => _RecordsSearchState();
}

class _RecordsSearchState extends State<RecordsSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = (value);
      },
      decoration: InputDecoration(
        labelText: 'Search Expenses',
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        hintText: 'e.g. 2023-05-20 format',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
