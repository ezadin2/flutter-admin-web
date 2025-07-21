import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:flutter/material.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../category/create_category/widgets/create_category_form.dart';
import '../widgets/create_banner_form.dart';


class CreateBannerTablet extends StatelessWidget {
   CreateBannerTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding
          (padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'create banner',breadCrumbItems: [TRoutes.banners,'create banner']),
              SizedBox(height: TSizes.spaceBtwSections),
              CreateBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
