import 'package:flutter/material.dart';
import 'package:proyecto_android/model/media.dart';
import 'package:proyecto_android/screens/add_list.dart';
import '../globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<TVShow> fetchShowDetails(int id) async {
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

  final List seasons;

  TVShow({
    required this.poster,
    required this.title,
    required this.overview,
    required this.rating,
    required this.releaseDate,
    required this.genres,
    required this.lastAir,
    required this.seasons,
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
      seasons: json['seasons'],
    );
  }
}

Future<List<Cast>> fetchCasting(int id) async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/tv/$id/credits?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = jsonDecode(response.body);
    final results = json['cast'];
    globals.cast_length = results.length;
    return results
        .map((movieJson) => Cast.fromJson(movieJson))
        .toList()
        .cast<Cast>();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Cast {
  final String department;
  final String name;
  final String character;
  final String picture;

  Cast({
    required this.character,
    required this.department,
    required this.name,
    required this.picture,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    if (json['profile_path'] == null) {
      json['profile_path'] = 'no_img';
    }
    return Cast(
      department: json['known_for_department'],
      name: json['name'],
      character: json['character'],
      picture: json['profile_path'],
    );
  }
}

Future<List<Streaming>> fetchStreaming(int id) async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/tv/$id/watch/providers?api_key=9ec3a5dc3d1c79366d75654dea61ebe3'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = jsonDecode(response.body);
    final results = json['results'];
    final spain = results['ES'];
    final stream = spain['flatrate'];
    globals.streaming_length = stream.length;
    return stream
        .map((movieJson) => Streaming.fromJson(movieJson))
        .toList()
        .cast<Streaming>();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Streaming {
  final String name;
  final String picture;

  Streaming({
    required this.name,
    required this.picture,
  });

  factory Streaming.fromJson(Map<String, dynamic> json) {
    if (json['logo_path'] == null) {
      json['logo_path'] = 'no_img';
    }
    return Streaming(
      name: json['provider_name'],
      picture: json['logo_path'],
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
    final db = FirebaseFirestore.instance;
    final media = db.collection("/users/${globals.userId}/media");

    return Theme(
      data: ThemeData(fontFamily: 'MadeTommy'),
      child: FutureBuilder<TVShow>(
          future: fetchShowDetails(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final show = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: globals.orange,
              ),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500/${show.poster}'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BasicInfo(movies: show),
                        Container(
                          color: globals.darkGrey,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StreamBuilder(
                                    stream: mediaSnapshots(
                                        globals.userId, widget.id),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<Media?> snapshot,
                                    ) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    media
                                                        .doc('S-${widget.id}')
                                                        .set({
                                                      'list': ['Watched'],
                                                      'type': 'Show',
                                                      'id': widget.id,
                                                      'fav': false,
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.remove_red_eye,
                                                          size: 32,
                                                          color:
                                                              globals.lightGrey,
                                                        ),
                                                        Text(
                                                          'Watched',
                                                          style: TextStyle(
                                                            color: globals
                                                                .lightGrey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    media
                                                        .doc('S-${widget.id}')
                                                        .set({
                                                      'list': ['Later'],
                                                      'type': 'Show',
                                                      'id': widget.id,
                                                      'fav': false,
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: 100,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.watch_later,
                                                          size: 32,
                                                          color:
                                                              globals.lightGrey,
                                                        ),
                                                        Text(
                                                          'Watch later',
                                                          style: TextStyle(
                                                            color: globals
                                                                .lightGrey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return AddList(
                                                              id: widget.id);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      media
                                                          .doc('S-${widget.id}')
                                                          .set({
                                                        'list': [],
                                                        'type': 'Show',
                                                        'id': widget.id,
                                                        'fav': false,
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Icon(
                                                            Icons.add,
                                                            size: 32,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            'Add to list...',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        );
                                      }
                                      final listInfo = snapshot.data!;
                                      return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (!listInfo.isWatched) {
                                                  media
                                                      .doc('S-${widget.id}')
                                                      .update({
                                                    'list':
                                                        FieldValue.arrayUnion(
                                                            ['Watched']),
                                                  });
                                                } else {
                                                  media
                                                      .doc('S-${widget.id}')
                                                      .update({
                                                    'list':
                                                        FieldValue.arrayRemove(
                                                            ['Watched']),
                                                  });
                                                }
                                              },
                                              child: SizedBox(
                                                width: 100,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.remove_red_eye,
                                                      size: 32,
                                                      color: listInfo.isWatched
                                                          ? globals.orange
                                                          : globals.lightGrey,
                                                    ),
                                                    Text(
                                                      'Watched',
                                                      style: TextStyle(
                                                        color: listInfo
                                                                .isWatched
                                                            ? globals.orange
                                                            : globals.lightGrey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (!listInfo.isLater) {
                                                  media
                                                      .doc('S-${widget.id}')
                                                      .update({
                                                    'list':
                                                        FieldValue.arrayUnion(
                                                            ['Later']),
                                                  });
                                                } else {
                                                  media
                                                      .doc('S-${widget.id}')
                                                      .update({
                                                    'list':
                                                        FieldValue.arrayRemove(
                                                            ['Later']),
                                                  });
                                                }
                                              },
                                              child: SizedBox(
                                                width: 100,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.watch_later,
                                                      size: 32,
                                                      color: listInfo.isLater
                                                          ? globals.orange
                                                          : globals.lightGrey,
                                                    ),
                                                    Text(
                                                      'Watch later',
                                                      style: TextStyle(
                                                        color: listInfo.isLater
                                                            ? globals.orange
                                                            : globals.lightGrey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return AddList(
                                                          id: widget.id);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: SizedBox(
                                                width: 100,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Icon(
                                                      Icons.add,
                                                      size: 32,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      'Add to list...',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]);
                                    }),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  show.overview,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                FutureBuilder<List<Cast>>(
                                    future: fetchCasting(widget.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      final casting = snapshot.data!;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Cast',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            height: 280,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                for (int i = 0;
                                                    i < globals.cast_length;
                                                    i++)
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 140,
                                                        height: 200,
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: casting[i]
                                                                              .picture ==
                                                                          'no_img'
                                                                      ? const NetworkImage(
                                                                          'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                                                      : NetworkImage(
                                                                          'https://image.tmdb.org/t/p/w500/${casting[i].picture}'),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10))),
                                                        margin: const EdgeInsets
                                                            .only(right: 20),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          casting[i].name,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          casting[i].character,
                                                          style: TextStyle(
                                                              color: globals
                                                                  .lightGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                if (show.seasons.isNotEmpty)
                                  for (int i = 0; i < show.seasons.length; i++)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: globals.grey),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              show.seasons[i]['name'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const Spacer(),
                                            Text(
                                                '${show.seasons[i]['episode_count'].toString()} episodes',
                                                style: const TextStyle(
                                                    color: Colors.white))
                                          ],
                                        ),
                                      ),
                                    ),
                                const SizedBox(
                                  height: 30,
                                ),
                                /* if (globals.streaming_length != 0) */
                                FutureBuilder<List<Streaming>>(
                                    future: fetchStreaming(widget.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('${snapshot.error}');
                                      }
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      final streaming = snapshot.data!;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Streaming on...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            height: 150,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        globals
                                                            .streaming_length;
                                                    i++)
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: streaming[i]
                                                                              .picture ==
                                                                          'no_img'
                                                                      ? const NetworkImage(
                                                                          'https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-no-image-available-icon-flat.jpg')
                                                                      : NetworkImage(
                                                                          'https://image.tmdb.org/t/p/w500/${streaming[i].picture}'),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            10))),
                                                        margin: const EdgeInsets
                                                            .only(right: 20),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class BasicInfo extends StatelessWidget {
  const BasicInfo({
    Key? key,
    required this.movies,
  }) : super(key: key);

  final TVShow movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                      globals.darkGrey.withOpacity(0.4),
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
                      globals.darkGrey.withOpacity(0.4),
                    ],
                    stops: const [
                      0.0,
                      1.0
                    ])),
          ),
          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
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
                      Text(
                        movies.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      for (int i = 0; i < movies.rating / 2.round(); i++)
                        Icon(
                          Icons.star_rounded,
                          color: globals.orange,
                        ),
                      for (int i = 0; i <= 4 - movies.rating / 2.round(); i++)
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${movies.releaseDate.substring(0, 4)} - ${movies.lastAir?.substring(0, 4)}',
                        style: TextStyle(
                          color: globals.lightGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        '|',
                        style: TextStyle(
                          color: globals.lightGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(width: 15),
                      for (int i = 0; i < movies.genres.length - 1; i++)
                        Text(
                          '${movies.genres[i]['name']}, ',
                          style: TextStyle(
                            color: globals.lightGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      Text(
                        movies.genres.last['name'],
                        style: TextStyle(
                          color: globals.lightGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
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
    );
  }
}
