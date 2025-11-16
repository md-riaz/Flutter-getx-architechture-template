import 'package:hive/hive.dart';

part 'product.g.dart';

/// Product model representing a product entity
@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final int stock;
  
  @HiveField(5)
  final String? imageUrl;
  
  @HiveField(6)
  final DateTime? lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.lastUpdated,
  });

  /// Create Product from JSON (for API responses)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] as String,
      description: json['body'] as String,
      price: (json['userId'] as num).toDouble() * 10, // Mock price based on userId
      stock: 100 - (json['id'] as num).toInt(), // Mock stock
      imageUrl: 'https://via.placeholder.com/150',
      lastUpdated: DateTime.now(),
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  /// Create a copy of Product with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    DateTime? lastUpdated,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
