import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:ecommerce_admin_panel/common/widgets/loaders/loader_animation.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widget/view_image_details.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/image_strings.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/enums.dart';
import 'folder_dropdown.dart';
import 'package:get/get.dart';

class MediaContent extends StatelessWidget {
   MediaContent({super.key, required this.allowSelection, required this.allowMultipleSelection, this.alreadySelectedUrls, this.onImagesSelected});

  final bool allowSelection;
  final bool allowMultipleSelection;
  final List<String>? alreadySelectedUrls;
  final List<ImageModel> selectedImages=[];
  final Function(List<ImageModel> selectedImages)? onImagesSelected;
  @override
  Widget build(BuildContext context) {
    bool LoadedPreviousSelection=false;
    final controller = MediaController.instance;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(

                children: [
                  // folder dropdown
                  Text(
                    'Select Folder',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  MediaFolderDropdown(
                    onChanged: (MediaCategory? newValue) {
                      if (newValue != null) {
                        print("Selected Folder: ${newValue.name}");
                        controller.selectedPath.value = newValue;
                        controller.getMediaImages();
                      }
                    },
                  )
                ],
              ),
              if (allowSelection) buildAddSelectedImagesButton(),
            ],
          ),
          SizedBox(
            height: TSizes.spaceBtwSections,
          ),


          Obx(() {
            List<ImageModel> images = _getSelectedFolderImages(controller);
            List<ImageModel> image =_getSelectedFolderImages(controller);
              if(!LoadedPreviousSelection) {
                if (alreadySelectedUrls != null &&
                    alreadySelectedUrls!.isNotEmpty) {
                  final selectedUrlsSet = Set<String>.from(
                      alreadySelectedUrls!);
                  for (var image in images) {
                    image.isSelected.value =
                        selectedUrlsSet.contains(image.url);
                    if (image.isSelected.value) {
                      selectedImages.add(image);
                    }
                  }
                } else {
                  for (var image in images) {
                    image.isSelected.value = false;
                  }
                }
                print("Images in selected folder: ${images
                    .length}"); // Debug print
                LoadedPreviousSelection = true;
              }
            if (controller.loading.value && images.isEmpty) {
              return TLoaderAnimation();
            }

            if (images.isEmpty) {
              return _buildEmptyAnimationWidget(context);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: TSizes.spaceBtwItems / 2,
                  runSpacing: TSizes.spaceBtwItems / 2,
                  children: images.map((image) {
                    print("Rendering image: ${image.fileName}"); // Debug print
                    return GestureDetector(
                      onTap: () => Get.dialog(ImagePopup(image: image)),
                      child: SizedBox(
                        width: 140,
                        height: 180,
                        child: Column(
                          children: [
                            allowSelection ? _buildListWithCheckbox(image): _buildSimpleList(image),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: TSizes.sm),
                                child: Text(
                                  image.fileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (!controller.loading.value)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: TSizes.buttonWidth,
                          child: ElevatedButton.icon(
                            onPressed: () => controller.loadMoreMediaImages(),
                            label: const Text('Load More'),
                            icon: const Icon(Iconsax.arrow_down),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          })
        ],
      ),
    );
  }

  List<ImageModel> _getSelectedFolderImages(MediaController controller) {
    List<ImageModel> images = [];
    if (controller.selectedPath.value == MediaCategory.banners) {
      images = controller.allBannerImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.brands) {
      images = controller.allBrandImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.categories) {
      images = controller.allCategoryImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.products) {
      images = controller.allProductImages.where((image) => image.url.isNotEmpty).toList();
    } else if (controller.selectedPath.value == MediaCategory.users) {
      images = controller.allUserImages.where((image) => image.url.isNotEmpty).toList();
    }
    print("Selected folder images: ${images.length}"); // Debug print
    return images;
  }

  Widget _buildEmptyAnimationWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TSizes.lg * 3),
      child: TAnimationLoaderWidget(
        width: 300,
        height: 300,
        text: 'Select  your Desire Folder',
        animation: TImages.packageAnimation,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildSimpleList(ImageModel image) {
    return TRoundedImage(
      image: image.url, // Pass the image URL here
      imageType: ImageType.network, // Ensure this is set to network
      margin: TSizes.spaceBtwItems / 2,
      backgroundColor: TColors.primaryBackground,
      width: 140,
      height: 140,
      fit: BoxFit.cover, // Ensure the image fits the container
    );
  }
   Widget _buildListWithCheckbox(ImageModel image)
   {
     return Stack(
       children: [
         TRoundedImage(width: 140,
         height: 140,
           image: image.url,
         padding: TSizes.sm,
           imageType: ImageType.network,
           margin: TSizes.spaceBtwItems / 2,
           backgroundColor: TColors.primaryBackground,
         ),
         Positioned(top: TSizes.md,right: TSizes.md,
         child: Obx(()=>Checkbox(value: image.isSelected.value, onChanged: (selected){
           if (selected !=null) {
             image.isSelected.value=selected;

             if (selected) {
               if(!allowMultipleSelection){
                 for (var otherImage in selectedImages){
                   if (otherImage !=image) {
                     otherImage.isSelected.value=false;
                   }
                 }
                 selectedImages.clear();
               }
               selectedImages.add(image);
             }  else{
               selectedImages.remove(image);
             }
           }
         },
         ),
         ),
         ),
       ],
     );
   }
  buildAddSelectedImagesButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: OutlinedButton.icon(label: const Text('close'), icon: const Icon(Iconsax.close_circle),onPressed: ()=>Get.back()),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        SizedBox(
          width: 120,
          child: ElevatedButton.icon(label:const Text('add'),icon: const Icon(Iconsax.image),
          onPressed: ()=>Get.back(result: selectedImages)),
        ),
      ],
    );
  }
}
