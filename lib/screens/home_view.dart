import 'package:flutter/material.dart';
import 'package:memo_app_flutter/components/top_bar.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/components/swiper.dart';
import 'package:memo_app_flutter/utils/style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(appBar: TopBar(), body: Swiper());
    // return const Column(children: [TopBar(), const Swiper()]);
    return const Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
            child: Column(children: [TopBar(), MemoCard(title: "Todoリスト")])));
  }
}
