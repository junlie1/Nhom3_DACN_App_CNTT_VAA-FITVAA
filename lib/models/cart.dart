import 'dart:convert';

class Cart {
  final String userId;
  final String productName;
  final int productPrice;
  final String category;
  final List<String> image;
  final String vendorId;
  int quantity;
  int productQuantity;
  final String productId;
  final String description;
  final String fullName;

  Cart({
    required this.userId,
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.image,
    required this.vendorId,
    required this.quantity,
    required this.productQuantity,
    required this.productId,
    required this.description,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'image': image,
      'vendorId': vendorId,
      'quantity': quantity,
      'productQuantity': productQuantity,
      'productId': productId,
      'vendorId': vendorId,
      'description': description,
      'fullName': fullName,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Cart.fromJson(Map<String, dynamic> map) {
    return Cart(
      userId: map['userId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productPrice: map['productPrice'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      image: List<String>.from(map['image'] as List? ?? []),
      vendorId: map['vendorId'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 1,
      productQuantity: map['productQuantity'] as int? ?? 1,
      productId: map['productId'] as String? ?? '',
      description: map['description'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
    );
  }
}
