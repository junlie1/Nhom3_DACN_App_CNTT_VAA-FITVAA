import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/provider/product_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductBySubcategoryWidget extends ConsumerStatefulWidget {
  final String subCategory;
  const ProductBySubcategoryWidget({super.key, required this.subCategory});

  @override
  ConsumerState<ProductBySubcategoryWidget> createState() => _ProductBySubcategoryWidgetState();
}

class _ProductBySubcategoryWidgetState extends ConsumerState<ProductBySubcategoryWidget> {
  final ProductController productController = ProductController();
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    final ProductController productController = ProductController();
    try {
      print(widget.subCategory);
      final products = await productController.loadProductBySubCategory(widget.subCategory);
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
        title: Text("Product by Subcategory"),
      ),
      body: SizedBox(
        height: 300,
        child: products.isEmpty
            ? Center(
          child: Text(
            "Danh mục này không có sản phẩm",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
            : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            // Gọi widget ProductItemWidget
            return ProductItemWidget(product: product);
          },
        ),
      ),
    );
  }
}
