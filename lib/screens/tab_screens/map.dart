import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:uni_map/widgets/map_details/map_background.dart';
import 'package:uni_map/widgets/map_details/map_cards.dart';


class UniMap extends StatefulWidget {
  const UniMap({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UniMapState();
  }
}

class _UniMapState extends State<UniMap> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-17.724003172714774, -63.174729262014694);
  Location _location = Location();
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  _getCurrentLocation() async {
    try {
      LocationData location = await _location.getLocation();
      _currentPosition = LatLng(location.latitude!, location.longitude!);
      //_updateUserMarker(_currentPosition);
    } catch (e) {
      throw Exception(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    controller
        .setMapStyle(await rootBundle.loadString('assets/map_style.json'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.645,
          ),
          minMaxZoomPreference: const MinMaxZoomPreference(17.645, 17.645),
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          mapToolbarEnabled: false,
          zoomGesturesEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
        ),
        const MapBackground(imagePath: 'assets/images/map_background.png'),
        const MapCards(),
      ],
    );
  }
}
