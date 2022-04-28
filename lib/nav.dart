import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:msb_companion/views/home_view.dart';
import 'package:msb_companion/views/schedule_view.dart';
import 'package:msb_companion/views/settings_view.dart';

import 'data.dart';
import 'views/schedule_view.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

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
      body: (StreamBuilder<DocumentSnapshot>(
          stream: robotDoc!.snapshots(),
          builder: (context, snapshot) {
            print('build');

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: IndexedStack(children: [
                ScheduleView(data: snapshot.data!),
                HomeView(data: snapshot.data!),
                SettingsView(data: snapshot.data!)
              ], index: _selectedIndex),
            );
          }
      )),
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
