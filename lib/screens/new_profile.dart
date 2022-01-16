import 'dart:async';
import 'dart:convert';
import 'package:flutter/painting.dart';

import '../globals.dart' as globals;
import 'package:proyecto_android/screens/tv_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie_details.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<Media> fetchMovieList(int id, bool movie) async {
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

    return Media.fromJson(json);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Media {
  final String? poster;

  Media({
    required this.poster,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    if (json['poster_path'] == null) {
      json['poster_path'] = 'no_img';
    }
    return Media(poster: json['poster_path']);
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

  List<int> myMedia = [46516, 46518, 46523, 46552];

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    const media = "/users/ySilogyEnDkZinqTdUbL/media";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.orange,
        title: const Text('itsmeemaaario'),
        centerTitle: true,
      ),
      backgroundColor: globals.darkGrey,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: db.collection(media).snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final docSnapshot = snapshot.data?.docs;

                /* final json = docSnapshot!.data()!; */
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        /* if (isMovie) {
                          setState(() {
                            myMedia.clear();
                            //Busca watched i movie i afegeix les id a la array myMedia
                            docSnapshot!.map((e) {
                              final json = e.data()!;
                              if (json['List'] == 'Watched' &&
                                  json['Type'] == 'Movie') {
                                myMedia.add(json['id']);
                              }
                            });
                          });
                        } else {
                          setState(() {
                            myMedia.clear();
                            //Busca watched i tvshow i afegeix les id a la array myMedia
                          });
                        } */
                      },
                      child: const Chip(
                        label: Text('Watched'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isMovie) {
                          setState(() {
                            myMedia.clear();
                            //Busca later i movie i afegeix les id a la array myMedia
                          });
                        } else {
                          setState(() {
                            myMedia.clear();
                            //Busca later i tvshow i afegeix les id a la array myMedia
                          });
                        }
                      },
                      child: const Chip(
                        label: Text('Plan to watch'),
                      ),
                    ),
                  ],
                );
              },
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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
                padding: const EdgeInsets.all(20),
                children: List.generate(myMedia.length, (index) {
                  return FutureBuilder<Media>(
                      future: fetchMovieList(myMedia[index], isMovie),
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
                        final media = snapshot.data!;
                        return GestureDetector(
                          onTap: () {
                            if (isMovie) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MovieDetails(
                                        id: globals.watchedM[index]);
                                  },
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return TVDetails(
                                        id: globals.watchedM[index]);
                                  },
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: media.poster == 'no_img'
                                      ? const NetworkImage(
                                          'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                      : NetworkImage(
                                          'https://image.tmdb.org/t/p/w500/${media.poster}'),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            margin: const EdgeInsets.only(right: 20),
                          ),
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
