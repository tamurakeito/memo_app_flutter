import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/utils/style.dart';

class IrregularCard extends StatelessWidget {
  final String message;
  final IconData icon;
  const IrregularCard({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context) - 350,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 42,
            color: kGray500,
          ),
          const SizedBox(
            height: 18,
          ),
          AtomicText(
            message,
            style: AtomicTextStyle.h5,
            type: AtomicTextColor.light,
          ),
        ],
      ),
    );
  }
}
