/* import 'dart:async';
import 'dart:convert';
 */
import 'package:flutter/material.dart';
/* import 'package:http/http.dart' as http; */

/* Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=9ec3a5dc3d1c79366d75654dea61ebe3&language=en-US&query=$query&page=1&include_adult=false'));

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

  Album({
    required this.poster,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      poster: json['poster_path'],
    );
  }
} */

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController controller;
  /*  late Future<Album> futureAlbum; */
  String query = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    /* futureAlbum = fetchAlbum(); */
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
        padding: const EdgeInsets.all(20),
        child: Column(
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
            )
          ],
        ),
      ),
    );
  }
}
