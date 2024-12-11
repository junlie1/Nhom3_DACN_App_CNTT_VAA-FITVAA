import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dacn_nhom3_customer/controllers/order_controller.dart';
import 'package:dacn_nhom3_customer/controllers/product_review_controller.dart';
import 'package:dacn_nhom3_customer/models/order.dart';
import 'package:dacn_nhom3_customer/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final OrderController _orderController = OrderController();
  final TextEditingController _reviewController = TextEditingController();

  double rating = 0.0;
  final ProductReviewController _productReviewController = ProductReviewController();

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    /*cập nhật trạng thái của đơn hàng, đảm bảo nếu không tìm thấy đơn hàng trong danh sách, nó sẽ mặc định sử dụng thông tin hiện có*/
    final updatedOrder = orders.firstWhere((order) => order.id == widget.order.id, orElse: () => widget.order);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.order.productName,
          style: const TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Container(
                width: 336,
                height: 155,
                decoration: const BoxDecoration(),
                child: SizedBox(
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          //Giao diện cho khung
                          width: 336,
                          height: 155,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.lightBlueAccent
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          //Phần bên trong khung
                          child: Stack(
                            children: [
                              Positioned(
                                left: 13,
                                top: 10,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFBCC5FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    /*Ảnh order*/
                                    children: [
                                      Positioned(
                                        left: 11.5,
                                        top: 6,
                                        child: Image.network(
                                          widget.order.image,
                                          width: 58,
                                          height: 67,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              /*Tên, category, price*/
                              Positioned(
                                left: 102,
                                top: 13,
                                child: SizedBox(
                                  width: 220,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: Column(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                /*Tên*/
                                                child: Text(
                                                  widget.order.productName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment:Alignment.centerLeft,
                                                /*Category*/
                                                child: Text(
                                                  widget.order.category,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              /*Giá*/
                                              Text(
                                                "\$${widget.order.productPrice.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
        
                              /*Processing*/
                              Positioned(
                                left: 11,
                                top: 113,
                                child: Container(
                                  width: 100,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: updatedOrder.delivered == true
                                        ? Colors.green
                                        :updatedOrder.shipping == true
                                        ? Colors.lightBlueAccent
                                        : updatedOrder.processing == true
                                        ? Colors.purple
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 9,
                                        top: 2,
                                        child: Text(
                                          updatedOrder.delivered == true
                                              ? "Delivered"
                                              : updatedOrder.shipping == true
                                              ? "Shipping"
                                              : updatedOrder.processing == true
                                              ? "Processing"
                                              : "Cancelled",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 115,
                                left: 298,
                                child: InkWell(
                                  onTap: () {
                                    // _deleteOrder(order.id);
                                  },
                                  child: Image.asset(
                                    'assets/icons/delete.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        
            ),
            /*Khung thông tin*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                width: 336,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFEFF0F2,),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin đơn hàng',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.7,
                            ),
                          ),
        
                          const SizedBox(height: 8,),
        
                          Text(
                            "Địa chỉ giao hàng: ${widget.order.locality}, ${widget.order.city}",
                            style: GoogleFonts.lato(
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.w500,
                                fontSize: 15
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            "Người nhận : ${widget.order.fullName}",
                            style: GoogleFonts.roboto(
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.w500,
                                fontSize: 15
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            "Mã vận chuyển: ${widget.order.id}",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            "Số điện thoại: ${widget.order.phoneNumber}",
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                    if (widget.order.shipping == false && widget.order.processing == false && widget.order.delivered == false) // Kiểm tra trạng thái Cancelled
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Đơn hàng đã bị hủy",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Icon(Icons.cancel_outlined)
                          ],
                        ),
                      ),
                    widget.order.processing == true
                        ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Đơn hàng đang được chuẩn bị",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green
                                  ),
                                ),
                              ),
                              Icon(Icons.access_time)
                            ],
                          ),
                        )
                        : widget.order.shipping == true
                        ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        "Đơn hàng đang được vận chuyển",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.green
                                        )
                                    ),
                                  ),
                                  Icon(FontAwesomeIcons.motorcycle)
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:const Text('Bạn có chắc không?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () async{
                                                await _orderController.deliveredOrder(id: widget.order.id, context: context).whenComplete(() {
                                                  ref.read(orderProvider.notifier).updateOrderStatusRealtime(widget.order.id, shipping: false,processing: false, delivered: true);
                                                });
                                              },
                                              child: const Text(
                                                'Đồng ý',
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  'Click here to confirm delivered shipping',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                        : widget.order.delivered == true
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      "Đơn đã được giao thành công",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green
                                      ),
                                  ),
                                ),
                                Icon(
                                    Icons.check_circle_outlined
                                )
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Đánh giá sản phẩm'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min, // Giới hạn chiều cao nội dung
                                              children: [
                                                TextFormField(
                                                  controller: _reviewController,
                                                  decoration: const InputDecoration(
                                                    labelText: 'Your Review',
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                RatingBar(
                                                  filledIcon: Icons.star,
                                                  emptyIcon: Icons.star_border,
                                                  onRatingChanged: (value) {
                                                    rating = value;
                                                  },
                                                  initialRating: 2,
                                                  maxRating: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                final review = _reviewController.text;
                                                _productReviewController.uploadReview(
                                                  id: '',
                                                  buyerId: widget.order.buyerId,
                                                  email: widget.order.email,
                                                  fullName: widget.order.fullName,
                                                  productId: widget.order.productId,
                                                  rating: rating,
                                                  review: review,
                                                  context: context,
                                                );
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              child: const Text(
                                "Đánh giá sản phẩm?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green
                                ),
                              )
                            )
                          ],
                        )
                        : const SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
