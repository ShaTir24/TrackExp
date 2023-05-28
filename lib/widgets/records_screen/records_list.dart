import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/widgets/records_screen/record_card.dart';
import '../../models/database_provider.dart';

class RecordsList extends StatelessWidget {
  const RecordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.dates;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: RecordCard(list[i]),
                ),
              )
            : const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      size: 150,
                      color: Colors.black38,
                    ),
                    Text(
                      'No Records Found',
                      style: TextStyle(fontSize: 25.0, color: Colors.black45),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
