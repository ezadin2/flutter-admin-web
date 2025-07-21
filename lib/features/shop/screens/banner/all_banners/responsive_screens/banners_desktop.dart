import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/table_header.dart';
import '../table/data_table.dart';

class BannersDesktopScreen extends StatelessWidget {
  const BannersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(
                  heading: 'Banners', breadCrumbItems: ['Banners']),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Obx(
                ()  { if(controller.isLoading.value) return TLoaderAnimation();
                 return TRoundedContainer(
                    child: Column(
                      children: [
                      TTableHeader(
                      buttonText: 'Create New Banner',
                      onPressed: () => Get.toNamed(TRoutes.createBanner),
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),

                       BannerTable()
                      ]
                    ),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}