import 'package:flutter/material.dart';
import 'package:memo_app_flutter/components/menu.dart';
import 'package:memo_app_flutter/components/navigation.dart';
import 'package:memo_app_flutter/components/top_bar.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/components/swiper.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(appBar: TopBar(), body: Swiper());
    // return const Column(children: [TopBar(), const Swiper()]);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kWhite,
      body: Stack(
        children: [
          SafeArea(
              child: Column(children: [
            TopBar(scaffoldKey: _scaffoldKey),
            const MemoCard(title: "Todoリスト")
          ])),
          const Menu()
        ],
      ),
      drawer: const Navigation(),
    );
  }
}
