import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/product/product_images_controller.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/product/edit_product_controller.dart';
import '../../../../models/product_model.dart';
import '../widgets/additional_images.dart';
import '../widgets/attributes_widget.dart';
import '../widgets/bottom_navigational_widget.dart';
import '../widgets/brand_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/product_type_widget.dart';
import '../widgets/stock_pricing_widget.dart';
import '../widgets/thumbnail_widget.dart';
import '../widgets/title_description.dart';
import '../widgets/variations_widget.dart';
import '../widgets/visibility_widget.dart';

class EditProductTabletScreen extends StatelessWidget {
  const EditProductTabletScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final imagesController = Get.put(ProductImagesController());
    final editController = Get.put(EditProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      editController.initProductData(product);
    });

    return Scaffold(
      bottomNavigationBar: ProductBottomNavigationButtons(product: product),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(
                returnToPreviousScreen: true,
                heading: 'Edit Product',
                breadCrumbItems: const [TRoutes.editProducts, 'Edit Product'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProductTitleAndDescription(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        ProductThumbnailImage(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('All Product Image',
                                  style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              ProductAddtionalImages(
                                additionalProductImagesURLs: imagesController.additionalProductImagesUrls,
                                onTapToAddImages: () =>
                                    imagesController.selectMultipleProductImages(),
                                onTapToRemoveImage: (index) =>
                                    imagesController.removeImage(index),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),

                  const SizedBox(width: TSizes.spaceBtwSections),

                  // Right column
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Stock & Pricing',
                                  style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              const ProductTypeWidget(),
                              const SizedBox(height: TSizes.spaceBtwInputFields),
                              const ProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const ProductAttributes(),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        const ProductVariations(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        const ProductBrand(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        ProductCategories(product: product),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        const ProductVisibilityWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
