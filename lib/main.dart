import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_android/screens/LogIn/auth.dart';
import 'package:proyecto_android/screens/LogIn/login.dart';
import 'package:proyecto_android/screens/discover_menu.dart';
import 'package:proyecto_android/wrapper.dart';
import '../globals.dart' as globals;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        )
      ],
      child: MaterialApp(
        home: const Wrapper(),
        theme: ThemeData(
          fontFamily: 'MadeTommy',
          scaffoldBackgroundColor: globals.darkGrey,
          primaryColor: globals.orange,
          textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: globals.darkGrey,
            unselectedIconTheme:
                IconThemeData(color: globals.lightGrey, size: 30, opacity: 0.5),
            selectedIconTheme:
                IconThemeData(color: globals.orange, size: 30, opacity: 1),
          ),
        ),
      ),
    );
  }
}
