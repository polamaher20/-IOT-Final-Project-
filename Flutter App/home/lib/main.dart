import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splachScreen.dart';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(First_page());
}

class First_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
