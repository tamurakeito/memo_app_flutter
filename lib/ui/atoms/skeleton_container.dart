import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kWhite,
          ),
        ),
        baseColor: kGray200,
        highlightColor: kWhite,
      ),
    );
  }
}
