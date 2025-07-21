import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_variation_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:ecommerce_admin_panel/utils/popups/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductAttributesController extends GetxController{
  static ProductAttributesController get instance => Get.find();

  final isLoading = false.obs;
  final attributeFormKey = GlobalKey<FormState>();
  TextEditingController attributeName = TextEditingController();
  TextEditingController attribute = TextEditingController();
  final RxList<ProductAttributeModel> productAttribute = <ProductAttributeModel>[].obs;

  void addNewAttribute(){
    if(!attributeFormKey.currentState!.validate()){
      return;
    }

    productAttribute.add(ProductAttributeModel(name: attributeName.text.trim(),values: attribute.text.trim().split('|').toList()));
    attributeName.text = '';
    attribute.text = '';
  }

  void removeAttribute(int index,BuildContext context){
    TDialogs.defaultDialog(context: context,
    onConfirm: (){
      Navigator.of(context).pop();
      productAttribute.removeAt(index);

      ProductVariationController.instance.productVariations.value = [];
    }
    );
  }
  void resetProductAttribute(){
    productAttribute.clear();
  }

  void resetAllValues() {
    attributeName.clear();
    attribute.clear();
    productAttribute.clear();

  }

}