import 'package:dacn_nhom3_customer/controllers/cart_controller.dart';
import 'package:dacn_nhom3_customer/provider/cart_provider.dart';
import 'package:dacn_nhom3_customer/provider/user_provider.dart';
import 'package:dacn_nhom3_customer/services/manager_http_response.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/checkout_screen.dart';
import 'package:dacn_nhom3_customer/views/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final userId = ref.read(userProvider)!.id;
      if (userId.isNotEmpty) {
        ref.read(cartProvider.notifier).fetchCartItems(userId); // Lấy dữ liệu giỏ hàng
      }
      _isInitialized = true;
    }
  }
  @override
  Widget build(BuildContext context) {

    final cartData = ref.watch(cartProvider);
    final _cartProvider  = ref.read(cartProvider.notifier);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();
    final userId = ref.read(userProvider)!.id;
    print("userId: $userId");
    final CartController cartController = CartController();


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My cart",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Giỏ hàng đang rỗng\n Chọn sản phẩm bằng cách ấn\n Xem sản phẩm ở dưới",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MainScreen();
                }));
              },
              child: const Text(
                "Xem sản phẩm"
              )
            )
          ],
        ),
      )
      : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          color: Colors.black12
                        ),
                      ),
                    ),
                    Positioned(
                      left: 44,
                      top: 19,
                      child: Container(
                        width: 10,
                        height: 10,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 69,
                      top: 14,
                      child: Text(
                        'You Have ${cartData.length} items',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
            ),
  /*Hiển thị sản phẩm*/
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartData.length,
              itemBuilder: (context,index) {
                final cartItem = cartData.values.toList()[index];
                return Card(
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          width: 180,
                          child: Image.network(cartItem.image[0]),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.productName.length > 20
                              ? '${cartItem.productName.substring(0, 20)}...'
                              : cartItem.productName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              cartItem.category,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey
                              ),
                            ),
                            Text(
                              "\$ ${cartItem.productPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.deepOrangeAccent
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (cartItem.quantity > 1) {
                                        _cartProvider.decrementCartItem(cartItem.productId);
                                      } else {
                                        _cartProvider.removeCartItem(cartItem.productId);
                                      }
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.white,
                                    )
                                  ),
                                  Text(
                                    cartItem.quantity.toStringAsFixed(0),
                                    style: const TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _cartProvider.incrementCartItem(cartItem.productId);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.plus,
                                        color: Colors.white,
                                      )
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  cartController.removeCartItem(userId, cartItem.productId);
                                  showSnackBar(context, "Bạn đã xóa sản phẩm ${cartItem.productName} khỏi giỏ hàng");
                                },
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  color: Colors.black,
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            )
          ]
        )
      ),
/*Tổng tiền và Button check out*/
      bottomNavigationBar: Container(
        width: 100,
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.blue
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Subtotal:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
                Text(
                  "\$${totalAmount.toString()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                )
              ],
            ),


            Container(
              height: 80,
              width: 10,
              color: Colors.grey,
            ),

            TextButton(
              onPressed: cartData.isEmpty
                  ? null
                  : () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const CheckoutScreen();
                    }));
                  },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    return cartData.isEmpty ? Colors.grey : Colors.blue;
                  },
                ),
              ),
              child: const Text(
                "Check out",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
