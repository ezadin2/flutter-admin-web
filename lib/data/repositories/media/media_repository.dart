import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/features/media/models/image_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../utils/constants/enums.dart';

class MediaRepostory extends GetxController {
  static MediaRepostory get instance => Get.find();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<ImageModel> uploadImageFieldInStorage({
    required dynamic file, // Can be Uint8List or html.File
    required String path,
    required String imageName,
  }) async {
    try {
      final Reference ref = _storage.ref('$path/$imageName');

      if (kIsWeb) {
        // Web: Use putBlob for html.File
        print('Uploading file to web...');
        await ref.putBlob(file as html.File);
      } else {
        // Mobile/Desktop: Use putData for Uint8List
        print('Uploading file to mobile/desktop...');
        await ref.putData(file as Uint8List);
      }

      final String downloadUrl = await ref.getDownloadURL();
      final FullMetadata metadata = await ref.getMetadata();

      return ImageModel.fromFirebaseMetadata(
          metadata, path, imageName, downloadUrl);
    } on FirebaseException catch (e) {
      print('FirebaseException in uploadImageFieldInStorage: ${e.message}');
      throw e.message!;
    } on PlatformException catch (e) {
      print('PlatformException in uploadImageFieldInStorage: ${e.message}');
      throw e.message!;
    } catch (e) {
      print('Unexpected Error in uploadImageFieldInStorage: $e');
      throw e.toString();
    }
  }

  Future<String> uploadImageFieldInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection("Images")
          .add(image.toJson());
      return data.id;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  //Fetch images from Firestore based on media category and load data
  Future<List<ImageModel>> fetchImagesFromDatabase(
      MediaCategory mediaCategory, int loadCount) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Images')
          .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('createdAt', descending: true)
          .limit(loadCount)
          .get();
      print(
          "Query executed for ${mediaCategory.name}, found ${querySnapshot.docs.length} documents"); // Debug print
      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      print(
          "FirebaseException in fetchImagesFromDatabase: ${e.message}"); // Debug print
      throw e.message!;
    } on PlatformException catch (e) {
      print(
          "PlatformException in fetchImagesFromDatabase: ${e.message}"); // Debug print
      throw e.message!;
    } catch (e) {
      print("Unexpected Error in fetchImagesFromDatabase: $e"); // Debug print
      throw e.toString();
    }
  }

  Future<List<ImageModel>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedDate,
    String lastFetchedId, // Add lastFetchedId to ensure uniqueness
  ) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Images')
          .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
          .orderBy('createdAt', descending: true)
          .orderBy('id',
              descending: true) // Add secondary orderBy for uniqueness
          .startAfter(
              [lastFetchedDate, lastFetchedId]) // Use both createdAt and id
          .limit(loadCount)
          .get();

      print("Loaded ${querySnapshot.docs.length} more images"); // Debug print
      return querySnapshot.docs.map((e) => ImageModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      print("FirebaseException in loadMoreImagesFromDatabase: ${e.message}");
      throw e.message!;
    } on PlatformException catch (e) {
      print("PlatformException in loadMoreImagesFromDatabase: ${e.message}");
      throw e.message!;
    } catch (e) {
      print("Unexpected Error in loadMoreImagesFromDatabase: $e");
      throw e.toString();
    }
  }

  Future<void> deleteFiledFromStorage(ImageModel image) async {
    try {
      await FirebaseStorage.instance.ref(image.fullPath).delete();
      await FirebaseFirestore.instance
          .collection('Images')
          .doc(image.id)
          .delete();
    } on FirebaseException catch (e) {
      throw e.message ?? 'something wnet wrong while deleteing image.';
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
// on html.SocketException catch (e) {
// throw e.message;
// }
