import 'package:ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_category_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_category_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_category_tablet_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_desktop_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/dashboard/responsive_screens/dashboard_tablet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../all_brands/responsive_screens/brand_desktop_screen.dart';
import '../all_brands/responsive_screens/brand_mobile_screen.dart';
import '../all_brands/responsive_screens/brand_tablet_screen.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Get.arguments;
    return TSiteTemplate(desktop: EditBrandDesktop(brand: brand,),tablet: EditBrandMobileScreen(brand: brand,),mobile: EditBrandTabletScreen(brand: brand,),);
  }
}
