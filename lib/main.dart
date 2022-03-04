import 'package:flutter/material.dart';

import 'nav.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.green.shade800,
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
          bottomAppBarColor: Colors.grey.shade900
      ),
      initialRoute: '/login',
      routes: {
        "/login": (context)=> const Login(),
        "/home": (context)=> const Nav()
      },
    );
  }
}
