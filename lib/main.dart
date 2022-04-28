import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'nav.dart';
import 'views/authenticate_view.dart';

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

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode themeMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: themeMode,
            initialRoute: '/login',
            routes: {
              "/login": (context)=> const AuthenticateView(),
              "/nav": (context)=> const Nav(),
            },
          );
        });
  }
}
