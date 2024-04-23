import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/data/api/post_add_task.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:line_icons/line_icons.dart';

class AddTaskModal extends HookConsumerWidget {
  const AddTaskModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = useTextEditingController();
    final MemoSummaryType? memo = ref.watch(memoProvider);

    Future<void> handleExec() async {
      final TaskType data = TaskType(
          id: 0, name: controller.text, memoId: memo!.id, complete: false);
      postAddTask(data).catchError((error) {
        print("Error fetching data: $error");
      }).whenComplete(() {
        controller.text = "";
      });
    }

    return TopModal(
      placeholder: "新しいタスク",
      visualIcon: FeatherIcons.penTool,
      execIcon: LineIcons.plus,
      textController: controller,
      onPressedExec: handleExec,
    );
  }
}
