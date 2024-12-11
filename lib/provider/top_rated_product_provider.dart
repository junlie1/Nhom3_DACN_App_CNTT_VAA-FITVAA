import 'package:dacn_nhom3_customer/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopRatedProductProvider extends StateNotifier<List<Product>> {
  TopRatedProductProvider() : super([]);

  //Set product
  void setProduct(List<Product> products) {
    state = products;
  }
}

final topRatedProductProvider = StateNotifierProvider<TopRatedProductProvider, List<Product>>(
  //Cách 1
        (ref) {
      return TopRatedProductProvider();
    }
  //Cách 2
  //   (ref) => ProductProvider()
);