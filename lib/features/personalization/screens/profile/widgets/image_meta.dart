import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/image_uploader.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return TRoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              TImageUploader(
                imageType: controller.user.value.profilePicture.isNotEmpty
                    ? ImageType.network
                    : ImageType.asset,
                right: 10,
                left: null,
                width: 200,
                height: 200,
                loading: controller.loading.value,
                onIconButtonPressed: () => controller.updateProfilePicture(),
                circular: true,
                image: controller.user.value.profilePicture.isNotEmpty
                    ? controller.user.value.profilePicture
                    : TImages.user,
                bottom: 20,
                icon: Iconsax.camera,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(controller.user.value.fullName,
                  style: Theme.of(context).textTheme.headlineLarge),
              Text(controller.user.value.email),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          )
        ],
      )),
    );
  }
}