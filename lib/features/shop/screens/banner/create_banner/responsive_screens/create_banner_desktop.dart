import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../widgets/create_banner_form.dart';


class CreateBannerDesktopScreen extends StatelessWidget {
   CreateBannerDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding
          (padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'create banner',breadCrumbItems: [TRoutes.banners,'create Banner']),
              SizedBox(height: TSizes.spaceBtwSections),
              CreateBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
