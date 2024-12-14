import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';

class AtomicText extends StatelessWidget {
  final String data;
  final AtomicTextStyle style;
  final AtomicTextColor? type;
  const AtomicText(this.data, {super.key, required this.style, this.type});

  @override
  Widget build(BuildContext context) {
    double size;
    FontWeight weight;
    Color color;
    switch (style) {
      case AtomicTextStyle.h1:
        size = kFontSizeHeadlineH1;
        weight = FontWeight.bold;
        break;
      case AtomicTextStyle.h2:
        size = kFontSizeHeadlineH2;
        weight = FontWeight.bold;
        break;
      case AtomicTextStyle.h3:
        size = kFontSizeHeadlineH3;
        weight = FontWeight.bold;
        break;
      case AtomicTextStyle.h4:
        size = kFontSizeHeadlineH4;
        weight = FontWeight.bold;
        break;
      case AtomicTextStyle.h5:
        size = kFontSizeHeadlineH5;
        weight = FontWeight.bold;
        break;
      case AtomicTextStyle.h6:
        size = kFontSizeHeadlineH6;
        weight = FontWeight.bold;
        break;
      case AtomicTextStyle.lg:
        size = kFontSizeTextLg;
        weight = FontWeight.normal;
        break;
      case AtomicTextStyle.md:
        size = kFontSizeTextMd;
        weight = FontWeight.normal;
        break;
      case AtomicTextStyle.sm:
        size = kFontSizeTextSm;
        weight = FontWeight.normal;
        break;
      case AtomicTextStyle.xs:
        size = kFontSizeTextXs;
        weight = FontWeight.normal;
        break;
      default:
        size = kFontSizeNomal;
        weight = FontWeight.normal;
        break;
    }
    ;
    switch (type) {
      case AtomicTextColor.light:
        color = kGray600;
        break;
      default:
        color = kGray900;
        break;
    }
    ;
    return Text(data,
        style: TextStyle(
          fontFamily: 'NotoSansJP',
          fontSize: size,
          fontWeight: weight,
          height: 1.0,
          color: color,
        ));
  }
}

enum AtomicTextStyle { h1, h2, h3, h4, h5, h6, lg, md, sm, xs }

enum AtomicTextColor { dark, light }
