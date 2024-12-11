import 'dart:convert';

import 'package:dacn_nhom3_customer/global_varibles.dart';
import 'package:dacn_nhom3_customer/models/product_review.dart';
import 'package:dacn_nhom3_customer/services/manager_http_response.dart';
import 'package:http/http.dart' as http;

class ProductReviewController {
  uploadReview({
    required String id,
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context
  }) async{
    try {
      final ProductReview productReview = ProductReview(
          id: '',
          buyerId: buyerId,
          email: email,
          fullName: fullName,
          productId: productId,
          rating: rating,
          review: review
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/product-review"),
        body: productReview.toJson(),
        headers: <String,String> {
          "Content-Type": 'application/json; charset=UTF-8'
        }
      );
      managerHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, "Bạn đã đăng review thành công");
      });
    }
    catch(e) {
      throw Exception("Lỗi kết nối");
    }
  }
  Future<List<ProductReview>> getProductReviewByProductId({required String productId}) async{
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/reviews/$productId"),
        headers: <String,String> {
          "Content-Type": 'application/json; charset=UTF-8'
        }
      );
      print(response.body);
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<ProductReview> reviews = data.map((review) => ProductReview.fromMap(review as Map<String, dynamic>)).toList();
        return reviews;
      }
      else {
        throw Exception("Fail to load Popular Product");
      }
    }
    catch(e) {
      print("Error: $e");
      throw Exception("Lỗi kết nối: $e");
    }
  }
}