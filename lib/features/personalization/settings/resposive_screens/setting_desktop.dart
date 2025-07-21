import 'package:ecommerce_admin_panel/common/widgets/breadcrumbs/bread_crumb_with_heading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../widgets/image_meta.dart';
import '../widgets/setting_form.dart';

class SettingsDesktopScreen extends StatelessWidget {
  const SettingsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200), // Or MediaQuery width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TBreadCrumbWithHeading(heading: 'setting', breadCrumbItems: ['setting']),
                SizedBox(height: TSizes.spaceBtwSections),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ImageAndMeta()),
                    SizedBox(width: TSizes.spaceBtwSections),
                    Expanded(flex: 2, child: SettingForm()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
