import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class NameSearch extends StatefulWidget {
  const NameSearch({super.key});

  @override
  State<NameSearch> createState() => _NameSearchState();
}

class _NameSearchState extends State<NameSearch> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        provider.searchText = value;
      },
      decoration: const InputDecoration(
        labelText: 'Search Names',
      ),
    );
  }
}
