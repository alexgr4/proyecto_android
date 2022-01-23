import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String uname;
  final String pass;
  final String email;

  User.fromFirestore(Map<String, dynamic> data)
      : uname = data['username'],
        pass = data['password'],
        email = data['email'];
}

Stream<User?> userSnapshots(String email) {
  final db = FirebaseFirestore.instance;

  return db
      .collection('/users')
      .where('email', isEqualTo: email)
      .snapshots()
      .map((querysnap) {
    if (querysnap.docs.isEmpty) {
      debugPrint('no');
      return null;
    }

    return User.fromFirestore(querysnap.docs[0].data());
  });
}
