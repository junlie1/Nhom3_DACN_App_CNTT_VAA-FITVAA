
import 'package:dacn_nhom3_customer/global_varibles.dart';
import 'package:dacn_nhom3_customer/models/cart.dart';
import 'package:dacn_nhom3_customer/services/manager_http_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartController {
  // Thêm sản phẩm vào giỏ hàng
  Future<void> addProductToCart({
    required String userId,
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String productId,
    required String vendorId,
    required context,
  }) async {
    try {
      final Cart cart = Cart(
        userId: userId,
        productName: productName,
        productPrice: productPrice,
        category: category,
        image: image,
        vendorId: vendorId,
        quantity: 1,
        productQuantity: 1,
        productId: productId,
        description: '',
        fullName: '',
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/add-cart"),
        body: cart.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        managerHttpResponse(response: response, context: context, onSuccess: () {
          showSnackBar(context, "Bạn đã thêm sản phẩm vào giỏ hàng thành công");
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng theo userId
  Future<Map<String, Cart>> fetchCartItems(String userId) async {
    try {
      final response = await http.get(
        Uri.parse("$uri/api/get-cart/$userId"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return {
          for (var item in data) item['productId']: Cart.fromJson(item)
        };
      } else {
        print("Failed to load cart items");
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  // Tăng số lượng sản phẩm
  Future<void> incrementCartItem(String userId, String productId) async {
    // Tăng số lượng trong cơ sở dữ liệu qua API
    await http.post(
      Uri.parse("$uri/api/increment-cart"),
      body: jsonEncode({'userId': userId, 'productId': productId}),
      headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8'
      },
    );
  }

  // Giảm số lượng sản phẩm
  Future<void> decrementCartItem(String userId, String productId) async {
    await http.post(
      Uri.parse("$uri/api/decrement-cart"),
      body: jsonEncode({'userId': userId, 'productId': productId}),
      headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8'
      },
    );
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeCartItem(String userId, String productId) async {
    await http.post(
      Uri.parse("$uri/api/remove-cart"),
      body: jsonEncode({'userId': userId, 'productId': productId}),
      headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8'
      },
    );
  }

  //Xóa sản phẩm khỏi giỏ hàng sau khi đặt hàng thành công
  Future<void> removeCartAfterOrder({
    required String userId,
    required context,
} ) async{
    try{
      http.Response response = await http.delete(
        Uri.parse("$uri/api/delete-cart/$userId"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      managerHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, "Bạn đã thêm sản phẩm vào giỏ hàng nên sẽ xóa sản phẩm khỏi cart");
      });
    }
    catch(e) {
      print("Lỗi cart_controller removeCartAfterOrder: $e");
    }
  }
}
