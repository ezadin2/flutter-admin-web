import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../data/repositories/setting/setting_repository.dart';
import '../../../../../personalization/models/setting_model.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final settingsRepo = Get.put(SettingsRepository());
    final settingsFuture = settingsRepo.getSettings();

    return FutureBuilder<SettingsModel>(
      future: settingsFuture,
      builder: (context, snapshot) {
        // Debug print for connection state
        print('Connection state: ${snapshot.connectionState}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Print error instead of showing in UI
          print('Error fetching settings: ${snapshot.error}');
          return const Center(child: Text('Could not load order details'));
        }

        if (!snapshot.hasData) {
          print('No settings data available');
          return const Center(child: Text('Could not load order details'));
        }

        final settings = snapshot.data!;
        print('Settings loaded: Tax Rate=${settings.taxRate}, Shipping Cost=${settings.shippingCost}');

        // Calculate subtotal
        final subTotal = order.items?.fold(0.0, (previousValue, element) {
          return previousValue + (element.price * element.quantity);
        }) ?? 0.0;
        print('Subtotal calculated: $subTotal');

        // Calculate tax amount (ensure taxRate is not null)
        final taxRate = settings.taxRate ?? 0.0; // Assuming this is stored as 0.05 for 5%
        final taxPercentage = taxRate * 100; // Convert to percentage for display
        final taxAmount = subTotal * taxRate; // Calculation using the decimal value
        print('Tax calculated: $taxAmount (Rate: $taxPercentage%)');


        // Get shipping cost (ensure it's not null)
        final shippingCost = settings.shippingCost ?? 0.0;
        print('Shipping cost: $shippingCost');

        // Calculate total
        final totalAmount = subTotal + taxAmount + shippingCost;
        print('Total amount calculated: $totalAmount');

        final items = order.items ?? [];
        print('Number of items in order: ${items.length}');

        return TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Items', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final item = items[index];
                  final itemTotal = item.price * item.quantity;
                  print('Item ${index + 1}: ${item.title} - Price: ${item.price} x Qty: ${item.quantity} = Total: $itemTotal');

                  return Row(
                    children: [
                      TRoundedImage(
                        backgroundColor: TColors.primaryBackground,
                        imageType: item.image != null ? ImageType.network : ImageType.asset,
                        image: item.image ?? TImages.defaultImage,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (item.selectedVariation != null)
                              Text(item.selectedVariation!.entries.map((e) => ('${e.key}:${e.value}')).toString())
                          ],
                        ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      SizedBox(
                        width: TSizes.xl * 2,
                        child: Text('\$${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      SizedBox(
                        width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl * 1.4 : TSizes.xl * 2,
                        child: Text(item.quantity.toString(), style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      SizedBox(
                        width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl * 1.4 : TSizes.xl * 2,
                        child: Text('\$${itemTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                itemCount: items.length,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                backgroundColor: TColors.primaryBackground,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: Theme.of(context).textTheme.titleLarge),
                        Text('\$${subTotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // In your UI display:
                        Text('Tax (${taxPercentage.toStringAsFixed(2)}%)', style: Theme.of(context).textTheme.titleLarge),  Text(
                          '\$${taxAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping', style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          shippingCost == 0.0
                              ? 'Free Shipping'
                              : '\$${shippingCost.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.headlineSmall),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}