import 'dart:convert';

import 'package:dacn_nhom3_customer/global_varibles.dart';
import 'package:dacn_nhom3_customer/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> loadPopularProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/popular-product-limit"),
          headers: <String,String> {
          "Content-Type": 'application/json; charset=UTF-8'
        }
      );
      print(response.body);
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      }
      else {
        throw Exception("Fail to load Popular Product");
      }
    }
    catch(e) {
      throw Exception("Error loading product: $e");
    }
  }

  Future<List<Product>> getAllProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/product/get-all"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      }
      else {
        throw Exception("Fail to load All Product");
      }
    }
    catch(e) {
      throw Exception("Error loading product: $e");
    }
  }

  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/products-by-category/$category"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      }
      else if(response.statusCode == 404) {
        print("Danh mục này chưa có sản phẩm.");
        return [];
      }
      else {
        throw Exception("Fail to load Popular Product");
      }
    }
    catch(e) {
      throw Exception("Error loading product: $e");
    }
  }

  Future<List<Product>> loadProductBySubCategory(String subCategory) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/products-by-subcategory/$subCategory"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      // print("Res.body productcontroller getProductBySub: ${response.body}");
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      }
      else if(response.statusCode == 404) {
        print("Danh mục này chưa có sản phẩm.");
        return [];
      }
      else {
        throw Exception("API Error - Status: ${response.statusCode}, Body: ${response.body}");;
      }
    }
    catch(e) {
      throw Exception("Error loading product: $e");
    }
  }

  // Future<Product> getProductById({required String id}) async {
  //   try {
  //     http.Response response = await http.get(
  //         Uri.parse("$uri/api/product/$id"),
  //         headers: <String,String> {
  //           "Content-Type": 'application/json; charset=UTF-8'
  //         }
  //     );
  //     if(response.statusCode == 200) {
  //       final Product product = jsonDecode(response.body);
  //       return product;
  //     }
  //     else {
  //       throw Exception("Fail to load Popular Product");
  //     }
  //   }
  //   catch(e) {
  //     throw Exception("Error loading product: $e");
  //   }
  // }
  Future<List<Product>> searchProduct(String query) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/search-products?query=$query"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> searchProducts = data.map((product) => Product.fromMap(product as Map<String, dynamic>)).toList();
        return searchProducts;
      }
      else if(response.statusCode == 404) {
        print("Không tìm thấy sản phẩm");
        return [];
      }
      else {
        throw Exception("Fail to load product by search");
      }
    }
    catch(e) {
      throw Exception("Error loading product: $e");
    }
  }
  Future<List<Product>> loadRelatedProductBySubcategory(String productId) async{
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/related-products-by-subcategory/$productId"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> relatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return relatedProducts;
      }
      else if(response.statusCode == 404) {
        print("Không tìm thấy sản phẩm");
        return [];
      }
      else {
        throw Exception("Fail to load related product");
      }
    }
    catch(e) {
      throw Exception("Error loading related product: $e");
    }
  }
  Future<List<Product>> topRatedProduct() async{
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/top-rated-products"),
          headers: <String, String>{
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        List<Product> topRatedProducts = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return topRatedProducts;
      }
      else {
        throw Exception("Fail to load related product");
      }
    }
    catch(e) {
      throw Exception("Error loading related product: $e");
    }
  }
}