import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_desktop_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_tablet_screen.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(desktop: DashboardDesktopScreen(),tablet: DashboardTabletScreen(),mobile: DashboardMobileScreen(),);
  }
}
