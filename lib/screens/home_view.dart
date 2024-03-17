import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memo_app_flutter/components/add_task_modal.dart';
import 'package:memo_app_flutter/components/menu.dart';
import 'package:memo_app_flutter/components/navigation.dart';
import 'package:memo_app_flutter/components/top_bar.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/components/swiper.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/provider/provider.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kWhite,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0) {
                // 上方向にスワイプ（dyが負の値）
                ref.read(isTopModalOpenProvider.notifier).state = true;
                // print("swipe down");
              }
              if (details.delta.dy < 0) {
                // 上方向にスワイプ（dyが負の値）
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.music_note),
                            title: Text('Music'),
                            onTap: () {
                              // アクションをここに追加
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.photo_album),
                            title: Text('Photos'),
                            onTap: () {
                              // アクションをここに追加
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.videocam),
                            title: Text('Video'),
                            onTap: () {
                              // アクションをここに追加
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            child: Container(
              decoration: BoxDecoration(color: kWhite),
              child: SafeArea(
                child: Column(children: [
                  TopBar(scaffoldKey: _scaffoldKey),
                  const MemoCard(title: "Todoリスト")
                ]),
              ),
            ),
          ),
          const Menu(),
          AddTaskModal()
        ],
      ),
      drawer: const Navigation(),
    );
  }
}
