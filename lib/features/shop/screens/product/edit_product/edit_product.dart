import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/create_product/responsive_screens/create_product_tablet.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    final product = Get.arguments;
    controller.initProductData(product);
    return TSiteTemplate(
      desktop: EditProductDesktopScreen(product: product,),
      mobile: EditProductMobileScreen(product: product),
      tablet:EditProductTabletScreen(product: product,),

    );
  }
}
