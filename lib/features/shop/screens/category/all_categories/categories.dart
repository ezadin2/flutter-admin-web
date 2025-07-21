import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/responsive_screens/categories_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/responsive_screens/categories_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/responsive_screens/categories_tablet.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(desktop: CategoriesDesktopScreen(),tablet:CategoriesTabletScreen(),mobile: CategoriesMobileScreen(),);
  }
}
