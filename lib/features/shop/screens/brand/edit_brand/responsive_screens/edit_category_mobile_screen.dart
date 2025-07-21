import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/brand_model.dart';
import '../../../../models/category_model.dart';
import '../widgets/edit_brand_form.dart';


class EditBrandMobileScreen extends StatelessWidget {
  const EditBrandMobileScreen({super.key, required this.brand});
  final BrandModel brand;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'Update Category',breadCrumbItems: [TRoutes.brands,'Update Categories'],),
              SizedBox(height: TSizes.spaceBtwSections,),

              EditBrandForm(brand: brand),
            ],
          ),
        ),
      ),
    );
  }
}
