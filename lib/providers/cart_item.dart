class CartItem {
  final String id;
  final String title;
  final int quantily;
  final int price;
  final String imgUrl;
  final int size;

  CartItem({
    required this.size,
    required this.id,
    required this.title,
    required this.quantily,
    required this.price,
    required this.imgUrl,
  });
}
