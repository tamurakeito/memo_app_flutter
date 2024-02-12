import 'package:flutter/material.dart';
import 'package:memo_app_flutter/components/header.dart';
import 'package:memo_app_flutter/components/swiper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: Header(), body: Swiper());
  }
}
