import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../table/data_table.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        // Show loading state
        if (controller.orderLoading.value) {
          return const TLoaderAnimation();
        }

        // Show empty state
        if (controller.filteredCustomerOrder.isEmpty) {
          return TAnimationLoaderWidget(
            text: 'No Orders Found',
            animation: TImages.pencilAnimation,
          );
        }

        // Calculate total amount
        final totalAmount = controller.filteredCustomerOrder.fold(
            0.0,
                (previous, element) => previous + element.totalAmount
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Orders', style: Theme.of(context).textTheme.headlineMedium),
                Text.rich(
                  TextSpan(children: [
                    const TextSpan(text: 'Total spent '),
                    TextSpan(
                      text: '\$${totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary),
                    ),
                    TextSpan(
                      text: ' on ${controller.filteredCustomerOrder.length} orders',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Search field
            TextFormField(
              onChanged: controller.searchQuery,
              controller: controller.searchTextController,
              decoration: const InputDecoration(
                hintText: 'Search Order',
                prefixIcon: Icon(Iconsax.search_normal),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Orders table
            const CustomerOrderTable(),
          ],
        );
      }),
    );
  }
}