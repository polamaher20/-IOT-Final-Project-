import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


// ignore: must_be_immutable
class Opertaion_box extends StatelessWidget {
  

  final String device;
  final IconData icon;
  final bool power;

  void Function(bool)? onChanged;


Opertaion_box({
    required this.device,
    required this.icon,
    required this.power,
    required this.onChanged,

  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color:power? Colors.grey[900] :Colors.grey[200],
          borderRadius: BorderRadius.circular(24)
        ),
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: power? Colors.white:Colors.black,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:25),
                    child: Text(
                      device,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: power? Colors.white:Colors.black,
                      ),
                    ),
                  )
                ),
                Transform.rotate(
                  angle: pi/2,
                  child: CupertinoSwitch(
                    value:power, 
                    onChanged:onChanged,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}