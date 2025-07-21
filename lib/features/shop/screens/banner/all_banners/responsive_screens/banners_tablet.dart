import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/table/data_table.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../controllers/banner/banner_controller.dart';
import '../table/data_table.dart';

class BannersTabletScreen extends StatelessWidget {
  const BannersTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(BannerController());
    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(heading: 'Banners', breadCrumbItems: ['Banners']),
              SizedBox(height: TSizes.spaceBtwSections,),
              Obx(() {
                if(controller.isLoading.value) return TLoaderAnimation();

                return  TRoundedContainer(
                  child: Column(
                    children: [
                      TTableHeader(
                        buttonText: 'Create New Banner', onPressed: () =>
                          Get.toNamed(TRoutes.createBanner),),
                      SizedBox(height: TSizes.spaceBtwItems,),
                      BannerTable(),
                    ],
                  ),
                );

              }
              )

            ],
          ),
        ),
      ),
    );;
  }
}
