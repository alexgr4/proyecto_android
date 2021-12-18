import 'package:flutter/material.dart';
import 'package:proyecto_android/screens/discover_movies.dart';

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
        scaffoldBackgroundColor: const Color(0xFF1E2940),
        primaryColor: const Color(0xFFF2BC1B),
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF2BC1B),
          unselectedIconTheme:
              IconThemeData(color: Color(0xFF1E2940), size: 30, opacity: 0.5),
          selectedIconTheme:
              IconThemeData(color: Color(0xFF1E2940), size: 30, opacity: 1),
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: 'TV Shows',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: const DiscoverMovies(),
      ),
    );
  }
}
