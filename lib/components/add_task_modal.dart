import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/components/top_modal.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:line_icons/line_icons.dart';

class AddTaskModal extends TopModal {
  AddTaskModal({Key? key})
      : super(
            key: key,
            placeholder: "新しいタスク",
            visualIcon: FeatherIcons.penTool,
            execIcon: LineIcons.plus,
            onPressedExec: () {});
}
