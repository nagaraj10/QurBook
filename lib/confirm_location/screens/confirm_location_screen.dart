import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/confirm_location/models/confirm_location_arguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class ConfirmLocationScreen extends StatefulWidget {
  ConfirmLocationArguments arguments;

  ConfirmLocationScreen({this.arguments});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConfirmLocationScreenState();
  }
}

class ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  final searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  GoogleMapController googleMapControll;
  List<Marker> _markers = [];

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(12.861693, 80.227242),
    zoom: 14.4746,
  );
  LatLng lastMapPosition;
  LatLng center = LatLng(0, 0);

  Address address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    searchController.text = widget.arguments.place.description;

    center = LatLng(
        widget.arguments.placeDetail.lat, widget.arguments.placeDetail.lng);
    lastMapPosition = center;

    kGooglePlex = CameraPosition(
      target: LatLng(
          widget.arguments.placeDetail.lat, widget.arguments.placeDetail.lng),
      zoom: 12,
    );
    addMarker();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        body: Stack(children: <Widget>[
      GoogleMap(
        scrollGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: kGooglePlex,
        onCameraMove: _onCameraMove,
        markers: Set.from(_markers),
        onMapCreated: _onMapCreated,
      ),
      Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 40),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: ColorUtils.blackcolor.withOpacity(0.1),
                  width: 1,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(ImageUrlUtils.backImg,
                        width: 16, height: 16, fit: BoxFit.cover)),
                SizedBox(width: 10),
                _ShowSearchTextField(),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            color: ColorUtils.darkbluecolor,
            child: Center(
              child: Text(
                  CommonConstants.locate_your + widget.arguments.providerType,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.lightwhitecolor.withOpacity(0.7))),
            ),
          ),
          Spacer(),
          _showConfirmLocationButton(),
          SizedBox(height: 30),
        ],
      )
    ]));
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapControll = controller;
  }

  Widget _ShowSearchTextField() {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
      child: new TextField(
        cursorColor: Theme.of(context).primaryColor,
        controller: searchController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        focusNode: searchFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          searchFocus.unfocus();
        },
        style: new TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: Icon(Icons.clear, color: ColorUtils.lightgraycolor),
            ),
            hintText: CommonConstants.searchPlaces,
            labelStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.greycolor1),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.greycolor1,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _showConfirmLocationButton() {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: confirmBtnTapped,
      child: new Container(
        width: 200,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.all(Radius.circular(25.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: new Center(
          child: new Text(
            CommonConstants.confirm_location,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: addButtonWithGesture);
  }

  void confirmBtnTapped() {
    Navigator.popUntil(context, (Route<dynamic> route) {
      bool shouldPop = false;
      if (route.settings.name == '/add_providers') {
        (route.settings.arguments as AddProvidersArguments).placeDetail =
            widget.arguments.placeDetail;
        (route.settings.arguments as AddProvidersArguments).place =
            widget.arguments.place;
        (route.settings.arguments as AddProvidersArguments)
            .confirmAddressDescription = searchController.text;
        shouldPop = true;
      }
      return shouldPop;
    });
  }

  Future addMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(ImageUrlUtils.markerImg, 50);
    BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);

    _markers.clear();

    setState(() {
      _markers.add(Marker(
          draggable: true,
          markerId: MarkerId(center.toString()),
          position: center,
          infoWindow: InfoWindow(
            title: widget.arguments.placeDetail.name,
            snippet: widget.arguments.placeDetail.formattedAddress,
          ),
          icon: descriptor,
          onDragEnd: ((value) {
            print(value.latitude);
            print(value.longitude);

            if (googleMapControll != null) {
              getAddressesFromCoordinates(value.latitude, value.longitude);

              center = LatLng(value.latitude, value.longitude);

              googleMapControll.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: center, zoom: 12.0, bearing: 45.0, tilt: 45.0)));
            }
          })));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  getAddressesFromCoordinates(double lat, double long) async {
    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    address = addresses.first;
    searchController.text = address.addressLine;
    print(
        ' ${address.locality}, ${address.adminArea},${address.subLocality}, ${address.subAdminArea},${address.addressLine}, ${address.featureName},${address.thoroughfare}, ${address.subThoroughfare}');
  }
}
