import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/order/order_detail_controller.dart';
import '../../../category/all_categories/table/data_table.dart';
import '../table/data_table.dart';
import '../widgets/order_customer.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transaction.dart';

class OrdersDetailMobileScreen extends StatelessWidget {
  const OrdersDetailMobileScreen({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    controller.order.value = order;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(
                returnToPreviousScreen: true,
                heading: order.id,
                breadCrumbItems: [TRoutes.orders, 'Details'],
              ),
              SizedBox(height: TSizes.spaceBtwSections),

              TTableHeader(showLeftWidget: false),
              SizedBox(height: TSizes.spaceBtwItems),

              // Stacked Order Detail Sections for Mobile
              OrderInfo(order: order),
              SizedBox(height: TSizes.spaceBtwSections),

              OrderItems(order: order),
              SizedBox(height: TSizes.spaceBtwSections),

              OrderTransaction(order: order),
              SizedBox(height: TSizes.spaceBtwSections),

              OrderCustomer(order: order),
            ],
          ),
        ),
      ),
    );
  }
}
