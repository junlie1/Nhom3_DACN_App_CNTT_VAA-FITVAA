import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/banner_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/category_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/header_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/popular_product_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/reusable_text_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/top_rated_product.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/view_all_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ProductController productController = ProductController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderWidget(),
          BannerWidget(),
          CategoryWidget(),
          ReusableTextWidget(title: "Top Products", subtitle: "", onSubtitlePressed: (){},),
          TopRatedProduct(),
          ReusableTextWidget(title: "Popular Products", subtitle: "View all", onSubtitlePressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ViewAllProduct();
            }));
          },),
          PopularProductWidget(),
        ],
      ),
    );
  }
}
