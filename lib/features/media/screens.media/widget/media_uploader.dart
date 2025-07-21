import 'dart:typed_data';

import 'package:ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_admin_panel/features/media/controllers/media_controller.dart';
import 'package:ecommerce_admin_panel/features/media/screens.media/widget/folder_dropdown.dart';
import 'package:ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:ecommerce_admin_panel/utils/constants/sizes.dart';
import 'package:ecommerce_admin_panel/utils/device/device_utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import '../../../../utils/constants/image_strings.dart';
import '../../models/image_model.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
          () => controller.showImagesUploaderSection.value
          ? Column(
        children: [
          TRoundedContainer(
            height: 250,
            showBorder: true,
            borderColor: TColors.borderPrimary,
            backgroundColor: TColors.borderPrimary,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      DropzoneView(
                        mime: const ['image/jpeg', 'image/png'],
                        cursor: CursorType.Default,
                        operation: DragOperation.copy,
                        onLoaded: () => print('Zone loaded'),
                        onError: (ev) => print('Zone error : $ev'),
                        onHover: () => print('Zone Hovered'),
                        onLeave: () => print('Zone left'),
                        onCreated: (ctrl) => controller.dropzoneController = ctrl,
                        onDropInvalid: (ev) => print('Zone Invalid MIME: $ev'),
                        onDropMultiple: (ev) {
                          print('zone drop multiple : $ev');
                        },
                        onDrop: (file) async {
                          if (kIsWeb) {
                            if (file is html.File) {
                              final reader = html.FileReader();
                              reader.readAsArrayBuffer(file);
                              await reader.onLoad.first; // Wait for the file to be read

                              final bytes = reader.result as List<int>; // Get the file bytes
                              final image = ImageModel(
                                url: '',
                                file: file,
                                folder: '',
                                fileName: file.name,
                                localImageToDisplay: Uint8List.fromList(bytes),
                              );
                              controller.selectedImagesToUpload.add(image);
                            } else {
                              print('Zone Unknown Type: ${file.runtimeType}');
                            }
                          } else {
                            if (file is Uint8List) {
                              final image = ImageModel(
                                url: '',
                                file: null, // No html.File for mobile/desktop
                                folder: '',
                                fileName: 'image_${DateTime.now().millisecondsSinceEpoch}.png',
                                localImageToDisplay: file,
                              );
                              controller.selectedImagesToUpload.add(image);
                            } else {
                              print('Zone Unknown Type: ${file.runtimeType}');
                            }
                          }
                        },
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(TImages.defaultMultiImageIcon, width: 50, height: 50),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          const Text('Drag and drop Images here'),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          OutlinedButton(
                            onPressed: () => controller.selectLocalImages(),
                            child: const Text('Select Images'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          if (controller.selectedImagesToUpload.isNotEmpty)
            TRoundedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Select Folder', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          MediaFolderDropdown(
                            onChanged: (MediaCategory? newValue) {
                              if (newValue != null) {
                                controller.selectedPath.value = newValue;
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => controller.selectedImagesToUpload.clear(),
                            child: Text('Remove All'),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          TDeviceUtils.isMobileScreen(context)
                              ? const SizedBox.shrink()
                              : SizedBox(
                            width: TSizes.buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => controller.uploadImagesConfirmation(),
                              child: Text('Upload'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: TSizes.spaceBtwItems / 2,
                    runSpacing: TSizes.spaceBtwItems / 2,
                    children: controller.selectedImagesToUpload
                        .where((image) => image.localImageToDisplay != null)
                        .map(
                          (element) => TRoundedImage(
                        width: 90,
                        height: 90,
                        padding: TSizes.sm,
                        imageType: ImageType.memory,
                        memoryImage: element.localImageToDisplay,
                        backgroundColor: TColors.primaryBackground,
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TDeviceUtils.isMobileScreen(context)
                      ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.uploadImagesConfirmation(),
                      child: const Text('Upload'),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
        ],
      )
          : SizedBox.shrink(),
    );
  }
}