import 'package:ecommerce_admin_panel/features/media/screens.media/responsiveScreens/media_desktop.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/layouts/templates/site_layout.dart';
class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop:MediaDesktopScreen());
  }
}
