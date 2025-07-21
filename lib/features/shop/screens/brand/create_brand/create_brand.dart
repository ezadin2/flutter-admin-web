import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/create_brand/responsive_screens/create_brand_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/create_brand/responsive_screens/create_brand_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_category_tablet.dart';
import 'package:flutter/material.dart';

class CreateBrandScreen extends StatelessWidget {
  const CreateBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CreateBrandDesktop(),
      tablet:CreateCategoryTablet(),
      mobile: CreateBrandMobile(),
    );
  }
}
