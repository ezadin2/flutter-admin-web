import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/setting_model.dart';

class SettingsRepository extends GetxController {
  static SettingsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  /// Function to save setting data to Firestore.
  Future<void> registerSettings(SettingsModel setting) async {
    try {
      await _db.collection("Settings").doc('GLOBAL_SETTINGS').set(setting.toJson());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Firebase Auth error occurred';
    } on FormatException catch(_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Function to fetch settings
  Future<SettingsModel> getSettings() async {
    try {
      final querySnapshot = await _db.collection("Settings").doc('GLOBAL_SETTINGS').get();
      return SettingsModel.fromSnapshot(querySnapshot);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Firebase Auth error occurred';
    } on FormatException {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred';
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Function to update setting data in Firestore.
  Future<void> updateSettingDetails(SettingsModel updatedSetting) async {
    try {
      await _db.collection("Settings").doc('GLOBAL_SETTINGS').update(updatedSetting.toJson());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Firebase Auth error occurred';
    } on FormatException {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Update any field in specific Settings Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Settings").doc('GLOBAL_SETTINGS').update(json);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Firebase Auth error occurred';
    } on FormatException {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw e.message ?? 'Platform error occurred';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
