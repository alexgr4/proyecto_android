import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MovieDetailsOld extends StatefulWidget {
  const MovieDetailsOld({Key? key}) : super(key: key);

  @override
  _MovieDetailsOldState createState() => _MovieDetailsOldState();
}

class _MovieDetailsOldState extends State<MovieDetailsOld> {
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
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
