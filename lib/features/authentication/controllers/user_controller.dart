import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';

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


  // In UserController
  final RxList<UserModel> deliveryBoys = <UserModel>[].obs;

  Future<void> loadDeliveryBoys() async {
    try {
      loading.value = true;
      final result = await userRepository.getAllDeliveryBoys();
      deliveryBoys.assignAll(result);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to fetch delivery boys');
      deliveryBoys.clear();
    } finally {
      loading.value = false;
    }
  }
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();
      print('Fetched user role: ${user.role}'); // Add this line
      this.user.value = user;
      loading.value = false;
      return user;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to load user details');
      return UserModel.empty();
    }
  }

  // In UserController class
// In UserController
  // In UserController
  // In UserController
  Future<List<UserModel>> getAllDeliveryBoys() async {
    try {
      loading.value = true;
      final deliveryBoys = await userRepository.getAllDeliveryBoys();
      loading.value = false;
      return deliveryBoys ?? []; // Ensures no null returns
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to fetch delivery boys');
      return [];
    }
  }


  Future<List<UserModel>> fetchAllUsers() async {
    try {
      loading.value = true;
      final users = await userRepository.getAllUsers();
      loading.value = false;
      return users;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to fetch users');
      return [];
    }
  }



  Future<void> deleteDeliveryBoy(String id) async {
    try {
      // Show loading
      TFullScreenLoader.openLoadingDialog('Deleting delivery boy...', TImages.docerAnimation);

      // Delete from authentication first
      await AuthenthicationRepository.instance.deleteUser(id);

      // Then delete from Firestore
      await UserRepository.instance.deleteUser(id);

      // Stop loading
      TFullScreenLoader.stopLoading();

      // Show success
      TLoaders.successSnackBar(title: 'Success', message: 'Delivery boy deleted successfully');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // In DeliveryController

  Future<void> updateProfilePicture() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController()); // Initialize if not already present
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      if (selectedImages != null && selectedImages.isNotEmpty) {
        ImageModel selectedImage = selectedImages.first;
        await userRepository.updateSingleField({'ProfilePicture': selectedImage.url});

        // Update local user value without triggering full rebuild
        final updatedUser = user.value.copyWith(profilePicture: selectedImage.url);
        user.value = updatedUser;

        TLoaders.successSnackBar(
          title: 'Success',
          message: 'Profile picture updated',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateUserInformation() async {
    try {
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        TLoaders.warningSnackBar(title: 'No Internet', message: 'Please check your internet connection');
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        loading.value = false;
        return;
      }

      // Create updated user model
      final updatedUser = user.value.copyWith(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );

      // Update in Firestore
      await userRepository.updateUserDetails(updatedUser);

      // Update local user value
      user.value = updatedUser;

      // Show success message
      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Profile updated successfully',
      );

    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      loading.value = false;
    }
  }
}