import 'dart:convert';
import 'package:dacn_nhom3_customer/global_varibles.dart';
import 'package:dacn_nhom3_customer/models/banner.dart';
import 'package:http/http.dart' as http;

class BannerController {
  //Lấy Banners
  Future<List<BannerModel>> loadBanners() async {
    try {
        http.Response response = await http.get(
          Uri.parse("$uri/api/banner"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners = data.map(
                (banner) {
              return BannerModel.fromJson(banner);
            }
        ).toList();

        return banners;
      }
      else{
        print("Failed to load banners: ${response.statusCode}");
        return [];
      }
    }
    catch(e) {
      // Bắt lỗi và trả về danh sách rỗng nếu có lỗi
      print("Error loading banners: $e");
      return [];
    }
  }
}