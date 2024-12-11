import 'dart:convert';

class ProductReview {
  final String? id; // Cho phép null
  final String? buyerId;
  final String? email;
  final String? fullName;
  final String? productId;
  final double rating; // Giữ nguyên vì có thể không null
  final String review;

  ProductReview({
    required this.id,
    required this.buyerId,
    required this.email,
    required this.fullName,
    required this.productId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id ?? '', // Cung cấp giá trị mặc định nếu null
      'buyerId': buyerId ?? '',
      'email': email ?? '',
      'fullName': fullName ?? '',
      'productId': productId ?? '',
      'rating': rating,
      'review': review ?? '',
    };
  }

  factory ProductReview.fromMap(Map<String, dynamic> map) {
    return ProductReview(
      id: map['id'] as String?, // Chấp nhận null
      buyerId: map['buyerId'] as String?,
      email: map['email'] as String?,
      fullName: map['fullName'] as String?,
      productId: map['productId'] as String?,
      rating: map['rating'] is String
          ? double.tryParse(map['rating']) ?? 0.0 // Chuyển từ String sang double
          : (map['rating'] as num?)?.toDouble() ?? 0.0,// Chuyển đổi từ num và cung cấp giá trị mặc định nếu null
      review: map['review'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ProductReview.fromJson(String source) =>
      ProductReview.fromMap(json.decode(source) as Map<String, dynamic>);
}
