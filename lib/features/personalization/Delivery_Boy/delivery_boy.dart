import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../authentication/controllers/user_controller.dart';
import 'deliivery_list_screen.dart';
import 'delivary_form.dart';

class DeliveryBoyScreen extends StatelessWidget {
  const DeliveryBoyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(heading: 'Delivery', breadCrumbItems: ['Delivary']),
              const SizedBox(height: TSizes.spaceBtwSections),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: DeliveryListScreen(), // Removed Obx here
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections),
                        Expanded(
                          flex: 2,
                          child: DelivaryForm(),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        DeliveryListScreen(), // Removed Obx here
                        const SizedBox(height: TSizes.spaceBtwSections),
                        DelivaryForm(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
