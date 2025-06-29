class Product {
  final int id;
  final int categoryId; // Changed to int to match API
  final String productName;
  final double productPrice; // Changed to double for formatting
  final String productDiscount;
  final int stock; // Changed to int for numerical stock
  final String productDescription;
  final String productImageUrl;
  final String additionalImage1Url;
  final String additionalImage2Url;
  final bool isActive;

  Product({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.stock,
    required this.productDescription,
    required this.productImageUrl,
    required this.additionalImage1Url,
    required this.additionalImage2Url,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('Product JSON: $json'); // Debug log
    return Product(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      categoryId: json['category_id'] is String ? int.parse(json['category_id']) : json['category_id'] as int,
      productName: json['product_name'] as String? ?? '',
      productPrice: json['product_price'] is String
          ? double.parse(json['product_price'])
          : (json['product_price'] as num).toDouble(),
      productDiscount: json['product_discount'] as String? ?? '',
      stock: json['stock'] is String ? int.parse(json['stock']) : json['stock'] as int,
      productDescription: json['product_description'] as String? ?? '',
      productImageUrl: json['product_image_url'] as String? ?? '',
      additionalImage1Url: json['additional_image_1_url'] as String? ?? '',
      additionalImage2Url: json['additional_image_2_url'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}