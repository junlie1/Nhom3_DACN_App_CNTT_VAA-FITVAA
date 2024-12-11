import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/provider/product_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewAllProduct extends ConsumerStatefulWidget {
  const ViewAllProduct({super.key});

  @override
  ConsumerState<ViewAllProduct> createState() => _ViewAllProductState();
}

class _ViewAllProductState extends ConsumerState<ViewAllProduct> {
  final ProductController productController = ProductController();
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController.getAllProduct();
      ref.read(productProvider.notifier).setProduct(products);
    }
    catch(e) {
      print("$e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách sản phẩm"),
      ),
      body: Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Hiển thị 2 sản phẩm trên mỗi dòng
            crossAxisSpacing: 10, // Khoảng cách ngang giữa các cột
            mainAxisSpacing: 40, // Khoảng cách dọc giữa các hàng
            childAspectRatio: 0.6, // Tỷ lệ giữa chiều rộng và chiều cao của mỗi item
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductItemWidget(product: product);
          },
        ),
      ),
    );
  }
}
