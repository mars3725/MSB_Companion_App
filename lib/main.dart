import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:msb_companion/data.dart';
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
  MyApp({Key? key}) : super(key: key);
  final _lightTheme = ThemeData.from(colorScheme: ColorScheme.light(
      primary: Colors.green.shade800,
      secondary: Colors.white70));

  final _darkTheme = ThemeData.from(colorScheme: ColorScheme.dark(
      primary: Colors.green.shade800,
      secondary: Colors.black87));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'Flutter Demo',
      theme: darkMode? _darkTheme : _lightTheme,
      initialRoute: '/login',
      routes: {
        "/login": (context)=> Login(),
        "/nav": (context)=> const Nav()
      },
    );
  }
}
