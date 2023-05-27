import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/records_screen/records_list.dart';
import '../../models/database_provider.dart';

class RecordsFetcher extends StatefulWidget {
  const RecordsFetcher({super.key});

  @override
  State<RecordsFetcher> createState() => _RecordsFetcherState();
}

class _RecordsFetcherState extends State<RecordsFetcher> {
  late Future _allDates;

  Future _getAllDates() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchDates();
  }

  @override
  void initState() {
    super.initState();
    _allDates = _getAllDates();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allDates,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 70.0),
              child: RecordsList(),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}