import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../features/shop/models/order_model.dart';

class OrderRepository extends GetxController {
  // Singleton instance of the OrderRepository
  static OrderRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetches all orders for a specific user from the main Orders collection
  Future<List<OrderModel>> getAllOrdersForUser(String userId) async {
    try {
      final querySnapshot = await _db
          .collection("Orders")
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch user orders: ${e.toString()}';
    }
  }

  /// Fetches all orders from the main Orders collection
  Future<List<OrderModel>> getAllOrders() async {
    try {
      debugPrint('Starting to fetch all orders...');

      final ordersSnapshot = await _db.collection('Orders')
          .orderBy('orderDate', descending: true)
          .limit(1000) // Set a reasonable limit
          .get();

      debugPrint('Found ${ordersSnapshot.docs.length} orders total');

      List<OrderModel> allOrders = [];

      for (var orderDoc in ordersSnapshot.docs) {
        try {
          final order = OrderModel.fromSnapshot(orderDoc);
          allOrders.add(order);
        } catch (e) {
          debugPrint('Error parsing order ${orderDoc.id}: $e');
        }
      }

      debugPrint('Successfully parsed ${allOrders.length} orders');
      return allOrders;

    } on FirebaseException catch (e) {
      debugPrint('Firebase error in getAllOrders: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      debugPrint('Unexpected error in getAllOrders: $e');
      throw Exception("Failed to fetch orders: ${e.toString()}");
    }
  }

  /// Adds a new order to the main Orders collection
  Future<String> addOrder(OrderModel order) async {
    try {
      debugPrint('Adding new order to main Orders collection');
      final docRef = await _db.collection("Orders").add(order.toJson());
      debugPrint('Order added successfully with ID: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      debugPrint('Firebase error adding order: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      debugPrint('Format error adding order: $e');
      throw TFormatException();
    } on PlatformException catch (e) {
      debugPrint('Platform error adding order: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      debugPrint('Unexpected error adding order: $e');
      throw Exception("Failed to add order: ${e.toString()}");
    }
  }

  /// Deletes an order from the main Orders collection
  Future<void> deleteOrder(String orderId) async {
    try {
      debugPrint('Deleting order $orderId from main Orders collection');
      await _db.collection("Orders").doc(orderId).delete();
      debugPrint('Order deleted successfully');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error deleting order: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      debugPrint('Format error deleting order: $e');
      throw TFormatException();
    } on PlatformException catch (e) {
      debugPrint('Platform error deleting order: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      debugPrint('Unexpected error deleting order: $e');
      throw Exception("Failed to delete order: ${e.toString()}");
    }
  }

  /// Updates order status in the main Orders collection
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      debugPrint('Updating order $orderId to status: $status');

      if (orderId.isEmpty) throw Exception('Order ID cannot be empty');

      await _db.collection("Orders").doc(orderId).update({
        'status': 'OrderStatus.$status',
        'updatedAt': FieldValue.serverTimestamp()
      });

      debugPrint('Order status updated successfully');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error updating order status: ${e.code} - ${e.message}');
      throw 'Failed to update order status: ${e.message}';
    } catch (e) {
      debugPrint('Error updating order status: $e');
      throw 'Failed to update order status: ${e.toString()}';
    }
  }

  /// Updates specific fields of an order in the main Orders collection
  Future<void> updateOrderSpecificValue(String orderId, Map<String, dynamic> data) async {
    try {
      debugPrint('Updating order $orderId with data: $data');

      data['updatedAt'] = FieldValue.serverTimestamp();

      await _db.collection("Orders").doc(orderId).update(data);

      debugPrint('Order updated successfully');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error updating order: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      debugPrint('Format error updating order: $e');
      throw TFormatException();
    } on PlatformException catch (e) {
      debugPrint('Platform error updating order: ${e.code} - ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      debugPrint('Unexpected error updating order: $e');
      throw Exception("Failed to update order: ${e.toString()}");
    }
  }

  /// Fetches a single order by its ID
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      debugPrint('Fetching order with ID: $orderId');
      final docSnapshot = await _db.collection("Orders").doc(orderId).get();

      if (!docSnapshot.exists) {
        throw Exception('Order not found');
      }

      return OrderModel.fromSnapshot(docSnapshot);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error fetching order: ${e.code} - ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      debugPrint('Error fetching order: $e');
      throw Exception("Failed to fetch order: ${e.toString()}");
    }
  }
}