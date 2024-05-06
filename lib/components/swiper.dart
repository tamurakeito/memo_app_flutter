import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/data/api/put_client_data.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/utils/style.dart';

class Swiper extends HookConsumerWidget {
  const Swiper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int page = ref.watch(memoPageProvider);
    final List<MemoSummaryType> list = ref.watch(memoSummariesProvider);

    final isSwipeFlag = useState<bool>(false);

    final memo = ref.watch(memoProvider);

    useEffect(() {
      // ページが捲られたときに一定時間そのページにとどまっていた場合そのページをClientDataとしてサーバーへ送信する
      int turnedPage = page;
      Timer(Duration(milliseconds: 1000), () {
        int currentPage = ref.watch(memoPageProvider);
        if (turnedPage == currentPage) {
          putClientData(ClientData(tab: currentPage)).catchError((error) {
            print("Error fetching data4: $error");
          });
        }
      });
      // memoProviderにセット
      Timer(
        Duration(milliseconds: 1),
        () {
          ref.read(memoProvider.notifier).state = list.length > page
              ? list[page]
              : MemoSummaryType(id: 0, name: '', tag: false, length: 0);
        },
      );
      return () {};
    }, [page]);

    return GestureDetector(
      onHorizontalDragStart: (details) {
        isSwipeFlag.value = true;
      },
      onHorizontalDragUpdate: (details) {
        if (isSwipeFlag.value == true) {
          isSwipeFlag.value = false;
          if (details.delta.dx > 0 && page > 0) {
            ref.read(memoPageProvider.notifier).state = page - 1;
          } else if (details.delta.dx < 0 && page + 1 < list.length) {
            ref.read(memoPageProvider.notifier).state = page + 1;
          }
        }

        // ページが捲られたときに一定時間そのページにとどまっていた場合そのページをClientDataとしてサーバーへ送信する
      },
      onHorizontalDragEnd: (details) {},
      child: Container(
        color: kTransplant,
        child: Stack(
          children: list.asMap().entries.expand<Widget>((entry) {
            int index = entry.key;
            MemoSummaryType memo = entry.value;
            return [
              SwiperPage(
                index: index,
                isActive: false,
                child: MemoCard(
                  index: index,
                  id: memo.id,
                ),
              )
            ];
          }).toList(),
        ),
      ),
    );
  }
}

class SwiperPage extends HookConsumerWidget {
  final int index;
  // final Duration duration;
  final bool isActive;
  final Widget child;
  SwiperPage(
      {super.key,
      required this.index,
      // required this.duration,
      required this.isActive,
      required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double height = screenHeight(context) - 160;
    const int durationTime = 200;
    final Duration duration = Duration(milliseconds: durationTime);

    final page = ref.watch(memoPageProvider);
    final list = ref.watch(memoSummariesProvider);

    final position = useState<double>(0);
    if (index < page) {
      position.value = -1 * screenWidth;
    } else if (index == page) {
      position.value = 0;
    } else if (index > page) {
      position.value = screenWidth;
    }

    useEffect(() {
      if (index == page - 1) {
        position.value = -1 * screenWidth;
      } else if (index == page) {
        position.value = 0;
      } else if (index == page + 1) {
        position.value = screenWidth;
      }
    }, [page]);

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(position.value, 0, 0),
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (page < list.length - 1) {
                  ref.read(memoPageProvider.notifier).state = page + 1;
                }
              },
              child: Container(
                color: kTransplant,
                width: 100,
                height: height,
              ),
            ),
          ),
          child,
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (page > 0) {
                  ref.read(memoPageProvider.notifier).state = page - 1;
                }
              },
              child: Container(
                color: kTransplant,
                width: 100,
                height: height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
