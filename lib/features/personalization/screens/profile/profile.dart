import 'package:ecommerce_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/personalization/screens/profile/responsible_screens/profile_desktop.dart';
import 'package:ecommerce_admin_panel/features/personalization/screens/profile/responsible_screens/profile_tablet.dart';
import 'package:flutter/cupertino.dart';

import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/personalization/screens/profile/responsible_screens/profile_desktop.dart';
import 'package:ecommerce_admin_panel/features/personalization/screens/profile/responsible_screens/profile_tablet.dart';
import 'package:ecommerce_admin_panel/features/personalization/screens/profile/responsible_screens/profile_mobile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: const ProfileDesktopScreen(),
      tablet: const ProfileTabletScreen(),
      mobile: const ProfileMobileScreen(),
    );
  }
}
