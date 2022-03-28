import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'data.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _name = '', _email = '', _password = '', _verifyPassword = '', _robotId = '';

  final _nameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _verifyPasswordFieldController = TextEditingController();
  final _robotIdFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          IconButton(onPressed: ()=> Navigator.of(context).popAndPushNamed('/login'), icon: const Icon(Icons.close), iconSize: 48),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 100),
              children: [
                const Text('Create Account', style: TextStyle(fontSize: 28)),
                const Padding(padding: EdgeInsets.all(20)),
                TextField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  controller: _nameFieldController,
                  onChanged: (value) {
                    setState(() => _name = value);
                  },
                ),
                const Padding(padding: EdgeInsets.all(5)),
                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  controller: _emailFieldController,
                  onChanged: (value) {
                    setState(() => _email = value);
                  },
                ),
                const Padding(padding: EdgeInsets.all(5)),
                TextField(
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: _passwordFieldController,
                  onChanged: (value) {
                    setState(() => _password = value);
                  },
                ),
                const Padding(padding: EdgeInsets.all(5)),
                TextField(
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat Password',
                  ),
                  controller: _verifyPasswordFieldController,
                  onChanged: (value) {
                    setState(() => _verifyPassword = value);
                  },
                ),
                const Padding(padding: EdgeInsets.all(5)),
                TextField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Robot ID',
                  ),
                  controller: _robotIdFieldController,
                  onChanged: (value) {
                    setState(() => _robotId = value);
                  },
                ),
                const Padding(padding: EdgeInsets.all(20)),
                MediaQuery.of(context).viewInsets.bottom == 0? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 23),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    if (_password != _verifyPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Password does not match repeat password'), backgroundColor: Colors.red.shade800));
                    }
                    createAccount().then((success) {
                      if (success) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.of(context).popAndPushNamed('/nav');
                      }
                    });
                  },
                  child: const Text('Create'),
                ) : Container(),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<bool> createAccount() async {
    try {
      UserCredential userCred =  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

      userDoc = FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid.toString());
      robotDoc = FirebaseFirestore.instance.collection('robots').doc(_robotId);
      DocumentSnapshot robotSnapshot = await robotDoc!.get();

      if (robotSnapshot.exists) {
        userDoc!.set({
          "name": _name,
          "email": _email,
          "robot_id": _robotId
        });
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Robot ID not found'), backgroundColor: Colors.red.shade800));
        return false;
      }

    } on FirebaseAuthException catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.code), backgroundColor: Colors.red.shade800));
      return false;
    }
  }
}
