import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../authentication/controllers/user_controller.dart';
import 'delivary_boy_controller.dart';

class DelivaryForm extends StatelessWidget {
  const DelivaryForm({super.key});

  // In DelivaryForm widget
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryController());

    return Column(
      children: [
        TRoundedContainer(
          padding: EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                  controller.isEditing.value ? 'Update Delivery Boy' : 'Add Delivery Boy',
                  style: Theme.of(context).textTheme.headlineSmall
              )),
              SizedBox(height: TSizes.spaceBtwSections),
              Form(
                key: controller.deliveryFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstName,
                            decoration: InputDecoration(
                              hintText: 'First name',
                              label: Text('First name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                                'First name', value),
                          ),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastName,
                            decoration: InputDecoration(
                              hintText: 'Last name',
                              label: Text('Last name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText(
                                'Last name', value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.email,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              label: Text('Email'),
                              prefixIcon: Icon(Iconsax.direct),
                            ),
                            validator: (value) => TValidator.validateEmail(value),
                            enabled: !controller.isEditing.value, // Disable email editing
                          ),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              label: Text('Phone number'),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.isEditing.value) {
                      await controller.updateDeliveryAccount();
                      // Refresh the list after update
                      final userController = Get.find<UserController>();
                      userController.loadDeliveryBoys();

                    } else {
                      await controller.createDeliveryAccount();
                    }
                  },
                  child: Text(controller.isEditing.value ? 'Update Delivery Boy' : 'Add Delivery Boy'),
                ),
              )),
              if (controller.isEditing.value) ...[
                SizedBox(height: TSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFields();
                      controller.isEditing.value = false;
                      controller.currentUserId.value = '';
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        )
      ],
    );
  }
}