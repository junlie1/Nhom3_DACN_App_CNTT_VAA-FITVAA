import 'dart:convert';

import 'package:dacn_nhom3_customer/global_varibles.dart';
import 'package:dacn_nhom3_customer/models/user.dart';
import 'package:dacn_nhom3_customer/provider/user_provider.dart';
import 'package:dacn_nhom3_customer/services/manager_http_response.dart';
import 'package:dacn_nhom3_customer/views/screens/authenication_screen/login_screen.dart';
import 'package:dacn_nhom3_customer/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


final providerContainer = ProviderContainer();
class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String fullName,
    required String password
})async {
    try {
      User user = User(
          id: '',
          fullName: fullName,
          email: email,
          city: '',
          locality: '',
          phoneNumber: '',
          password: password,
          token: ''
      );
      http.Response response = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String> {
        "Content-Type" : 'application/json; charset=UTF-8',
          }
      );
      managerHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            showSnackBar(context, "Bạn đã tạo mới tài khoản thành công");
          }
      );
    }
    catch(e) {

    }
  }

  //SignIn Users
  Future<void> signInUsers({
    required context,
    required email,
    required password
})async{
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email':email,
          'password': password
        }),
        headers: <String, String> {
          "Content-Type" : 'application/json; charset=UTF-8',
        }
        );

      managerHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
 /*Lưu trữ thông tin user bằng SharedPreferences*/
          //Khởi tạo SharedPreferences
          SharedPreferences preferences = await SharedPreferences.getInstance();
          
          //Giải mã token từ body để sử dụng trong app
          String token = jsonDecode(response.body)['token'];
          await preferences.setString('auth_token', token);

          // Mã hóa user data nhận được từ backend trả về không lấy password trong auth.js
          final userJson = jsonEncode(jsonDecode(response.body)['user']);
          providerContainer.read(userProvider.notifier).setUser(userJson);

          //Lưu trữ dữ liệu user cho sau này sử dụng
          await preferences.setString('user', userJson);

      /* Navigator.pushAndRemoveUntil(context, newRoute, predicate)
      Là đẩy sang trang mới và xóa dữ liệu trang cũ
      predicate là một hàm bool Function(Route) trả về giá trị true hoặc false */
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()), (route)=> false
        );
          showSnackBar(context, "Bạn đã đăng nhập thành công");
      });
    }
    catch(e) {
      print("Error: $e");
    }
  }

  //SignOut User
  Future<void> signOutUser({required context, required WidgetRef ref}) async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('auth_token');
      await preferences.remove('user');
      //Xóa thông tin user trong userProvider
      providerContainer.read(userProvider.notifier).signOut();

      //Đẩy về trang Login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }),
          (route) => false
      );
      showSnackBar(context, "Bạn đã đăng xuất thành công" );
    }
    catch(e) {
      showSnackBar(context, "Đăng xuất thất bại" );
    }
  }

  //Update location
  Future<void> updateUserLocation({required context, required userId, required city, required locality, required phoneNumber,
}) async {
    try{
      http.Response response = await http.put(
        Uri.parse("$uri/api/users/$userId"),
        body: jsonEncode({
          'city': city,
          'locality': locality,
          'phoneNumber': phoneNumber,
        }),
        headers: <String, String> {
          "Content-Type" : 'application/json; charset=UTF-8',
        }
      );
      managerHttpResponse(
        response: response,
        context: context,
        onSuccess: ()async {
          final updatedUser = jsonDecode(response.body);
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final userJson = jsonEncode(updatedUser);

          providerContainer.read(userProvider.notifier).setUser(userJson);

          preferences.setString('user', userJson);
        }
      );
    }
    catch(e) {
      showSnackBar(context, "Lỗi update user localtion");
    }
  }
}