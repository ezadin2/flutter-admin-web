import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/order/order_detail_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/order_model.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    controller.order.value = order;
    controller.getCustomerOfCurrentOrder();

    return Obx(() {
      final customer = controller.customer.value;
      final isLoading = controller.loading.value;
      final shippingAddress = controller.shippingAddress.value;
      final billingAddress = controller.billingAddress.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Profile Section
          TRoundedContainer(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customers', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: TSizes.spaceBtwSections),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (customer.id!.isEmpty)
                  const Text('No customer data found')
                else
                  Row(
                    children: [
                      TRoundedImage(
                        imageType: customer.profilePicture.isNotEmpty
                            ? ImageType.network
                            : ImageType.asset,
                        image: customer.profilePicture.isNotEmpty
                            ? customer.profilePicture
                            : TImages.user,
                        backgroundColor: TColors.primaryBackground,
                        padding: 0,
                      ),
                      SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.fullName,
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                customer.email,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          )
                      )
                    ],
                  ),
              ],
            ),
          ),

          SizedBox(height: TSizes.spaceBtwSections),

          // Contact Person Section
          SizedBox(
            width: double.infinity,
            child: TRoundedContainer(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Person', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: TSizes.spaceBtwSections),
                  if (!isLoading && customer.id!.isNotEmpty) ...[
                    Text(customer.fullName, style: Theme.of(context).textTheme.titleSmall),
                    SizedBox(height: TSizes.spaceBtwItems/2),
                    Text(customer.email, style: Theme.of(context).textTheme.titleSmall),
                    SizedBox(height: TSizes.spaceBtwItems/2),
                    Text(
                        customer.formattedPhoneNo.isNotEmpty
                            ? customer.formattedPhoneNo
                            : '(+1)*** ****',
                        style: Theme.of(context).textTheme.titleSmall
                    )
                  ] else ...[
                    Text('No contact information available',
                        style: Theme.of(context).textTheme.titleSmall)
                  ]
                ],
              ),
            ),
          ),

          SizedBox(height: TSizes.spaceBtwSections),

          // Shipping Address Section
          SizedBox(
            width: double.infinity,
            child: TRoundedContainer(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: TSizes.spaceBtwSections),
                  if (shippingAddress != null) ...[
                    Text(shippingAddress.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: TSizes.spaceBtwItems/2),
                    Text(shippingAddress.toString(),
                        style: Theme.of(context).textTheme.titleSmall),
                  ] else ...[
                    Text('No shipping address provided',
                        style: Theme.of(context).textTheme.titleSmall)
                  ]
                ],
              ),
            ),
          ),

          SizedBox(height: TSizes.spaceBtwSections),

          // Billing Address Section
          SizedBox(
            width: double.infinity,
            child: TRoundedContainer(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Billing Address', style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: TSizes.spaceBtwSections),
                  if (order.billingAddressSameAsShipping && shippingAddress != null) ...[
                    Text(shippingAddress.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: TSizes.spaceBtwItems/2),
                    Text(shippingAddress.toString(),
                        style: Theme.of(context).textTheme.titleSmall),
                  ] else if (billingAddress != null) ...[
                    Text(billingAddress.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: TSizes.spaceBtwItems/2),
                    Text(billingAddress.toString(),
                        style: Theme.of(context).textTheme.titleSmall),
                  ] else ...[
                    Text('No billing address provided',
                        style: Theme.of(context).textTheme.titleSmall)
                  ]
                ],
              ),
            ),
          ),
          SizedBox(height: TSizes.spaceBtwSections)
        ],
      );
    });
  }
}