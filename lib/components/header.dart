import 'package:flutter/material.dart';

class Header extends AppBar {
  Header({super.key})
      : super(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // navigation open
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                // お気に入りアクション
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // menu open
              },
            ),
          ],
        );
}
