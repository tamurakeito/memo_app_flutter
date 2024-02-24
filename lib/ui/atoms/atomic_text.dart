import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';

class AtomicText extends StatelessWidget {
  final AtomicTextStyle style;
  final String text;
  const AtomicText({super.key, required this.style, required this.text});

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle;
    double size;
    FontWeight weight;
    switch (style) {
      case AtomicTextStyle.h1:
        size = kFontSizeHeadlineH1;
        weight = FontWeight.bold;
        break;
      default:
        size = kFontSizeHeadlineH1;
        weight = FontWeight.bold;
        break;
    }
    ;
    return Text(text,
        style: TextStyle(
            fontFamily: 'NotoSansJP', fontSize: size, fontWeight: weight));
  }
}

enum AtomicTextStyle { h1, h2, h3, h4, h5, h6, lg, md, sm, xs }
