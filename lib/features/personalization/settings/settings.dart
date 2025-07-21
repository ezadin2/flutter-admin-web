import 'package:ecommerce_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/personalization/screens/profile/responsible_screens/profile_desktop.dart';
import 'package:ecommerce_admin_panel/features/personalization/settings/resposive_screens/setting_desktop.dart';
import 'package:ecommerce_admin_panel/features/personalization/settings/resposive_screens/setting_tablet.dart';
import 'package:flutter/cupertino.dart';

import '../screens/profile/responsible_screens/profile_mobile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(desktop: SettingsDesktopScreen(),tablet: SettingsTabletScreen() ,mobile: ProfileMobileScreen());
  }
}
