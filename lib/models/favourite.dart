
class Favourite {
  final String userId;
  final String productName;
  final int productPrice;
  final String category;
  final List<String> image;
  final String vendorId;
  int quantity;
  int productQuantity;
  final String productId;
  final String description;
  final String fullName;

  Favourite({
    required this.userId,
    required this.productName,
    required this.productPrice,
    required this.category,
    required this.image,
    required this.vendorId,
    required this.quantity,
    required this.productQuantity,
    required this.productId,
    required this.description,
    required this.fullName,
  });

}
