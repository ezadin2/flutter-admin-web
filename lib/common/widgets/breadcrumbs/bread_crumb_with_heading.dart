import 'package:ecommerce_admin_panel/common/widgets/texts/page_heading.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class TBreadCrumbWithHeading extends StatelessWidget {
  const TBreadCrumbWithHeading(
      {super.key,
      required this.heading,
      required this.breadCrumbItems,
       this.returnToPreviousScreen=false,
      });

  final String heading;
  final List<String> breadCrumbItems;
  final bool returnToPreviousScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => Get.offAllNamed(TRoutes.dashboard),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Text(
                  'DashBoard',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .apply(fontWeightDelta: -1),
                ),
              ),
            ),
            SizedBox(height: TSizes.sm,),
            for(int i=0;i< breadCrumbItems.length;i++)
              Row(
                children: [
                  const Text('/'),
                  InkWell(
                    onTap: i== breadCrumbItems.length -1?null:()=> Get.toNamed(breadCrumbItems[i]),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.xs),
                      child: Text(
                        i==breadCrumbItems.length -1 ?breadCrumbItems[i].capitalize.toString():capitalize(breadCrumbItems[i].substring(1)),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .apply(fontWeightDelta: -1),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
        const SizedBox(
          height: TSizes.sm,
        ),
        Row(
          children: [
            if (returnToPreviousScreen) IconButton(onPressed: ()=>Get.back(), icon: const Icon(Iconsax.arrow_left)),
            if (returnToPreviousScreen) const SizedBox(width: TSizes.spaceBtwItems,),

            TPageHeading(heading: heading,)
          ],
        )
      ],
    );
  }

  String capitalize(String s){
    return s.isEmpty?'':s[0].toUpperCase()+s.substring(1);
  }
}
