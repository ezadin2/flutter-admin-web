import 'package:ecommerce_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/all_brands/responsive_screens/brand_desktop_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/all_brands/responsive_screens/brand_mobile_screen.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/brand/all_brands/responsive_screens/brand_tablet_screen.dart';
import 'package:flutter/cupertino.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: BrandDesktopScreen(),tablet: BrandTabletScreen(),mobile: BrandMobileScreen());
  }
}
