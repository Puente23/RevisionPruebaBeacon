import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Bar extends StatefulWidget implements PreferredSizeWidget {
  const Bar({
    Key? key,
  }) : super(key: key);

  @override
  State<Bar> createState() => _BarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}

class _BarState extends State<Bar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("Beacon's."),
      leadingWidth: 100, // default is 56
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            exit(0);
          },
        ),
        //const Icon(Icons.more_vert),
      ],
      backgroundColor: Colors.orange,
      shadowColor: Color.fromARGB(255, 255, 175, 54),
      toolbarTextStyle: TextTheme(
        headline6: TextStyle(
          // headline6 is used for setting title's theme
          color: Colors.amber[200],
          fontSize: 24,
        ),
      ).bodyText2,
      titleTextStyle: TextTheme(
        headline6: TextStyle(
          // headline6 is used for setting title's theme
          color: Colors.amber[200],
          fontSize: 24,
        ),
      ).headline6,
    );
  }
}
