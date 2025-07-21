import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/styles/user_model.dart';
import '../../../features/authentication/models/address_model.dart';
import '../../../features/shop/models/order_model.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../authentication/authentication_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something  went wrong pls check $e';
    }
  }

  // In your UserRepository class

// In UserRepository
  // In UserRepository
// In UserRepository
  Future<List<UserModel>> getAllDeliveryBoys() async {
    try {
      final querySnapshot = await _db
          .collection('Users')
          .where('Role', isEqualTo: AppRole.delivery.name.toString())
          .get();
      return querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } catch (e) {
      return []; // Return empty list on error
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _db.collection('Users').get();
      return querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw 'Failed to fetch users: $e';
    }
  }

  Future<void> updateDeliveryBoy(UserModel deliveryBoy) async {
    try {
      await _db.collection('Users').doc(deliveryBoy.id).update(deliveryBoy.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to update delivery boy: ${e.toString()}';
    }
  }
// user_repository.dart
  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try {
      final querySnapshot = await _db
          .collection("Users")
          .doc(userId)
          .collection("Addresses")
          .get();

      return querySnapshot.docs
          .map((doc) => AddressModel.fromDocumentSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  Future<UserModel> fetchAdminDetails() async {
    try {
      final docSnapshot = await _db
          .collection('Users')
          .doc(AuthenthicationRepository.instance.autheUser!.uid)
          .get();
      return UserModel.fromSnapshot(docSnapshot);
    } catch (e) {
      debugPrint('Error fetching admin details: $e');
      return UserModel.empty();
    }
  }

  Future<UserModel> fetchUserDetails(String id) async {
    try {
      final documentSnapshot = await _db.collection('Users').doc(id).get(); // Changed 'user' to 'Users'
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again! Error: $e';
    }
  }
  Future<List<OrderModel>> fetchUserOrders(String userId) async {
    try {
      final querySnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders') // Note: Changed from 'Orders' to 'Orders'
          .orderBy('orderDate', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch orders: ${e.toString()}';
    }
  }
  Future<void> updateSingleField(Map<String,dynamic> json) async {
    try {
      await _db.collection('Users').doc(AuthenthicationRepository.instance.autheUser!.uid).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again! Error: $e';
    }
  }
  Future<void> deleteUser(String id) async {
    try {
      await _db.collection('Users').doc(id).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again! Error: $e';
    }
  }

  // Add this to UserRepository class
  Future<void> updateUserDetails(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again! Error: $e';
    }
  }
}