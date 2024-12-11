import 'package:dacn_nhom3_customer/models/banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() : super([]);

  //Set product
  void setBanners(List<BannerModel> banners) {
    state = banners;
  }
}

final bannerProvider = StateNotifierProvider<BannerProvider, List<BannerModel>>(
  //Cách 1
        (ref) {
      return BannerProvider();
    }
  //Cách 2
  //   (ref) => ProductProvider()
);