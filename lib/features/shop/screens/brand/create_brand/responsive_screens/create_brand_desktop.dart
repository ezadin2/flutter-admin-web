import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../widgets/create_brand_form.dart';
//import '../widgets/create_category_form.dart';

class CreateBrandDesktop extends StatelessWidget {
  const CreateBrandDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding
          (padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'create Brand',breadCrumbItems: [TRoutes.createBrand,'create Brand']),
              SizedBox(height: TSizes.spaceBtwSections),
              CreateBrandForm(),
            ],
          ),
        ),
      ),
    );
  }
}
