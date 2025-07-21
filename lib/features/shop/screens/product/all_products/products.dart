import 'package:ecommerce_admin_panel/features/shop/screens/product/all_products/responsive_screens/product_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/all_products/responsive_screens/product_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/all_products/responsive_screens/product_tablet.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/layouts/templates/site_layout.dart';

class ProductsScreen extends StatelessWidget {
   ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(desktop: ProductDesktopScreen(),tablet:ProductTabletScreen(),mobile: ProductMobileScreen(),);
  }
}
