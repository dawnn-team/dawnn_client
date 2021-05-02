import 'package:dawnn_client/main.dart';
import 'package:dawnn_client/src/network/objects/image.dart' as img;
import 'package:dawnn_client/src/util/network_util.dart';
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

  _MapPageState() {
    DawnnClient.mapPage = this;
  }

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

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
        markers: Set.of(_markers.values),
      ),
    );
  }

  /// Called when the map is created.
  void _onMapCreated(GoogleMapController context) async {
    print('Map loaded, requesting image data.');
    List<img.Image> images = await NetworkUtils.requestImages();

    MarkerId id = MarkerId('1');
    var marker = Marker(
        markerId: id,
        position: LatLng(
            images.first.location.latitude, images.first.location.longitude),
        infoWindow:
            InfoWindow(title: "sample title", onTap: () => print('tapped icon')));

    setState(() {
      _markers[id] = marker;
    });
    // var currentLoc = await ClientUtils.getLocation();

    // context.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: LatLng(currentLoc.latitude, currentLoc.longitude), zoom: 15)));
    //
    // _location.changeSettings(
    //     accuracy: LocationAccuracy.balanced, interval: 1000, distanceFilter: 10);

    _location.onLocationChanged.listen((location) {
      // print('Location changed, requesting new image data.');
      // NetworkUtils.getImages();

      // context.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //     target: LatLng(currentLoc.latitude, currentLoc.longitude), zoom: 15)));
    });
  }
}
