import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'order_item.dart';
import 'package:http/http.dart' as http;

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadingOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadingOrder.add(OrderItem(
        id: orderId,
        dateTime: DateTime.parse(orderData['dateOrder']),
        amount: orderData['amount'],
        productsOrder: (orderData['productsOrder'] as List<dynamic>)
            .map(
              (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantily: e['quantily'],
                  price: e['price'],
                  imgUrl: e['imgUrl']),
            )
            .toList(),
      ));
    });
    _orders = loadingOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cart, double totalAmount) async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/orders.json');
    final time = DateTime.now();
    if (cart.isEmpty && totalAmount == 0) {
      return;
    }
    try {
      final response = await http.post(url,
          body: json.encode({
            'dateOrder': time.toIso8601String(),
            'amount': totalAmount,
            'productsOrder': cart
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantily': e.quantily,
                      'price': e.price,
                      'imgUrl': e.imgUrl,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            dateTime: time,
            amount: totalAmount,
            productsOrder: cart,
          ));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
