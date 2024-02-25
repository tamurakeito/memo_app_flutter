import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';

class AtomicCircle extends StatelessWidget {
  final AtomicCircleType type;
  final double? radius;
  const AtomicCircle({super.key, required this.type, double? radius})
      : radius = radius ?? 8.0;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case AtomicCircleType.gray:
        color = kGray300;
        break;
      default:
        color = kWhite;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: kGray900, // 枠線の色
          width: 1.2, // 枠線の太さ
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: color,
      ),
    );
  }
}

enum AtomicCircleType { gray, white }
