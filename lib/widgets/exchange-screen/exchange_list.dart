import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import 'exchange_card.dart';

class ExchangeList extends StatelessWidget {
  const ExchangeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var exList = db.lendings;
        return exList.isNotEmpty
            ? ListView.builder(
                itemCount: exList.length,
                itemBuilder: (_, i) => ExchangeCard(exList[i]))
            : const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      size: 150,
                      color: Colors.black38,
                    ),
                    Text(
                      'No Transactions Found',
                      style: TextStyle(fontSize: 25.0, color: Colors.black45),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
