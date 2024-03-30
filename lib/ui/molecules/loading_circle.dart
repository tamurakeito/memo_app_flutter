import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math';

class LoadingCircle extends HookWidget {
  final bool isActive;
  const LoadingCircle({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    // final isVisible = useState<bool>(false);

    useEffect(() {
      if (isActive) {}
    }, [isActive]);

    final controller = useAnimationController(
      duration: Duration(milliseconds: 1500),
    )..repeat();

    return SizedBox(
      height: 100,
      child: Center(
        child: AnimatedOpacity(
          opacity: isActive ? 1 : 0,
          duration: Duration(milliseconds: 120),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: controller.value * 2.0 * pi,
                child: child,
              );
            },
            child: Icon(LineIcons.syncIcon),
          ),
        ),
      ),
    );
  }
}
