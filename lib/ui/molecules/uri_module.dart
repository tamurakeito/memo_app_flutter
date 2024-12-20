import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';

class UriModule extends StatelessWidget {
  final String uri;
  UriModule(this.uri, {super.key});

  @override
  Widget build(BuildContext context) {
    void launchURL(Uri url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    return GestureDetector(
      onTap: () {
        launchURL(Uri.parse(uri));
      },
      child: Text(
        uri,
        style: TextStyle(
          fontFamily: 'NotoSansJP',
          fontSize: kFontSizeTextMd,
          fontWeight: FontWeight.normal,
          height: 1.0,
          color: kGray700,
          decoration: TextDecoration.underline,
          decorationColor: kGray600,
        ),
      ),
    );
  }
}

bool isValidUri(String uri) {
  try {
    var parsedUri = Uri.parse(uri);
    return parsedUri.hasScheme; // スキーマが存在するか確認
  } catch (e) {
    // URIが無効な場合、例外が発生
    return false;
  }
}

bool isValidPhoneNum(String phoneNum) {
  final phoneRegex = RegExp(r'^\+?[0-9\s\-()]+$');
  return phoneRegex.hasMatch(phoneNum);
}
