import 'package:adminpanel/utils/constants/colors.dart';
import 'package:adminpanel/utils/constants/enums.dart';
import 'package:adminpanel/utils/constants/image_strings.dart';
import 'package:adminpanel/utils/constants/sizes.dart';
import 'package:adminpanel/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../images/t_rounded_image.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(onPressed: () {}, icon: Icon(Iconsax.menu))
            : null,
        title: TDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'search anything...'),
                ),
              )
            : null,

        ///actions
        actions: [
          if (!TDeviceUtils.isDesktopScreen(context))
            IconButton(onPressed: () {}, icon: Icon(Iconsax.search_normal)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.notification)),
          SizedBox(
            width: TSizes.spaceBtwItems / 2,
          ),

          //user Data

          Row(
            children: [
              TRoundedImage(
                width: 40,
                padding: 2,
                height: 40,
                imageType: ImageType.asset,
                image: TImages.user,
              ),
              SizedBox(width: TSizes.sm,),


              //name and email
             if (!TDeviceUtils.isMobileScreen(context))
               Column(
                 mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tomas Ecommerce System",style: Theme.of(context).textTheme.titleLarge,),
                  Text("Support@Tomas.com",style: Theme.of(context).textTheme.labelMedium,)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
