import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data.dart';

class AuthenticateView extends StatefulWidget {
  const AuthenticateView({Key? key}) : super(key: key);

  @override
  _AuthenticateViewState createState() => _AuthenticateViewState();
}

class _AuthenticateViewState extends State<AuthenticateView> {
  bool newUser = false, loading = false;
  String _name = '', _email = '', _password = '', _verifyPassword = '', _robotId = '';

  final _nameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _verifyPasswordFieldController = TextEditingController();
  final _robotIdFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Image.asset('assets/logo.png', color: Theme.of(context).colorScheme.inverseSurface)),
            const Text('Robot Companion App', style: TextStyle(fontSize: 28)),
            const Padding(padding: EdgeInsets.all(20)),
            Visibility(visible: newUser, child: TextField(
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
            )),
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
              textInputAction: newUser? TextInputAction.next : TextInputAction.done,
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
            Visibility(visible: newUser, child: TextField(
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
            )),
            const Padding(padding: EdgeInsets.all(5)),
            Visibility(visible: newUser, child: TextField(
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
            )),
            const Padding(padding: EdgeInsets.all(20)),
            loading? const CircularProgressIndicator() : Column(children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle: const TextStyle(fontSize: 27),
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
                onPressed: () {
                  if (newUser) {
                    if (_password != _verifyPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Password does not match repeat password'), backgroundColor: Colors.red.shade800));
                    } else {
                      setState(()=> loading = true);
                      createAccount().then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Navigator.of(context).popAndPushNamed('/nav');
                        }
                      });
                    }
                  } else {
                    setState(()=> loading = true);
                    logIn().then((success) {
                      if (success) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.of(context).popAndPushNamed('/nav');
                      } else {
                        setState(() => _password = '');
                        setState(() => loading = false);
                      }
                    });
                  }
                },
                child: Text(newUser? 'Create Account' : 'Sign In'),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              const Text('OR', style: TextStyle(fontSize: 18)),
              const Padding(padding: EdgeInsets.all(5)),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    textStyle: const TextStyle(fontSize: 15),
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
                onPressed: () => setState(()=> newUser = !newUser),
                child: Text(newUser? 'Sign In' : 'Create Account'),
              )
            ])
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.code), backgroundColor: Colors.red.shade800));
      return false;
    }
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
