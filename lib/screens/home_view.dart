import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:memo_app_flutter/components/add_task_modal.dart';
import 'package:memo_app_flutter/components/bottom_modal.dart';
import 'package:memo_app_flutter/components/menu.dart';
import 'package:memo_app_flutter/components/navigation.dart';
import 'package:memo_app_flutter/components/remove_memo_modal.dart';
import 'package:memo_app_flutter/components/rename_memo_modal.dart';
import 'package:memo_app_flutter/components/skeleton_memo_card.dart';
import 'package:memo_app_flutter/components/skeleton_top_bar.dart';
import 'package:memo_app_flutter/components/top_bar.dart';
import 'package:memo_app_flutter/components/memo_card.dart';
import 'package:memo_app_flutter/components/swiper.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/data/api/get_client_data.dart';
import 'package:memo_app_flutter/data/api/get_memo_summary.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/skeleton_container.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMenuOpen = ref.watch(isMenuOpenProvider);
    final isTopModalOpen = ref.watch(isAddTaskModalOpenProvider);
    final isBottomModalOpen = ref.watch(isBottomModalOpenProvider);

    final isLoading = ref.watch(isLoadingProvider);

    Future<void> fetch() async {
      final List<MemoSummaryType> sortedList = await fetchMemoSummaries(ref);
      final ClientData clientData = await getClientData();
      final int tab = clientData.tab;
      ref.read(memoPageProvider.notifier).state = tab;

      if (sortedList.isNotEmpty && sortedList.length > tab) {
        fetchMemoDetail(ref, tab, sortedList[tab].id, tab);
      }
    }

    useEffect(() {
      fetch();
    }, []);

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
                  ref.read(isAddTaskModalOpenProvider.notifier).state = true;
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
                    children: !isLoading
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
          RenameMemoModal(),
          RemoveMemoModal(),
        ],
      ),
      drawer: Navigation(homeRef: ref),
    );
  }
}
