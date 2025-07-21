import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/category/all_categories/table/data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class BannersMobileScreen extends StatelessWidget {
  const BannersMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(heading: 'banners', breadCrumbItems: ['Banners']),
              SizedBox(height: TSizes.spaceBtwSections,),
              TRoundedContainer(
                child: Column(
                  children: [
                    TTableHeader(buttonText: 'Create New Banner',onPressed: ()=> Get.toNamed(TRoutes.createBanner),),
                    SizedBox(height: TSizes.spaceBtwItems,),
                    BannerTable(),
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
