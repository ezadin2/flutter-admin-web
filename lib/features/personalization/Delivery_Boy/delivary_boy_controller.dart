import 'package:ecommerce_admin_panel/common/styles/user_model.dart';
import 'package:ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/controllers/user_controller.dart';

class DeliveryController extends GetxController {
  static DeliveryController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  final userRepository = Get.put(UserRepository());
  final authRepository = Get.put(AuthenthicationRepository());

  GlobalKey<FormState> deliveryFormKey = GlobalKey<FormState>();
  final RxBool isEditing = false.obs;
  final RxString currentUserId = ''.obs;



  Future<void> createDeliveryAccount() async {
    try {
      // Form Validation
      if (!deliveryFormKey.currentState!.validate()) return;

      // Start Loading
      TFullScreenLoader.openLoadingDialog('Creating delivery account...', TImages.docerAnimation);

      // Generate a default password
      password.text = "Delivery@123";

      // Register the user
      await authRepository.registerWithEmailAndPassword(
          email.text.trim(),
          password.text.trim()
      );

      // Create user record
      final user = UserModel(
        id: authRepository.autheUser!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phone.text.trim(),
        role: AppRole.delivery,
        createdAt: DateTime.now(),
      );

      await userRepository.createUser(user);
      await UserController.instance.loadDeliveryBoys();
      // Stop Loading
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Success',
          message: 'Delivery account created successfully'
      );

      // Clear controllers
      clearFields();

    } catch (e) {
      // Stop Loading if error occurs
      TFullScreenLoader.stopLoading();

      // Show Error Message
      TLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: e.toString()
      );
    }
  }


  Future<void> updateDeliveryAccount() async {
    try {
      // Form Validation
      if (!deliveryFormKey.currentState!.validate()) return;

      // Start Loading
      TFullScreenLoader.openLoadingDialog('Updating delivery account...', TImages.docerAnimation);

      // Update user record
      final user = UserModel(
        id: currentUserId.value,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phone.text.trim(),
        role: AppRole.delivery,
        createdAt: DateTime.now(), // Keep original creation date
      );

      await userRepository.updateUserDetails(user);

      // Stop Loading
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Success',
          message: 'Delivery account updated successfully'
      );

      // Clear controllers and reset editing state
      clearFields();
      isEditing.value = false;
      currentUserId.value = '';

    } catch (e) {
      // Stop Loading if error occurs
      TFullScreenLoader.stopLoading();

      // Show Error Message
      TLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: e.toString()
      );
    }
  }
  void clearFields() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phone.clear();
  }
}