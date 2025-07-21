import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:ecommerce_admin_panel/features/shop/models/product_varition_model.dart';
import 'package:ecommerce_admin_panel/utils/formatters/formatter.dart';

class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  List<String> categoryIds;
  String productType;
  String? description;
  List<String>? images;
  int soldQuantity;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.soldQuantity = 0,
    this.sku,
    this.brand,
    this.description,
    this.date,
    this.images,
    this.salePrice = 0.0,
    this.isFeatured,
    this.categoryIds = const [],
    this.productAttributes,
    this.productVariations,
  });

  String get formattedDate => TFormatter.formatDate(date);

  static ProductModel empty() => ProductModel(
      id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '');

  toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalesPrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryIds,
      'Brand': brand!.toJson(),
      'Description': description,
      'ProductType': productType,
      'SoldQuantity': soldQuantity,
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : [],
    };
  }

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documant) {
    final data = documant.data()!;
    return ProductModel(
        id: documant.id,
        title: data['Title'],
        stock: data['Stock'],
        price: data['Price'] is double
            ? data['Price']
            : double.tryParse(data['Price']?.toString() ?? '0') ?? 0.0,
        thumbnail: data['Thumbnail'] ?? '',
        productType: data['ProductType'] ?? '',
        description: data['Description'] ?? '',
        sku: data['SKU'],
        soldQuantity:
            data.containsKey('SoldQuantity') ? data['SoldQuantity'] ?? 0 : 0,
        isFeatured: data['IsFeatured'] ?? false,
        salePrice: data['SalesPrice'] is double
            ? data['SalesPrice']
            : double.tryParse(data['SalesPrice']?.toString() ?? '0') ?? 0.0,
        categoryIds: data['CategoryId'] != null
            ? List<String>.from(data['CategoryId'])
            : [],
        brand: BrandModel.fromJson(data['Brand']),
        images: data['Images'] != null ? List<String>.from(data['Images']) : [],
        productAttributes: (data['ProductAttributes'] as List<dynamic>)
            .map((e) => ProductAttributeModel.fromJson(e))
            .toList(),
        productVariations: (data['ProductVariations'] as List<dynamic>?)
                ?.map((e) => ProductVariationModel.fromJson(e))
                .toList() ??
            []);
  }

  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object> documant) {
    final data = documant.data() as Map<String, dynamic>;
    return ProductModel(
        id: documant.id,
        title: data['Title'] ?? '',
        stock: data['Stock'] ?? 0,
        price: double.parse((data['Price'] ?? 0.0).toString()),
        thumbnail: data['Thumbnail'] ?? '',
        productType: data['ProductType'] ?? '',
        description: data['Description'] ?? '',
        sku: data['SKU'] ?? '',
        soldQuantity:
            data.containsKey('SoldQuantity') ? data['SoldQuantity'] ?? 0 : 0,
        isFeatured: data['IsFeatured'] ?? false,
        salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
        categoryIds: data['CategoryId'] ?? '',
        brand: BrandModel.fromJson(data['Brand']),
        images: data['Images'] != null ? List<String>.from(data['Images']) : [],
        productAttributes: (data['ProductAttributes'] as List<dynamic>)
            .map((e) => ProductAttributeModel.fromJson(e))
            .toList(),
        productVariations: (data['ProductVariations'] as List<dynamic>)
            .map((e) => ProductVariationModel.fromJson(e))
            .toList());
  }
}
