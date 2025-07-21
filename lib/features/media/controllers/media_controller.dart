import 'package:ecommerce_admin_panel/common/widgets/loaders/circular_loader.dart';
import 'package:ecommerce_admin_panel/data/repositories/media/media_repository.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widget/media_uploader.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widget/meia_content.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/constants/text_strings.dart';
import 'package:ecommerce_admin_panel/utils/popups/dialogs.dart';
import 'package:ecommerce_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:ecommerce_admin_panel/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../models/image_model.dart';

class MediaController extends GetxController {
  final RxBool loading = false.obs;
  final int initialLoadCount = 20;
  final int loadMoreCount = 25;
  static MediaController get instance => Get.find();

  late DropzoneViewController dropzoneController;

  final Rx<bool> showImagesUploaderSection = false.obs;

  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;

  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;

  final RxList<ImageModel> allImages = <ImageModel>[].obs;

  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;

  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;

  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;

  final RxList<ImageModel> allUserImages = <ImageModel>[].obs;

  final MediaRepostory mediaRepostory = MediaRepostory();

  void getMediaImages() async {
    try {
      loading.value = true;
      print("Fetching images for folder: ${selectedPath.value.name}"); // Debug print

      RxList<ImageModel> targetList = <ImageModel>[].obs;
      if (selectedPath.value == MediaCategory.banners && allBannerImages.isEmpty) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands && allBrandImages.isEmpty) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories && allCategoryImages.isEmpty) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products && allProductImages.isEmpty) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users && allUserImages.isEmpty) {
        targetList = allUserImages;
      }

      final images = await mediaRepostory.fetchImagesFromDatabase(selectedPath.value, initialLoadCount);
      print("Fetched ${images.length} images"); // Debug print
      targetList.assignAll(images);

      loading.value = false;
    } catch (e) {
      loading.value = false;
      print("Error fetching images: $e"); // Debug print
      TLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: 'Unable to fetch images, something went wrong. Try again.',
      );
    }
  }

  loadMoreMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = <ImageModel>[].obs;
      if (selectedPath.value == MediaCategory.banners) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users) {
        targetList = allUserImages;
      }

      // Ensure targetList is not empty and has a valid createdAt value
      if (targetList.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'No Images',
          message: 'No images found to load more.',
        );
        return;
      }

      final DateTime lastFetchedDate = targetList.last.createdAt ?? DateTime.now();
      final String lastFetchedId = targetList.last.id; // Get the ID of the last image
      print("Loading more images after: $lastFetchedDate, ID: $lastFetchedId"); // Debug print

      final images = await mediaRepostory.loadMoreImagesFromDatabase(
        selectedPath.value,
        loadMoreCount,
        lastFetchedDate,
        lastFetchedId, // Pass the lastFetchedId
      );

      if (images.isEmpty) {
        TLoaders.warningSnackBar(
          title: 'No More Images',
          message: 'No more images to load.',
        );
      } else {
        targetList.addAll(images);
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
      print("Error loading more images: $e"); // Debug print
      TLoaders.errorSnackBar(
        title: 'Oh Snap',
        message: 'Unable to fetch images, something went wrong. Try again.',
      );
    }
  }

  Future<void> selectLocalImages() async {
    final files = await dropzoneController
        .pickFiles(multiple: true, mime: ['image/jpeg', 'image/png']);

    if (files.isNotEmpty) {
      for (var file in files) {
        Uint8List fileData = await dropzoneController.getFileData(file);

        final image = ImageModel(
          url: '',
          file: kIsWeb ? html.File([fileData], file.name) : null,
          folder: selectedPath.value.name, // Assign selected folder
          fileName: file.name,
          localImageToDisplay:
          Uint8List.fromList(fileData), // Ensure image preview works
        );

        selectedImagesToUpload.add(image);

        // Add image to the corresponding folder list
        switch (selectedPath.value) {
          case MediaCategory.banners:
            allBannerImages.add(image);
            break;
          case MediaCategory.brands:
            allBrandImages.add(image);
            break;
          case MediaCategory.categories:
            allCategoryImages.add(image);
            break;
          case MediaCategory.products:
            allProductImages.add(image);
            break;
          case MediaCategory.users:
            allUserImages.add(image);
            break;
          default:
            allImages.add(image);
        }
      }
    }
  }

  void uploadImagesConfirmation() {
    if (selectedPath.value == MediaCategory.folders) {
      TLoaders.warningSnackBar(
          title: 'Select Folder',
          message: 'Please select the folder in order to upload the images.');
      return;
    }
    TDialogs.defaultDialog(
      context: Get.context!,
      title: 'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async => await uploadImages(),
      content:
      'Are you sure you want to upload all the images in ${selectedPath.value.name.toUpperCase()} folder',
    );
  }

  Future<void> uploadImages() async {
    try {
      Get.back();
      UploadImagesLoader();
      MediaCategory selectedCategory = selectedPath.value;
      RxList<ImageModel> targetList;

      // Log the selected category
      print('Selected Category: ${selectedCategory.name}');

      // Determine the target list based on the selected category
      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          print('Invalid category selected.');
          return;
      }

      // Log the number of images to upload
      print('Number of images to upload: ${selectedImagesToUpload.length}');

      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesToUpload[i];

        // Log the current image being processed
        print('Processing image: ${selectedImage.fileName}');

        // Ensure the file is not null
        if (selectedImage.file == null) {
          print('Error: File is null for image ${selectedImage.fileName}');
          continue; // Skip this image and proceed to the next one
        }

        final image = selectedImage.file!;

        // Log the file type and size (if applicable)
        if (kIsWeb) {
          print('File type: Web (html.File)');
        } else {
          print('File type: Mobile/Desktop (Uint8List)');
        }

        // Upload the image to Firebase Storage
        print('Uploading image to Firebase Storage...');
        final ImageModel uploadImage =
        await mediaRepostory.uploadImageFieldInStorage(
          file: image,
          path: getSelectedPath(),
          imageName: selectedImage.fileName,
        );

        // Log successful upload
        print('Image uploaded successfully. Download URL: ${uploadImage.url}');

        // Set the media category and upload to Firestore
        uploadImage.mediaCategory = selectedCategory.name;
        print('Uploading image metadata to Firestore...');
        final id = await mediaRepostory.uploadImageFieldInDatabase(uploadImage);

        // Log Firestore upload
        print('Image metadata uploaded to Firestore. Document ID: $id');

        // Update the image model with the Firestore ID
        uploadImage.id = id;

        // Remove the image from the upload list and add it to the target list
        selectedImagesToUpload.removeAt(i);
        targetList.add(uploadImage);

        // Log completion
        print('Image ${selectedImage.fileName} processed successfully.');
      }

      // Show success message after all images are uploaded
      TLoaders.successSnackBar(
          title: 'Success',
          message: 'All images have been uploaded successfully.');
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      print('FirebaseException: ${e.message}');
      print('Firebase Error Code: ${e.code}');
      TLoaders.warningSnackBar(
          title: 'Firebase Error',
          message: e.message ?? 'An error occurred while uploading images.');
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      print('PlatformException: ${e.message}');
      TLoaders.warningSnackBar(
          title: 'Platform Error',
          message: e.message ?? 'An error occurred while uploading images.');
    } catch (e, stackTrace) {
      // Handle any other errors
      print('Unexpected Error: $e');
      print('Stack Trace: $stackTrace');
      TLoaders.warningSnackBar(
          title: 'Unexpected Error',
          message: 'An unexpected error occurred while uploading images.');
    } finally {
      // Ensure the loader is stopped
      TFullScreenLoader.stopLoading();
    }
  }

  void UploadImagesLoader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Uploading Images'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(TImages.uploadingImageIllustration,
                  height: 300, width: 300),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Sit tight, Your images are uploading ...'),
            ],
          ),
        ),
      ),
    );
  }

  String getSelectedPath() {
    String path = '';
    switch (selectedPath.value) {
      case MediaCategory.banners:
        path = TTexts.bannersStoragePath;
        break;
      case MediaCategory.brands:
        path = TTexts.brandsStoragePath;
        break;
      case MediaCategory.categories:
        path = TTexts.categoriesStoragePath;
        break;
      case MediaCategory.products:
        path = TTexts.productsStoragePath;
        break;
      case MediaCategory.users:
        path = TTexts.usersStoragePath;
        break;
      default:
        path = 'Others';
    }
    return path;
  }
   void removeCloudImageConfirmation(ImageModel image){
    TDialogs.defaultDialog(context: Get.context!,
    content: 'Are you want to delete this image',
      onConfirm: (){
      Get.back();

      removeCloudImage(image);
      },
    );
   }

  void removeCloudImage(ImageModel image) async{
    try {
      Get.back();
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(canPop: false,child: SizedBox(width: 150,height: 150,child: TCircularLoader())),
      );

        // Delete the file from storage
        await mediaRepostory.deleteFiledFromStorage(image);

        // Initialize targetList
        RxList<ImageModel> targetList;

        // Assign the correct list based on selectedPath.value
        switch (selectedPath.value) {
          case MediaCategory.banners:
            targetList = allBannerImages;
            break;
          case MediaCategory.brands:
            targetList = allBrandImages;
            break;
          case MediaCategory.categories:
            targetList = allCategoryImages;
            break;
          case MediaCategory.products:
            targetList = allProductImages;
            break;
          case MediaCategory.users:
            targetList = allUserImages;
            break;
          default:
            return; // Exit if no matching case is found
        }

        // Remove the image from the targetList
        targetList.remove(image);

        // Update the UI (if using GetX)
        update();


      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Image Delete',
          message: 'image successfully delete from your cloud storage');

    }
    catch (e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'oh stop', message: e.toString());
    }
  }
  Future<List<ImageModel>?> selectImagesFromMedia({List<String>? selectedUrls,bool allowSelection=true ,bool multipleSelection=false}) async{
    showImagesUploaderSection.value=true;

    List<ImageModel>? selectedImages=await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: TColors.primaryBackground,
      FractionallySizedBox(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const MediaUploader(),
              MediaContent(allowSelection: allowSelection,alreadySelectedUrls:selectedUrls ?? [], allowMultipleSelection: multipleSelection),
            ],
          ),),
        ),
      ),

    );

     return selectedImages;
  }
}