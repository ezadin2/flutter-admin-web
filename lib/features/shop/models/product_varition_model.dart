import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProductVariationModel {
  final String id;
  String sku;
  Rx<String> image;
  String? description;
  double price;
  double salePrice;
  int stock;
  int soldQuantity;
  Map<String, String> attributeValues;

  ProductVariationModel({
    required this.id,
    this.sku = '',
    String image = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.description = '',
    this.stock = 0,
    this.soldQuantity = 0,
    required this.attributeValues,
  }) : image = image.obs;

  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {});

  toJson() {
    return {
      'Id': id,
      'Image': image.value,
      'Description': description,
      'Price': price,
      'SalesPrice': salePrice,
      'SKU': sku,
      'Stock': stock,
      'SoldQuantity': soldQuantity,
      'AttributeValues': attributeValues,
    };
  }

  factory ProductVariationModel.fromJson(Map<String, dynamic> document) {
    final data = document;

    if (data.isEmpty) return ProductVariationModel.empty();

    return ProductVariationModel(
      id: data['Id'] ?? '',
      image: data['Image'] ?? '',
      price: data['Price'] is double
          ? data['Price']
          : double.tryParse(data['Price']?.toString() ?? '0') ?? 0.0,
      sku: data['SKU'] ?? '',
      description: data['Description'] ?? '',
      soldQuantity: data['SoldQuantity'] ?? 0,
      salePrice: data['SalesPrice'] is double
          ? data['SalesPrice']
          : double.tryParse(data['SalesPrice']?.toString() ?? '0') ?? 0.0,
      stock: data['Stock'] is int
          ? data['Stock']
          : int.tryParse(data['Stock']?.toString() ?? '0') ?? 0,
      attributeValues: Map<String, String>.from(data['AttributeValues'] ?? {}),
    );
  }
}