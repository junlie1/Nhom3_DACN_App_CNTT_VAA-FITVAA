import 'package:dacn_nhom3_customer/models/product_review.dart';
import 'package:flutter/material.dart';

class ReviewWidget extends StatelessWidget {
  final ProductReview review;

  const ReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3), // Dịch chuyển bóng đổ
            ),
          ],
          border: Border.all(color: Colors.grey.shade300), // Viền mỏng
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.fullName ?? "Admin",
              style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4,),
            Text(
              review.review,
              style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4,),
            review.rating != 0.0
                ? Container(
                    child: Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            if (index < review.rating.floor()) {
                              return const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 15,
                              );
                            } else if (index < review.rating) {
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
                      ],
                    ),
                  )
                : const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "Chưa có đánh giá",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
