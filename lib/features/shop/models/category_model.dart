import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/utils/formatters/formatter.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.parentId = '',
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  static CategoryModel empty() => CategoryModel(id: '', name: '', image: '',isFeatured: false);
  toJson() {
    return {
      'Name': name,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  //Map json

  factory CategoryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documant) {
    if (documant.data() != null) {
      final data = documant.data()!;

      return CategoryModel(
          id: documant.id,
          name: data['Name'] ?? '',
          image: data['Image'] ?? '',
          parentId: data['ParentId'] ?? '',
          isFeatured: data['IsFeatured'] ?? false,
          createdAt: data.containsKey('CreatedAt')
              ? data['CreatedAt']?.toDate()
              : null,
          updatedAt: data.containsKey('UpdatedAt')
              ? data['UpdatedAt']?.toDate()
              : null);
    } else {
      return CategoryModel.empty();
    }
  }
}
