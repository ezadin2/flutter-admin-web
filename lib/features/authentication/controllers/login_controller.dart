import 'package:ecommerce_admin_panel/data/repositories/setting/setting_repository.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/features/personalization/models/setting_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/styles/user_model.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    email.text = localStorage.read('REMEMBER_ME_EMAIL')?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD')?? '';
  } //Handels email and password signin

  Future<void> emailAndPassword() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          "wait..", TImages.docerAnimation);
//check the internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      //form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      //save Data if remember me is selcted
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }
      //login user using email and password authentication
      await AuthenthicationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //fetch user Details and assign to user credentials

      final user = await UserController.instance.fetchUserDetails();

      //remove loader

      TFullScreenLoader.stopLoading();


      if (user.role != AppRole.admin) {
        await AuthenthicationRepository.instance.logout();
        TLoaders.errorSnackBar(title: 'Not Authorized',message: 'You are not authorized or do have acess,contact admin');
      } else{
        AuthenthicationRepository.instance.screenRedirect();
      }
    }catch (e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'oh snap',message:e.toString());
    }
  }

  //handels registers of admin
  Future<void> registerAdmin() async {
    try {

      TFullScreenLoader.openLoadingDialog(
          "Register Admin Account....", TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenthicationRepository.instance.registerWithEmailAndPassword(
          TTexts.adminEmail, TTexts.adminPassword);


      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(UserModel(
          id: AuthenthicationRepository.instance.autheUser!.uid,
          firstName: 'Tomas',
          lastName: 'Admin',
          email: TTexts.adminEmail,
          role: AppRole.admin,
          createdAt: DateTime.now()));

      final settingsRepositry = Get.put(SettingsRepository());
      await settingsRepositry.registerSettings(SettingsModel(appLogo: '',appName: 'Tomas Ecommerce-System',taxRate: 0,shippingCost: 0));
      TFullScreenLoader.stopLoading();

      //redirect
      AuthenthicationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'oh snap', message: e.toString());
    }
  }
}
