import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/components/skeleton_memo_card.dart';
import 'package:memo_app_flutter/data/api/get_memo_detail.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/ui/molecules/loading_circle.dart';
import 'package:memo_app_flutter/utils/style.dart';

class MemoCard extends HookConsumerWidget {
  final int index;
  final int id;
  const MemoCard({
    super.key,
    required this.index,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int page = ref.watch(memoPageProvider);
    final isLoadable = useState<bool>(false);
    final isSyncActive = useState<bool>(false);
    final isLoading = useState<bool>(false);
    final isLoaded = useState<bool>(false);
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<MemoSummaryType> list = ref.watch(memoListProvider);

    final MemoDetailType nullMemo =
        MemoDetailType(id: 0, name: '', tag: false, tasks: []);
    final memo = useState<MemoDetailType>(nullMemo);

    void fetch() {
      isLoading.value = true;
      getMemoDetail(id).then((data) {
        memo.value = data;
      }).catchError((error) {
        print("Error fetching data: $error");
      }).whenComplete(() {
        isLoading.value = false;
        isLoaded.value = true;
      });
    }

    useEffect(() {
      // ページが捲られたときにローディングする
      if ((index == page - 1 || index == page || index == page + 1) &&
          !isLoaded.value) {
        fetch();
      }
      return () {};
    }, [page]);

    useEffect(() {
      isLoaded.value = false;
    }, [list]);

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels < -100 &&
                isLoadable.value == false) {
              isLoadable.value = true;
              isSyncActive.value = true;
            } else if (notification.metrics.pixels > -55 &&
                isLoadable.value == true) {
              isSyncActive.value = false;
            }
            if (notification is ScrollEndNotification &&
                isLoadable.value == true) {
              fetch();
              isLoadable.value = false;
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight - 160),
              child: !isLoading.value && memo.value != nullMemo
                  ? MemoLayout(memo: memo.value)
                  : SkeletonMemoCard(),
            ),
          ),
        ),
        LoadingCircle(
          isActive: isSyncActive.value,
        ),
      ],
    );
  }
}

class MemoLayout extends HookWidget {
  final MemoDetailType memo;
  const MemoLayout({super.key, required this.memo});

  @override
  Widget build(BuildContext context) {
    final uncompleteList = memo.tasks
        .where((element) => !element.complete)
        .map((task) => ListBlock(isCompleted: false, text: task.name))
        .toList();
    final completeList = memo.tasks
        .where((element) => element.complete)
        .map((task) => ListBlock(isCompleted: true, text: task.name))
        .toList();

    final isOpenCompletedList = useState<bool>(true);
    const isOpenDuration = Duration(milliseconds: 120);

    final controller = useAnimationController(duration: isOpenDuration);

    final animation = Tween<Offset>(
      begin: const Offset(0, 0), // 画面上部から開始
      end: const Offset(0, -1 / 3), // 画面の中心に終了
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return Column(
      children: [
        // 未完了リスト
        Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                TitleBlock(
                  text: memo.name,
                ),
                ...uncompleteList
              ],
            )),
        // 完了済リスト
        if (completeList.isNotEmpty)
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 18, 12),
                decoration: const BoxDecoration(
                  border: Border(top: AtomicBorder()),
                ),
                child: Row(
                  children: [
                    const AtomicText(
                      "完了",
                      style: AtomicTextStyle.md,
                      type: AtomicTextColor.light,
                    ),
                    const Spacer(),
                    Button(
                      onPressed: () {
                        if (isOpenCompletedList.value) {
                          controller.forward();
                          isOpenCompletedList.value = false;
                        } else {
                          controller.reverse();
                          isOpenCompletedList.value = true;
                        }
                      },
                      child: AnimatedContainer(
                        duration: isOpenDuration,
                        transform: Matrix4.rotationX(
                            isOpenCompletedList.value ? 0 : pi), // 回転アニメーション
                        transformAlignment: Alignment.center,
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: kGray500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: isOpenCompletedList.value ? 1 : 0,
                duration: isOpenDuration,
                curve: Curves.easeInOut,
                child: SlideTransition(
                  position: animation,
                  child: Column(
                    children: completeList,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class TitleBlock extends StatelessWidget {
  final String text;
  const TitleBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Row(children: [
        const AtomicCircle(
          type: AtomicCircleType.gray,
        ),
        const SizedBox(
          width: 16,
        ),
        AtomicText(text, style: AtomicTextStyle.h2)
      ]),
    );
  }
}

class ListBlock extends StatelessWidget {
  final bool isCompleted;
  final String text;
  const ListBlock({super.key, required this.isCompleted, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(children: [
        !isCompleted
            ? const AtomicCircle(
                type: AtomicCircleType.white,
              )
            : const Icon(
                Icons.check,
                size: 18,
                color: kGray500,
              ),
        const SizedBox(
          width: 16,
        ),
        AtomicText(
          text,
          style: AtomicTextStyle.md,
          type: !isCompleted ? AtomicTextColor.dark : AtomicTextColor.light,
        ),
        const Spacer(),
        !isCompleted
            ? Button(
                onPressed: () {
                  //
                },
                child: const Icon(
                  Icons.check,
                  size: 18,
                  color: kGray700,
                ))
            : Button(
                onPressed: () {
                  //
                },
                child: const Icon(
                  Icons.clear,
                  size: 18,
                  color: kGray500,
                )),
      ]),
    );
  }
}
