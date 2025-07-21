import 'package:flutter/material.dart';

import '../../layouts/headers/header.dart';
import '../../layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
   DesktopLayout({super.key, this.body});
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: TSidebar()),
          Expanded(
              flex: 5,
              child: Column(
                children: [
               THeader(),
                  //body
                  Expanded(child: body ?? SizedBox())
                ],
              )),
        ],
      ),
    );
  }
}
