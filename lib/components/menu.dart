import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/provider/provider.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/ui/molecules/barrier_scrim.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Menu extends HookConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isMenuOpenProvider);
    final isVisible = useState<bool>(false);
    final duration = 100;

    useEffect(() {
      if (isOpen)
        Timer(const Duration(milliseconds: 1), () => isVisible.value = true);
    }, [isOpen]);

    return isOpen
        ? Stack(children: [
            BarrierScrim(
                isActive: isVisible,
                onPressed: () =>
                    ref.read(isMenuOpenProvider.notifier).state = false),
            SafeArea(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          opacity: isVisible.value ? 1 : 0,
                          duration: Duration(milliseconds: duration),
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
                                          style: AtomicTextStyle.h4,
                                          type: AtomicTextColor.light,
                                          text: "メモ"),
                                      Spacer()
                                    ],
                                  ),
                                ),
                                MenuBlock(
                                  icon: LineIcons.penFancy,
                                  text: "メモを編集",
                                  onPressed: () {
                                    ref
                                        .read(isMenuOpenProvider.notifier)
                                        .state = true;
                                  },
                                ),
                                MenuBlock(
                                  icon: LineIcons.alternateTrashAlt,
                                  text: "メモを削除",
                                  onPressed: () {},
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
                                  onPressed: () {},
                                ),
                                MenuBlock(
                                  icon: LineIcons.checkCircle,
                                  text: "全てを完了済に",
                                  onPressed: () {},
                                ),
                                MenuBlock(
                                  icon: LineIcons.timesCircle,
                                  text: "完了済を削除",
                                  onPressed: () {},
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
                style: AtomicTextStyle.h4,
                type: AtomicTextColor.dark,
                text: text),
            const Spacer(),
          ]),
        ));
  }
}
