import 'dart:async';
import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_android/screens/tv_details.dart';

Future<List<Movie>> fetchMovieList(String endpoint) async {
  const String base =
      'https://api.themoviedb.org/3/discover/tv?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate';
  final String endpoints = endpoint;
  late String url = base + endpoints;

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
  final dynamic vote;

  Movie({
    required this.poster,
    required this.title,
    required this.id,
    required this.vote,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return Movie(
      poster: json['poster_path'],
      title: json['name'],
      id: json['id'],
      vote: json['vote_average'],
    );
  }
}

class DiscoverTV extends StatelessWidget {
  const DiscoverTV({Key? key}) : super(key: key);

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
                future: fetchMovieList(''),
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
                                  return TVDetails(id: movies[i].id);
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: movies[i].poster == 'no_img'
                                      ? const NetworkImage(
                                          'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                      : NetworkImage(
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
        const Section(
          title: "Sitcoms",
          list:
              "&sort_by=popularity.desc&vote_average.gte=7&vote_count.gte=500&with_original_language=en&with_genres=35&without_genres=16%2C18%2C80%2C10759",
        ),
        const Section(
          title: "Anime",
          list:
              "&sort_by=popularity.desc&with_genres=16&with_original_language=ja",
        ),
        const Section(
          title: "Cartoon",
          list:
              "&sort_by=popularity.desc&with_genres=16%2C10762&with_original_language=en",
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12.0, 30, 12, 12),
              child: Text(
                "Most valued",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 450,
              child: FutureBuilder<List<Movie>>(
                future: fetchMovieList(
                    '&sort_by=vote_average.desc&vote_average.gte=8&vote_count.gte=1000&with_original_language=en&without_genres=10764%2C10767'),
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
                                  return TVDetails(id: movies[i].id);
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: movies[i].poster == 'no_img'
                                      ? const NetworkImage(
                                          'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                      : NetworkImage(
                                          'https://image.tmdb.org/t/p/w500/${movies[i].poster}'),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            margin: const EdgeInsets.only(right: 20),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(10),
                                      topStart: Radius.circular(10),
                                    ),
                                    color: globals.darkGrey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      movies[i].vote.toString(),
                                      style: TextStyle(
                                        color: globals.orange,
                                        fontSize: 42,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
        const Section(
          title: "Netflix",
          list:
              "&sort_by=popularity.desc&with_watch_providers=8&watch_region=ES",
        ),
        const Section(
          title: "HBO",
          list:
              "&sort_by=popularity.desc&with_watch_providers=118&watch_region=ES",
        ),
        const Section(
          title: "Disney+",
          list:
              "&sort_by=popularity.desc&with_watch_providers=337&watch_region=ES",
        ),
        const Section(
          title: "Prime Video",
          list:
              "&sort_by=popularity.desc&with_watch_providers=119&watch_region=ES",
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final String list;
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
                              return TVDetails(id: movies[i].id);
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: movies[i].poster == 'no_img'
                                  ? const NetworkImage(
                                      'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                  : NetworkImage(
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
