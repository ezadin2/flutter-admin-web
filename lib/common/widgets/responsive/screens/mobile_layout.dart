import 'package:adminpanel/common/widgets/containers/rounded_container.dart';
import 'package:adminpanel/common/widgets/layouts/headers/header.dart';
import 'package:flutter/material.dart';

  class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key, this.body});
  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:   Drawer(),
      appBar: THeader(),
      body: body ?? SizedBox(),
    );
  }
}
