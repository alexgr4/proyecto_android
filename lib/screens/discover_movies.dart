import 'package:flutter/material.dart';

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({Key? key}) : super(key: key);

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
        body: ListView(
          children: const [
            Section(title: "Trending"),
            Section(title: "Best of 2021"),
            Section(title: "2000s"),
            Section(title: "1990s"),
            Section(title: "1980s"),
            Section(title: "Retro"),
            Section(title: "Family time"),
            Section(title: "Great action"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  const Section({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 30, 12, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              for (int i = 0; i < 20; i++)
                Container(
                  width: 100,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF2BC1B),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.only(right: 10),
                ),
            ],
          ),
        )
      ],
    );
  }
}
