import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../name_screen/name_card.dart';

class AllNamesList extends StatelessWidget {
  const AllNamesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.names;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NameCard(list[i]),
                ),
              )
            : const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      size: 150,
                    ),
                    Text(
                      'No Names Found',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
