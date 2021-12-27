import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Movie>> fetchMovieDetails(int id) async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/movie/$id?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US'));

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
  final String overview;
  final double rating;

  Movie({
    required this.poster,
    required this.title,
    required this.overview,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return Movie(
      poster: json['poster_path'],
      title: json['original_title'],
      overview: json['overview'],
      rating: json['vote_average'],
    );
  }
}

class MovieDetails extends StatefulWidget {
  final int id;
  const MovieDetails({Key? key, required this.id}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF774F),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: const Color(0xFFEF774F),
        activeBackgroundColor: Colors.black,
        icon: Icons.add,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.remove_red_eye),
            /*backgroundColor: getColor(Colors.white, Colors.orange), */
            onTap: () {
              debugPrint('visto');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.watch_later),
          )
        ],
      ),
      backgroundColor: const Color(0xFF1A1B1E),
      body: FutureBuilder<List<Movie>>(
          future: fetchMovieDetails(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final movies = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                          /* decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500/${movies.poster}'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ), */
                          ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  const Color(0xFF1A1B1E).withOpacity(0.0),
                                  const Color(0xFF1A1B1E),
                                ],
                                stops: const [
                                  0.0,
                                  1.0
                                ])),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.centerLeft,
                                end: FractionalOffset.centerRight,
                                colors: [
                                  const Color(0xFF1A1B1E).withOpacity(0.0),
                                  const Color(0xFF1A1B1E).withOpacity(0.3),
                                ],
                                stops: const [
                                  0.0,
                                  1.0
                                ])),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.centerRight,
                                end: FractionalOffset.centerLeft,
                                colors: [
                                  const Color(0xFF1A1B1E).withOpacity(0.0),
                                  const Color(0xFF1A1B1E).withOpacity(0.3),
                                ],
                                stops: const [
                                  0.0,
                                  1.0
                                ])),
                      ),
                      Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                const Center(
                                  child: Text(
                                    'Spider-Man: No way home',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Color(0xFFEF774F),
                                        ),
                                      const Icon(
                                        Icons.star_outline_rounded,
                                        color: Color(0xFFEF774F),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      '2021',
                                      style: TextStyle(
                                        color: Color(0xFFa3a5a5),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      '|',
                                      style: TextStyle(
                                        color: Color(0xFFa3a5a5),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      'Sci-fi, Action, Comedy',
                                      style: TextStyle(
                                        color: Color(0xFFa3a5a5),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ])
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 80),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Text(
                            'Eu sit ut fugiat elit. Sint id laborum laborum sit commodo quis pariatur duis. Id amet magna nostrud adipisicing dolor ex pariatur eu. Laboris excepteur commodo incididunt labore tempor tempor ullamco eu. Sit commodo occaecat tempor tempor aliquip et. Nulla anim anim ullamco aliquip duis. Eiusmod anim sunt Lorem sint quis consequat ea proident. Quis laborum voluptate ipsum reprehenderit qui reprehenderit amet non amet nisi nostrud officia enim fugiat. Minim culpa do occaecat et sit et enim cupidatat eiusmod. Velit anim nulla laborum velit exercitation velit tempor dolore aute eiusmod. Laboris pariatur proident cillum sint ut veniam consequat aute aute sit aliqua sit anim. Mollit culpa dolor commodo irure ea nulla. Culpa ipsum est mollit qui ad id veniam cillum sint irure.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    });
  }
}
