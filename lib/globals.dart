library my_prj.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//marioalejandre99@gmail.com
String? userId = FirebaseAuth.instance.currentUser?.email;

Color orange = const Color(0xFFEF774F);
Color darkGrey = const Color(0xFF1A1B1E);
Color lightGrey = const Color(0xFF919191);
Color grey = const Color(0xFF27292e);
int search_length = 20;
late int cast_length;
late int streaming_length;
