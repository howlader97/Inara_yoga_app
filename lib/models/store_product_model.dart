class StoreProductModel {
  final String id;
  final String name;
  final String thumbnail;
  final String shortDescription;
  final int stockQuantity;
  final double price;
  final double? discountPrice;
  final String status;

  StoreProductModel({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.shortDescription,
    required this.stockQuantity,
    required this.price,
    this.discountPrice,
    required this.status,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    return StoreProductModel(
      id: "${json['id'] ?? ''}",
      name: "${json['name'] ?? ''}",
      thumbnail: "${json['thumbnail'] ?? ''}",
      shortDescription: "${json['shortDescription'] ?? ''}",
      stockQuantity: int.tryParse("${json['stockQuantity'] ?? 0}") ?? 0,
      price: double.tryParse("${json['price'] ?? 0}") ?? 0,
      discountPrice: double.tryParse("$json['discountPrice']"),
      status: "${json['status'] ?? ''}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'shortDescription': shortDescription,
      'stockQuantity': stockQuantity,
      'price': price,
      'discountPrice': discountPrice,
      'status': status,
    };
  }
}
