import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/utils/style.dart';

class BarrierScrim extends ConsumerWidget {
  final ValueNotifier<bool> isActive;
  final void Function() onTap;
  final void Function()? onDragUp;
  final void Function()? onDragDown;
  const BarrierScrim(
      {super.key,
      required this.isActive,
      required this.onTap,
      this.onDragUp,
      this.onDragDown});

  void handleFadeOut(int duration, void Function() onExec) {
    isActive.value = false;
    Timer(Duration(milliseconds: duration), () => onExec());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const duration = 100;
    return GestureDetector(
        onTap: () {
          handleFadeOut(duration, onTap);
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0 && onDragDown != null) {
            // 下方向にスワイプ
            handleFadeOut(duration, onDragDown!);
          }
          if (details.delta.dy < 0 && onDragUp != null) {
            // 上方向にスワイプ
            handleFadeOut(duration, onDragUp!);
          }
        },
        child: AnimatedOpacity(
          opacity: isActive.value ? 1 : 0,
          duration: const Duration(milliseconds: duration),
          child: Container(
            color: kScrimColor,
          ),
        ));
  }
}
