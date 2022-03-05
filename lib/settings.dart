import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _nameFieldController = TextEditingController(text: name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 15),
            child: Text('Settings',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          Expanded(child:
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enabled'),
                  Checkbox(value: enabled, onChanged: (value) {
                    setState(() => enabled = value!);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Lock Movement'),
                  Checkbox(value: movementLocked, onChanged: (value) {
                    setState(() => movementLocked = value!);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Allow Sleep'),
                  Checkbox(value: allowSleep, onChanged: (value) {
                    setState(() => allowSleep = value!);
                    pushData().then(
                            (success) => print('updated: $success')
                    );
                  })
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
              const Padding(padding: EdgeInsets.all(50)),
              OutlinedButton(onPressed: () => {
                Navigator.of(context).popAndPushNamed('/login')
              }, child: const Text('Log Out'))
            ],
          ))
        ],
      ),
    );
  }
}
