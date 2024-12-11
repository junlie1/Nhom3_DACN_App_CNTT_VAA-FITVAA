import 'package:dacn_nhom3_customer/controllers/product_controller.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/product_by_subcategory_widget.dart';
import 'package:flutter/material.dart';

class SubcategoryTileWidget extends StatelessWidget {
  final String image;
  final String title;

  const SubcategoryTileWidget({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
  /*Ảnh*/
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProductBySubcategoryWidget(subCategory: title);
            }));
          },
          child: SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(image,fit: BoxFit.cover,),
            ),
          ),
        ),
  const SizedBox(height: 10,),
  /* Tiêu đề */
        SizedBox(
          height: 60,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}
