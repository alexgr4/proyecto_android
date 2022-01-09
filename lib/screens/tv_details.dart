import 'package:flutter/material.dart';
import '../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<TVShow> fetchMovieDetails(int id) async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/tv/$id?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = jsonDecode(response.body);
    /* final results = json['json']; */
    return TVShow.fromJson(json);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class TVShow {
  final String poster;
  final String title;
  final String overview;
  final double rating;
  final String releaseDate;
  final List genres;
  final String? lastAir;

  TVShow({
    required this.poster,
    required this.title,
    required this.overview,
    required this.rating,
    required this.releaseDate,
    required this.genres,
    required this.lastAir,
  });

  factory TVShow.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return TVShow(
      poster: json['poster_path'],
      title: json['name'],
      overview: json['overview'],
      rating: json['vote_average'],
      releaseDate: json['first_air_date'],
      genres: json['genres'],
      lastAir: json['last_air_date'],
    );
  }
}

class TVDetails extends StatefulWidget {
  final int id;
  const TVDetails({Key? key, required this.id}) : super(key: key);

  @override
  _TVDetailsState createState() => _TVDetailsState();
}

class _TVDetailsState extends State<TVDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TVShow>(
        future: fetchMovieDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final movies = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500/${movies.poster}'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: globals.orange,
              ),
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 340,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    globals.darkGrey.withOpacity(0.0),
                                    globals.darkGrey,
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
                                    globals.darkGrey.withOpacity(0.0),
                                    globals.darkGrey.withOpacity(0.3),
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
                                    globals.darkGrey.withOpacity(0.0),
                                    globals.darkGrey.withOpacity(0.3),
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
                                  Center(
                                    child: Text(
                                      movies.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (int i = 0;
                                            i < movies.rating / 2.round();
                                            i++)
                                          Icon(
                                            Icons.star_rounded,
                                            color: globals.orange,
                                          ),
                                        for (int i = 0;
                                            i <= 4 - movies.rating / 2.round();
                                            i++)
                                          Icon(
                                            Icons.star_outline_rounded,
                                            color: globals.orange,
                                          )
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${movies.releaseDate.substring(0, 4)} - ${movies.lastAir?.substring(0, 4)}',
                                          style: const TextStyle(
                                            color: Color(0xFFa3a5a5),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        const Text(
                                          '|',
                                          style: TextStyle(
                                            color: Color(0xFFa3a5a5),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        for (int i = 0;
                                            i < movies.genres.length - 1;
                                            i++)
                                          Text(
                                            '${movies.genres[i]['name']}, ',
                                            style: const TextStyle(
                                              color: Color(0xFFa3a5a5),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        Text(
                                          movies.genres.last['name'],
                                          style: const TextStyle(
                                            color: Color(0xFFa3a5a5),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ])
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: globals.darkGrey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 30, 15, 80),
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
                            Expanded(
                              child: Text(
                                movies.overview,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
