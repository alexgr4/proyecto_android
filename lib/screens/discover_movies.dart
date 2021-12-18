import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    debugPrint(response.body);
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String poster;
  final String title;

  Album({
    required this.poster,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      poster: json['poster_path'],
      title: json['original_title'],
    );
  }
}

class DiscoverMovies extends StatefulWidget {
  const DiscoverMovies({Key? key}) : super(key: key);

  @override
  _DiscoverMoviesState createState() => _DiscoverMoviesState();
}

class _DiscoverMoviesState extends State<DiscoverMovies> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, json) {
            if (json.hasData) {
              return Text(json.data!.title);
            } else if (json.hasError) {
              return Text('${json.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
        const Section(title: "Trending"),
        const Section(title: "Best of 2021"),
        const Section(title: "2000s"),
        const Section(title: "1990s"),
        const Section(title: "1980s"),
        const Section(title: "Retro"),
        const Section(title: "Family time"),
        const Section(title: "Great action"),
        const SizedBox(height: 20),
      ],
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
