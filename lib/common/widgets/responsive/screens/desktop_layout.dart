import 'package:adminpanel/common/widgets/containers/rounded_container.dart';
import 'package:adminpanel/common/widgets/layouts/headers/header.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatelessWidget {
   DesktopLayout({super.key, this.body});
  final Widget? body;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Row(
        children: [
          Expanded(child: Drawer()),
          Expanded(
              flex: 5,
              child: Column(
                children: [
               THeader(),
                  //body
                  body ?? SizedBox()
                ],
              )),
        ],
      ),
    );
  }
}
