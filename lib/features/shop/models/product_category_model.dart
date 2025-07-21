import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  final String id;
  final String productId;
  final String categoryId;
  // Add any other fields you need

  ProductCategoryModel({
     this.id = '',
    required this.productId,
    required this.categoryId,
    // Initialize other fields here
  });

  // Convert model to JSON for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      // Add other fields to the map
    };
  }

  // Create model from Firestore document snapshot
  factory ProductCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductCategoryModel(
      id: snapshot.id,
      productId: data['productId'] ?? '',
      categoryId: data['categoryId'] ?? '',

    );
  }

  // Optionally, add empty or default constructor
  ProductCategoryModel.empty()
      : id = '',
        productId = '',
        categoryId = '';
}