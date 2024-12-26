import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/components/skeleton_top_bar.dart';
import 'package:memo_app_flutter/data/api/put_restatus_memo.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/ui/molecules/loading_circle_mini.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';

class TopBar extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TopBar({super.key, required this.scaffoldKey});
  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MemoSummaryType? memo = ref.watch(memoProvider);

    final isLoading = useState(false);

    Future<void> handleRestatusTag(bool tag) async {
      try {
        isLoading.value = true;
        if (memo != null) {
          await putRestatusMemo(MemoSummaryType(
            id: memo.id,
            name: memo.name,
            tag: tag,
            length: memo.length,
          ));
        }

        final sortedList = await fetchMemoSummaries(ref);

        int index = sortedList.indexWhere((element) => element.id == memo!.id);
        ref.read(memoPageProvider.notifier).state = index;
        isLoading.value = false;
      } catch (error) {
        print("Error fetching data3: $error");
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        // 下端に線を追加する
        border: Border(bottom: AtomicBorder()),
      ),
      child: Row(
        children: [
          TopBarIconButton(
            icon: FeatherIcons.menu,
            onPressed: () {
              openDrawer();
            },
          ),
          const Spacer(),
          if (memo != null)
            Row(children: [
              !isLoading.value
                  ? TopBarIconButton(
                      icon: memo.tag ? Icons.bookmark : Icons.bookmark_border,
                      onPressed: () {
                        handleRestatusTag(!memo.tag);
                      },
                    )
                  : LoadingCircleMini(),
              const SizedBox(
                width: 18,
              ),
              TopBarIconButton(
                icon: FeatherIcons.moreVertical,
                onPressed: () {
                  ref.read(isMenuOpenProvider.notifier).state = true;
                },
              ),
            ])
        ],
      ),
    );
  }
}

class TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  const TopBarIconButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 24,
        color: kGray700,
      ),
    );
  }
}
