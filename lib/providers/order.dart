import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'order_item.dart';
import 'package:http/http.dart' as http;

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> _listOrdered = [];
  List<OrderItem> _listPacked = [];
  List<OrderItem> _listIntransit = [];
  List<OrderItem> _listDelivered = [];
  List<OrderItem> _listCanceled = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<OrderItem> get listOrdered {
    return [..._listOrdered];
  }

  List<OrderItem> get listPacked {
    return [..._listPacked];
  }

  List<OrderItem> get listIntransit {
    return [..._listIntransit];
  }

  List<OrderItem> get listDelivered {
    return [..._listDelivered];
  }

  List<OrderItem> get listCanceled {
    return [..._listCanceled];
  }

  // List<OrderItem> selectOrder(String status) {
  //   _orders.forEach((order) {
  //     if (order.status == status) {
  //       listOrder.add(order);
  //     }
  //   });
  //   return listOrder;
  // }

  Future<void> deleteOrder(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/orders/$id.json');
    final existingOrderIndex =
        _listOrdered.indexWhere((element) => element.id == id);
    OrderItem? existingOrder = orders[existingOrderIndex];
    _listOrdered.removeAt(existingOrderIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _listOrdered.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw Exception;
    }
    existingOrder = null;
  }

  Future<void> cancelOrder(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/orders/$id.json');
    try {
      final response =
          await http.patch(url, body: json.encode({'status': 'Cancel'}));
      if (response.statusCode == 200) {
        final existingOrderIndex =
            _listOrdered.indexWhere((element) => element.id == id);
        OrderItem? existingOrder = orders[existingOrderIndex];
        existingOrder.status = "Cancel";
        _listCanceled.add(existingOrder);
        _listOrdered.removeAt(existingOrderIndex);
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadingOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadingOrder.add(OrderItem(
        id: orderId,
        status: orderData['status'],
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
    _listOrdered = loadingOrder.reversed
        .where((order) => order.status == "Ordered")
        .toList();
    _listPacked = loadingOrder.reversed
        .where((order) => order.status == "Packed")
        .toList();
    _listIntransit = loadingOrder.reversed
        .where((order) => order.status == "In transit")
        .toList();
    _listDelivered = loadingOrder.reversed
        .where((order) => order.status == "Delivered")
        .toList();
    _listCanceled = loadingOrder.reversed
        .where((order) => order.status == "Cancel")
        .toList();
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
            'status': 'Ordered',
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
            status: 'Ordered',
          ));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
