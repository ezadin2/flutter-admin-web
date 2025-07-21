import 'package:ecommerce_admin_panel/features/media/screens.media/media.dart';
import 'package:ecommerce_admin_panel/features/personalization/Delivery_Boy/delivery_boy.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/customer/all_customers/customers.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/order/all_orders/orders.dart';
import 'package:ecommerce_admin_panel/features/shop/screens/product/all_products/products.dart';
import 'package:ecommerce_admin_panel/routes/routes.dart';
import 'package:ecommerce_admin_panel/routes/routes_middleware.dart';
import 'package:get/get.dart';

import '../features/authentication/screens/forget_password/forget_password.dart';
import '../features/authentication/screens/login/login.dart';
import '../features/authentication/screens/reset_password/reset_password.dart';
import '../features/personalization/Delivery_Boy/delivary.dart';
import '../features/personalization/screens/profile/profile.dart';
import '../features/personalization/settings/settings.dart';
import '../features/shop/screens/banner/all_banners/banners.dart';
import '../features/shop/screens/banner/create_banner/create_banner.dart';
import '../features/shop/screens/banner/edit_banner/edit_banner.dart';
import '../features/shop/screens/brand/all_brands/brands.dart';
import '../features/shop/screens/brand/create_brand/create_brand.dart';
import '../features/shop/screens/brand/edit_brand/brand_screen.dart';
import '../features/shop/screens/category/all_categories/categories.dart';
import '../features/shop/screens/category/create_category/create_category.dart';
import '../features/shop/screens/category/edit_category/edit_category.dart';
import '../features/shop/screens/customer/customer_detail/customer.dart';
import '../features/shop/screens/dashboard/dashboard_screen.dart';
import '../features/shop/screens/order/orders_detail/order_detial.dart';
import '../features/shop/screens/product/create_product/create_product.dart';
import '../features/shop/screens/product/edit_product/edit_product.dart';



class TAppRoute {
  static final List<GetPage> pages = [
    GetPage(name: TRoutes.login, page: () => LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => ForgetPasswordScreen()),
    GetPage(name: TRoutes.resetPassword, page: () => ResetPasswordScreen()),
    GetPage(name: TRoutes.dashboard, page: () => DashboardScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.media, page: ()=>  MediaScreen(),middlewares: [TRouteMiddleware()]),


    GetPage(name: TRoutes.categories, page: () => CategoriesScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createCategory, page: () => CreateCategoryScreen(),middlewares: [TRouteMiddleware()]),
     GetPage(name: TRoutes.editCategory, page: ()=> EditCategoryScreen(),middlewares: [TRouteMiddleware()]),

    GetPage(name: TRoutes.brands, page: () =>const BrandsScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createBrand, page: () =>const CreateBrandScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editBrand, page: ()=>const EditBrandScreen(),middlewares: [TRouteMiddleware()]),

    //banners

    GetPage(name: TRoutes.banners, page: () =>const BannersScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createBanner, page: () =>const CreateBannerScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editBanner, page: ()=>const EditBannerScreen(),middlewares: [TRouteMiddleware()]),   //banners

    //Products
    GetPage(name: TRoutes.products, page: () => ProductsScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createProducts, page: () =>const CreateProductScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editProducts, page: ()=>const EditProductScreen(),middlewares: [TRouteMiddleware()]),

    //customers
    GetPage(name: TRoutes.customers, page: () =>const CustomersScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.customerDetails, page: ()=>const CustomerDetailScreen(),middlewares: [TRouteMiddleware()]),

    //orders
    GetPage(name: TRoutes.orders, page: () =>const OrdersScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.orderDetails, page: ()=>const orderDetailScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.delivary, page: ()=>const DelivaryScreen(),middlewares: [TRouteMiddleware()]),

    GetPage(name: TRoutes.settings, page: () =>const SettingScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.profile, page: ()=>const ProfileScreen(),middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.logout, page: ()=>const LoginScreen(),middlewares: [TRouteMiddleware()]),

  ];
}
