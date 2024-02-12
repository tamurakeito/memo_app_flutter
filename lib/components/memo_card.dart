import 'package:flutter/material.dart';
import 'package:memo_app_flutter/ui/atoms/h1_text.dart';

class MemoCard extends StatelessWidget {
  final String title;
  const MemoCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        H1Text(
          text: title,
        ),
        Text(title),
        Text(title),
        Text(title),
        Text(title),
        Text(title),
        Text(title),
      ],
    );
  }
}
