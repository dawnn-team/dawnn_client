import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _center = const LatLng(45.521563, -122.677433);
  Location _location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Page'), // TODO Load name according to language
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 15),
      ),
    );
  }

  // This is a lazy way to set the position once.
  bool _once = true;

  /// Called when the map is created.
  void _onMapCreated(GoogleMapController context) {
    // TODO Request alert data from dawn server.
    _location.onLocationChanged.listen((loc) {
      if (_once) {
        context.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(loc.latitude, loc.longitude), zoom: 15)));
        _once = false;
      }
    });
  }
}
