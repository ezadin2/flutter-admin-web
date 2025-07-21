import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_attribute_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_variation_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/category_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_category_model.dart';
import 'package:ecommerce_admin_panel/features/shop/product/product_images_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/Product/product_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  // Observables for loading state and product details
  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;
  final productDataUploader = false.obs; // Added missing observable
  final selectedCategories = <CategoryModel>[].obs;
  // Controllers and keys
  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFormKey = GlobalKey<FormState>();

  // Text editing controllers for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  // Observables for selected brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);

  // Flags for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImageUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  void showProgressDialog() {  // Added missing method
    TFullScreenLoader.openLoadingDialog('Processing...', TImages.docerAnimation);
  }

  Future<void> createProduct() async {
    try {
      // Start progress dialog
      showProgressDialog();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!titleDescriptionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (productType.value == ProductType.single && !stockPriceFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (selectedBrand.value == null) throw 'Select Brand For this product';

      if (productType.value == ProductType.variable &&
          ProductVariationController.instance.productVariations.isEmpty) {
        throw 'There is no Variations for the product Type variable, create some Variations or change Product type';
      }

      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationController.instance.productVariations.any((element) =>
        element.price.isNaN ||
            element.price <= 0 ||
            element.salePrice.isNaN ||
            element.salePrice < 0 ||
            element.stock.isNaN ||
            element.stock < 0 ||
            element.image.value.isEmpty
        );

        if (variationCheckFailed) throw 'Variation data is not accurate. Please recheck Variations';
      }

      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      if(imagesController.selectedThumbnailImageUrl.value == null) throw 'Select Product Thumbnails images';
      additionalImageUploader.value = true;

      final variations = ProductVariationController.instance.productVariations;
      if (productType.value == ProductType.single) {
        ProductVariationController.instance.resetAllValues();
        variations.clear();
      }

      // For single products, get price and salePrice from controllers
      // For variable products, calculate min/max prices
      double productPrice = 0;
      double productSalePrice = 0;

      if (productType.value == ProductType.single) {
        productPrice = double.tryParse(price.text.trim()) ?? 0;
        productSalePrice = double.tryParse(salePrice.text.trim()) ?? 0;
      } else if (variations.isNotEmpty) {
        // For variable products, set price range
        final prices = variations.map((v) => v.price).toList();
        final salePrices = variations.where((v) => v.salePrice > 0).map((v) => v.salePrice).toList();

        productPrice = prices.reduce((min, current) => min < current ? min : current);
        productSalePrice = salePrices.isNotEmpty
            ? salePrices.reduce((min, current) => min < current ? min : current)
            : 0;
      }

      // Create the product with category IDs
      final newRecord = ProductModel(
        id: '',
        sku: '',
        isFeatured: true,
        title: title.text.trim(),
        brand: selectedBrand.value,
        productVariations: productType.value == ProductType.variable ? variations : [],
        description: description.text.trim(),
        productType: productType.value.toString(),
        stock: productType.value == ProductType.single
            ? int.tryParse(stock.text.trim()) ?? 0
            : variations.fold(0, (sum, variation) => sum + (variation.stock)),
        price: productPrice,
        images: imagesController.additionalProductImagesUrls,
        salePrice: productSalePrice,
        thumbnail: imagesController.selectedThumbnailImageUrl.value ?? '',
        productAttributes: ProductAttributesController.instance.productAttribute,
        date: DateTime.now(),
        categoryIds: selectedCategories.map((cat) => cat.id).toList(), // Add category IDs
      );

      productDataUploader.value = true;
      newRecord.id = await productRepository.createProduct(newRecord);

      // Create product-category relationships in separate collection
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Error storing data, try again';
        categoriesRelationshipUploader.value = true;
        for (var category in selectedCategories) {
          final productCategory = ProductCategoryModel(
              productId: newRecord.id,
              categoryId: category.id
          );
          await productRepository.createProductCategory(productCategory);
        }
      }

      ProductController.instance.addItemToLists(newRecord);

      TFullScreenLoader.stopLoading();
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Sorry', message: e.toString());
    }
  }


  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.single;
    productVisibility.value = ProductVisibility.hidden;

    // Reset form states
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();

    // Clear controllers
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();

    // Clear other values
    selectedCategories.clear();
    selectedBrand.value = null;
    ProductVariationController.instance.resetAllValues();
ProductAttributesController.instance.resetProductAttribute();
    // Reset flags
    thumbnailUploader.value = false;
    additionalImageUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;

  }

  void showCompletionDialog() {
    Get.dialog(
        AlertDialog(
          title: const Text('Congratulations'),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text('Go to Product')
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(TImages.productsIllustration, height: 200, width: 200),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text('Congratulations', style: Theme.of(Get.context!).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Your Product has been created')
            ],
          ),
        )
    );
  }
}