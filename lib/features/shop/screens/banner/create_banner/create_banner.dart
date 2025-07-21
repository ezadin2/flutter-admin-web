import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/create_banner/responsive_screens/create_banner_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/create_banner/responsive_screens/create_banner_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/banner/create_banner/responsive_screens/create_banner_tablet.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_tablet.dart';
import 'package:flutter/material.dart';

class CreateBannerScreen extends StatelessWidget {
  const CreateBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CreateBannerDesktopScreen(),
      tablet:CreateBannerMobile(),
      mobile: CreateBannerTablet(),
    );
  }
}
