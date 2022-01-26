import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_android/model/firebase_user.dart';
import 'package:proyecto_android/model/user.dart';
import '../../globals.dart' as globals;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return FirebaseUser(uid: user.uid);
  }

  Stream<FirebaseUser?>? get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<FirebaseUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    globals.userId = email;
    return _userFromFirebaseUser(credential.user);
  }

  Future<FirebaseUser?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    globals.userId = email;
    return _userFromFirebaseUser(credential.user);
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
