import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:ecommerce_admin_panel/features/authentication/models/address_model.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingAddress extends StatelessWidget {
  const ShippingAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CustomerDetailController.instance;
    controller.getCostumerAddress();

    return Obx(() {
      if (controller.addressesLoading.value) return const TLoaderAnimation();

      final addresses = controller.customer.value.addresses ?? [];
      final defaultAddress = addresses.firstWhereOrNull((address) => address.selectedAddress);
      final displayAddress = defaultAddress ?? (addresses.isNotEmpty ? addresses.first : AddressModel.empty());

      return TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (addresses.isNotEmpty)
              _buildAddressDetail(context, displayAddress)
            else
              Text('No shipping address provided', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    });
  }

  Widget _buildAddressDetail(BuildContext context, AddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Primary Address', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),
        _buildDetailRow(context, 'Name', address.name),
        _buildDetailRow(context, 'Country', address.country),
        _buildDetailRow(context, 'Phone Number', address.phoneNumber),
        _buildDetailRow(context, 'Address', address.toString()),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems/2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label)),
          const Text(':'),
          const SizedBox(width: TSizes.spaceBtwItems/2),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}