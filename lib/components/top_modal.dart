import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/provider/provider.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/ui/molecules/barrier_scrim.dart';
import 'package:memo_app_flutter/utils/style.dart';

class TopModal extends HookConsumerWidget {
  final String placeholder;
  final IconData visualIcon;
  final IconData execIcon;
  final void Function() onPressedExec;
  // final Widget child;
  const TopModal(
      {super.key,
      required this.placeholder,
      required this.visualIcon,
      required this.execIcon,
      required this.onPressedExec});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double topPadding = MediaQuery.of(context).padding.top;

    final isOpen = ref.watch(isTopModalOpenProvider);
    final isVisible = useState<bool>(false);
    final duration = 100;

    FocusNode myFocusNode = FocusNode();

    useEffect(() {
      if (isOpen) {
        Timer(const Duration(milliseconds: 1), () => isVisible.value = true);
      }
      myFocusNode.requestFocus();
    }, [isOpen]);

    // AnimationControllerをHookを使って作成
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );

    // アニメーションの初期化と開始
    useEffect(() {
      if (isVisible.value) {
        controller.forward();
      } else {
        controller.reverse();
      }
      return null;
    }, [isVisible.value]);

    // アニメーションの定義
    final animation = Tween<Offset>(
      begin: Offset(0, -1), // 画面上部から開始
      end: Offset(0, 0), // 画面の中心に終了
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    void handleClose() {
      ref.read(isTopModalOpenProvider.notifier).state = false;
    }

    return isOpen
        ? Stack(
            children: [
              BarrierScrim(
                isActive: isVisible,
                onTap: handleClose,
                onDragUp: handleClose,
              ),
              SlideTransition(
                position: animation,
                child: Container(
                    alignment: Alignment.topCenter,
                    height: 50 + topPadding,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(
                        top: topPadding + 10, left: 10, right: 10, bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          visualIcon,
                          size: 24,
                          color: kGray900,
                        ),
                        // TextField(),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontFamily: 'NotoSansJP',
                              fontSize: kFontSizeTextLg,
                              fontWeight: FontWeight.normal,
                              color: kBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: placeholder,
                              border: InputBorder.none, // 枠線なし
                              contentPadding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                            ),
                            focusNode: myFocusNode,
                          ),
                        ),
                        TopModalIconButton(
                            icon: execIcon,
                            onPressed: () {
                              onPressedExec();
                              isVisible.value = false;
                              Timer(
                                  Duration(milliseconds: duration),
                                  () => ref
                                      .read(isTopModalOpenProvider.notifier)
                                      .state = false);
                            })
                      ],
                    )),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}

class TopModalIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  const TopModalIconButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 24,
        color: kGray900,
      ),
    );
  }
}
