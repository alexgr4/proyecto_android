import 'package:flutter/material.dart';

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: ListView(
          children: const [
            Section(title: "Novetats"),
            Section(title: "Seguir mirant"),
            Section(title: "Secció 1"),
            Section(title: "Secció 2"),
            Section(title: "Secció 3"),
            Section(title: "Secció 4"),
            Section(title: "Secció 5"),
            Section(title: "Secció 6"),
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
          padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              for (int i = 0; i < 20; i++)
                Container(
                  width: 60,
                  color: Colors.grey,
                  child: Center(child: Text("$i")),
                  margin: const EdgeInsets.only(right: 10),
                ),
            ],
          ),
        )
      ],
    );
  }
}
