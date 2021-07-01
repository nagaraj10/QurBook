import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddProvidersMapView extends StatelessWidget {
  GoogleMapController googleMapControll;
  LatLng lastMapPosition;
  Set<Marker> markers = {};
  static const double _lat = 12.861693;
  static const double _lan = 80.227242;
  static const double _zoom = 14.4746;

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(_lat, _lan),
    zoom: _zoom,
  );

  AddProvidersMapView(
      {this.googleMapControll,
      this.lastMapPosition,
      this.markers,
      this.kGooglePlex});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      scrollGesturesEnabled: false,
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
    googleMapControll = controller;
  }
}
