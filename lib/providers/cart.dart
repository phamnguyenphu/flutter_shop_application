import 'package:flutter/foundation.dart';
import 'package:flutter_shop_application/providers/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartItemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantily;
    });
    return total;
  }

  void addItem(String productId, double price, String title, String imgUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                quantily: value.quantily + 1,
                price: value.price,
                imgUrl: value.imgUrl,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantily: 1,
                price: price,
                imgUrl: imgUrl,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((key, value) => key == productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantily > 1) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            quantily: value.quantily - 1,
            price: value.price,
            imgUrl: value.imgUrl),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
