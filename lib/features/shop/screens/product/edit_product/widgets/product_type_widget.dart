import 'package:ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/product/edit_product_controller.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProductController>();
    return Obx(
          () => Row(
        children: [
          Text('product type', style: Theme.of(context).textTheme.bodyMedium),
          RadioMenuButton(
            value: ProductType.single,
            groupValue: controller.productType.value,
            onChanged: (value) => controller.productType.value = value ?? ProductType.single,
            child: const Text('single'),
          ),
          RadioMenuButton(
            value: ProductType.variable,
            groupValue: controller.productType.value,
            onChanged: (value) => controller.productType.value = value ?? ProductType.single,
            child: const Text('Variable'),
          ),
        ],
      ),
    );
  }
}