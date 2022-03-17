import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _nameFieldController = TextEditingController(text: name);

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).platformBrightness);
    print(MyApp.themeNotifier.value);

    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 50),
            child: Text('Settings',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          Expanded(child:
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            children: [
              const Text('Robot Options',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
              ),
              TextField(
                decoration: const InputDecoration(label: Text('Name')),
                controller: _nameFieldController,
                onChanged: (value) {
                  setState(() => name = value);
                  pushData().then(
                          (success) => print('updated: $success')
                  );
                },
              ),
              Row(
                children: [
                  Checkbox(value: enabled,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                    setState(() => enabled = value!);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  }),
                  const Text('Enabled')
                ],
              ),
              Row(
                children: [
                  Checkbox(value: movementLocked,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                    setState(() => movementLocked = value!);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  }),
                  const Text('Lock Movement')
                ],
              ),
              Row(
                children: [
                  Checkbox(value: allowSleep,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                    setState(() => allowSleep = value!);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  }),
                  const Text('Allow Sleep')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Volume'),
                  Slider(value: volume, onChanged: (value) {
                    setState(() => volume = value);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  })
                ],
              ),
              const Padding(padding: EdgeInsets.all(25)),
              const Text('App Options',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
              ),
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
              Row(
                children: [
                  Checkbox(value: offlineMode,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                    setState(() => offlineMode = value!);
                  }),
                  const Text('Offline Mode')
                ],
              ),
              const Padding(padding: EdgeInsets.all(50)),
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
