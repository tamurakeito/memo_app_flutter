import 'package:flutter/material.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/utils/style.dart';

class MemoCard extends StatelessWidget {
  final String title;
  const MemoCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TitleBlock(
          text: "タスクリスト",
        ),
        ListBlock(text: "アプリ作る"),
        ListBlock(text: "chatGTP"),
        ListBlock(text: "服買う"),
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
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: const BoxDecoration(color: kWhite),
      child: Row(children: [
        const AtomicCircle(
          type: AtomicCircleType.gray,
        ),
        const SizedBox(
          width: 16,
        ),
        AtomicText(style: AtomicTextStyle.h1, text: text)
      ]),
    );
  }
}

class ListBlock extends StatelessWidget {
  final String text;
  const ListBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: const BoxDecoration(color: kWhite),
      child: Row(children: [
        const AtomicCircle(
          type: AtomicCircleType.white,
        ),
        const SizedBox(
          width: 16,
        ),
        AtomicText(style: AtomicTextStyle.h1, text: text)
      ]),
    );
  }
}
