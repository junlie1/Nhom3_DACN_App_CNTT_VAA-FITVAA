import 'package:dacn_nhom3_customer/models/favourite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouriteProvider extends StateNotifier<Map<String,Favourite>>{
  FavouriteProvider() : super({});

  void addProductToFavoutire({
    required userId,
    required productName,
    required productPrice,
    required category,
    required image,
    required vendorId,
    required quantity,
    required productQuantity,
    required productId,
    required description,
    required fullName
  }) {
    state[productId] = Favourite(
        userId: userId,
        productName: productName,
        productPrice: productPrice,
        category: category,
        image: image,
        vendorId: vendorId,
        quantity: quantity,
        productQuantity: productQuantity,
        productId: productId,
        description: description,
        fullName: fullName);
    //Lắng nghe sự kieện nếu có thay đổi gì
    state = {...state};
  }

  void removeFavouriteItem(String productId) {
    state.remove(productId);

    state = {...state};
  }
  /*Method get dữ liệu*/
  Map<String,Favourite> get getFavoutireItems => state;
}

final favouriteProvider = StateNotifierProvider<FavouriteProvider, Map<String, Favourite>>((ref) {
  return FavouriteProvider();
});
