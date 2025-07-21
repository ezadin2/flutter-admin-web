import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../../../models/category_model.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesController = Get.put(CategoryController());
    final productController = CreateProductController.instance;

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: TSizes.spaceBtwItems),
          Obx(
                () => categoriesController.isLoading.value
                ? TShimmerEffect(width: double.infinity, height: 50)
                : MultiSelectDialogField<CategoryModel>(
              buttonText: Text("Select Categories"),
              title: Text("Categories"),
              items: categoriesController.allItems
                  .map((category) => MultiSelectItem(category, category.name))
                  .toList(),
              initialValue: productController.selectedCategories.toList(),
              listType: MultiSelectListType.CHIP,
              onConfirm: (values) {
                productController.selectedCategories.assignAll(values);
              },
            ),
          )
        ],
      ),
    );
  }
}