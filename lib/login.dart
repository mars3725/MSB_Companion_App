import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'data.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '', _password = '';

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Image.asset('assets/logo.png', color: Theme.of(context).colorScheme.inverseSurface)),
            const Text('Robot Companion App', style: TextStyle(fontSize: 28)),
            const Padding(padding: EdgeInsets.all(20)),
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
              textInputAction: TextInputAction.done,
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
            const Padding(padding: EdgeInsets.all(20)),
            Visibility(visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      textStyle: const TextStyle(fontSize: 27),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () {
                    logIn().then((success) {
                      if (success) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.of(context).popAndPushNamed('/nav');
                      } else {
                        setState(() => _password = '');
                      }
                    });
                  },
                  child: const Text('Login'),
                )
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Visibility(visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: const Text('OR', style: TextStyle(fontSize: 18))
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Visibility(visible: MediaQuery.of(context).viewInsets.bottom == 0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      textStyle: const TextStyle(fontSize: 15),
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  onPressed: () => Navigator.of(context).popAndPushNamed('/create'),
                  child: const Text('Create Account'),
                )
            )
          ],
        ),
      ),
    );
  }

  Future<bool> logIn() async {
    try {
      UserCredential userCred =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      userDoc = FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid.toString());
      DocumentSnapshot userSnapshot = await userDoc!.get();
      robotDoc = FirebaseFirestore.instance.collection('robots').doc(userSnapshot.get('robot_id'));
      return true;

    } on FirebaseAuthException catch (exception) {
      print(exception.code);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.code), backgroundColor: Colors.red.shade800));
      return false;
    }
  }
}
