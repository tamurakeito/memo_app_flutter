import 'package:flutter/material.dart';
import 'package:memo_app_flutter/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';

class PhoneModule extends StatelessWidget {
  final String number;
  PhoneModule(this.number, {super.key});

  @override
  Widget build(BuildContext context) {
    void launchPhone(String phoneNumber) async {
      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'この電話番号は開けません: $phoneNumber';
      }
    }

    return GestureDetector(
      onTap: () {
        launchPhone(number);
      },
      child: Text(
        number,
        style: TextStyle(
          fontFamily: 'NotoSansJP',
          fontSize: kFontSizeTextMd,
          fontWeight: FontWeight.normal,
          height: 1.0,
          color: kGray700,
          // decoration: TextDecoration.underline,
          decorationColor: kGray600,
        ),
      ),
    );
  }
}
