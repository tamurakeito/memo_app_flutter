import 'package:flutter/material.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/style.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
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
            const MemoListBox(
              isTagged: true,
              memoList: [
                MemoListBlock(
                  text: "タスクリスト",
                  length: 12,
                  isFocused: false,
                ),
                MemoListBlock(
                  text: "タスクリスト",
                  length: 12,
                  isFocused: true,
                ),
                MemoListBlock(
                  text: "タスクリスト",
                  length: 12,
                  isFocused: false,
                ),
              ],
            ),
            const MemoListBox(
              isTagged: false,
              memoList: [
                MemoListBlock(
                  text: "タスクリスト",
                  length: 12,
                  isFocused: false,
                ),
                MemoListBlock(
                  text: "タスクリスト",
                  length: 12,
                  isFocused: false,
                ),
                MemoListBlock(
                  text: "タスクリスト",
                  length: 12,
                  isFocused: false,
                ),
              ],
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

class MemoListBlock extends StatelessWidget {
  final String text;
  final int length;
  final bool isFocused;
  const MemoListBlock(
      {super.key,
      required this.text,
      required this.length,
      required this.isFocused});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        AtomicText(text, style: AtomicTextStyle.h5, type: AtomicTextColor.dark),
        const Spacer(),
        AtomicText(length.toString(), style: AtomicTextStyle.sm)
      ]),
    );
  }
}
