import 'package:flutter/material.dart';
import 'package:memo_app_flutter/components/memo_card.dart';

class Swiper extends StatelessWidget {
  const Swiper({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    List<String> arr = ['First Page', 'Second Page', 'Third Page'];
    List<Widget> contents = arr.map<Widget>((txt) {
      return MemoCard(title: txt);
    }).toList();
    return PageView(controller: controller, children: contents);
  }
}

// ぬるぬる動くのが気持ち悪い