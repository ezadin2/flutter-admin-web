import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/models/category_model.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_tablet_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/edit_banner/widgets/edit_banner_form.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_tablet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/banner_model.dart';

class EditBannerScreen extends StatelessWidget {
  const EditBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final banner = Get.arguments;
    return TSiteTemplate(
      desktop: EditBannerDesktop(banner: banner),
      mobile: EditBannerTabletScreen(banner: banner),
      tablet: EditBannerMobileScreen(banner: banner),
    );
  }
}
