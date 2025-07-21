import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/models/category_model.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_tablet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = Get.arguments;
    return TSiteTemplate(
      desktop: EditCategoryDesktop(category: category),
      mobile: EditCategoryTabletScreen(category: category),
      tablet: EditCategoryMobileScreen(category: category),
    );
  }
}
