import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_attribute_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:ecommerce_admin_panel/utils/popups/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/product_varition_model.dart';

class ProductVariationController extends GetxController {
  static ProductVariationController get instance => Get.find();
  final isLoading = false.obs;
  final RxList<ProductVariationModel> productVariations =
      <ProductVariationModel>[].obs;
  List<Map<ProductVariationModel, TextEditingController>> stockControllerList =
      [];
  List<Map<ProductVariationModel, TextEditingController>> priceControllerList =
      [];
  List<Map<ProductVariationModel, TextEditingController>>
      salePriceControllerList = [];
  List<Map<ProductVariationModel, TextEditingController>>
      descriptionControllerList = [];

  final attributesController = Get.put(ProductAttributesController());

  void removeVariations(BuildContext context) {
    TDialogs.defaultDialog(
        context: context,
        title: 'Remove Variations',
        onConfirm: () {
          productVariations.value = [];
          resetAllValues();
          Navigator.of(context).pop();
        });
  }

  void generateVariationsConfirmation(BuildContext context) {
    TDialogs.defaultDialog(
        context: context,
        confirmText: 'Generate',
        title: 'Generate Variations',
        content:
            'Once The Varations are created, you cannot add more attributes,in order to add more Variations,you should have to Delete any of the attributes',
        onConfirm: () => generateVariationsFromAttributes());
  }

  void generateVariationsFromAttributes() {
    Get.back();

    final List<ProductVariationModel> varaitions = [];
    if (attributesController.productAttribute.isNotEmpty) {
      final List<List<String>> attributeCombinations = getCombinations(
          attributesController.productAttribute
              .map((attr) => attr.values ?? <String>[])
              .toList());

      for (final combination in attributeCombinations) {
        final Map<String, String> attributeValues = Map.fromIterables(
            attributesController.productAttribute
                .map((attr) => attr.name ?? ''),
            combination);
        final ProductVariationModel variation = ProductVariationModel(
            id: UniqueKey().toString(), attributeValues: attributeValues);
        varaitions.add(variation);
        final Map<ProductVariationModel, TextEditingController>
            stockController = {};
        final Map<ProductVariationModel, TextEditingController>
            priceController = {};
        final Map<ProductVariationModel, TextEditingController>
            salesPriceController = {};
        final Map<ProductVariationModel, TextEditingController>
            descriptionController = {};

        stockController[variation] = TextEditingController();
        priceController[variation] = TextEditingController();
        salesPriceController[variation] = TextEditingController();
        descriptionController[variation] = TextEditingController();

        stockControllerList.add(stockController);
        priceControllerList.add(priceController);
        salePriceControllerList.add(salesPriceController);
        descriptionControllerList.add(descriptionController);
      }
    }
    productVariations.assignAll(varaitions);
  }

  List<List<String>> getCombinations(List<List<String>> lists) {
    final List<List<String>> result = [];

    combine(lists, 0, <String>[], result);

    return result;
  }

  void combine(List<List<String>> lists, int index, List<String> current,
      List<List<String>> result) {
    if (index == lists.length) {
      result.add(List.from(current));
      return;
    }

    for (final item in lists[index]) {
      final List<String> update = List.from(current)..add(item);

      combine(lists, index + 1, update, result);
    }
  }

  void resetAllValues() {
    productVariations.clear();
    stockControllerList.clear();
    priceControllerList.clear();
    salePriceControllerList.clear();
    descriptionControllerList.clear();
  }

  void initializedVariationController(List<ProductVariationModel> variations) {
    stockControllerList.clear();
    salePriceControllerList.clear();
    priceControllerList.clear();
    descriptionControllerList.clear();

    for (var variation in variations) {
      // Stock controller
      Map<ProductVariationModel, TextEditingController> stockController = {};
      stockController[variation] = TextEditingController(text: variation.stock.toString());
      stockControllerList.add(stockController);

      // Price controller
      Map<ProductVariationModel, TextEditingController> priceController = {};
      priceController[variation] = TextEditingController(text: variation.price.toString());
      priceControllerList.add(priceController);

      // Sale price controller
      Map<ProductVariationModel, TextEditingController> salePriceController = {};
      salePriceController[variation] = TextEditingController(text: variation.salePrice?.toString() ?? '');
      salePriceControllerList.add(salePriceController);

      // Description controller
      Map<ProductVariationModel, TextEditingController> descriptionController = {};
      descriptionController[variation] = TextEditingController(text: variation.description ?? '');
      descriptionControllerList.add(descriptionController);
    }
  }
}
