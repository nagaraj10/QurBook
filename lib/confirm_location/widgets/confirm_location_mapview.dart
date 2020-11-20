import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmLocationMapView extends StatelessWidget {
  Completer<GoogleMapController> googleMapControll = Completer();
  LatLng lastMapPosition;
  Set<Marker> markers = {};
  static const double _lat = 12.861693;
  static const double _lang = 80.227242;
  static const double _zoom = 14.4746;
  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(_lat, _lang),
    zoom: _zoom,
  );

  ConfirmLocationMapView(
      {this.googleMapControll,
      this.lastMapPosition,
      this.markers,
      this.kGooglePlex});

  @override
  Widget build(BuildContext context) {

    return GoogleMap(
      scrollGesturesEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      onCameraMove: _onCameraMove,
      markers: markers,
      onMapCreated: _onMapCreated,
    );
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapControll.complete(controller);
  }
}
