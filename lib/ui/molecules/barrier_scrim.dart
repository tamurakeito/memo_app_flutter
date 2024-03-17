import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/utils/style.dart';

class BarrierScrim extends ConsumerWidget {
  final ValueNotifier<bool> isActive;
  final void Function() onPressed;
  const BarrierScrim(
      {super.key, required this.isActive, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const duration = 100;
    return GestureDetector(
        onTap: () {
          isActive.value = false;

          Timer(Duration(milliseconds: duration), () => onPressed());
        },
        child: AnimatedOpacity(
          opacity: isActive.value ? 1 : 0,
          duration: Duration(milliseconds: duration),
          child: Container(
            color: kScrimColor,
          ),
        ));
  }
}
