import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';

class AtomicCircle extends StatelessWidget {
  const AtomicCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // 枠線の外側の色
        shape: BoxShape.circle,
        border: Border.all(
          color: kGray900, // 枠線の色
          width: 2, // 枠線の太さ
        ),
      ),
      child: const CircleAvatar(
        radius: 8,
        backgroundColor: kGray300,
      ),
    );
  }
}
