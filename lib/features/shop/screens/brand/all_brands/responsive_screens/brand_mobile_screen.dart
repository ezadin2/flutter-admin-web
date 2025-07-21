import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/all_brands/table/data_table.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/table/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/brand_controller.dart';

class BrandMobileScreen extends StatelessWidget {
  const BrandMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(BrandController());
    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(heading: 'Categories', breadCrumbItems: ['Categories']),
              SizedBox(height: TSizes.spaceBtwSections,),
              TRoundedContainer(
                child: Column(
                  children: [
                    TTableHeader(buttonText: 'Create New brand',onPressed: ()=> Get.toNamed(TRoutes.brands),),
                    SizedBox(height: TSizes.spaceBtwItems,),
                    Obx((){
                      if (controller.isLoading.value) return const TLoaderAnimation();
                      return const BrandTable();
                    }),
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
