import 'dart:core';

import 'package:ecommerce_admin_panel/common/widgets/layouts/sidebars/menu/menu_item.dart';
import 'package:ecommerce_admin_panel/features/personalization/controllers/setting_controller.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../images/t_circular_image.dart';

class TSidebar extends StatelessWidget {
  TSidebar({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: BeveledRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
            color: TColors.white,
            border: Border(right: BorderSide(color: TColors.grey, width: 1))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  // In your TSidebar widget, update the TCircularImage section:
                  Obx(
                        () => TCircularImage(
                          width: 80,
                          height: 80,
                          padding: TSizes.sm,
                          imageType: SettingsController.instance.settings.value.appLogo.isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                          image: SettingsController.instance.settings.value.appLogo.isNotEmpty
                              ? SettingsController.instance.settings.value.appLogo
                              : TImages.darkAppLogo,
                          backgroundColor: Colors.transparent,
                          fit: BoxFit.contain,
                        )
                  ),
                  Expanded(
                      child: Obx(() => Text(
                            SettingsController.instance.settings.value.appName,
                            style: Theme.of(context).textTheme.headlineLarge,
                            overflow: TextOverflow.ellipsis,
                          )))
                ],
              ),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Padding(
                padding: EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Menu',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    TMenuItem(
                        route: TRoutes.dashboard,
                        icon: Iconsax.status,
                        itemName: 'Dashboard'),
                    TMenuItem(
                        route: TRoutes.media,
                        icon: Iconsax.image,
                        itemName: 'Media'),
                    TMenuItem(
                        route: TRoutes.categories,
                        icon: Iconsax.category_2,
                        itemName: 'Categories'),
                    TMenuItem(
                        route: TRoutes.brands,
                        icon: Iconsax.dcube,
                        itemName: 'Brands'),
                    TMenuItem(
                        route: TRoutes.banners,
                        icon: Iconsax.picture_frame,
                        itemName: 'Banners'),
                    TMenuItem(
                        route: TRoutes.products,
                        icon: Iconsax.shopping_bag,
                        itemName: 'Products'),
                    TMenuItem(
                        route: TRoutes.customers,
                        icon: Iconsax.profile_2user,
                        itemName: 'Customers'),
                    TMenuItem(
                        route: TRoutes.orders,
                        icon: Iconsax.box,
                        itemName: 'Orders'),
                    Text(
                      'Other',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(letterSpacingDelta: 1.2),
                    ),
                    TMenuItem(
                        route: TRoutes.delivary,
                        icon: Iconsax.profile_2user,
                        itemName: 'Delivary Person'),
                    TMenuItem(
                        route: TRoutes.profile,
                        icon: Iconsax.user,
                        itemName: 'profile'),
                    TMenuItem(
                        route: TRoutes.settings,
                        icon: Iconsax.setting_2,
                        itemName: 'Settings'),
                    TMenuItem(
                        route: 'logout',
                        icon: Iconsax.logout,
                        itemName: 'logout'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
