import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_android/model/media.dart';
import 'package:proyecto_android/model/user.dart';
import 'package:proyecto_android/screens/movie_details.dart';
import 'package:proyecto_android/screens/tv_details.dart';

import '../globals.dart' as globals;

Future<APIMedia> fetchMovieList(int id, bool movie) async {
  late dynamic response;
  if (movie) {
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US'));
  } else {
    response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/$id?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US'));
  }

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = jsonDecode(response.body);

    return APIMedia.fromJson(json);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class APIMedia {
  final String? poster;
  final int id;

  APIMedia({
    required this.poster,
    required this.id,
  });

  factory APIMedia.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return APIMedia(poster: json['poster_path'], id: json['id']);
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String query;
  late int id;
  bool isMovie = true;
  List<Media> list = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Media>>(
      stream: userMediaSnapshots(globals.userId),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Media>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: globals.orange,
              title: StreamBuilder(
                stream: userSnapshots(globals.userId),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<User?> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final docSnapshot = snapshot.data;

                  return Text(docSnapshot!.uname);
                },
              ),
              centerTitle: true,
            ),
          );
        }
        final media = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: globals.orange,
            title: StreamBuilder(
              stream: userSnapshots(globals.userId),
              builder: (
                BuildContext context,
                AsyncSnapshot<User?> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final docSnapshot = snapshot.data;

                return Text(docSnapshot!.uname);
              },
            ),
            centerTitle: true,
          ),
          backgroundColor: globals.darkGrey,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          list.clear();
                        });

                        media.map((m) {
                          if (m.lists.contains('Watched')) {
                            setState(() {
                              list.add(m);
                            });
                          }
                        });
                      },
                      child: const Chip(
                        label: Text('Watched'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          list.clear();
                        });
                        media.map((m) {
                          if (m.lists.contains('Later')) {
                            setState(() {
                              list.add(m);
                            });
                          }
                        });
                      },
                      child: const Chip(
                        label: Text('Plan to watch'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                    padding: const EdgeInsets.all(20),
                    children: media.where((m) => m.isMovie == isMovie).map((m) {
                      return FutureBuilder<APIMedia>(
                          future: fetchMovieList(m.id, m.isMovie),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                'Search any movie by query',
                                style: TextStyle(color: Colors.white24),
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final mediaAPI = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                if (isMovie) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MovieDetails(id: mediaAPI.id);
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return TVDetails(id: mediaAPI.id);
                                      },
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: mediaAPI.poster == 'no_img'
                                          ? const NetworkImage(
                                              'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                          : NetworkImage(
                                              'https://image.tmdb.org/t/p/w500/${mediaAPI.poster}'),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                margin: const EdgeInsets.only(right: 20),
                              ),
                            );
                          });
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
