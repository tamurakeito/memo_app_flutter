import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/data/api/delete_task.dart';
import 'package:memo_app_flutter/data/api/put_restatus_task.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/ui/molecules/barrier_scrim.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Menu extends HookConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isMenuOpenProvider);
    final isVisible = useState<bool>(false);
    final duration = Duration(milliseconds: 100);
    final list = ref.watch(memoDetailsProvider);
    final page = ref.watch(memoPageProvider);

    useEffect(() {
      if (isOpen)
        Timer(const Duration(milliseconds: 1), () => isVisible.value = true);
    }, [isOpen]);

    Future<void> handleTaskBulkOperate(
      Future<void> handleOperation(TaskType task),
    ) async {
      isVisible.value = false;
      Timer(
        duration,
        () => ref.read(isMenuOpenProvider.notifier).state = false,
      );
      ref.read(isLoadingProvider.notifier).state = true;
      final memo = list[page];
      memo.tasks.forEach((task) {
        handleOperation(task);
      });
      await fetchMemoDetail(ref, page, memo.id);
      ref.read(isLoadingProvider.notifier).state = false;
    }

    Future<void> handleTaskBulkUncompletes() async {
      Future<void> handleOperation(TaskType task) async {
        final TaskType data = TaskType(
          id: task.id,
          name: task.name,
          memoId: task.memoId,
          complete: false,
        );
        await putRestatusTask(data);
      }

      handleTaskBulkOperate(handleOperation);
    }

    Future<void> handleTaskBulkCompletes() async {
      Future<void> handleOperation(TaskType task) async {
        final TaskType data = TaskType(
          id: task.id,
          name: task.name,
          memoId: task.memoId,
          complete: true,
        );
        await putRestatusTask(data);
      }

      handleTaskBulkOperate(handleOperation);
    }

    Future<void> handleTaskBulkDelete() async {
      Future<void> handleOperation(TaskType task) async {
        await deleteTask(task.id);
      }

      handleTaskBulkOperate(handleOperation);
    }

    return isOpen
        ? Stack(children: [
            BarrierScrim(
                isActive: isVisible,
                onTap: () =>
                    ref.read(isMenuOpenProvider.notifier).state = false),
            SafeArea(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          opacity: isVisible.value ? 1 : 0,
                          duration: duration,
                          child: Container(
                            width: 220,
                            padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                            margin: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: const Row(
                                    children: [
                                      AtomicText(
                                        "メモ",
                                        style: AtomicTextStyle.h4,
                                        type: AtomicTextColor.light,
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                MenuBlock(
                                  icon: LineIcons.penFancy,
                                  text: "メモを編集",
                                  onPressed: () {
                                    isVisible.value = false;
                                    Timer(
                                      duration,
                                      () => ref
                                          .read(isMenuOpenProvider.notifier)
                                          .state = false,
                                    );
                                    Timer(
                                        duration,
                                        () => ref
                                            .read(isRenameMemoModalOpenProvider
                                                .notifier)
                                            .state = true);
                                  },
                                ),
                                MenuBlock(
                                  icon: LineIcons.alternateTrashAlt,
                                  text: "メモを削除",
                                  onPressed: () {
                                    isVisible.value = false;
                                    Timer(
                                      duration,
                                      () => ref
                                          .read(isMenuOpenProvider.notifier)
                                          .state = false,
                                    );
                                    Timer(
                                        duration,
                                        () => ref
                                            .read(isBottomModalOpenProvider
                                                .notifier)
                                            .state = true);
                                  },
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                  decoration: const BoxDecoration(
                                      border: Border(bottom: AtomicBorder())),
                                ),
                                MenuBlock(
                                  icon: LineIcons.circle,
                                  text: "全てを未完了に",
                                  onPressed: handleTaskBulkUncompletes,
                                ),
                                MenuBlock(
                                  icon: LineIcons.checkCircle,
                                  text: "全てを完了済に",
                                  onPressed: handleTaskBulkCompletes,
                                ),
                                MenuBlock(
                                  icon: LineIcons.timesCircle,
                                  text: "完了済を削除",
                                  onPressed: handleTaskBulkDelete,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer()
                      ],
                    )))
          ])
        : const SizedBox.shrink();
  }

  // late AnimationController _controller;

  // void close() {
  //   _controller.fling(velocity: -1.0);
  //   // widget.drawerCallback?.call(false);å
  // }

  // late ColorTween _scrimColorTween;
  // ColorTween _buildScrimColorTween() {
  //   return ColorTween(
  //     begin: Colors.transparent,
  //     end: Colors.black54,
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   _scrimColorTween = _buildScrimColorTween();
  //   return BlockSemantics(
  //     // 背景の要素を操作できないようにする
  //     child: ExcludeSemantics(
  //       // スクリーンリーダーにアクセス不可能になるように
  //       excluding: false, // スクリーンリーダーにアクセス不可能になるように
  //       child: GestureDetector(
  //         onTap: close,
  //         child: Semantics(
  //           // アクセシビリティを可能にする
  //           // 視覚障害アクセシビリティ
  //           label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //           child: Container(
  //             // The drawer's "scrim"
  //             color: _scrimColorTween.evaluate(_controller),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class MenuBlock extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onPressed;
  const MenuBlock(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // style: ButtonStyle(
        //     padding: MaterialStateProperty.all(value),
        //     overlayColor: MaterialStateProperty.all(kGray400)),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(children: [
            Icon(
              icon,
              size: 20,
              color: kGray900,
            ),
            const SizedBox(
              width: 16,
            ),
            AtomicText(
              text,
              style: AtomicTextStyle.h4,
              type: AtomicTextColor.dark,
            ),
            const Spacer(),
          ]),
        ));
  }
}
