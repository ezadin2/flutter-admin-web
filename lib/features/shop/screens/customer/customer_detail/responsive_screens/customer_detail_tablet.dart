import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/customer_info.dart';
import '../widget/customer_orders.dart';
import '../widget/shipping_address.dart';

class CustomerDetailTabletScreen extends StatelessWidget {
  const CustomerDetailTabletScreen({super.key, required this.customer});
  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerDetailController());

    // Initialize customer data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.customer.value = customer;
      controller.initializeCustomerData();
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(
                returnToPreviousScreen: true,
                heading: customer.fullName,
                breadCrumbItems: [TRoutes.customers, 'detail'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left section: Info + Shipping
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        CustomerInfo(customer: customer),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        const ShippingAddress(),
                      ],
                    ),
                  ),

                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Right section: Orders
                  Expanded(
                    flex: 6,
                    child: const CustomerOrders(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
