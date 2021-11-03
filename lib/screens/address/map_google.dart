import 'package:flutter/material.dart';
import 'package:flutter_shop_application/screens/address/create_address.dart';
import 'package:flutter_shop_application/providers/directions_model.dart';
import 'package:flutter_shop_application/providers/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'edit_address.dart';

class MapScreen extends StatefulWidget {
  final bool isCreate;
  final String name;
  final String phoneNumber;
  final bool defaultStatus;

  const MapScreen(
      {Key? key,
      required this.isCreate,
      required this.name,
      required this.phoneNumber,
      required this.defaultStatus})
      : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(10.762622, 106.660172),
    zoom: 11.5,
  );

  GoogleMapController? _googleMapController;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Google Maps',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          if (_destination != null)
            TextButton(
              onPressed: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => widget.isCreate == true
                        ? CreateAddress(address: _info!.endAddress)
                        : EditAddress(
                            id: '1',
                            address: _info!.endAddress,
                            phoneNumber: widget.phoneNumber,
                            defaultStatus: widget.defaultStatus,
                            name: widget.name,
                          )))
              },
              style: TextButton.styleFrom(
                primary: Colors.greenAccent,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ACCEPT'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.red,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {if (_destination != null) _destination!},
            onTap: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_info != null)
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  )
                ],
              ),
              child: Text(
                '${_info!.endAddress}',
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController!.animateCamera(
          _info != null
              ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
              : CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    _destination = null;
    if (_destination == null) {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        );
      });
      final directions =
          await DirectionsRepository().getDirections(destination: pos);
      setState(() => _info = directions);
    }
  }
}
