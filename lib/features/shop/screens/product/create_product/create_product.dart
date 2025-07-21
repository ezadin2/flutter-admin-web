import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_tablet.dart';
import 'package:flutter/material.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: CreateProductDesktopScreen(),
      tablet:CreateProductMobileScreen(),

    );
  }
}
