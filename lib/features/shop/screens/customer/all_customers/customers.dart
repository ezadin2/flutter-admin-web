import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/categories_desktop.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/categories_mobile.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/categories_tablet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/customer_controller.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(CustomerController());
    final customerId = Get.parameters['customerId'];
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (customerId != null) {
        controller.fetchCustomerDetails(customerId);
      } else {
        controller.fetchItems();
      }
    });

    return TSiteTemplate(
      desktop: Obx(() {
        if (controller.isLoading.value && controller.filteredItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return const CutomersDesktopScreen();
      }),
      tablet: const CustomersTabletScreen(),
      mobile: const CustomersMobileScreen(),
    );
  }
}