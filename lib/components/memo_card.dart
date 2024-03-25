import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/style.dart';

class MemoCard extends StatelessWidget {
  final String title;
  const MemoCard({super.key, required this.title});

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
                text: title,
              ),
              ListBlock(isCompleted: false, text: "アプリ作る"),
              ListBlock(isCompleted: false, text: "chatGTP"),
              ListBlock(isCompleted: false, text: "服買う"),
            ],
          ),
        ),
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
            const ListBlock(isCompleted: true, text: "アプリ作る"),
            const ListBlock(isCompleted: true, text: "chatGTP"),
            const ListBlock(isCompleted: true, text: "服買う"),
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
