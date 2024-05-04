import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math';

import 'package:memo_app_flutter/utils/style.dart';

class LoadingCircleMini extends HookWidget {
  final LoadingCircleMiniColor? type;
  const LoadingCircleMini({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: Duration(milliseconds: 1500),
    )..repeat();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2.0 * pi,
          child: child,
        );
      },
      child: Icon(
        LineIcons.circleNotched,
        color: type == LoadingCircleMiniColor.light ? kGray600 : kGray800,
        size: 18,
      ),
    );
  }
}

enum LoadingCircleMiniColor { dark, light }
