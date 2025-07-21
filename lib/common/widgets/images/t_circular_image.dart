import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../shimmers/shimmer.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.memoryImage,
    this.backgroundColor,
    this.image,
    this.imageType = ImageType.asset,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.file,
    this.margin,
    this.border,
    this.shadow = false,
    this.elevation = 0,
  });

  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Uint8List? memoryImage;
  final double width, height, padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final bool shadow;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(width),
        border: border,
        boxShadow: shadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: _buildImageWidget(),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    try {
      switch (imageType) {
        case ImageType.network:
          if (image != null && image!.isNotEmpty) {
            return _buildNetworkImage();
          }
          break;
        case ImageType.memory:
          if (memoryImage != null && memoryImage!.isNotEmpty) {
            return _buildMemoryImage();
          }
          break;
        case ImageType.file:
          if (file != null) {
            return _buildFileImage();
          }
          break;
        case ImageType.asset:
          if (image != null && image!.isNotEmpty) {
            return _buildAssetImage();
          }
          break;
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
    }
    return _buildPlaceholder();
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      fit: fit ?? BoxFit.contain,
      color: overlayColor,
      imageUrl: image!,
      width: width - (padding * 2),
      height: height - (padding * 2),
      errorWidget: (context, url, error) {
        debugPrint('Error loading network image: $error');
        return _buildPlaceholder();
      },
      progressIndicatorBuilder: (context, url, downloadProgress) =>
      const TShimmerEffect(width: 55, height: 55),
    );
  }

  Widget _buildMemoryImage() {
    return Image(
      fit: fit ?? BoxFit.cover,
      image: MemoryImage(memoryImage!),
      color: overlayColor,
      width: width - (padding * 2),
      height: height - (padding * 2),
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading memory image: $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildFileImage() {
    return Image.file(
      file!,
      fit: fit ?? BoxFit.cover,
      color: overlayColor,
      width: width - (padding * 2),
      height: height - (padding * 2),
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading file image: $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      image!,
      fit: fit ?? BoxFit.contain,
      color: overlayColor,
      width: width - (padding * 2),
      height: height - (padding * 2),
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading asset image: $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: TColors.grey.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.image,
          size: width * 0.4,
          color: TColors.dark.withOpacity(0.3),
        ),
      ),
    );
  }
}