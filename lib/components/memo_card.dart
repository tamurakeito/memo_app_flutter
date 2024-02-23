import 'package:flutter/material.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/molecules/item_unit.dart';

class MemoCard extends StatelessWidget {
  final String title;
  const MemoCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ItemUnit(
          text: "Todoリスト",
        )
      ],
    );
  }
}
