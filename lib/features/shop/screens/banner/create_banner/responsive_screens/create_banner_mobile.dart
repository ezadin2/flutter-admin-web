import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../category/create_category/widgets/create_category_form.dart';


class CreateBannerMobile extends StatelessWidget {
  const CreateBannerMobile({super.key});

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
              CreateBannerMobile(),
            ],
          ),
        ),
      ),
    );
  }
}
