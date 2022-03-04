import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
            Image.asset('assets/logo.png'),
            const Center(
              child: Text('To improve the lives of patients with Alzheimer’s disease and related dementias',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/home');
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/google.png', width: 25),
                    const Padding(padding: EdgeInsets.all(5)),
                    const Text('Sign In')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
