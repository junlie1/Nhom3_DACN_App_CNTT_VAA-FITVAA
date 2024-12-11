import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/models/product.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _searchController = TextEditingController();
  ProductController _productController = ProductController();

  List<Product> searchProduct = [];
  bool isLoading = false;

  void _searchProduct() async {
    setState((){
      isLoading = true;
    });
    try {
      final query = _searchController.text.trim();
      print("query: ${query}");
      final products = await _productController.searchProduct(query);
      print("products: ${products}");
      setState(() {
        searchProduct = products;
      });
    }
    catch(e) {
      print("Lỗi khi search: $e");
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "search products ...",
            suffixIcon: IconButton(
              onPressed: () {
                _searchProduct();
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16,),

          if(isLoading)
            Center(child: Text("Hãy tìm kiếm sản phẩm"),)
          else if (searchProduct.isEmpty)
            Center(child: Text("Không tìm thấy sản phẩm"),)
          else
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: searchProduct.length,
                  itemBuilder: (context,index) {
                    final product = searchProduct[index];
                    /*Gọi widget ProductItemWidget */
                    return ProductItemWidget(product: product,);
                  }
              ),
            )
        ],
      ),
    );
  }
}
