import 'dart:ffi';
import 'package:flutter/material.dart';

// const kColorWhite = Color(0xFFF0F0F0);

// const kColorRed = Color(0xFFFFD2D2);
// const kColorOrange = Color(0xFFFFDFBF);
// const kColorYellow = Color(0xFFFFEA9E);
// const kColorBlue = Color(0xFFCCE0FF);

// const kColorCyan = Color(0xFFD2F9F6);
// const kColorPurple = Color(0xFFF5F5FF);

/// Typography - Font Weight
const FontWeight kFontWeightText = FontWeight.w400;
const FontWeight kFontWeightHeadline = FontWeight.bold;

/// Typography - Font Size
const double kFontSizeNomal = 14;
const double kFontSizeHeadlineH1 = 23;
const double kFontSizeHeadlineH2 = 18;
const double kFontSizeHeadlineH3 = 16;
const double kFontSizeHeadlineH4 = 14;
const double kFontSizeHeadlineH5 = 12;
const double kFontSizeHeadlineH6 = 10;

const double kFontSizeTextLg = 16;
const double kFontSizeTextMd = 14;
const double kFontSizeTextSm = 12;
const double kFontSizeTextXs = 10;

/// Color
// black
const Color kBlack = Color(0xff303030);
// gray
const Color kGray000 = Color(0xffffffff);
const Color kGray100 = Color(0xfffafafa);
const Color kGray200 = Color(0xfff1f1f1);
const Color kGray300 = Color(0xffe8e8e8);
const Color kGray400 = Color(0xffdddddd);
const Color kGray500 = Color(0xffc6c6c6);
const Color kGray600 = Color(0xffafafaf);
const Color kGray700 = Color(0xff7d7d7d);
const Color kGray800 = Color(0xff4a4a4a);
const Color kGray900 = Color(0xff373737);
// white
const Color kWhite = Color(0xffffffff);
const Color kWhiteSoft = kGray400;
const Color kWhiteHover = kGray300;
// other
const Color kScrimColor = Color(0x8A000000);
const Color kTransplant = Color.fromRGBO(0, 0, 0, 0);

/// Layout
double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
