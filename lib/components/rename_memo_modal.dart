import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/data/api/post_add_task.dart';
import 'package:memo_app_flutter/data/api/put_restatus_memo.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:line_icons/line_icons.dart';

class RenameMemoModal extends HookConsumerWidget {
  const RenameMemoModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = useTextEditingController();
    final MemoSummaryType? memo = ref.watch(memoProvider);
    final isOpen = ref.watch(isRenameMemoModalOpenProvider);
    final page = ref.watch(memoPageProvider);

    useEffect(() {
      if (isOpen) controller.text = memo != null ? memo.name : '';
    }, [isOpen]);

    Future<void> handleExec() async {
      if (memo != null && controller.text != memo.name) {
        final MemoSummaryType data = MemoSummaryType(
          id: memo.id,
          name: controller.text,
          tag: memo.tag,
          length: memo.length,
        );
        putRestatusMemo(data).catchError((error) {
          print("Error fetching data5: $error");
        }).whenComplete(() async {
          controller.text = "";
          ref.read(isLoadingProvider.notifier).state = true;
          await fetchMemoDetail(ref, page, memo!.id, page);
          ref.read(isLoadingProvider.notifier).state = false;
          fetchMemoSummaries(ref);
        });
        ;
      }
    }

    return TopModal(
      placeholder: "新しいタイトルを入力",
      visualIcon: FeatherIcons.edit3,
      execIcon: FeatherIcons.check,
      textController: controller,
      onPressedExec: handleExec,
      isOpenProvider: isRenameMemoModalOpenProvider,
    );
  }
}
