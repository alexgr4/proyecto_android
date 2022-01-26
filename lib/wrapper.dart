import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_android/model/firebase_user.dart';
import 'package:proyecto_android/screens/LogIn/auth.dart';
import 'package:proyecto_android/screens/LogIn/login.dart';
import 'package:proyecto_android/screens/discover_menu.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<FirebaseUser?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot<FirebaseUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final FirebaseUser? user = snapshot.data;
            return user == null ? const LogIn() : const DiscoverMenu();
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
