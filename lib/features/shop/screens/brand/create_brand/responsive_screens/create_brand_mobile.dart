import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';
//import '../widgets/create_category_form.dart';

class CreateBrandMobile extends StatelessWidget {
  const CreateBrandMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding
          (padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'create category',breadCrumbItems: [TRoutes.createBrand,'create category']),
              SizedBox(height: TSizes.spaceBtwSections),
              CreateBrandForm(),
            ],
          ),
        ),
      ),
    );
  }
}
