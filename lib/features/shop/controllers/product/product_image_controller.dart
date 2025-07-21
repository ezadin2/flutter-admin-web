import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_varition_model.dart';
import 'package:get/get.dart';

import '../../../media/controllers/media_controller.dart';

class ProductImagesController extends GetxController {
  static ProductImagesController get instance => Get.find();

  Rx<String?> selectedThumbnailImageUrl = Rx<String?>(null);
  final RxList<String> additionalProductImagesUrls = <String>[].obs;

  Future<void> removeAdditionalImage(int index) async {
    additionalProductImagesUrls.removeAt(index);
  }

  Future<void> addAdditionalImages(List<String> imageUrls) async {
    additionalProductImagesUrls.addAll(imageUrls);
  }

  Future<void> selectThumbnailImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      selectedThumbnailImageUrl.value = selectedImages.first.url;
    }
  }

  Future<void> selectVariationImage(ProductVariationModel variation) async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      variation.image.value = selectedImages.first.url;
    }
  }

  // Add this new method
  Future<void> selectMultipleProductImages() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia(
      multipleSelection: true,
    );

    if (selectedImages != null && selectedImages.isNotEmpty) {
      additionalProductImagesUrls.addAll(
        selectedImages.map((image) => image.url).toList(),
      );
    }
  }


  Future<void> removeImage(int index) async {
    additionalProductImagesUrls.removeAt(index);
  }
}