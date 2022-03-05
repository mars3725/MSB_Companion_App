import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '', _password = '';

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // if (widget.auth.currentUser != null) {
    //   Navigator.of(context).pushNamed('/nav');
    // }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Image.asset('assets/logo_alt.png')),
            const Padding(padding: EdgeInsets.all(10)),
            const Text('Robot Companion App', style: TextStyle(fontSize: 32)),
            const Padding(padding: EdgeInsets.all(20)),
            TextField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              controller: _emailFieldController,
              onChanged: (value) {
                setState(() => _email = value);
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextField(
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
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 23),
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
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> logIn() async {
    try {
      await widget.auth.signInWithEmailAndPassword(email: _email, password: _password);
      return true;
    } on FirebaseAuthException catch (exception) {
      print(exception.code);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.code)));
      return false;
    }
  }
}
