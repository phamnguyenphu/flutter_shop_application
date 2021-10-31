import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/Utils/.env.dart';
import 'package:http/http.dart' as http;

class Addresses with ChangeNotifier {
  List<Address> _addresses = [];

  List<Address> get addresses {
    return [..._addresses];
  }

  //  Future<void> toggleStatus(String id) async {
  //   final address = _addresses.firstWhere((element) => element.id == id);
  //   final oldStatus = address.status;
  //   address.status = !address.status;
  //   notifyListeners();
  //   final url = Uri.parse(
  //       'https://flutter-shop-d0a51-default-rtdb.firebaseio.com/addressese/$id.json');
  //   try {
  //     final response =
  //         await http.patch(url, body: json.encode({'status': address.status}));
  //     if (response.statusCode >= 400) {
  //       address.status = oldStatus;
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     address.status = oldStatus;
  //     notifyListeners();
  //   }
  // }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('${baseURL}addresses/$id.json');
    final existingAddressIndex =
        _addresses.indexWhere((element) => element.id == id);
    Address? existingAddress = _addresses[existingAddressIndex];
    _addresses.removeAt(existingAddressIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _addresses.insert(existingAddressIndex, existingAddress);
      notifyListeners();
      throw Exception;
    }
    existingAddress = null;
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('${baseURL}products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      final List<Address> loadingAddresses = [];
      extractedData.forEach((addressId, addressData) {
        loadingAddresses.add(Address(
            id: addressId,
            street: addressData['street'],
            wards: addressData['wards'],
            district: addressData['district'],
            city: addressData['city'],
            status: addressData['status']));
      });
      _addresses = loadingAddresses;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateStatus() async {
    final id = _addresses.firstWhere((element) => element.status == true).id;
    final url = Uri.parse('${baseURL}addresses/$id.json');
    final response = await http.patch(
      url,
      body: json.encode({'status': false}),
    );
    if (response.statusCode == 200) {}
  }

  Future<void> updateAddress(String id, Address address) async {
    final indexAddress = _addresses.indexWhere((element) => element.id == id);
    final url = Uri.parse('${baseURL}addresses/$id.json');
    try {
      if (address.status) {
        updateStatus();
      }
      await http.patch(
        url,
        body: json.encode({
          "street": address.street,
          "wards": address.wards,
          "district": address.district,
          "city": address.city,
          "status": address.status
        }),
      );
      _addresses[indexAddress] = address;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addAddress(Address address) async {
    final url = Uri.parse('${baseURL}addresses');
    try {
      if (address.status) {
        updateStatus();
        notifyListeners();
      }
      final response = await http.post(url,
          body: json.encode({
            "street": address.street,
            "wards": address.wards,
            "district": address.district,
            "city": address.city,
            "status": address.status
          }));

      if (response.statusCode == 200) {
        _addresses.insert(
            0,
            Address(
              id: json.decode(response.body)['name'],
              street: address.street,
              wards: address.wards,
              district: address.district,
              city: address.city,
              status: address.status,
            ));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
