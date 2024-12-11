
import 'package:dacn_nhom3_customer/controllers/cart_controller.dart';
import 'package:dacn_nhom3_customer/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartControllerProvider = Provider((ref) => CartController());

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  final CartController _cartController;

  // Khởi tạo CartNotifier với ref và lấy CartController từ cartControllerProvider
  CartNotifier(Ref ref)
      : _cartController = ref.read(cartControllerProvider),
        super({});


  Future<void> loadCart(String userId) async {
    final cartItems = await _cartController.fetchCartItems(userId);
    state = cartItems;
  }

  Future<void> fetchCartItems(String userId) async {
    final cartItems = await _cartController.fetchCartItems(userId); // Lấy dữ liệu từ cơ sở dữ liệu
    state = cartItems;
  }

  Future<void> addProductToCart(Cart cart, context) async {
    await _cartController.addProductToCart(
      userId: cart.userId,
      productName: cart.productName,
      productPrice: cart.productPrice,
      category: cart.category,
      image: cart.image,
      productId: cart.productId,
      vendorId: cart.vendorId,
      context: context,
    );
    loadCart(cart.userId); // Refresh cart after adding
  }

  // Future<void> removeCartItem(String userId, String productId) async {
  //   await _cartController.removeCartItem(userId, productId);
  //   loadCart(userId); // Refresh cart after removing
  // }
  //
  // Future<void> incrementCartItem(String userId, String productId) async {
  //   await _cartController.incrementCartItem(userId, productId);
  //   loadCart(userId); // Refresh cart after incrementing
  // }
  //
  // Future<void> decrementCartItem(String userId, String productId) async {
  //   await _cartController.decrementCartItem(userId, productId);
  //   loadCart(userId); // Refresh cart after decrementing
  // }
  // double calculateTotalAmount() {
  //   return state.values.fold(0.0, (sum, cartItem) => sum + cartItem.productPrice);
  // }
  void addProductToCartLocal({
    required String productName,
    required int productPrice,
    required String category,
    required List<String> image,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName
  }) {
    /*Kiểm tra sản phẩm có trong giỏ hàng chưa?*/
    if(state.containsKey(productId)) {
      state = {
        ...state,
        productId: Cart(
            userId: '',
            productName: state[productId]!.productName,
            productPrice: state[productId]!.productPrice,
            category: state[productId]!.category,
            image: state[productId]!.image,
            vendorId: state[productId]!.vendorId,
            productQuantity: state[productId]!.productQuantity,
            quantity: state[productId]!.quantity + 1,
            productId: state[productId]!.productId,
            description: state[productId]!.description,
            fullName: state[productId]!.fullName
        )
      };
    }
    else {
      state = {
        ...state,
        productId: Cart(
          userId: '',
            productName: productName,
            productPrice: productPrice,
            category: category,
            image: image,
            vendorId: vendorId,
            productQuantity: productQuantity,
            quantity: quantity,
            productId: productId,
            description: description,
            fullName: fullName
        )
      };
    }
  }

  /*Method tăng số lượng sản phẩm*/
  void incrementCartItem(String productId) {
    if(state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Sự kiện lắng nghe sự thay đổi số lương
      state ={...state};
    }
  }

  /*Method tăng số lượng sản phẩm*/
  void decrementCartItem(String productId) {
    if(state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Sự kiện lắng nghe sự thay đổi số lương
      state ={...state};
    }
  }

  /*Method xóa item ra khỏi cart*/
  void removeCartItem(String productId) {
    state.remove(productId);

    state = {...state};
  }

  /*Method tính tổng tiền*/
  double calculateTotalAmount() {
    double totatAmount = 0.0;
    state.forEach((productId,cartItem) {
      totatAmount += cartItem.quantity * cartItem.productPrice;
    });
    return totatAmount;
  }
  /*Method get dữ liệu*/
  Map<String,Cart> get getCartItems => state;
}


final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier(ref);
});
