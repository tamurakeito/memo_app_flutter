import 'package:flutter/material.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/utils/style.dart';

class ItemUnit extends StatelessWidget {
  final String text;
  const ItemUnit({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: const BoxDecoration(color: Colors.pink),
      child: Row(children: [
        const AtomicCircle(),
        AtomicText(style: AtomicTextStyle.h1, text: text)
      ]),
    );
  }
}
