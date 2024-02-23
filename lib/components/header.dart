import 'package:flutter/material.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/utils/style.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // 下端に線を追加する
        border: Border(bottom: AtomicBorder()),
      ),
      child: Row(
        children: [
          HeaderIconButton(
            icon: Icons.menu,
            onPressed: () {
              // navigation open
            },
          ),
          HeaderIconButton(
            icon: Icons.bookmark,
            onPressed: () {
              // お気に入りアクション
            },
          ),
          HeaderIconButton(
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

class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  const HeaderIconButton(
      {super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      iconSize: 16,
      color: kGray700,
    );
  }
}

// enum HeaderIconButtonType = {  }

// class Header extends AppBar {
//   Header({super.key})
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
