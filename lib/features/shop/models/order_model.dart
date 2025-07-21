import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../authentication/models/address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final double? shippingCost;
  final double? taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel>? items;
  final bool billingAddressSameAsShipping;
  final double latitude;
  final double longitude;
  final AddressModel? address;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    this.items,
    required this.totalAmount,
    this.shippingCost = 5.00,
    this.taxCost = 15.00,
    required this.orderDate,
    this.paymentMethod = 'CBE Birr',
    this.billingAddress,
    this.shippingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.address,
  });

  // Add this getter for better status display
  String get statusDisplayText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return status.toString().split('.').last.capitalizeFirst!;
    }
  }
  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  static OrderModel empty() {
    return OrderModel(
      id: '',
      userId: '',
      status: OrderStatus.processing,
      items: [],
      totalAmount: 0.0,
      orderDate: DateTime.now(),
      paymentMethod: 'CBE Birr',
      taxCost: 0,
      billingAddressSameAsShipping: true,
      deliveryDate: null,
      latitude: 0.0,
      longitude: 0.0,
      shippingCost: 5.00,
    );
  }

  String get formattedDeliveryDate =>
      deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText =>
      status == OrderStatus.delivered
          ? 'Delivered'
          : status == OrderStatus.shipped
          ? 'Shipment on the way'
          : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'billingAddress': billingAddress?.toJson(),
      'shippingAddress': shippingAddress?.toJson(),
      'deliveryDate': deliveryDate,
      "billingAddressSameAsShipping": billingAddressSameAsShipping,
      'items': items?.map((item) => item.toJson()).toList(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address?.toJson(),
    };
  }
  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>? ?? {};

      // Safely parse all fields with comprehensive null checks
      return OrderModel(
        id: data['id']?.toString() ?? '',
        docId: snapshot.id,
        userId: data['userId']?.toString() ?? '',
        status: _parseOrderStatus(data['status']),
        totalAmount: _parseDouble(data['totalAmount']),
        shippingCost: _parseDouble(data['shippingCost'], defaultValue: 5.0),
        taxCost: _parseDouble(data['taxCost'], defaultValue: 15.0),
        orderDate: _parseTimestamp(data['orderDate']),
        paymentMethod: data['paymentMethod']?.toString() ?? 'CBE Birr',
        address: _parseAddress(data['address']),
        shippingAddress: _parseAddress(data['shippingAddress']),
        billingAddress: _parseAddress(data['billingAddress']),
        deliveryDate: _parseTimestamp(data['deliveryDate']),
        billingAddressSameAsShipping: data['billingAddressSameAsShipping'] as bool? ?? true,
        items: _parseCartItems(data['items']),
        latitude: _parseDouble(data['latitude']),
        longitude: _parseDouble(data['longitude']),
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing order ${snapshot.id}: $e');
      debugPrint('Stack trace: $stackTrace');
      return OrderModel.empty(); // Return empty order instead of failing
    }
  }

// Helper methods for parsing
  static OrderStatus _parseOrderStatus(dynamic status) {
    try {
      if (status is String) {
        return OrderStatus.values.firstWhere(
              (e) => e.toString() == status,
          orElse: () => OrderStatus.processing,
        );
      }
    } catch (e) {
      debugPrint('Error parsing order status: $e');
    }
    return OrderStatus.processing;
  }

  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    return DateTime.now();
  }

  static AddressModel? _parseAddress(dynamic addressData) {
    try {
      if (addressData is Map<String, dynamic>) {
        return AddressModel.fromMap(addressData);
      }
    } catch (e) {
      debugPrint('Error parsing address: $e');
    }
    return null;
  }

  static List<CartItemModel> _parseCartItems(dynamic itemsData) {
    final List<CartItemModel> items = [];
    try {
      if (itemsData is List) {
        for (var itemData in itemsData) {
          try {
            if (itemData is Map<String, dynamic>) {
              items.add(CartItemModel.fromJson(itemData));
            }
          } catch (e) {
            debugPrint('Error parsing cart item: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error parsing items list: $e');
    }
    return items;
  }
}