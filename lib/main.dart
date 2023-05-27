import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackexp/screens/all_lending.dart';
import 'package:trackexp/screens/all_names.dart';
import 'package:trackexp/screens/exchange_screen.dart';
import 'package:trackexp/screens/home_screen.dart';
import 'package:trackexp/screens/records_screen.dart';
import 'package:trackexp/screens/savings.dart';
import 'package:trackexp/screens/transaction_screen.dart';
import './models/database_provider.dart';
// screens
import './screens/category_screen.dart';
import './screens/expense_screen.dart';
import './screens/all_expenses.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.name,
      routes: {
        HomeScreen.name: (_) => const HomeScreen(),
        CategoryScreen.name: (_) => const CategoryScreen(),
        ExpenseScreen.name: (_) => const ExpenseScreen(),
        AllExpenses.name: (_) => const AllExpenses(),
        AllLending.name: (_) => const AllLending(),
        TransactionScreen.name: (_) => const TransactionScreen(),
        AllNames.name: (_) => const AllNames(),
        ExchangeScreen.name: (_) => const ExchangeScreen(),
        Savings.name: (_) => const Savings(),
        Records.name: (_) => const Records()
      },
    );
  }
}
