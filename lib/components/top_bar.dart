import 'package:flutter/material.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/utils/style.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: const BoxDecoration(
        // 下端に線を追加する
        border: Border(bottom: AtomicBorder()),
      ),
      child: Row(
        children: [
          TopBarIconButton(
            icon: Icons.menu,
            onPressed: () {
              // navigation open
            },
          ),
          const Spacer(),
          TopBarIconButton(
            icon: Icons.bookmark,
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
              // menu open
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
    return InkResponse(
      onTap: onPressed,
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
