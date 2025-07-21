import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../data/repositories/brand_repository/edit_brand_controller.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';

class EditBrandForm extends StatelessWidget {
  const EditBrandForm({super.key, required this.brand});
  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBrandController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(brand);
    });
    final categoryController = Get.put(CategoryController());

    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Brand',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            TextFormField(
              controller: controller.name,
              validator: (value) => TValidator.validateEmptyText('Brand Name', value),
              decoration: const InputDecoration(
                labelText: 'Brand Name',
                prefixIcon: Icon(Iconsax.box),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Text(
              'Select Categories',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Obx(() => Wrap(
              spacing: TSizes.sm,
              children: categoryController.allItems.map((element) => Padding(
                padding: const EdgeInsets.only(bottom: TSizes.sm),
                child: TChoiceChip(
                  text: element.name,
                  selected: controller.selectedCategories.contains(element),
                  onSelected: (value) => controller.toggleSelection(element),
                ),
              )).toList(),
            )),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            Obx(() => TImageUploader(
              width: 80,
              height: 80,
              image: controller.imageURL.value.isNotEmpty
                  ? controller.imageURL.value
                  : TImages.defaultImage,
              imageType: controller.imageURL.value.isNotEmpty
                  ? ImageType.network
                  : ImageType.asset,
              onIconButtonPressed: controller.pickImage,
            )),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(() => CheckboxMenuButton(
              value: controller.isFeatured.value,
              onChanged: (value) => controller.isFeatured.value = value ?? false,
              child: const Text('Featured'),
            )),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateBrand(brand),
                child: const Text('Update'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}