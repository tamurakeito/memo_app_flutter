import 'package:flutter/material.dart';

class H1Text extends StatelessWidget {
  final String text;
  const H1Text({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold));
  }
}
