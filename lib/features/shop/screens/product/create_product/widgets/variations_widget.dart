import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_variation_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../models/product_varition_model.dart';
import '../../../../product/product_images_controller.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    final variationController = ProductVariationController.instance;

    return Obx(
          () => CreateProductController.instance.productType.value == ProductType.variable
          ? TRoundedContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Product Variation', style: Theme.of(context).textTheme.headlineSmall),
                TextButton(
                  onPressed: () => variationController.removeVariations(context),
                  child: const Text('Remove Variation'),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            if (variationController.productVariations.isNotEmpty)
              SizedBox(
                height: 400,
                child: ListView.separated(
                  itemCount: variationController.productVariations.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final variation = variationController.productVariations[index];
                    return _buildVariationTile(context, index, variation, variationController);
                  },
                ),
              )
            else
              _buildNoVariationsMessage(),
          ],
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildVariationTile(
      BuildContext context,
      int index,
      ProductVariationModel variation,
      ProductVariationController variationController,
      ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        backgroundColor: TColors.lightGrey,
        collapsedBackgroundColor: TColors.lightGrey,
        childrenPadding: const EdgeInsets.all(TSizes.md),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
        ),
        title: Text(
          variation.attributeValues.entries
              .map((entry) => '${entry.key}:${entry.value}')
              .join(', '),
        ),
        children: [
          SizedBox(
            height: 200,
            child: Obx(
                  () => TImageUploader(
                right: 0,
                left: null,
                imageType: variation.image.value.isNotEmpty ? ImageType.network : ImageType.asset,
                image: variation.image.value.isNotEmpty ? variation.image.value : TImages.defaultImage,
                onIconButtonPressed: () => ProductImagesController.instance.selectVariationImage(variation),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: variationController.stockControllerList[index][variation],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      variation.stock = int.tryParse(value) ?? 0;
                    }
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Add stock, only numbers are allowed',
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: // Inside your _buildVariationTile method in ProductVariations widget
                TextFormField(
                  controller: variationController.priceControllerList[index][variation],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      variation.price = double.tryParse(value) ?? 0.0;
                      variationController.productVariations.refresh();
                    }
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter price',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: variationController.salePriceControllerList[index][variation],
            onChanged: (value) {
              if (value.isNotEmpty) {
                variation.salePrice = double.tryParse(value) ?? 0.0;
              }
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
            ],
            decoration: const InputDecoration(
              labelText: 'Discount Price',
              hintText: 'Price with up-to 2 Decimal',
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: variationController.descriptionControllerList[index][variation],
            onChanged: (value) => variation.description = value,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter variation description...',
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
      ),
    );
  }

  Widget _buildNoVariationsMessage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(
              width: 200,
              height: 200,
              imageType: ImageType.asset,
              image: TImages.defaultAttributeColorsImageIcon,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        Text(
          'No variations generated yet',
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        Text(
          'Add product attributes first, then generate variations',
          style: Theme.of(Get.context!).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}