import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../models/banner_model.dart';
import '../../../../models/category_model.dart';
import '../widgets/edit_banner_form.dart';


class EditBannerDesktop extends StatelessWidget {
  const EditBannerDesktop({super.key,required this.banner});

  final BannerModel banner;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TBreadCrumbWithHeading(returnToPreviousScreen: true,heading: 'Update banner',breadCrumbItems: [TRoutes.banners,'Update Banners'],),
            SizedBox(height: TSizes.spaceBtwSections,),

            EditBannerForm(banner: banner),
          ],
        ),
        ),
      ),
    );
  }
}
