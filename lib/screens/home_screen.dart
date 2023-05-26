import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trackexp/screens/category_screen.dart';
import 'package:trackexp/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const name = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CategoryScreen(),     //
    const TransactionScreen(),  //
  ];

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
              backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
              title: const Text('TrackExp'),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
              centerTitle: true,
              elevation: 0.1,
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Theme.of(context).primaryColorDark.withOpacity(0.7),
        selectedFontSize: 16.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_rounded),
            label: 'Lend/Due',
          ),
        ],
      ),
    );
  }
}
