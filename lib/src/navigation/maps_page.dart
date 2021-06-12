import 'package:dawnn_client/src/network/objects/image.dart' as img;
import 'package:dawnn_client/src/util/network_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'image_viewer_page.dart';

/// A page displaying Google Maps with alerts on it.
///
/// Google Maps loads first, after which it goes through a pipeline
/// ending in a call to [NetworkUtils.requestImages].
class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _center = const LatLng(0, 0);
  Location _location = Location();

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
          onMapCreated: (GoogleMapController googleMapController) =>
              {_onMapCreated(googleMapController)},
          initialCameraPosition: CameraPosition(target: _center, zoom: 1),
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
        CameraPosition(target: LatLng(locData.latitude, locData.longitude), zoom: 14)));
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
      print('Server did not respond, not generating any makers.');
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
                image.user.location.latitude, image.user.location.longitude),
            icon: BitmapDescriptor.defaultMarker)
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

  void viewImage(img.Image image) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageViewerPage(image)));
  }
}
