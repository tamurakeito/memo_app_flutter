import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/utils/style.dart';

class ToastType {
  bool isActive;
  String? message;
  int? duration;
  void Function()? onTap;
  bool isBelow;

  ToastType(this.isActive, this.message,
      {this.duration, this.onTap, this.isBelow = false});
}

final toastProvider = StateProvider<ToastType>((ref) => ToastType(false, null));

void setToast(WidgetRef ref, String message,
    {int? duration, void Function()? onTap, bool? isBelow}) {
  Future.microtask(() {
    ref.read(toastProvider.notifier).state = ToastType(true, message,
        duration: duration, onTap: onTap, isBelow: isBelow ?? false);
  });
}

class Toast extends HookConsumerWidget {
  Toast({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.watch(toastProvider);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );
    final animation = Tween<Offset>(
      begin: Offset(0, -1), // 画面上部から開始
      end: Offset(0, 0), // 画面の中心に終了
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    useEffect(() {
      if (toast.isActive) {
        controller.forward();
        if (toast.duration != null) {
          Timer(Duration(milliseconds: toast.duration!), () {
            ref.read(toastProvider.notifier).state = ToastType(false, null);
          });
        }
      } else {
        controller.reverse();
      }
      return null;
    }, [toast.isActive]);

    void handleOnTap() {
      toast.onTap ?? () {};
    }

    return Column(
      children: [
        SlideTransition(
          position: animation,
          child: GestureDetector(
            onTap: () {
              controller.reverse();
              if (toast.onTap != null) {
                toast.onTap!();
              }
            },
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < 0) {
                // 上方向へスワイプ
                ref.read(toastProvider.notifier).state = ToastType(false, null);
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: !toast.isBelow ? 60 : 120,
                  bottom: 50),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.7),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor,
                    offset: Offset(0, 4),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      toast.message ?? '',
                      style: TextStyle(
                          fontFamily: 'NotoSansJP',
                          fontSize: kFontSizeTextLg,
                          fontWeight: FontWeight.normal,
                          color: kWhite),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
