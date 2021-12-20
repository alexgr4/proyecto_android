import 'package:flutter/material.dart';
import 'package:proyecto_android/screens/discover_menu.dart';

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
        scaffoldBackgroundColor: const Color(0xFF1A1B1E),
        primaryColor: const Color(0xFFEF774F),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1B1E),
          unselectedIconTheme:
              IconThemeData(color: Color(0xFFA3A5A5), size: 30, opacity: 0.5),
          selectedIconTheme:
              IconThemeData(color: Color(0xFFEF774F), size: 30, opacity: 1),
        ),
      ),
      child: const DiscoverMenu(),
    );
  }
}
