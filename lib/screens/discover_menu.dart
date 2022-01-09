import 'package:flutter/material.dart';
import 'package:proyecto_android/screens/discover_tv.dart';
import 'package:proyecto_android/screens/search.dart';
import '../globals.dart' as globals;
import 'discover_movies.dart';

class DiscoverMenu extends StatefulWidget {
  const DiscoverMenu({Key? key}) : super(key: key);

  @override
  _DiscoverMenuState createState() => _DiscoverMenuState();
}

class _DiscoverMenuState extends State<DiscoverMenu> {
  int currentScreen = 0;

  List<Widget> screens = [
    const DiscoverMovies(),
    const DiscoverTV(),
    const DiscoverMovies(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentScreen,
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
        },
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
      body: screens[currentScreen],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const Search();
              },
            ),
          );
        },
        backgroundColor: globals.orange,
        child: const Icon(Icons.search),
      ),
    );
  }
}
