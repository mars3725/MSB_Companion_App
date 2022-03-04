import 'package:flutter/material.dart';
import 'package:msb_companion/home.dart';
import 'package:msb_companion/schedule.dart';
import 'package:msb_companion/settings.dart';

import 'schedule.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);
  static const widgetOptions = [
    Schedule(),
    Home(),
    Settings()
  ];

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: Nav.widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
              label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
              label: ''
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        iconSize: 52,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
