import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dawnn_client/main.dart';
import 'package:dawnn_client/src/network/objects/image.dart' as img;
import 'package:dawnn_client/src/util/generator.dart';
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
  final LatLng _center = const LatLng(1, 2);
  Location _location = Location();

  // To be used when creating markers - call back only returns
  // bitmap data, not captions, uuid, or location.
  List<img.Image> imageData = <img.Image>[];

  _MapPageState() {
    DawnnClient.mapPage = this;
  }

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void dispose() {
    super.dispose();
    imageData.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Maps Page'), // TODO Load name according to language
          centerTitle: true,
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          onMapCreated: (GoogleMapController googleMapController) =>
              {_onMapCreated(googleMapController, context)},
          initialCameraPosition: CameraPosition(target: _center, zoom: 4),
          markers: Set.of(_markers.values),
        ));
  }

  /// Called when the map is created.
  void _onMapCreated(
      GoogleMapController googleMapController, BuildContext context) async {
    print('Map loaded, requesting images.');

    _prepareGenerateMarkers(await NetworkUtils.requestImages());

    // var currentLoc = await ClientUtils.getLocation();
    // context.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: LatLng(currentLoc.latitude, currentLoc.longitude), zoom: 15)));
    // _location.changeSettings(
    //     accuracy: LocationAccuracy.balanced, interval: 1000, distanceFilter: 10);

    _location.onLocationChanged.listen((location) {
      // print('Location changed, requesting new image data.');
      // NetworkUtils.getImages();
      // context.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //     target: LatLng(currentLoc.latitude, currentLoc.longitude), zoom: 15)));
    });
  }

  void _prepareGenerateMarkers(List<img.Image> images) async {
    // Don't draw if not mounted.
    if (!mounted) {
      print('Aborting preparing to generate map markers.');
      return;
    }

    if (images == null) {
      // Something went wrong - server did not respond?
      print(
          'Server did not respond? Images are null, cannot prepare to draw markers.');
      return;
    }

    List<Widget> circleAvatars = <Widget>[];

    print('Generating avatars.');
    for (var image in images) {
      var loadedImage = Image.memory(base64Decode(image.base64));
      circleAvatars.add(CircleAvatar(
        backgroundImage: loadedImage.image,
        radius: 7,
      ));
    }

    var generator = MarkerGenerator(circleAvatars, _generateMarkers);

    generator.generate(context);
  }

  dynamic _generateMarkers(List<Uint8List> bitmapList) async {
    print('Generating markers.');

    Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();

    for (var bitmap in bitmapList) {
      var markerId = bitmap.hashCode.toString();
      markers.addAll({
        MarkerId(markerId): Marker(
            markerId: MarkerId(bitmap.hashCode.toString()),
            alpha: 0.75,
            consumeTapEvents: false,
            infoWindow: InfoWindow(title: 'marker info'),
            position: LatLng(
                Random().nextInt(5).toDouble(), Random().nextInt(5).toDouble()),
            icon: BitmapDescriptor.fromBytes(bitmap))
      });
    }

    setState(() {
      for (var finishedMarkers in markers.entries) {
        _markers[finishedMarkers.key] = finishedMarkers.value;
      }
    });

    var ending = (markers.length == 1 ? ' marker' : ' markers') + '.';
    print('Added ' + markers.length.toString() + '$ending');
  }
}
