import 'package:flutter/material.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key}) : super(key: key);

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
      backgroundColor: const Color(0xFF1A1B1E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/nowayhome.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
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
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
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
                            fontSize: 20,
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
                      Row()
                    ],
                  ),
                ])
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          )
        ],
      ),
    );
  }
}
