import 'package:ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductStockAndPricing extends StatelessWidget {
  const ProductStockAndPricing({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;
    return Obx(() => controller.productType.value == ProductType.single
        ? Form(
      key: controller.stockPriceFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FractionallySizedBox(
            widthFactor: 0.45,
            child: TextFormField(
              controller: controller.stock,
              decoration: InputDecoration(
                  labelText: 'Stock',
                  hintText: 'add stock ,only number are allowed'),
              validator: (value) =>
                  TValidator.validateEmptyText('stock', value),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.price,
                  decoration: InputDecoration(
                      labelText: 'price',
                      hintText: 'price with up-to 2 decimals'),
                  validator: (value) =>
                      TValidator.validateEmptyText('price', value),
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(r'\d+.?\d{0,2}$')
                  ],
                ),
              ),
              SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                  child: TextFormField(
                    controller: controller.salePrice,
                    decoration: InputDecoration(
                        labelText: 'discounted price',
                        hintText: 'price with up-to 2 decimal'),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'\d+.?\d{0,2}$')),
                    ],
                  ))
            ],
          )
        ],
      ),
    )
        : SizedBox.shrink());
  }
}
