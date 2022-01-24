import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:proyecto_android/model/user.dart';
import 'package:proyecto_android/screens/discover_menu.dart';
import '../../globals.dart' as globals;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKeyLogIn = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String username = '';
  String action = 'log';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login-bg.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: [
                  globals.darkGrey.withOpacity(1.0),
                  globals.darkGrey.withOpacity(0.5),
                ],
                    stops: const [
                  0.0,
                  1.0
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 300,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/listit-logo.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                action == 'log' ? logIn() : signUp(),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Form logIn() {
    return Form(
        key: _formKeyLogIn,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: globals.darkGrey,
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: globals.lightGrey)),
              style: const TextStyle(color: Colors.white),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: globals.darkGrey,
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: globals.lightGrey)),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Minimum 6 characters' : null,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: globals.orange,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                onPressed: () async {
                  if (_formKeyLogIn.currentState!.validate()) {
                    debugPrint(email);
                    debugPrint(password);
                    userSnapshots(email);

                    /* StreamBuilder(
                                stream: userSnapshots(email),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<User?> snapshot,
                                ) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child:
                                          Text('user or password incorrect'),
                                    );
                                  }

                                  globals.userId = email;
                                  return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.white);
                                }); */
                  }
                },
                child: const Text('Log In')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('You don\'t have an account yet?'),
                  const Spacer(),
                  InkWell(
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: globals.orange, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      setState(() {
                        action = 'sign';
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }

  Form signUp() {
    final db = FirebaseFirestore.instance;
    final users = db.collection("/users");

    return Form(
        key: _formKeySignUp,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: globals.darkGrey,
                  hintText: 'Set your username',
                  hintStyle: TextStyle(color: globals.lightGrey)),
              style: const TextStyle(color: Colors.white),
              validator: (val) => val!.isEmpty ? 'Set your username' : null,
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: globals.darkGrey,
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: globals.lightGrey)),
              style: const TextStyle(color: Colors.white),
              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: globals.darkGrey,
                  hintText: 'Create your 6+ characters password',
                  hintStyle: TextStyle(color: globals.lightGrey)),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              validator: (val) =>
                  val!.length < 6 ? 'Minimum 6 characters' : null,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: globals.orange,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                onPressed: () async {
                  if (_formKeySignUp.currentState!.validate()) {
                    users.doc(email).set({
                      'username': username,
                      'email': email,
                      'password': password,
                    });
                    globals.userId = email;
                    //añadir colección 'media'
                    /* FirebaseFirestore.instance
                        .collection("users/${globals.userId}/media")
                        .doc('S-1420')
                        .set({
                      'type': 'Show',
                      'id': '1420',
                      'list': [],
                      'fav': false
                    }); */

                    globals.userId = email;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const DiscoverMenu();
                        },
                      ),
                    );
                  }
                },
                child: const Text('Sign Up')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('You already have an account?'),
                  const Spacer(),
                  InkWell(
                    child: Text(
                      'Log in',
                      style: TextStyle(
                          color: globals.orange, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      setState(() {
                        action = 'log';
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
