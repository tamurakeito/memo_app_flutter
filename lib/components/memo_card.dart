import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/components/skeleton_memo_card.dart';
import 'package:memo_app_flutter/data/get_memo_detail.dart';
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

    final memo = useState<MemoDetailType>(
        MemoDetailType(id: 0, name: '', tag: false, tasks: []));

    void fetch() {
      isLoading.value = true;
      getMemoDetail(id).then((data) {
        memo.value = data;
      }).catchError((error) {
        // エラーハンドリング
        print("Error fetching data: $error");
      }).whenComplete(() {
        isLoading.value = false;
        isLoaded.value = true;
      });
    }

    useEffect(() {
      if ((index == page - 1 || index == page || index == page + 1) &&
          !isLoaded.value) {
        fetch();
      }
    }, [page]);

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
              child: !isLoading.value
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

class MemoLayout extends StatelessWidget {
  final MemoDetailType memo;
  const MemoLayout({super.key, required this.memo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 未完了リスト
        Container(
            padding: const EdgeInsets.only(bottom: 12),
            decoration:
                const BoxDecoration(border: Border(bottom: AtomicBorder())),
            child: Column(
              children: [
                TitleBlock(
                  text: memo.name,
                ),
                ...memo.tasks
                    .where((element) => !element.complete)
                    .map((task) =>
                        ListBlock(isCompleted: false, text: task.name))
                    .toList()
              ],
            )),
        // 完了済リスト
        Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 18, 12),
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
                        //
                      },
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: kGray500,
                        ),
                      ))
                ],
              ),
            ),
            ...memo.tasks
                .where((element) => element.complete)
                .map((task) => ListBlock(isCompleted: true, text: task.name))
                .toList()
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
