import 'package:dacn_nhom3_customer/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryProvider extends StateNotifier<List<Category>> {
  CategoryProvider() : super([]);

  //Set product
  void setCategories(List<Category> categories) {
    state = categories;
  }
}

final categoryProvider = StateNotifierProvider<CategoryProvider, List<Category>>(
  //Cách 1
        (ref) {
      return CategoryProvider();
    }
  //Cách 2
  //   (ref) => ProductProvider()
);