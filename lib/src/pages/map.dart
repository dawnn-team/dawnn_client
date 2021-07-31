import 'dart:async';

import 'package:dawnn_client/src/network/objects/image.dart' as img;
import 'package:dawnn_client/src/util/client.dart';
import 'package:dawnn_client/src/util/network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'image_viewer.dart';

/// A page displaying Google Maps with alerts on it.
///
/// Google Maps loads first, after which it goes through a pipeline
/// ending in a call to [NetworkUtils.requestImages].
class MapPage extends StatefulWidget {
  final Stream shouldTriggerChange;

  MapPage(this.shouldTriggerChange);

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  // Listen to events denoting the need to update markers.
  StreamSubscription streamSubscription;
  Location _location = Location();

  // This keeps track of the current image requesting process.
  bool _requesting = false;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    streamSubscription =
        widget.shouldTriggerChange.listen((_) => updateMarkers());
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Map Page'), // TODO Load name according to language
          centerTitle: true,
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 1),
          markers: Set.of(_markers.values),
          myLocationEnabled: true,
        ));
  }

  /// Called when the map is created.
  void _onMapCreated(GoogleMapController googleMapController) async {
    // Slight redundancy here, we're getting locationData here and in NetworkUtils.requestImages()
    // Would a solution be to overload requestImages with a header that accepts locationData object?
    var locData = await _location.getLocation();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(locData.latitude, locData.longitude), zoom: 14)));
    print('Map loaded, requesting images.');

    updateMarkers();

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

  /// Update markers inside the map.
  ///
  /// Used by [HomePage] when user switches between pages in order to update the map.
  void updateMarkers() async {
    if (!_requesting) {
      print('Updating markers.');
      _requesting = true;
      _prepareGenerateMarkers(await NetworkUtils.requestImages());
    } else {
      print('Not updating markers, they have already been requested.');
    }
  }

  void _prepareGenerateMarkers(List<img.Image> images) async {
    // Don't draw if this widget is not mounted, or there are no images.
    // Don't forget to end the process.
    if (!mounted) {
      print('Aborting preparing to generate map markers.');
      _requesting = false;
      return;
    }

    if (images == null) {
      print('Server did not respond, not generating any makers.');
      _requesting = false;
      return;
    }

    _generateMarkers(images);
  }

  void _generateMarkers(List<img.Image> images) async {
    print('Generating markers.');

    Map<MarkerId, Marker> markers = Map<MarkerId, Marker>();

    for (img.Image image in images) {
      var id = MarkerId(image.uuid);
      markers.addAll({
        id: Marker(
            markerId: id,
            alpha: 0.75,
            onTap: () => viewImage(image),
            consumeTapEvents: true,
            infoWindow: InfoWindow(title: image.caption),
            position: LatLng(
                image.x, image.y),
            icon: BitmapDescriptor.defaultMarker)
      });
    }

    // We just received the new markers, let's remove the old ones.
    _markers.clear();

    setState(() {
      for (var finishedMarkers in markers.entries) {
        _markers[finishedMarkers.key] = finishedMarkers.value;
      }
    });

    ClientUtils.markersLoaded(context, markers.length);

    // Finish requesting process.
    _requesting = false;
  }

  void viewImage(img.Image image) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageViewerPage(image)));
  }
}
