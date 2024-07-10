import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/data/api/post_add_task.dart';
import 'package:memo_app_flutter/data/api/put_restatus_task.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:line_icons/line_icons.dart';

class EditTaskModal extends HookConsumerWidget {
  const EditTaskModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = useTextEditingController();
    final MemoSummaryType? memo = ref.watch(memoProvider);
    final isOpen = ref.watch(isEditTaskModalOpenProvider);
    final page = ref.watch(memoPageProvider);
    final task = ref.watch(taskProvider);

    useEffect(() {
      if (isOpen) controller.text = task != null ? task.name : '';
    }, [isOpen]);

    Future<void> handleExec() async {
      if (task != null &&
          controller.text != "" &&
          controller.text != task.name) {
        final TaskType data = TaskType(
          id: task.id,
          name: controller.text,
          memoId: task.memoId,
          complete: task.complete,
        );
        putRestatusTask(data).catchError((error) {
          print("Error fetching data5: $error");
        }).whenComplete(() async {
          controller.text = "";
          await fetchMemoDetail(ref, page, memo!.id, page);
        });
      }
    }

    return TopModal(
      placeholder: "タスクを入力してください",
      visualIcon: FeatherIcons.penTool,
      execIcon: LineIcons.plus,
      textController: controller,
      onPressedExec: handleExec,
      isOpenProvider: isEditTaskModalOpenProvider,
    );
  }
}
