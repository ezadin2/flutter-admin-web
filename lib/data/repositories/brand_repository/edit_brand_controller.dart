import 'package:ecommerce_admin_panel/data/repositories/brand_repository/brand_repository.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/brand_category_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/category_model.dart';

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  final BrandRepository repository = BrandRepository.instance;

  void init(BrandModel brand) {
    name.text = brand.name;
    imageURL.value = brand.image;
    isFeatured.value = brand.isFeatured;
    if (brand.brandCategories != null) {
      selectedCategories.addAll(brand.brandCategories ?? []);
    }
  }

  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void resetFields() {
    name.clear();
    loading(false);
    isFeatured(false);
    imageURL.value = '';
    selectedCategories.clear();
  }

  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      imageURL.value = selectedImage.url;
    }
  }

  Future<void> updateBrand(BrandModel brand) async {
    try {
      TFullScreenLoader.popUpCircular();
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!formkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      bool isBrandUpdated = false;
      if (brand.image != imageURL.value ||
          brand.name != name.text.trim() ||
          brand.isFeatured != isFeatured.value) {
        isBrandUpdated = true;

        brand.image = imageURL.value;
        brand.name = name.text.trim();
        brand.isFeatured = isFeatured.value;
        brand.updatedAt = DateTime.now();

        await repository.updateBrand(brand);
      }

      if (selectedCategories.isNotEmpty) await updateBrandCategories(brand);
      if (isBrandUpdated) await updateBrandInProducts(brand);

      BrandController.instance.updateItemsFromLists(brand);
      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Success', message: 'Brand has been updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> updateBrandCategories(BrandModel brand) async {
    final brandCategories = await repository.getCategoriesOfSpecificBrand(brand.id);
    final selectedCategoryIds = selectedCategories.map((e) => e.id).toList();

    // Remove categories that are no longer selected
    final categoriesToRemove = brandCategories
        .where((existingCategory) => !selectedCategoryIds.contains(existingCategory.categoryId))
        .toList();

    for (var categoryToRemove in categoriesToRemove) {
      if (categoryToRemove.id != null) {
        await BrandRepository.instance.deleteBrandCategory(categoryToRemove.id!);
      }
    }

    // Add new categories that weren't previously selected
    final newCategoriesToAdd = selectedCategories
        .where((newCategory) => !brandCategories
        .any((existingCategory) => existingCategory.categoryId == newCategory.id))
        .toList();

    for (var categoryToAdd in newCategoriesToAdd) {
      var brandCategory = BrandCategoryModel(
        brandId: brand.id,
        categoryId: categoryToAdd.id ?? '',
      );
      brandCategory.id = await BrandRepository.instance.createBrandCategory(brandCategory);
    }

    // Update the brand's categories list
    brand.brandCategories ??= [];
    brand.brandCategories!.assignAll(selectedCategories);
    BrandController.instance.updateItemsFromLists(brand);
  }

  Future<void> updateBrandInProducts(BrandModel brand) async {
    // Implement your product update logic here
    // This should update all products that reference this brand
    // with the new brand information
  }
}