import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/provider/top_rated_product_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopRatedProduct extends ConsumerStatefulWidget {
  const TopRatedProduct({super.key});

  @override
  ConsumerState<TopRatedProduct> createState() => _TopRatedProductState();
}

class _TopRatedProductState extends ConsumerState<TopRatedProduct> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.topRatedProduct();
      ref.read(topRatedProductProvider.notifier).setProduct(products);
    }
    catch(e) {
      print("$e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context,index) {
            final product = products[index];
            /*Gọi widget ProductItemWidget */
            if(product.averageRating == 0) {
              return null;
            }
            return ProductItemWidget(product: product,);
          }
      ),
    );
  }
}
