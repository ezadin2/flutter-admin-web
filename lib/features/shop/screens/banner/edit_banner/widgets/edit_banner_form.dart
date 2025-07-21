import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/banner/edit_banner_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/category_model.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../routes/app_screens.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/banner/create_banner_controller.dart';
import '../../../../models/banner_model.dart';

class EditBannerForm extends StatelessWidget {
  const EditBannerForm({super.key, required this.banner});

  final BannerModel banner;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBannerController());
    controller.init(banner);
    // TODO: implement build
    return TRoundedContainer(
      width: 500,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: TSizes.sm),
              Text(
                'Update Banner',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              Column(
                children: [
                  Obx(
                  ()=> TRoundedImage(
                      width: 400,
                      height: 200,
                      backgroundColor: TColors.primaryBackground,
                      image: controller.imageUrl.value.isNotEmpty? controller.imageUrl.value : TImages.defaultImage,
                      imageType:controller.imageUrl.value.isNotEmpty? ImageType.network : ImageType.asset,
                    ),
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  TextButton(onPressed:() =>controller.pickImage(), child: Text('Select Image')),
                ],
              ),
              SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Text(
                'Make Your Banner Active or InActive',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Obx(
                    () => CheckboxMenuButton(
                    value: controller.isActive.value,
                    onChanged: (value) =>
                    controller.isActive.value = value ?? false,
                    child: Text('Active')),
              ),
              SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Obx(() {
                return DropdownButton<String>(
                  value: controller.targetScreen.value,
                  onChanged: (String? newValue) =>
                  controller.targetScreen.value = newValue!,
                  items: AppScreens.allAppScreenItems
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                );
              }),
              SizedBox(
                height: TSizes.spaceBtwInputFields * 2,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.updateBanner(banner),
                    child: Text('Update')),
              ),
              SizedBox(
                height: TSizes.spaceBtwInputFields * 2,
              )
            ],
          )),
    );
  }
}

