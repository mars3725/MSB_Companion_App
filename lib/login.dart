import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 250),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset('assets/logo_alt.png'),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/home');
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text('Sign In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
