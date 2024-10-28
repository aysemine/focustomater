import 'package:flutter/material.dart';

class ExpDisplay extends StatelessWidget {
  final int exp;

  ExpDisplay({required this.exp});

  @override
  Widget build(BuildContext context) {
    return Text(
      "EXP: $exp",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}