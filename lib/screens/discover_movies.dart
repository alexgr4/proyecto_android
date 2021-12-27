import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_android/screens/movie_details.dart';
import 'package:proyecto_android/screens/movie_details_old.dart';

Future<List<Movie>> fetchMovieList(int list) async {
  late String url = '';
  switch (list) {
    case 1:
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate';
      break;
    case 2:
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2000&with_watch_monetization_types=flatrate';
      break;
    case 3:
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2002&with_watch_monetization_types=flatrate';
      break;
    case 4:
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2004&with_watch_monetization_types=flatrate';
      break;
    case 5:
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2006&with_watch_monetization_types=flatrate';
      break;
    case 6:
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2008&with_watch_monetization_types=flatrate';
      break;
    default:
  }
  final response = await http.get(Uri.parse(url));

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
    return Movie(
      poster: json['poster_path'],
      title: json['original_title'],
      id: json['id'],
    );
  }
}

class DiscoverMovies extends StatelessWidget {
  const DiscoverMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12.0, 30, 12, 12),
              child: Text(
                "Trending",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Movie>>(
                future: fetchMovieList(1),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final movies = snapshot.data!;
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 12),
                      for (int i = 0; i < 20; i++)
                        GestureDetector(
                          onTap: () {
                            debugPrint(movies[i].poster);
                          },
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500/${movies[i].poster}'),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            margin: const EdgeInsets.only(right: 20),
                          ),
                        ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
        const Section(title: "Trending", list: 2),
        const Section(
          title: "Best of 2021",
          list: 3,
        ),
        const Section(
          title: "2000s",
          list: 4,
        ),
        const Section(
          title: "1990s",
          list: 5,
        ),
        const Section(
          title: "1980s",
          list: 6,
        ),
        /* const Section(
          title: "Retro",
          list: 7,
        ),
        const Section(
          title: "Family time",
          list: 8,
        ),
        const Section(
          title: "Great action",
          list: 9,
        ), */
        const SizedBox(height: 20),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final int list;
  const Section({
    Key? key,
    required this.title,
    required this.list,
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
          height: 200,
          child: FutureBuilder<List<Movie>>(
            future: fetchMovieList(list),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final movies = snapshot.data!;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 12),
                  for (int i = 0; i < 20; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              /* return MovieDetails(id: movies[i].id); */
                              return const MovieDetailsOld();
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500/${movies[i].poster}'),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        margin: const EdgeInsets.only(right: 20),
                      ),
                    ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
