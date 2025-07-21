
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/authentication/controllers/user_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../images/t_rounded_image.dart';
import '../../shimmers/shimmer.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});
final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Container(
      decoration: BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(onPressed: ()=>scaffoldKey?.currentState?.openDrawer(), icon: Icon(Iconsax.menu))
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
              Obx(
                ()=> TRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network: ImageType.asset,
                  image:  controller.user.value.profilePicture.isNotEmpty? controller.user.value.profilePicture : TImages.user,
                ),
              ),
              SizedBox(width: TSizes.sm,),


              //name and email
             if (!TDeviceUtils.isMobileScreen(context))
               Obx(
                 ()=> Column(
                   mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.loading.value ? TShimmerEffect(width:50,height:13):
                    Text(controller.user.value.fullName,style: Theme.of(context).textTheme.titleLarge,),
                    controller.loading.value ? TShimmerEffect(width:50,height:13):
                    Text(controller.user.value.email,style: Theme.of(context).textTheme.labelMedium,)
                  ],
                               ),
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
