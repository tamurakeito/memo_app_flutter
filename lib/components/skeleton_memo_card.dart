import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/ui/atoms/skeleton_container.dart';
import 'package:memo_app_flutter/utils/style.dart';

class SkeletonMemoCard extends StatelessWidget {
  const SkeletonMemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // 未完了リスト
      Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(border: Border(bottom: AtomicBorder())),
        child: Column(
          children: [
            // TitleBlock
            Container(
              padding: EdgeInsets.only(
                left: 16,
                top: 18,
                bottom: 13,
              ),
              child: Row(
                children: [
                  SkeletonContainer(width: 200, height: 24),
                  Spacer(),
                ],
              ),
            ),
            // ListBlock
            SkeletonListBlock(),
            SkeletonListBlock(),
            SkeletonListBlock(),
          ],
        ),
      ),
      // 完了済リスト
      Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 18, 10),
          child: Row(
            children: [
              SkeletonContainer(width: 36, height: 20),
              const Spacer(),
              SkeletonContainer(width: 20, height: 20),
            ],
          ),
        ),
        SkeletonListBlock(),
        SkeletonListBlock(),
        SkeletonListBlock(),
      ]),
    ]);
  }
}

class SkeletonListBlock extends StatelessWidget {
  const SkeletonListBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        top: 12,
        bottom: 10,
      ),
      child: Row(
        children: [
          SkeletonContainer(width: 160, height: 18),
          Spacer(),
        ],
      ),
    );
  }
}
