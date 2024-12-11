import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/provider/product_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PopularProductWidget extends ConsumerStatefulWidget {
  const PopularProductWidget({super.key});

  @override
  ConsumerState<PopularProductWidget> createState() => _PopularProductWidgetState();
}

class _PopularProductWidgetState extends ConsumerState<PopularProductWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.loadPopularProduct();
      ref.read(productProvider.notifier).setProduct(products);
    }
    catch(e) {
      print("$e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    return SizedBox(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context,index) {
            final product = products[index];
            /*Gọi widget ProductItemWidget */
            return ProductItemWidget(product: product,);
          }
      ),
    );
  }
}
