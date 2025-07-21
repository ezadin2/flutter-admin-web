import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/features/personalization/controllers/setting_controller.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

class SettingForm extends StatelessWidget {
  const SettingForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SettingsController.instance;
    return Column(
      children: [
        TRoundedContainer(
          padding: EdgeInsets.symmetric(
            vertical: TSizes.lg,
            horizontal: TSizes.md,
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Setting',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: TSizes.spaceBtwSections),

                /// App Name
                TextFormField(
                  controller: controller.appNameController,
                  decoration: InputDecoration(
                    hintText: 'App name',
                    label: Text('App name'),
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
                SizedBox(height: TSizes.spaceBtwInputFields),

                /// Tax & Shipping Inputs
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.taxController,
                        decoration: InputDecoration(
                          hintText: 'Tax %',
                          label: Text('Tax Rate (%)'),
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                      ),
                    ),
                    SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: TextFormField(
                        controller: controller.shippingController,
                        decoration: InputDecoration(
                          hintText: 'Shipping',
                          label: Text('Shippinh cost (ETB)'),
                          prefixIcon: Icon(Iconsax.ship),
                        ),
                      ),
                    ),
                    SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: TextFormField(
                        controller: controller.freeShippingThresholdController,
                        decoration: InputDecoration(
                          hintText: 'Free shipping',
                          label: Text('Free shipping Threshhold'),
                          prefixIcon: Icon(Iconsax.ship),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: TSizes.spaceBtwSections),

                /// Submit Button (moved out of the Row)
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                        () => ElevatedButton(
                      onPressed: controller.loading.value
                          ? null  // Disable button when loading
                          : () => controller.updateSettingInformation(),
                      child: controller.loading.value
                          ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Text('Update App Settings'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
