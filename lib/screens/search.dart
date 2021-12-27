import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_android/screens/movie_details_old.dart';

import 'movie_details.dart';

Future<List<Movie>> fetchMovieList(String query) async {
  late dynamic response;
  if (query == '') {
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate'));
  } else {
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&query=$query&page=1&include_adult=false'));
  }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = jsonDecode(response.body);
    final results = json['results'];
    return results
        .map((movieJson) => Movie.fromJson(movieJson))
        .toList()
        .cast<Movie>();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Movie {
  final String poster;
  final String title;
  final int id;

  Movie({
    required this.poster,
    required this.title,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return Movie(
      poster: json['poster_path'],
      title: json['original_title'],
      id: json['id'],
    );
  }
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController controller;

  late String query;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    query = '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF774F),
      ),
      backgroundColor: const Color(0xFF1A1B1E),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              onChanged: (text) {
                setState(() {
                  query = text;
                });
                debugPrint(query);
              },
              decoration: const InputDecoration(
                /* border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))), */
                /* focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEF774F), width: 2.0),
                ), */
                labelText: 'Search...',
                filled: true,
                fillColor: Color(0xFF27292e),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFa3a5a5),
                ),
                labelStyle: TextStyle(
                  color: Color(0xFFa3a5a5),
                ),
              ),
            ),
            FutureBuilder<List<Movie>>(
              future: fetchMovieList(query),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                    'Search any movie by query',
                    style: TextStyle(color: Colors.white24),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movies = snapshot.data!;
                return Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                    padding: const EdgeInsets.all(20),
                    children: List.generate(20, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                /* return MovieDetails(id: movies[index].id); */
                                return const MovieDetailsOld();
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: movies[index].poster == 'no_img'
                                    ? const NetworkImage(
                                        'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                    : NetworkImage(
                                        'https://image.tmdb.org/t/p/w500/${movies[index].poster}'),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          margin: const EdgeInsets.only(right: 20),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
