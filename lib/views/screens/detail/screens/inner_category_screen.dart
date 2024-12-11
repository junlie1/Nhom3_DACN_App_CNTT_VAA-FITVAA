import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/controllers/subcategory_controller.dart';
import 'package:dacn_nhom3_customer/models/category.dart';
import 'package:dacn_nhom3_customer/models/sub_category.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/widgets/inner_banner_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/widgets/inner_header_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../nav_screen/widgets/product_item_widget.dart';

class InnerCategoryScreen extends StatefulWidget {
/*Muốn sử dụng biến cần có widget*/
  final Category category;

  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  /*Khai báo biến*/
  late Future<List<SubCategory>> _subCategories;
  final SubcategoryController _subcategoryController = SubcategoryController();
  late Future<List<Product>> futureProducts;
  /*init state để hứng sự thay đổi của sự kiện*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subCategories = _subcategoryController.getSubCategoryByCategoryName(widget.category.name);
    futureProducts = ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
          child: const InnerHeaderWidget()
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
/* Hiển thị banner */
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text(
                "Sản phẩm con của danh mục ${widget.category.name}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

/* Hiển thị subcategory */
            FutureBuilder(future: _subCategories, builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              else if(snapshot.hasError) {
                return Center(
                  child: Text(
                      "Error: ${snapshot.error}"
                  ),
                );
              }
              //Không có dữ liệu
              else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                      "Không có Categories nào trong database"
                  ),
                );
              }
              else {
                final subcategories = snapshot.data!; //Data vẫn là Json
  /*Hiển thị sản phẩm con*/
  /*Của danh mục sản phẩm*/
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: List.generate(
                      (subcategories.length / 5).ceil(), (setIndex) {
        /* đối với mỗi hàng, tính chỉ số bắt đầu và kết thúc */
                      final start = setIndex * 10;
                      final end = (setIndex + 1) * 10;

        /*Tạo khoảng cách giữa các Row*/
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
        /* tạo một hàng các ô danh mục con */
                          children: subcategories
                              .sublist(
                                start,
                                end > subcategories.length ? subcategories.length : end)
                              .map((subcategory) => Padding(
                                  padding: const EdgeInsets.only(right: 15), // Cách mỗi sản phẩm 8 pixel
                                  child: SubcategoryTileWidget(image: subcategory.image, title: subcategory.subCategoryName,),
                                ))
                              .toList(),
                        ),
                      );
                    },
                    ),
                  ),
                );
              }
            }),
            ReusableTextWidget(title: "Popular Product", subtitle: "View all", onSubtitlePressed: () {},),
            FutureBuilder(
                future: futureProducts,
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  else if(snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text("Lỗi: ${snapshot.error}"),);
                  }
                  else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(child: Text("Không có sản phẩm"),);
                  }
                  else {
                    final products = snapshot.data;
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products!.length,
                          itemBuilder: (context,index) {
                            final product = products[index];
                            return ProductItemWidget(product: product,);
                          }
                      ),
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
