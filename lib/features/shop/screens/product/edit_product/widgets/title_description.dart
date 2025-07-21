import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    return TRoundedContainer(
      child: Form(
        key: controller.titleDescriptionFormKey,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('basic information',
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: TSizes.spaceBtwItems),
          TextFormField(
            controller:  controller.title,
            validator: (value) =>
                TValidator.validateEmptyText('product Title', value),
            decoration: InputDecoration(labelText: 'product tilte'),
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
            height: 300,
            child: TextFormField(
              expands: true,
              maxLines: null,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.multiline,
              controller: controller.description,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) =>
                  TValidator.validateEmptyText('product description', value),
              decoration: InputDecoration(
                labelText: 'product description',
                hintText: 'add your product description her .....',
                alignLabelWithHint: true,
              ),
            ),
          )
        ],
      )),
    );
  }
}
