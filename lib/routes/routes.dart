class TRoutes{
  static const login = '/login';
  static const forgetPassword = '/forget-Password/';
  static const resetPassword = '/reset-Password';
  static const dashboard = '/dashboard';
  static const media = '/media';
  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';
  static const products = '/products';
  static const createProducts = '/createProducts';
  static const editProducts = '/editProducts';
  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';
  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand';
  static const customers = '/customers';
  static const createCustomer = '/createCustomer';
  static const customerDetails = '/customerDetails';
  static const editCustomer = '/editCustomer';
  static const orders = '/orders';
  static const orderDetails = '/orderDetails';

  static const coupons = '/coupons';
  static const settings = '/settings';
  static const profile = '/profile';
  static const delivary = '/delivary';
  static const logout = '/logout';

  static List sidebarMenuItems = [
    dashboard,
    media,
    categories,
    brands,
    banners,
    products,
    customers,
    delivary,
    orders,
    profile,
    settings,
  ];
}