import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/provider/provider.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/utils/style.dart';

class TopBar extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TopBar({super.key, required this.scaffoldKey});
  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isMenuOpenProvider);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        // 下端に線を追加する
        border: Border(bottom: AtomicBorder()),
      ),
      child: Row(
        children: [
          TopBarIconButton(
            icon: Icons.menu,
            onPressed: () {
              openDrawer();
            },
          ),
          const Spacer(),
          TopBarIconButton(
            icon: Icons.bookmark_border,
            onPressed: () {
              // お気に入りアクション
            },
          ),
          const SizedBox(
            width: 18,
          ),
          TopBarIconButton(
            icon: Icons.more_vert,
            onPressed: () {
              ref.read(isMenuOpenProvider.notifier).state = true;
            },
          ),
        ],
      ),
    );
  }
}

class TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  const TopBarIconButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 24,
        color: kGray700,
      ),
    );
  }
}

// enum TopBarIconButtonType = {  }

// class TopBar extends AppBar {
//   TopBar({super.key})
//       : super(
//             leading: IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () {
//                 // navigation open
//               },
//             ),
//             actions: <Widget>[
//               IconButton(
//                 icon: const Icon(Icons.bookmark),
//                 onPressed: () {
//                   // お気に入りアクション
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.more_vert),
//                 onPressed: () {
//                   // menu open
//                 },
//               ),
//             ],
//   // toolbarHeight: 100;
//   ;
// }
