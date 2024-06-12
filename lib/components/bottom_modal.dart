import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:memo_app_flutter/components/toast.dart';
import 'package:memo_app_flutter/data/api/delete_memo.dart';
import 'package:memo_app_flutter/data/api/post_add_memo.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/molecules/barrier_scrim.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';

class BottomModal extends HookConsumerWidget {
  const BottomModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    final isOpen = ref.watch(isBottomModalOpenProvider);
    final isVisible = useState<bool>(false);
    final duration = 100;

    useEffect(() {
      if (isOpen) {
        Timer(const Duration(milliseconds: 1), () => isVisible.value = true);
      }
    }, [isOpen]);

    final controller =
        useAnimationController(duration: const Duration(milliseconds: 250));

    final animation = Tween<Offset>(
      begin: const Offset(0, 1), // 画面上部から開始
      end: const Offset(0, 0), // 画面の中心に終了
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    useEffect(() {
      if (isVisible.value) {
        controller.forward();
      } else {
        controller.reverse();
      }
      return null;
    }, [isVisible.value]);

    void handleClose() {
      ref.read(isBottomModalOpenProvider.notifier).state = false;
    }

    final deleteController =
        useAnimationController(duration: const Duration(milliseconds: 250));

    final deleteAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: deleteController,
      curve: Curves.easeInOut,
    ));

    final modalHeight = 320;
    final startPosition = useState<double>(0);
    final movePosition = useState<double>(0);
    final isDuration = useState<bool>(false);

    bool isModalDefault = true;
    bool isModalUp = false;
    bool isModalDown = false;
    if (movePosition.value < -1 / 2 * screenHeight + modalHeight) {
      isModalDefault = false;
      isModalUp = true;
      isModalDown = false;
    } else if (movePosition.value > 50) {
      isModalDefault = false;
      isModalUp = false;
      isModalDown = true;
    } else {
      isModalDefault = true;
      isModalUp = false;
      isModalDown = false;
    }

    final memo = ref.watch(memoProvider);

    void Function() handleSubmit = () async {
      deleteController.forward();
      await Future.delayed(Duration(milliseconds: duration));
      ref.read(isBottomModalOpenProvider.notifier).state = false;
      isVisible.value = false;
      deleteController.reset();
      movePosition.value = 0;
      List<MemoDetailType> details = ref.watch(memoDetailsProvider);
      MemoDetailType deletedMemo = details[ref.watch(memoPageProvider)];
      await deleteMemo(memo!.id);
      fetchNewMemoSummaries(ref);
      setToast(
        ref,
        '削除したメモを元に戻します',
        duration: 5000,
        onTap: () async {
          await postAddMemo(deletedMemo);
          fetchNewMemoSummaries(ref);
        },
      );
    };

    void Function() handleCancel = () => {
          isVisible.value = false,
          Timer(Duration(milliseconds: duration), () {
            movePosition.value = 0;
            handleClose();
          })
        };

    return isOpen
        ? SlideTransition(
            position: deleteAnimation,
            child: Stack(
              children: [
                BarrierScrim(
                  isActive: isVisible,
                  onTap: handleClose,
                  onDragDown: handleClose,
                ),
                Column(
                  children: [
                    const Spacer(),
                    SlideTransition(
                      position: animation,
                      child: GestureDetector(
                        onPanStart: (details) {
                          startPosition.value = details.globalPosition.dy;
                        },
                        onPanUpdate: (details) => {
                          movePosition.value =
                              details.globalPosition.dy - startPosition.value,
                          if (movePosition.value <
                              -screenHeight + modalHeight + 160)
                            {
                              handleSubmit(),
                            }
                          else if (movePosition.value > modalHeight - 120)
                            {
                              handleCancel(),
                            },
                        },
                        onPanEnd: (details) => {
                          if (movePosition.value <
                              -1 / 2 * screenHeight + modalHeight)
                            {
                              handleSubmit(),
                            }
                          else if (movePosition.value > 50)
                            {
                              handleCancel(),
                            }
                          else
                            {
                              isDuration.value = true,
                              movePosition.value = 0,
                              Timer(Duration(milliseconds: duration), () {
                                isDuration.value = false;
                              })
                            },
                        },
                        child: AnimatedContainer(
                          duration: Duration(
                            milliseconds: isDuration.value ? duration : 1,
                          ),
                          alignment: Alignment.bottomCenter,
                          height:
                              modalHeight + bottomPadding - movePosition.value,
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(top: 50),
                          // child: const DefaultView(),
                          // child: UpView(),
                          // child: DownView(),
                          child: Stack(
                            children: [
                              ModalContent(
                                view: DefaultView(title: memo!.name),
                                isActive: isModalDefault,
                              ),
                              ModalContent(
                                view: UpView(),
                                isActive: isModalUp,
                              ),
                              ModalContent(
                                view: DownView(),
                                isActive: isModalDown,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class ModalContent extends HookWidget {
  final StatelessWidget view;
  final bool isActive;
  ModalContent({
    super.key,
    required this.view,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    const int duration = 100;
    final isDisplay = useState<bool>(true);

    final controller = useAnimationController(
        duration: const Duration(milliseconds: duration));
    // ..repeat(reverse: true);

    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    useEffect(() {
      if (isActive) {
        isDisplay.value = true;
        controller.forward();
      } else {
        controller.reverse();
        Timer(const Duration(milliseconds: duration),
            () => isDisplay.value = true);
      }
    }, [isActive]);
    return isDisplay.value
        ? FadeTransition(
            opacity: animation,
            child: view,
          )
        : const SizedBox.shrink();
  }
}

class DefaultView extends StatelessWidget {
  final String title;
  const DefaultView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AtomicText(
          "『$title』を削除します",
          style: AtomicTextStyle.h3,
          type: AtomicTextColor.dark,
        ),
        ChevronsUpAnimation(),
        Align(
          alignment: Alignment(-0.007, 0),
          child: Icon(
            LineIcons.alternateTrashAlt,
            size: 48,
          ),
        ),
      ],
    );
  }
}

class UpView extends StatelessWidget {
  const UpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Align(
        alignment: Alignment(-0.007, 0),
        child: Icon(
          LineIcons.alternateTrashAlt,
          size: 48,
        ),
      ),
      ChevronsUpAnimation(),
    ]);
  }
}

class DownView extends StatelessWidget {
  const DownView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AtomicText(
        "キャンセル",
        style: AtomicTextStyle.h3,
        type: AtomicTextColor.dark,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15),
        child: Icon(
          LineIcons.timesCircle,
          size: 48,
        ),
      ),
    ]);
  }
}

class ChevronsUpAnimation extends HookWidget {
  const ChevronsUpAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final offsetController =
        useAnimationController(duration: const Duration(milliseconds: 1200));
    // ..repeat(reverse: false);

    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: offsetController,
      curve: Curves.easeInOut,
    ));

    final opacityController =
        useAnimationController(duration: const Duration(milliseconds: 600));
    // ..repeat(reverse: true);

    final opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: opacityController,
      curve: Curves.easeInOut,
    ));

    useEffect(() {
      offsetController.repeat(
          period: const Duration(milliseconds: 1000), reverse: false);
      opacityController.repeat(
          period: const Duration(milliseconds: 500), reverse: true);
    }, []);
    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(
        position: offsetAnimation,
        child: const SizedBox(
          height: 80,
          child: Icon(
            FeatherIcons.chevronsUp,
            size: 36,
          ),
        ),
      ),
    );
  }
}
