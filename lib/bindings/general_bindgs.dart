import 'package:ecommerce_admin_panel/features/personalization/controllers/setting_controller.dart';
import 'package:get/get.dart';

import '../features/authentication/controllers/user_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindgs extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(()=>NetworkManager(),fenix: true);
   Get.lazyPut(()=>UserController(),fenix: true);
   Get.lazyPut(()=>SettingsController(),fenix: true);
  }

}