import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/add_task_modal.dart';
import 'package:memo_app_flutter/components/bottom_modal.dart';
import 'package:memo_app_flutter/components/menu.dart';
import 'package:memo_app_flutter/components/navigation.dart';
import 'package:memo_app_flutter/components/remove_memo_modal.dart';
import 'package:memo_app_flutter/components/skeleton_memo_card.dart';
import 'package:memo_app_flutter/components/skeleton_top_bar.dart';
import 'package:memo_app_flutter/components/top_bar.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/components/swiper.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/ui/atoms/skeleton_container.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMenuOpen = ref.watch(isMenuOpenProvider);
    final isTopModalOpen = ref.watch(isTopModalOpenProvider);
    final isBottomModalOpen = ref.watch(isBottomModalOpenProvider);

    final isLoading = useState<bool>(false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kWhite,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (!isMenuOpen && !isTopModalOpen && !isBottomModalOpen) {
                if (details.delta.dy > 0) {
                  // 下方向にスワイプ
                  ref.read(isTopModalOpenProvider.notifier).state = true;
                }
                if (details.delta.dy < 0) {
                  // 上方向にスワイプ
                  ref.read(isBottomModalOpenProvider.notifier).state = true;
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(color: kWhite),
              child: SafeArea(
                child: Column(
                    children: !isLoading.value
                        ? [
                            TopBar(scaffoldKey: _scaffoldKey),
                            Swiper(),
                          ]
                        : [
                            SkeletonTopBar(),
                            SkeletonMemoCard(),
                          ]),
              ),
            ),
          ),
          const Menu(),
          AddTaskModal(),
          RemoveMemoModal(),
        ],
      ),
      drawer: const Navigation(),
    );
  }
}
