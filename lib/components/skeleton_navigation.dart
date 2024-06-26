import 'package:flutter/material.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/ui/atoms/skeleton_container.dart';

class SkeletonNavigation extends StatelessWidget {
  const SkeletonNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 100),
      decoration: const BoxDecoration(border: Border(top: AtomicBorder())),
      child: Column(
        children: [
          SkeletonMemoListBox(
            isTagged: true,
            memoList: [
              SkeletonMemmoBlock(),
              SkeletonMemmoBlock(),
              SkeletonMemmoBlock(),
            ],
          ),
          SkeletonMemoListBox(
            isTagged: false,
            memoList: [
              SkeletonMemmoBlock(),
              SkeletonMemmoBlock(),
              SkeletonMemmoBlock(),
              SkeletonMemmoBlock(),
            ],
          ),
        ],
      ),
    );
  }
}

class SkeletonMemoListBox extends StatelessWidget {
  final bool isTagged;
  final List<Widget> memoList;
  const SkeletonMemoListBox({
    super.key,
    required this.isTagged,
    required this.memoList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(21, 10, 21, 10),
            child: Row(
              children: [
                SkeletonContainer(width: 19, height: 19),
                const SizedBox(
                  width: 16,
                ),
                SkeletonContainer(width: 42, height: 14),
                Spacer(),
                if (!isTagged) SkeletonContainer(width: 19, height: 19),
              ],
            ),
          ),
          ...memoList,
        ],
      ),
    );
  }
}

class SkeletonMemmoBlock extends StatelessWidget {
  const SkeletonMemmoBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(23, 10, 23, 10),
      child: Row(children: [
        SkeletonContainer(width: 16, height: 16),
        const SizedBox(
          width: 16,
        ),
        SkeletonContainer(width: 60, height: 12),
        const Spacer(),
        SkeletonContainer(width: 12, height: 12),
      ]),
    );
  }
}
