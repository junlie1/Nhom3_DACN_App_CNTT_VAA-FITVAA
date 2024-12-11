import 'package:dacn_nhom3_customer/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RelatedProductProvider extends StateNotifier<List<Product>> {
  RelatedProductProvider() : super([]);

  //Set product
  void setProduct(List<Product> products) {
    state = products;
  }
}

final relatedProductProvider = StateNotifierProvider<RelatedProductProvider, List<Product>>(
  //Cách 1
        (ref) {
      return RelatedProductProvider();
    }
  //Cách 2
  //   (ref) => ProductProvider()
);