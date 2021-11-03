import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_shop_application/providers/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_shop_application/Utils/.env.dart';

class DirectionsRepository with ChangeNotifier {
  static const dynamic _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();
  List<Directions> _item = [];

  List<Directions> get item {
    return [..._item];
  }

  void remove() {
    if (_item == null) {
      return;
    }
    _item.clear();
    notifyListeners();
  }

  Future<Directions?> getDirections({
    @required LatLng? destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '10.7626564,106.6603132',
        'destination': '${destination!.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      Directions direc = Directions.fromMap(response.data);
      _item.insert(0, direc);
      return direc;
    }
    return null;
  }
}
