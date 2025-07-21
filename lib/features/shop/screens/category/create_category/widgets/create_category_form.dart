import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:ecommerce_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/category/create_category_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../../controllers/category/category_controller.dart';

class CreateCategoryForm extends StatelessWidget {
  const CreateCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
    final categoryController = Get.put(CategoryController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TSizes.sm),
            TextFormField(
              controller: createController.name,
              validator: (value) => TValidator.validateEmptyText('name', value),
              decoration: const InputDecoration(
                  labelText: 'category', prefixIcon: Icon(Iconsax.category)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(
              () => categoryController.isLoading.value
                  ? TShimmerEffect(width: double.infinity, height: 55)
                  : DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'parent category',
                          labelText: 'parent category',
                          prefixIcon: Icon(Iconsax.bezier)),
                      onChanged: (newValue) =>
                          createController.selectedParent.value = newValue!,
                      items: categoryController.allItems
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [Text(item.name)],
                                ),
                              ))
                          .toList(),
                    ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            Obx(
              ()=> TImageUploader(
                width: 80,
                height: 80,
                image: createController.imageUrl.value.isNotEmpty ? createController.imageUrl.value : TImages.defaultImage,
                imageType: createController.imageUrl.value.isNotEmpty ? ImageType.network : ImageType.asset,
                onIconButtonPressed: () =>createController.pickImage(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(
              ()=> CheckboxMenuButton(
                value: createController.isFeatured.value,
                onChanged: (value) => createController.isFeatured.value = value ?? false,
                child: const Text('feature'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => createController.createCategory(),  // Removed the parameter
                child: Text('Create'),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields *2,)
          ],
        ),
      ),
    );
  }
}
