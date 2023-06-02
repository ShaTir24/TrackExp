import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/models/database_provider.dart';


class PrintingScreen extends StatefulWidget {
  const PrintingScreen({Key? key}) : super(key: key);

  static const name = '/printing';

  @override
  State<PrintingScreen> createState() => _PrintingScreenState();
}

class _PrintingScreenState extends State<PrintingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 5),
            child: AppBar(
              backgroundColor:
              Theme.of(context).primaryColorDark.withOpacity(0.7),
              title: const Text('Print Expenses'),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: PdfPreview(
        build: (format) async {
          final provider = Provider.of<DatabaseProvider>(context, listen: false);
          return provider.generatePdf(format);
          },
      ),
    );
  }
}
