import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  static const routeName = '/second';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple,
              Colors.pink,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 400,
            ),
            Center(
              child: Text(
                "A7LA MESA YA REGALA",
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
