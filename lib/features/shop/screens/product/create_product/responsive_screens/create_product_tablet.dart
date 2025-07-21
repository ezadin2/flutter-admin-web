import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:flutter/material.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';
//import '../widgets/create_category_form.dart';

class CreateProductTablet extends StatelessWidget {
  const CreateProductTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding
          (padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'create product',breadCrumbItems: [TRoutes.products ,'create product']),
              SizedBox(height: TSizes.spaceBtwSections),

            ],
          ),
        ),
      ),
    );
  }
}
