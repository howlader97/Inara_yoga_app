class ProductDetailsModel {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String material;
  final String dimensions;
  final double price;
  final double totalPrice;
  final int quantity;
  final int stockQuantity;
  final List<String> images;
  final String thumbnail;
  final double weight;
  final String color;
  final String size;
  final double? discountPrice;
  final String sku;
  final List<String> tags;
  final String? categoryId;
  final String slug;
  final String status;
  final bool isFeatured;
  final int viewCount;
  final int salesCount;
  final double averageRating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.material,
    required this.dimensions,
    required this.price,
    required this.stockQuantity,
    required this.images,
    required this.thumbnail,
    required this.weight,
    required this.color,
    required this.size,
    this.discountPrice,
    required this.sku,
    required this.tags,
    this.categoryId,
    required this.slug,
    required this.status,
    required this.isFeatured,
    required this.viewCount,
    required this.salesCount,
    required this.averageRating,
    required this.totalReviews,
    required this.createdAt,
    required this.updatedAt,
    required this.totalPrice,
    required this.quantity,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: "${json['id'] ?? ''}",
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      material: json['material'] ?? '',
      dimensions: json['dimensions'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: 1,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      images: json['images'] is List
          ? (json['images'] as List).map((e) => e.toString()).toList()
          : [],
      thumbnail: json['thumbnail'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] ?? '',
      size: json['size'] ?? '',
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      sku: json['sku'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      categoryId: json['categoryId'],
      slug: json['slug'] ?? '',
      status: json['status'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      salesCount: (json['salesCount'] as num?)?.toInt() ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  ProductDetailsModel copyWith({
    String? id,
    String? name,
    String? description,
    String? shortDescription,
    String? material,
    String? dimensions,
    double? price,
    double? totalPrice,
    int? quantity,
    int? stockQuantity,
    List<String>? images,
    String? thumbnail,
    double? weight,
    String? color,
    String? size,
    double? discountPrice,
    String? sku,
    List<String>? tags,
    String? categoryId,
    String? slug,
    String? status,
    bool? isFeatured,
    int? viewCount,
    int? salesCount,
    double? averageRating,
    int? totalReviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      price: price ?? this.price,
      totalPrice: totalPrice ?? this.totalPrice,
      quantity: quantity ?? this.quantity,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      size: size ?? this.size,
      discountPrice: discountPrice ?? this.discountPrice,
      sku: sku ?? this.sku,
      tags: tags ?? this.tags,
      categoryId: categoryId ?? this.categoryId,
      slug: slug ?? this.slug,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
      salesCount: salesCount ?? this.salesCount,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "shortDescription": shortDescription,
      "material": material,
      "dimensions": dimensions,
      "price": price,
      "totalPrice": price,
      "quantity": quantity,
      "stockQuantity": stockQuantity,
      "images": images,
      "thumbnail": thumbnail,
      "weight": weight,
      "color": color,
      "size": size,
      "discountPrice": discountPrice,
      "sku": sku,
      "tags": tags,
      "categoryId": categoryId,
      "slug": slug,
      "status": status,
      "isFeatured": isFeatured,
      "viewCount": viewCount,
      "salesCount": salesCount,
      "averageRating": averageRating,
      "totalReviews": totalReviews,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
