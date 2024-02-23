import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';

class AtomicText extends StatelessWidget {
  final AtomicTextStyle style;
  final String text;
  const AtomicText({super.key, required this.style, required this.text});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    switch (style) {
      case AtomicTextStyle.h1:
        textStyle = const TextStyle(
            fontSize: kFontSizeHeadlineH1, fontWeight: FontWeight.bold);
        break;
      default:
        textStyle =
            const TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
    }
    ;
    return Text(text, style: textStyle);
  }
}

enum AtomicTextStyle { h1, h2, h3, h4, h5, h6, lg, md, sm, xs }
