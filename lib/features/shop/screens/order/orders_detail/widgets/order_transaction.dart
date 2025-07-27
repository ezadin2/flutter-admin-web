import 'package:ecommerce_admin_panel/features/shop/models/order_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class OrderTransaction extends StatelessWidget {
  const OrderTransaction({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transaction', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              return isMobile
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentInfo(context),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildDateInfo(context),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildTotalInfo(context),
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildPaymentInfo(context)),
                  Expanded(child: _buildDateInfo(context)),
                  Expanded(child: _buildTotalInfo(context)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(BuildContext context) {
    return Row(
      children: [
        TRoundedImage(
          imageType: ImageType.asset,
          image: TImages.paypal,
          width: 60,
          height: 60,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment via ${order.paymentMethod.capitalize}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${order.paymentMethod.capitalize} fee \$25',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date', style: Theme.of(context).textTheme.labelMedium),
        Text('April 21, 2025', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildTotalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total', style: Theme.of(context).textTheme.labelMedium),
        Text('\$${order.totalAmount}', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
