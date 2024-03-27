import 'package:flutter/material.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/ui/atoms/skeleton_container.dart';

class SkeletonTopBar extends StatelessWidget {
  const SkeletonTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        // 下端に線を追加する
        border: Border(bottom: AtomicBorder()),
      ),
      child: Row(
        children: [
          SkeletonContainer(width: 24, height: 24),
          const Spacer(),
          SkeletonContainer(width: 24, height: 24),
          const SizedBox(
            width: 18,
          ),
          SkeletonContainer(width: 24, height: 24),
        ],
      ),
    );
  }
}
