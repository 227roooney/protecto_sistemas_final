import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class MapPopup extends StatefulWidget {
  final LatLng location;
  final String moduleName;

  MapPopup({required this.location, required this.moduleName});

  @override
  _MapPopupState createState() => _MapPopupState();
}

class _MapPopupState extends State<MapPopup> {
  Set<Marker> _markers = {};
  late GoogleMapController mapController;
  Location _location = Location();
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _createMarker();
  }

  _getCurrentLocation() async {
    try {
      LocationData location = await _location.getLocation();
      setState(() {
        _currentPosition = LatLng(location.latitude!, location.longitude!);
      });
    } catch (e) {}
  }

  Future<void> _createMarker() async {
    final Marker destinationMarker = Marker(
      markerId: MarkerId('dest_location'),
      position: widget.location,
      infoWindow: InfoWindow(title: widget.moduleName),
      icon: await _createMarkerIcon(),
    );

    setState(() {
      _markers.add(destinationMarker);
    });
  }

  Future<BitmapDescriptor> _createMarkerIcon() async {
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller
        .setMapStyle(await rootBundle.loadString('assets/map_style.json'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Geo-Favoritos')),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.location,
                zoom: 17.345,
              ),
              minMaxZoomPreference: MinMaxZoomPreference(17.345, 17.345),
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
              zoomGesturesEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
            ),
    );
  }
}
