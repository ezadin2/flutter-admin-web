import 'package:ecommerce_admin_panel/features/shop/controllers/category/category_controller.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/Product/product_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();

  // Observables for loading state and product details
  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;
  final productDataUploader = false.obs; // Added missing observable

  // Controllers and keys
  final stockPriceFormKey = GlobalKey<FormState>();
  final ProductRepository productRepository = Get.find<ProductRepository>();
  final titleDescriptionFormKey = GlobalKey<FormState>();

  final variationsContoller = Get.put(ProductVariationController());
  final attributeController = Get.put(ProductAttributesController());
  final imageController = Get.put(ProductImagesController());
  final stockPrice = GlobalKey<FormState>();

  // Text editing controllers for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();
  final selectedCategoriesLoader = false.obs;
  final RxList<CategoryModel> alreadyAddedCategories = <CategoryModel>[].obs;
  // Observables for selected brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  // Flags for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImageUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  void initProductData(ProductModel product) {
    try {
      isLoading.value = true;

      // Initialize basic product data
      title.text = product.title;
      description.text = product.description ?? '';

      // Initialize product type
      productType.value = product.productType == ProductType.single.toString()
          ? ProductType.single
          : ProductType.variable;

      // Initialize stock and pricing if single product
      if (product.productType == ProductType.single.toString()) {
        stock.text = product.stock.toString();
        price.text = product.price.toString();
        salePrice.text = product.salePrice.toString();
      }

      // Initialize brand
      selectedBrand.value = product.brand;
      brandTextField.text = product.brand?.name ?? '';

      // Initialize images - THIS IS THE CRUCIAL PART
      final imagesController = ProductImagesController.instance;
      imagesController.selectedThumbnailImageUrl.value = product.thumbnail;

      // Clear any existing images and add the product's images
      imagesController.additionalProductImagesUrls.clear();
      if (product.images != null && product.images!.isNotEmpty) {
        imagesController.additionalProductImagesUrls.addAll(product.images!);
      }

      // Initialize other product attributes
      attributeController.productAttribute
          .assignAll(product.productAttributes ?? []);
      variationsContoller.productVariations
          .assignAll(product.productVariations ?? []);
      variationsContoller
          .initializedVariationController(product.productVariations ?? []);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<List<CategoryModel>> loadSelectedCategories(String productId) async {
    selectedCategoriesLoader.value = true;

    final productCategories =
    await productRepository.getAllProductsCategory(productId);
    final categoriesController = Get.put(CategoryController());
    if (categoriesController.allItems.isEmpty)
      await categoriesController.fetchItems();

    final categoriesIds = productCategories.map((e) => e.categoryId).toList();
    final categories = categoriesController.allItems
        .where((element) => categoriesIds.contains(element.id))
        .toList();
    selectedCategories.assignAll(categories);
    alreadyAddedCategories.assignAll(categories);
    selectedCategoriesLoader.value = false;

    return categories;
  }

  void showProgressDialog() {
    // Added missing method
    TFullScreenLoader.openLoadingDialog(
        'Processing...', TImages.docerAnimation);
  }
  Future<void> editProduct(ProductModel product) async {
    try {
      // Start progress dialog
      showProgressDialog();

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate forms
      if (!titleDescriptionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (productType.value == ProductType.single && !stockPriceFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate brand selection
      if (selectedBrand.value == null) throw 'Select Brand For this product';

      // Validate variations if product is variable type
      if (productType.value == ProductType.variable) {
        if (variationsContoller.productVariations.isEmpty) {
          throw 'There is no Variations for the product Type variable, create some Variations or change Product type';
        }

        final variationCheckFailed = variationsContoller.productVariations.any((element) =>
        element.price.isNaN ||
            element.price <= 0 ||
            element.salePrice.isNaN ||
            element.salePrice < 0 ||
            element.stock.isNaN ||
            element.stock < 0 ||
            element.image.value.isEmpty);

        if (variationCheckFailed) throw 'Variation data is not accurate. Please recheck Variations';
      }

      // Handle images
      thumbnailUploader.value = true;
      if (imageController.selectedThumbnailImageUrl.value == null) {
        throw 'Select Product Thumbnail image';
      }
      additionalImageUploader.value = true;

      // Calculate price and salePrice based on product type
      double updatedPrice = 0;
      double updatedSalePrice = 0;
      int updatedStock = 0;

      if (productType.value == ProductType.single) {
        // For single product, use direct values from form
        updatedPrice = double.tryParse(price.text.trim()) ?? 0;
        updatedSalePrice = double.tryParse(salePrice.text.trim()) ?? 0;
        updatedStock = int.tryParse(stock.text.trim()) ?? 0;

        // Clear variations if switching from variable to single
        if (variationsContoller.productVariations.isNotEmpty) {
          variationsContoller.resetAllValues();
        }
      } else {
        // For variable product, calculate min price and salePrice from variations
        final prices = variationsContoller.productVariations.map((v) => v.price).toList();
        final salePrices = variationsContoller.productVariations
            .where((v) => v.salePrice > 0)
            .map((v) => v.salePrice)
            .toList();

        updatedPrice = prices.reduce((min, current) => min < current ? min : current);
        updatedSalePrice = salePrices.isNotEmpty
            ? salePrices.reduce((min, current) => min < current ? min : current)
            : 0;
        updatedStock = variationsContoller.productVariations.fold(
            0, (sum, variation) => sum + (variation.stock));
      }

      // Update the product model
      product
        ..title = title.text.trim()
        ..description = description.text.trim()
        ..brand = selectedBrand.value
        ..productType = productType.value.toString()
        ..stock = updatedStock
        ..price = updatedPrice
        ..salePrice = updatedSalePrice
        ..images = imageController.additionalProductImagesUrls
        ..thumbnail = imageController.selectedThumbnailImageUrl.value ?? ''
        ..productAttributes = attributeController.productAttribute
        ..productVariations = productType.value == ProductType.variable
            ? variationsContoller.productVariations
            : [];

      // Update product in database
      productDataUploader.value = true;
      await productRepository.updateProduct(product);

      // Update categories if changed
      if (!listEquals(
        alreadyAddedCategories.map((c) => c.id).toList(),
        selectedCategories.map((c) => c.id).toList(),
      )) {
        await _updateProductCategories(product);
      }

      // Update product in the list
      ProductController.instance.updateItemsFromLists(product);

      TFullScreenLoader.stopLoading();
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      // Reset loading states
      thumbnailUploader.value = false;
      additionalImageUploader.value = false;
      productDataUploader.value = false;
      categoriesRelationshipUploader.value = false;
    }
  }

// Helper method to update product categories
  Future<void> _updateProductCategories(ProductModel product) async {
    categoriesRelationshipUploader.value = true;

    final existingIds = alreadyAddedCategories.map((c) => c.id).toList();
    final newIds = selectedCategories.map((c) => c.id).toList();

    // Find categories to add
    final toAdd = newIds.where((id) => !existingIds.contains(id)).toList();
    for (final categoryId in toAdd) {
      await productRepository.createProductCategory(
          ProductCategoryModel(productId: product.id, categoryId: categoryId)
      );
    }

    // Find categories to remove
    final toRemove = existingIds.where((id) => !newIds.contains(id)).toList();
    for (final categoryId in toRemove) {
      await productRepository.removeProductCategory(product.id, categoryId);
    }

    // Update local cache
    alreadyAddedCategories.assignAll(selectedCategories);
    categoriesRelationshipUploader.value = false;
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

    // Reset flags
    thumbnailUploader.value = false;
    additionalImageUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;
  }

  void showCompletionDialog() {
    Get.dialog(AlertDialog(
      title: const Text('Congratulations'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Go to Product'))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(TImages.productsIllustration, height: 200, width: 200),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text('Congratulations',
              style: Theme.of(Get.context!).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Text('Your Product has been Updated')
        ],
      ),
    ));
  }
}
