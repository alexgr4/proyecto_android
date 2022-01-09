import 'package:flutter/material.dart';
import 'package:proyecto_android/screens/discover_menu.dart';
import '../globals.dart' as globals;

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'MadeTommy',
        scaffoldBackgroundColor: globals.darkGrey,
        primaryColor: globals.orange,
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: globals.darkGrey,
          unselectedIconTheme:
              IconThemeData(color: globals.lightGrey, size: 30, opacity: 0.5),
          selectedIconTheme:
              IconThemeData(color: globals.orange, size: 30, opacity: 1),
        ),
      ),
      child: const DiscoverMenu(),
    );
  }
}
