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
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (drag) {
          if (!drag.primaryVelocity!.isNegative && _selectedIndex > 0) {
            setState(() => _selectedIndex--);
          } else if (drag.primaryVelocity!.isNegative && _selectedIndex < 2) {
            setState(() => _selectedIndex++);
          }
        },
        child: Nav.widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).colorScheme.primary),
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
