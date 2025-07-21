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

class CreateBrandController extends GetxController{
  static CreateBrandController get instance=> Get.find();

  final loading =false.obs;
  RxString imageURL= ''.obs;
  final isFeatured =false.obs;
  final name =TextEditingController();
  final formkey = GlobalKey<FormState>(); // Changed here
  final List<CategoryModel> selectedCategories=<CategoryModel>[].obs;

  void toggleSelection(CategoryModel category){
    if(selectedCategories.contains(category)){
      selectedCategories.remove(category);
    }else{
      selectedCategories.add(category);
    }
  }

  void resetFields(){
    name.clear();
    loading(false);
    isFeatured(false);
    imageURL.value='';
    selectedCategories.clear();
  }

  void pickImage() async{
    final controller =Get.put(MediaController());
    List<ImageModel>? selectedImages =await controller.selectImagesFromMedia();

    if(selectedImages != null && selectedImages.isNotEmpty){
      ImageModel selectedImage = selectedImages.first;
      imageURL.value =selectedImage.url;
    }
  }

  Future<void> createBrand() async{
    try{
      TFullScreenLoader.popUpCircular();
      final isConnected =await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      // Changed validation check here
      if(formkey.currentState == null || !formkey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      final newRecord = BrandModel(
          id: '',
          name: name.text.trim(),
          image: imageURL.value,
          isFeatured: isFeatured.value,
          productsCount: 0
      );

      newRecord.id =await BrandRepository.instance.createBrand(newRecord);

      if(selectedCategories.isNotEmpty){
        if(newRecord.id.isEmpty) throw 'error storing relational data, try again';

        for(var category in selectedCategories){
          final brandCategory = BrandCategoryModel(brandId: newRecord.id, categoryId: category.id);
          await BrandRepository.instance.createBrandCategory(brandCategory);
        }
        newRecord.brandCategories ??= [];
        newRecord.brandCategories!.addAll(selectedCategories);
      }

      BrandController.instance.addItemToLists(newRecord);
      resetFields();
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'congragulation', message: 'new record has been added.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'on shop', message: e.toString());
    }
  }
}