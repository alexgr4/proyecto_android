import 'dart:async';
import 'dart:convert';
import 'package:flutter/painting.dart';

import '../globals.dart' as globals;
import 'package:proyecto_android/screens/tv_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'movie_details.dart';

Future<List<Movie>> fetchMovieList(String query, bool movie) async {
  late dynamic response;
  if (movie) {
    if (query == '') {
      response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&query=$query&page=1&include_adult=false'));
    }
  } else {
    if (query == '') {
      response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/discover/tv?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/tv?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&query=$query&page=1&include_adult=false'));
    }
  }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = jsonDecode(response.body);
    final results = json['results'];
    globals.search_length = results.length;

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
  final String? poster;
  final int id;

  Movie({
    required this.poster,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return Movie(poster: json['poster_path'], id: json['id']);
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
  bool isMovie = true;

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
        backgroundColor: globals.orange,
      ),
      backgroundColor: globals.darkGrey,
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
              decoration: InputDecoration(
                /* border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))), */
                /* focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFEF774F), width: 2.0),
                ), */
                labelText: 'Search...',
                filled: true,
                fillColor: globals.grey,
                prefixIcon: Icon(
                  Icons.search,
                  color: globals.lightGrey,
                ),
                labelStyle: TextStyle(
                  color: globals.lightGrey,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMovie = true;
                      });
                    },
                    child: Container(
                      color: isMovie ? globals.orange : Colors.transparent,
                      child: const Center(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Movies",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMovie = false;
                      });
                    },
                    child: Container(
                      color: !isMovie ? globals.orange : Colors.transparent,
                      child: const Center(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "TV Shows",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Movie>>(
              future: fetchMovieList(query, isMovie),
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
                    children: List.generate(globals.search_length, (index) {
                      return GestureDetector(
                        onTap: () {
                          if (isMovie) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return MovieDetails(id: movies[index].id);
                                },
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return TVDetails(id: movies[index].id);
                                },
                              ),
                            );
                          }
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
