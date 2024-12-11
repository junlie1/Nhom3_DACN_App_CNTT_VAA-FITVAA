import 'package:flutter/material.dart';

//Muốn gọi class này phải truyền image vào

class InnerBannerWidget extends StatelessWidget {
  final String image;

  const InnerBannerWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 170,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(image, fit: BoxFit.cover,)
        ),
      ),
    );
  }
}
