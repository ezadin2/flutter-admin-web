import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:ecommerce_admin_panel/data/repositories/Product/product_repository.dart';
import 'package:ecommerce_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/all_products/table/products_table.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/table_header.dart';

class ProductDesktopScreen extends StatelessWidget {
  const ProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(
                  heading: 'Products', breadCrumbItems: ['Products']),
              SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Obx(
                () {
                  if(controller.isLoading.value) return TLoaderAnimation();
                   return TRoundedContainer(
                    child: Column(
                      children: [
                        TTableHeader(
                          buttonText: 'Add Product',
                          onPressed: () => Get.toNamed(TRoutes.createProducts),
                          searchOnChanged: (query)=> controller.searchQuery(query),
                        ),
                        SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        ProductsTable(),
                      ],
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
