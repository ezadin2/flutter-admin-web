import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    // Initialize controllers only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.firstNameController.text.isEmpty) {
        controller.firstNameController.text = controller.user.value.firstName;
      }
      if (controller.lastNameController.text.isEmpty) {
        controller.lastNameController.text = controller.user.value.lastName;
      }
      if (controller.phoneController.text.isEmpty) {
        controller.phoneController.text = controller.user.value.phoneNumber;
      }
    });

    return Column(
      children: [
        TRoundedContainer(
          padding: EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Information', style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: TSizes.spaceBtwSections),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            decoration: InputDecoration(
                              hintText: 'First name',
                              label: Text('First name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText('First name', value),
                          ),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            decoration: InputDecoration(
                              hintText: 'Last name',
                              label: Text('Last name'),
                              prefixIcon: Icon(Iconsax.user),
                            ),
                            validator: (value) => TValidator.validateEmptyText('Last name', value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                              label: Text('Email'),
                              prefixIcon: Icon(Iconsax.direct),
                              enabled: false,
                            ),
                            initialValue: controller.user.value.email,
                          ),
                        ),
                        SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              label: Text('Phone number'),
                              prefixIcon: Icon(Iconsax.mobile),
                            ),
                            validator: (value) => TValidator.validateEmptyText('Phone Number', value),
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
                  onPressed: controller.loading.value ? null : () => controller.updateUserInformation(),
                  child: controller.loading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Update Profile'),
                ),
              )),
            ],
          ),
        )
      ],
    );
  }
}
