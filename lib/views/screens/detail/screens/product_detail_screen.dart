import 'package:dacn_nhom3_customer/controllers/cart_controller.dart';
import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/controllers/product_review_controller.dart';
import 'package:dacn_nhom3_customer/models/product.dart';
import 'package:dacn_nhom3_customer/models/product_review.dart';
import 'package:dacn_nhom3_customer/provider/favourite_provider.dart';
import 'package:dacn_nhom3_customer/provider/product_provider.dart';
import 'package:dacn_nhom3_customer/provider/related_product_provider.dart';
import 'package:dacn_nhom3_customer/provider/user_provider.dart';
import 'package:dacn_nhom3_customer/services/manager_http_response.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/reusable_text_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});


  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late Future<List<ProductReview>> futureProductsReview;
  final ProductReviewController productReviewController = ProductReviewController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureProductsReview = productReviewController.getProductReviewByProductId(productId: widget.product.id);
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadRelatedProductBySubcategory(widget.product.id);
      ref.read(relatedProductProvider.notifier).setProduct(products);
    }
    catch(e) {
      print("$e");
    }
  }
  @override
  Widget build(BuildContext context) {
    /*cart provider các biến*/
    final favouriteProviderData = ref.read(favouriteProvider.notifier);
    ref.watch(favouriteProvider);
    final relatedProduct = ref.watch(relatedProductProvider);

    CartController cartController = CartController();
    final user = ref.read(userProvider);
    final userId = user != null ? user.id : "";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Product Detail",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            IconButton(
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
            )
          ],
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      //Ảnh
            Center(
              child: SizedBox(
                width: 260,
                height: 275,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      left: 22,
                      top: 0,
                      child: Container(
                        width: 216,
                        height: 274,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF9CA8FF,
                          ),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                              itemCount: widget.product.images.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.product.images[index],
                                  width: 198,
                                  height: 225,
                                  fit: BoxFit.cover,
                                );
                              }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      //Tên
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.productName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    ),
                  ),
                  Text(
                    "\$${widget.product.productPrice.toString()}",
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                    ),
                  )
                ],
              ),
            ),
      //Mô tả
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Description: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent
                    ),
                  ),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 3,
              color: Colors.black12,
            ),
      //Đánh giá
            Padding(
              padding: const EdgeInsets.only(top: 10,left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Đánh giá sản phẩm",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          if (index < widget.product.averageRating.floor()) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            );
                          } else if (index < widget.product.averageRating) {
                            return const Icon(
                              Icons.star_half,
                              color: Colors.amber,
                              size: 15,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 15,
                            );
                          }
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "${widget.product.averageRating.toStringAsFixed(1)}/5 (${widget.product.totalRatings} Đánh giá)"
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 4,
                    color: Colors.black12, // Màu xám
                  ),
                  FutureBuilder(
                      future: futureProductsReview,
                      builder: (context,snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          print("Error: ${snapshot.error}");
                          return Center(child: Text("Lỗi: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Không có đánh giá nào"));
                        } else {
                          final reviews = snapshot.data;
                          return SizedBox(
                            height: 250,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: reviews!.length,
                                itemBuilder: (context,index) {
                                  final review = reviews[index];
                                  return ReviewWidget(review: review);
                                }
                            ),
                          );
                        }
                      }
                  ),
                ],
              ),
            ),
      //Related product
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sản phẩm tương tự :",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProduct.length,
                        itemBuilder: (context,index) {
                          final product = relatedProduct[index];
                          /*Gọi widget ProductItemWidget */
                          return ProductItemWidget(product: product,);
                        }
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
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
                  },
                  child: Container(
                    width: 300,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Add to cart",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
