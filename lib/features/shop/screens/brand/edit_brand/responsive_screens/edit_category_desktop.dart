import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../models/brand_model.dart';
import '../widgets/edit_brand_form.dart';


class EditBrandDesktop extends StatelessWidget {
  const EditBrandDesktop({super.key,required this.brand});

  final BrandModel brand;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'Update Brand',breadCrumbItems: [TRoutes.brands,'Update Brand'],),
            SizedBox(height: TSizes.spaceBtwSections,),

            EditBrandForm(brand: brand),
          ],
        ),
        ),
      ),
    );
  }
}
