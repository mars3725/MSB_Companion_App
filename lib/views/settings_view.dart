import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import '../main.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key, required this.data}) : super(key: key);
  final DocumentSnapshot data;

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _nameFieldController = TextEditingController();
  final _activityFieldController = TextEditingController();
  double volume = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 15),
            child: Text('Settings',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          Expanded(child:
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            children: [
              const Text('Robot Options',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
              ),
              const Padding(padding: EdgeInsets.all(10)),
              TextField(
                decoration: const InputDecoration(label: Text('Name')),
                controller: _nameFieldController,
                onChanged: (value) {
                  robotDoc!.update({
                    "name": value
                  });
                },
              ),
              Row(
                children: [
                  Checkbox(value: widget.data.get('allowMovement'),
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                        robotDoc!.update({
                          "allowMovement": value
                        });
                      }),
                  const Text('Allow Movement')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Volume'),
                  Slider(value: volume,
                    onChanged: (value) {
                      setState(()=> volume = value);
                    },
                    onChangeEnd: (value) {
                      robotDoc!.update({
                        "volume": double.parse(volume.toStringAsFixed(2))
                      });
                    },
                  )
                ],
              ),
              TextField(
                decoration: const InputDecoration(label: Text('Activity Url')),
                controller: _activityFieldController,
                onChanged: (value) {
                  robotDoc!.update({
                    "activityUrl": value
                  });
                },
              ),
              const Padding(padding: EdgeInsets.all(25)),
              const Text('App Options',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Row(
                children: [
                  Checkbox(value: inDarkMode(),
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                        MyApp.themeNotifier.value =
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? ThemeMode.dark
                            : ThemeMode.light;
                      }),
                  const Text('Dark Mode')
                ],
              ),
              const Padding(padding: EdgeInsets.all(30)),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).popAndPushNamed('/login');
                  }, child: const Text('Log Out')),
              const Padding(padding: EdgeInsets.all(25)),
            ],
          ))
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _nameFieldController.text = widget.data.get('name');
    _activityFieldController.text = widget.data.get('activityUrl');
    volume = widget.data.get('volume');
  }

  bool inDarkMode() {
    switch (MyApp.themeNotifier.value) {
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }
}
