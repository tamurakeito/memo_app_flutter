import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math';

class LoadingCircleMini extends HookWidget {
  const LoadingCircleMini({super.key});

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
        size: 18,
      ),
    );
  }
}
