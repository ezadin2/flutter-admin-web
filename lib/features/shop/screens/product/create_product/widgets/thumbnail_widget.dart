import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/shop/product/product_images_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/constants/enums.dart';

class ProductThumbnailImage extends StatelessWidget {
  ProductThumbnailImage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductImagesController controller = Get.find<ProductImagesController>();
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('product thumbnail',
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: TSizes.spaceBtwItems),
          TRoundedContainer(
            height: 300,
            backgroundColor: TColors.primaryBackground,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Obx(
                        () => TRoundedImage(
                            width: 220,
                            height: 220,
                            image: controller.selectedThumbnailImageUrl.value ??
                                TImages.defaultSingleImageIcon,
                            imageType:
                                controller.selectedThumbnailImageUrl.value ==
                                        null
                                    ? ImageType.asset
                                    : ImageType.network),
                      ))
                    ],
                  ),
                  SizedBox(
                      width: 200,
                      child: OutlinedButton(
                          onPressed: () =>
                              controller.selectThumbnailImage(),
                          child: Text('Add thumbnail'))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
