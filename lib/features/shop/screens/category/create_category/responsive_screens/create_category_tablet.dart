import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:flutter/material.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_category_form.dart';

class CreateCategoryTablet extends StatelessWidget {
  const CreateCategoryTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding
          (padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'create category',breadCrumbItems: [TRoutes.categories,'create category']),
              SizedBox(height: TSizes.spaceBtwSections),
              CreateCategoryForm(),
            ],
          ),
        ),
      ),
    );
  }
}
