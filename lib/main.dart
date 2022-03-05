import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'nav.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'Flutter Demo',
      theme: ThemeData.from(colorScheme: ColorScheme.dark(
          primary: Colors.green.shade800,
          secondary: Colors.black87)),
      initialRoute: '/login',
      routes: {
        "/login": (context)=> Login(),
        "/home": (context)=> const Nav()
      },
    );
  }
}
