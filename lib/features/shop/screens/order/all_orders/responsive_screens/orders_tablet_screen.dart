import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../common/widgets/loaders/loader_animation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/order/order_controller.dart';
import '../table/data_table.dart';

class OrdersTabletScreen extends StatelessWidget {
  const OrdersTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(OrderController());
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
                    TTableHeader(showLeftWidget: false, searchController: controller.searchTextController,
                      searchOnChanged:(query)=>controller.searchQuery(query),

                    ),
                    SizedBox(height: TSizes.spaceBtwItems,),
                    Obx(() {if (controller.isLoading.value)return const TLoaderAnimation();

                    return    OrderTable();}),
                  ]
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
