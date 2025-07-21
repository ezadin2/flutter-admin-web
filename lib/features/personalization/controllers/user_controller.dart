import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../media/controllers/media_controller.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  // Observable variables
  final RxBool loading = false.obs;
  final Rx<UserModel> user = UserModel.empty().obs;

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  // Dependencies
  final UserRepository userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();
      this.user.value = user;

      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneController.text = user.phoneNumber;

      loading.value = false;
      return user;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to load user details');
      return UserModel.empty();
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      loading.value = true;
      TFullScreenLoader.openLoadingDialog('Updating Profile...', 'Please wait while we update your profile picture');

      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      if (selectedImages != null && selectedImages.isNotEmpty) {
        ImageModel selectedImage = selectedImages.first;

        await userRepository.updateSingleField({
          'ProfilePicture': selectedImage.url,
          'UpdatedAt': DateTime.now()
        });

        user.value.profilePicture = selectedImage.url;
        user.refresh();

        TLoaders.successSnackBar(
            title: 'Success',
            message: 'Profile picture updated'
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: e.toString()
      );
    } finally {
      loading.value = false;
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> updateUserInformation() async {
    try {
      loading.value = true;
      TFullScreenLoader.openLoadingDialog('Saving Changes...', 'Please wait while we save your changes');

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(title: 'No Internet Connection');
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Update user model
      user.update((val) {
        val?.firstName = firstNameController.text.trim();
        val?.lastName = lastNameController.text.trim();
        val?.phoneNumber = phoneController.text.trim();
        val?.updatedAt = DateTime.now();
      });

      // Save to Firestore
      await userRepository.updateUserDetails(user.value);

      TLoaders.successSnackBar(
          title: 'Success',
          message: 'Profile updated successfully'
      );
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: e.toString()
      );
    } finally {
      loading.value = false;
      TFullScreenLoader.stopLoading();
    }
  }
}