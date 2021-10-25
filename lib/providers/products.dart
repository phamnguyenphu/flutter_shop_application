import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get itemsFavorites {
    return items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      final List<Product> loadingProducts = [];
      extractedData.forEach((productId, productData) {
        loadingProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imgUrl'],
            isFavorite: productData['isFavorite'],
          ),
        );
      });
      _items = loadingProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> searchProducts(String name){
    List<Product> result = [];
    _items.forEach((p) {
      var exist = p.title.contains(name);
      if(exist){
        result.add(p);
      }
    });
    return result;
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imgUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'price': product.price,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final indexProduct = _items.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/products/$id.json');
    await http.patch(
      url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imgUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );
    _items[indexProduct] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception;
    }
    existingProduct = null;
  }
}
