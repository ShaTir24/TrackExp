import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/records_screen/records_list.dart';
import 'package:trackexp/widgets/records_screen/records_search.dart';
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
            return Stack(
              children: [
                const Positioned(child: Padding(
                  padding: EdgeInsets.only(
                    top: 70.0
                  ),
                  child: RecordsList(),
                )),
                Positioned(child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        color: Colors.white,
                        child: const RecordsSearch()),
                  ),
                )),
              ],
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}