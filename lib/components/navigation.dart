import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/style.dart';

class Navigation extends ConsumerWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<MemoSummaryType> list = ref.watch(memoListProvider);
    final int page = ref.watch(memoPageProvider);
    return Drawer(
      child: Container(
        color: kWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              decoration:
                  const BoxDecoration(border: Border(bottom: AtomicBorder())),
            ),
            MemoListBox(
              isTagged: true,
              memoList: list
                  .where((element) => element.tag)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                MemoSummaryType memo = entry.value;
                return MemoListBlock(
                  text: memo.name,
                  length: memo.length,
                  isFocused: page == index,
                  jumpPage: index,
                );
              }).toList(),
            ),
            MemoListBox(
              isTagged: false,
              memoList: list
                  .where((memo) => !memo.tag)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                int index =
                    entry.key + list.where((element) => element.tag).length;
                MemoSummaryType memo = entry.value;
                return MemoListBlock(
                  text: memo.name,
                  length: memo.length,
                  isFocused: page == index,
                  jumpPage: index,
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class MemoListBox extends StatelessWidget {
  final bool isTagged;
  final List<MemoListBlock> memoList;
  const MemoListBox(
      {super.key, required this.isTagged, required this.memoList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(21, 10, 21, 10),
            child: Row(children: [
              Icon(
                isTagged ? Icons.bookmark : Icons.bookmark_border,
                size: 19,
                color: kGray700,
              ),
              const SizedBox(
                width: 16,
              ),
              AtomicText(
                isTagged ? "固定" : "リスト",
                style: AtomicTextStyle.h4,
                type: AtomicTextColor.light,
              ),
            ]),
          ),
          ...memoList
        ],
      ),
    );
  }
}

class MemoListBlock extends ConsumerWidget {
  final String text;
  final int length;
  final bool isFocused;
  final int jumpPage;
  const MemoListBlock({
    super.key,
    required this.text,
    required this.length,
    required this.isFocused,
    required this.jumpPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Button(
        onPressed: () {
          Navigator.pop(context);
          ref.read(memoPageProvider.notifier).state = jumpPage;
        },
        child: Container(
          color: isFocused ? kGray200 : kWhite,
          padding: const EdgeInsets.fromLTRB(23, 10, 23, 10),
          child: Row(children: [
            const AtomicCircle(
              type: AtomicCircleType.gray,
              radius: 6,
            ),
            const SizedBox(
              width: 16,
            ),
            AtomicText(text,
                style: AtomicTextStyle.h5, type: AtomicTextColor.dark),
            const Spacer(),
            AtomicText(length.toString(), style: AtomicTextStyle.sm)
          ]),
        ));
  }
}
