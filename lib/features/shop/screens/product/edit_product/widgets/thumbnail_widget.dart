import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/product/product_images_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/enums.dart';

class ProductThumbnailImage extends StatelessWidget {
  const ProductThumbnailImage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductImagesController.instance;
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md), // Add padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Add this to prevent vertical expansion
        children: [
          Text('Product Thumbnail',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),
          TRoundedContainer(
            height: 300,
            padding: const EdgeInsets.all(TSizes.sm), // Add inner padding
            backgroundColor: TColors.primaryBackground,
            child: Center(
              child: SingleChildScrollView( // Add scroll for safety
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent column expansion
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 220, // Constrain image height
                      ),
                      child: AspectRatio(
                        aspectRatio: 1, // Keep image square
                        child: Obx(() => TRoundedImage(
                          image: controller.selectedThumbnailImageUrl.value ??
                              TImages.defaultSingleImageIcon,
                          imageType: controller.selectedThumbnailImageUrl.value != null
                              ? ImageType.network
                              : ImageType.asset,
                        )),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    SizedBox(
                      width: double.infinity, // Use full available width
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        child: OutlinedButton(
                          onPressed: () => controller.selectThumbnailImage(),
                          child: const Text('Change Thumbnail'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}