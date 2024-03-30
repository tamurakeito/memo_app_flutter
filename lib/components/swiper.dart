import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/utils/style.dart';

class Swiper extends HookConsumerWidget {
  const Swiper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int durationTime = 200;

    final int page = ref.watch(memoPageProvider);
    final List<MemoSummaryType> list = ref.watch(memoListProvider);

    final positionPageLeft = useState<double>(-1 * screenWidth);
    final positionPageCenter = useState<double>(0);
    final positionPageRight = useState<double>(screenWidth);

    final isSwipeFlag = useState<bool>(false);
    final isDuration = useState<bool>(false);

    final Duration duration =
        Duration(milliseconds: isDuration.value ? durationTime : 0);

    return GestureDetector(
        onHorizontalDragStart: (details) {
          isSwipeFlag.value = true;
          isDuration.value = true;
        },
        onHorizontalDragUpdate: (details) {
          if (isSwipeFlag.value == true) {
            isSwipeFlag.value = false;
            if (details.delta.dx > 0 && page > 0) {
              positionPageCenter.value = screenWidth;
              positionPageLeft.value = 0;
              Timer(Duration(milliseconds: durationTime), () {
                ref.read(memoPageProvider.notifier).state = page - 1;
                positionPageCenter.value = 0;
                positionPageLeft.value = -1 * screenWidth;
                isDuration.value = false;
              });
            } else if (details.delta.dx < 0 && page + 1 < list.length) {
              positionPageCenter.value = -1 * screenWidth;
              positionPageRight.value = 0;
              Timer(Duration(milliseconds: durationTime), () {
                ref.read(memoPageProvider.notifier).state = page + 1;
                positionPageCenter.value = 0;
                positionPageRight.value = screenWidth;
                isDuration.value = false;
              });
            }
          }
        },
        onHorizontalDragEnd: (details) {},
        child: Stack(
          children: [
            if (page > 0) ...[
              SwiperPage(
                duration: duration,
                position: positionPageLeft,
                child: MemoCard(
                  title: list[page - 1].name,
                ),
              )
            ],
            SwiperPage(
              duration: duration,
              position: positionPageCenter,
              child: MemoCard(
                title: list[page].name,
              ),
            ),
            if (page < list.length - 1) ...[
              SwiperPage(
                duration: duration,
                position: positionPageRight,
                child: MemoCard(
                  title: list[page + 1].name,
                ),
              )
            ],
          ],
        ));
  }
}

class SwiperPage extends HookConsumerWidget {
  final Duration duration;
  final ValueNotifier<double> position;
  final Widget child;
  SwiperPage(
      {super.key,
      required this.duration,
      required this.position,
      required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final page = ref.watch(memoPageProvider);

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(position.value, 0, 0),
      color: kWhite,
      height: screenHeight - 160,
      child: child,
    );
  }
}
