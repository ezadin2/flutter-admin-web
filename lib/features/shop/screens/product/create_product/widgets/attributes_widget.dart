import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_variation_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../controllers/product/product_attribute_controller.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = CreateProductController.instance;
    final attributeController = Get.put(ProductAttributesController());
    final variationController = Get.put(ProductVariationController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return productController.productType.value == ProductType.single
              ? Column(
                  children: [
                    Divider(color: TColors.primaryBackground),
                    SizedBox(height: TSizes.spaceBtwSections),
                  ],
                )
              : SizedBox.shrink();
        }),
        Text('add product attribute',
            style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: TSizes.spaceBtwItems),
        Form(
          key: attributeController.attributeFormKey,
          child: TDeviceUtils.isDesktopScreen(context)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildAttributeName(attributeController)),
                    SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                        flex: 2, child: _buildAttributes(attributeController)),
                    SizedBox(width: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                )
              : Column(
                  children: [
                    _buildAttributeName(attributeController),
                    SizedBox(height: TSizes.spaceBtwItems),
                    _buildAttributes(attributeController),
                    SizedBox(height: TSizes.spaceBtwItems),
                    _buildAddAttributeButton(attributeController),
                  ],
                ),
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('all attribute', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: TSizes.spaceBtwItems),
        TRoundedContainer(
            backgroundColor: TColors.primaryBackground,
            child: Obx(
              () => attributeController.productAttribute.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: attributeController.productAttribute.length,
                      separatorBuilder: (_, __) => SizedBox(
                            height: TSizes.spaceBtwItems,
                          ),
                      itemBuilder: (_, index) {
                        return Container(
                            decoration: BoxDecoration(
                                color: TColors.white,
                                borderRadius: BorderRadius.circular(
                                    TSizes.borderRadiusLg)),
                            child: ListTile(
                              title: Text(attributeController
                                      .productAttribute[index].name ??
                                  ''),
                              subtitle: Text(
                                attributeController
                                    .productAttribute[index].values!
                                    .map((e) => e.trim())
                                    .toString(),
                              ),
                              trailing: IconButton(
                                  onPressed: () => attributeController
                                      .removeAttribute(index, context),
                                  icon: Icon(
                                    Iconsax.trash,
                                    color: TColors.error,
                                  )),
                            ));
                      })
                  : Column(children: [Row()]),
            )),
        SizedBox(height: TSizes.spaceBtwSections),
        Obx(
          () => productController.productType.value == ProductType.variable &&
                  variationController.productVariations.isEmpty
              ? Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      icon: Icon(Iconsax.activity),
                      label: Text('generate variation'),
                      onPressed: () => variationController
                          .generateVariationsConfirmation(context),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        )
      ],
    );
  }

  Widget buildAttributesList(
      ProductAttributesController controller, BuildContext context) {
    return ListView.separated(
      itemCount: controller.productAttribute.length,
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final attribute = controller.productAttribute[index];
        return Container(
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          ),
          child: ListTile(
            title: Text(attribute.name ?? ''),
            subtitle: Text(attribute.values?.join(', ') ?? ''),
            trailing: IconButton(
              onPressed: () => controller.removeAttribute(index, context),
              icon: Icon(Iconsax.trash, color: TColors.error),
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptyAttributes() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(
              width: 150,
              height: 80,
              imageType: ImageType.asset,
              image: TImages.defaultAttributeColorsImageIcon,
            )
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('there are no attribute added or for these product'),
      ],
    );
  }

  TextFormField _buildAttributeName(ProductAttributesController controller) {
    return TextFormField(
      controller: controller.attributeName,
      validator: (value) =>
          TValidator.validateEmptyText('attribute name', value),
      decoration: InputDecoration(
        labelText: 'attribute name',
        hintText: 'colors, sizes, material',
      ),
    );
  }

  SizedBox _buildAttributes(ProductAttributesController controller) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        controller: controller.attribute,
        expands: true,
        maxLines: null,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,
        validator: (value) =>
            TValidator.validateEmptyText('attribute field', value),
        decoration: InputDecoration(
          labelText: 'attribute',
          hintText: 'add attribute separated by | example: blue | yellow',
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  SizedBox _buildAddAttributeButton(ProductAttributesController controller) {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: () => controller.addNewAttribute(),
        icon: Icon(Iconsax.add),
        style: ElevatedButton.styleFrom(
          foregroundColor: TColors.black,
          backgroundColor: TColors.secondary,
          side: BorderSide(color: TColors.secondary),
        ),
        label: Text('add'),
      ),
    );
  }
}
