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

  Future<void> deleteAddress(String id) async {
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

  Address? findDefaultAddress() {
    final address = _addresses.firstWhere((address) => address.status == true);
    // ignore: unnecessary_null_comparison
    if (address == null) {
      return null;
    }
    return address;
  }

  Future<void> fetchAddresss() async {
    final url = Uri.parse('${baseURL}addresses.json');
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
            address: addressData['address'],
            idUser: addressData['idUser'],
            fullName: addressData['fullName'],
            phoneNumber: addressData['phoneNumber'],
            distance: addressData['distances'],
            status: addressData['status']));
      });
      _addresses = loadingAddresses;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateStatus() async {
    final id = _addresses.firstWhere((address) => address.status == true).id;
    final url = Uri.parse('${baseURL}addresses/$id.json');
    final response = await http.patch(
      url,
      body: json.encode({'status': false}),
    );
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final index = _addresses.indexWhere((address) => address.id == id);
      _addresses[index].status = false;
      notifyListeners();
    }
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
          "address": address.address,
          "idUser": address.idUser,
          "distance": address.distance,
          "fullName": address.fullName,
          "phoneNumber": address.phoneNumber,
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
    final url = Uri.parse('${baseURL}addresses.json');
    try {
      if (address.status) {
        updateStatus();
        notifyListeners();
      }
      final response = await http.post(url,
          body: json.encode({
            "address": address.address,
            "idUser": address.idUser,
            "distance": address.distance,
            "fullName": address.fullName,
            "phoneNumber": address.phoneNumber,
            "status": address.status
          }));

      if (response.statusCode == 200) {
        _addresses.insert(
            0,
            Address(
              id: json.decode(response.body)['name'],
              address: address.address,
              idUser: address.idUser,
              fullName: address.fullName,
              phoneNumber: address.phoneNumber,
              distance: address.distance,
              status: address.status,
            ));
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
