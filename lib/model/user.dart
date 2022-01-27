import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto_android/screens/add_list.dart';

class MyUser {
  final String username;
  final List<String> lists;
  final String email;

  MyUser.fromFirestore(Map<String, dynamic> data)
      : username = data['username'],
        lists = (data['lists'] as List).cast<String>(),
        email = data['email'];
}

Stream<MyUser?> userSnapshots(String? email) {
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

    return MyUser.fromFirestore(querysnap.docs[0].data());
  });
}
