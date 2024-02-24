import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  const Button({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkResponse(onTap: onPressed, child: child);
  }
}
