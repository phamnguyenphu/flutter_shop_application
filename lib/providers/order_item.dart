import 'cart_item.dart';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final double amount;
  final List<CartItem> productsOrder;
  String status;

  OrderItem(
      {required this.id,
      required this.dateTime,
      required this.amount,
      required this.productsOrder,
      required this.status});
}
