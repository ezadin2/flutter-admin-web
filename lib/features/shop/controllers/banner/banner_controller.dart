import 'package:ecommerce_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:ecommerce_admin_panel/features/shop/models/banner_model.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/baners/baanners_repository.dart';

class BannerController extends TBaseController<BannerModel> {
  static BannerController get instance => Get.find();

  final _bannerRepository = Get.put(BannerRepository());

  @override
  Future<List<BannerModel>> fetchItems() async {
    return await _bannerRepository.getAllBanners();
  }

  @override
  bool containsSearchQuery(BannerModel item, String query) {
    // Implement your search logic here
    return false;
  }

  @override
  Future<void> deleteItem(BannerModel item) async {
    await _bannerRepository.deleteBanner(item.id ?? '');
  }

  String formatRoute(String route) {
    if (route.isEmpty) return '';
    String formatted = route.substring(1);
    formatted = formatted[0].toUpperCase() + formatted.substring(1);
    return formatted;
  }
}