import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddProvidersMapView extends StatelessWidget {
  GoogleMapController googleMapControll;
  LatLng lastMapPosition;
  Set<Marker> markers = {};

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(12.861693, 80.227242),
    zoom: 14.4746,
  );

  AddProvidersMapView(
      {this.googleMapControll,
      this.lastMapPosition,
      this.markers,
      this.kGooglePlex});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GoogleMap(
      scrollGesturesEnabled: false,
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
    googleMapControll = controller;
  }
}
