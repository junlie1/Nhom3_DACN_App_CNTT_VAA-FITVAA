import 'package:dacn_nhom3_customer/controllers/cart_controller.dart';
import 'package:dacn_nhom3_customer/models/product.dart';
import 'package:dacn_nhom3_customer/provider/favourite_provider.dart';
import 'package:dacn_nhom3_customer/provider/user_provider.dart';
import 'package:dacn_nhom3_customer/services/manager_http_response.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItemWidget extends ConsumerStatefulWidget {
  final Product product;

  const ProductItemWidget({super.key, required this.product});

  @override
  ConsumerState<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends ConsumerState<ProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    final favouriteProviderData = ref.read(favouriteProvider.notifier);
    ref.watch(favouriteProvider);
    final userId = ref.read(userProvider)!.id;
    CartController cartController = CartController();

    return SingleChildScrollView(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductDetailScreen(product: widget.product);
          })
          );
        },
        child: Container(
          width: 170,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Stack(
                  children: [
                    Image.network(widget.product.images[0],height: 170,width: 170,fit: BoxFit.cover,),
        /*Favourite*/
                    Positioned(
                      top: 0,
                      right: -5,
                      child: IconButton(
                        onPressed: () {
                          favouriteProviderData.addProductToFavoutire(
                              userId: userId,
                              productName: widget.product.productName,
                              productPrice: widget.product.productPrice,
                              category: widget.product.category,
                              image: widget.product.images,
                              vendorId: widget.product.vendorId,
                              quantity: 1,
                              productQuantity: widget.product.quantity,
                              productId: widget.product.id,
                              description: widget.product.description,
                              fullName: widget.product.fullName
                            );
                          showSnackBar(context, "Thêm sản phẩm ${widget.product.productName} vào mục yêu thích");
                          },
                        icon: favouriteProviderData.getFavoutireItems.containsKey(widget.product.id)
                            ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                            : const Icon(Icons.favorite_border)
                      ),
                    ),
        /*Cart*/
                    Positioned(
                      bottom: 0,
                      right: -5,
                      child: IconButton(
                        onPressed: () {
                          cartController.addProductToCart(
                            userId: ref.read(userProvider)!.id,
                            productName: widget.product.productName,
                            productPrice: widget.product.productPrice,
                            category: widget.product.category,
                            image: widget.product.images,
                            productId: widget.product.id,
                            vendorId: widget.product.vendorId,
                            context: context,
                          );
                          showSnackBar(context, "Bạn đã thêm sản phẩm ${widget.product.productName} vào giỏ hàng");
                        },
                        icon: Image.asset(
                          'assets/icons/cart.png',
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                widget.product.productName,
                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                widget.product.category,
                style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                '\$ ${widget.product.productPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
              ),
              widget.product.averageRating != 0.0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8), // Góc bo tròn
                      border: Border.all(color: Colors.yellow, width: 2), // Viền màu vàng
                    ),
                    child: Row(
                      children: [
                        // Dãy các ngôi sao
                        Row(
                          children: List.generate(5, (index) {
                            if (index < widget.product.averageRating.floor()) {
                              return const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              );
                            } else if (index < widget.product.averageRating) {
                              return const Icon(
                                Icons.star_half,
                                color: Colors.yellow,
                                size: 15,
                              );
                            } else {
                              return const Icon(
                                Icons.star_border,
                                color: Colors.yellow,
                                size: 15,
                              );
                            }
                          }),
                        ),
                        const SizedBox(width: 8),
                        // Số sao
                        Text(
                          widget.product.averageRating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
              : const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Chưa có đánh giá",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
