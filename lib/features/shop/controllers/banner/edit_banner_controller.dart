// edit_banner_controller.dart
import 'package:ecommerce_admin_panel/data/repositories/baners/baanners_repository.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:ecommerce_admin_panel/routes/app_screens.dart';
import 'package:ecommerce_admin_panel/utils/helpers/network_manager.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/banner_model.dart';

class EditBannerController extends GetxController {
  static EditBannerController get instance => Get.find();
  final imageUrl = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final targetScreen = ''.obs;
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BannerRepository());

  void init(BannerModel banner) {
    imageUrl.value = banner.imageUrl;
    isActive.value = banner.active;
    targetScreen.value = banner.targetScreen;
  }

  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      imageUrl.value = selectedImage.url;
    }
  }

  Future<void> updateBanner(BannerModel banner) async {
    try {
      // Start loading
      loading.value = true;
      TFullScreenLoader.popUpCircular();

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(title: 'No Internet Connection', message: 'Please check your internet connection');
        return;
      }

      // Check if any changes were made
      if (banner.imageUrl != imageUrl.value ||
          banner.targetScreen != targetScreen.value ||
          banner.active != isActive.value) {

        // Update banner properties
        banner.imageUrl = imageUrl.value;
        banner.targetScreen = targetScreen.value;
        banner.active = isActive.value;

        // Update in repository
        await repository.updateBanner(banner);

        // Update in the list
        BannerController.instance.updateItemsFromLists(banner);

        // Show success message
        TLoaders.successSnackBar(
            title: 'Success',
            message: 'Banner has been updated successfully'
        );
      } else {

      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: e.toString()
      );
    } finally {
      // Stop loading in all cases (success or error)
      loading.value = false;
      TFullScreenLoader.stopLoading();
    }
  }
}