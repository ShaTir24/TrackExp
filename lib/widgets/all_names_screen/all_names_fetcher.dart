import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import 'all_names_list.dart';
import 'name_search.dart';

class AllNamesFetcher extends StatefulWidget {
  const AllNamesFetcher({super.key});

  @override
  State<AllNamesFetcher> createState() => _AllNamesFetcherState();
}

class _AllNamesFetcherState extends State<AllNamesFetcher> {
  late Future _allNamesList;

  Future _getAllNames() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllNames();
  }

  @override
  void initState() {
    super.initState();
    _allNamesList = _getAllNames();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allNamesList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  NameSearch(),
                  Expanded(child: AllNamesList()),
                ],
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
