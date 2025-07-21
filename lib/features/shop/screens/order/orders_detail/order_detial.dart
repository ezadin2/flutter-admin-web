import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/order/orders_detail/responsive_screens/orders_detail_desktop_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/order/orders_detail/responsive_screens/orders_detail_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/order/orders_detail/responsive_screens/orders_detail_tablet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class orderDetailScreen extends StatelessWidget {
  const orderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    final orderId=Get.parameters['orderId'];
    return TSiteTemplate(
      desktop: OrdersDetailDesktopScreen(order: order,),
      mobile: OrdersDetailMobileScreen(order: order,),
      tablet: OrdersDetailTabletScreen(order: order,),
    );
  }
}
