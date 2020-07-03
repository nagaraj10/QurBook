import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_address/models/AddAddressArguments.dart';
import 'package:myfhb/add_providers/bloc/add_providers_bloc.dart';
import 'package:myfhb/add_providers/bloc/update_providers_bloc.dart';
import 'package:myfhb/add_providers/models/add_doctors_providers_id.dart';
import 'package:myfhb/add_providers/models/add_hospitals_providers_id.dart';
import 'package:myfhb/add_providers/models/add_labs_providers_id.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/add_providers/models/update_providers_id.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/search_providers/models/doctors_data.dart';
import 'package:myfhb/search_providers/models/hospital_data.dart';
import 'package:myfhb/search_providers/models/lab_data.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/search_providers/bloc/hospital_list_block.dart';
import 'package:myfhb/search_providers/bloc/labs_list_block.dart';
import 'package:myfhb/search_providers/bloc/doctors_list_block.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class AddProviders extends StatefulWidget {
  DoctorsData data;
  HospitalData hospitalData;
  LabData labData;

  String searchKeyWord;
  bool hasData;
  String searchText;
  String fromClass;

  DoctorsModel doctorsModel;
  HospitalsModel hospitalsModel;
  LaboratoryModel labsModel;

  AddProvidersArguments arguments;

  AddProviders(
      {this.arguments,
      this.data,
      this.searchKeyWord,
      this.hospitalData,
      this.hasData,
      this.labData,
      this.searchText,
      this.fromClass,
      this.doctorsModel,
      this.hospitalsModel,
      this.labsModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddProvidersState();
  }
}

class AddProvidersState extends State<AddProviders> {
  final doctorController = TextEditingController();
  final FocusNode _doctorFocus = FocusNode();
  bool isSwitched = true;

  bool isPreferred;
  bool myprovidersPreferred;
  BitmapDescriptor markerIcon;

  GoogleMapController googleMapControll;
  List<Marker> _markers = [];

  double latitude = 0.0;
  double longtiude = 0.0;

  String addressLine1 = '';
  String addressLine2 = '';

  LatLng center = LatLng(0, 0);
  LatLng lastMapPosition;

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(12.861693, 80.227242),
    zoom: 12,
  );

  AddProvidersBloc addProvidersBloc;
  UpdateProvidersBloc updateProvidersBloc;

  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  Address address;

  MyProfile selectedProfile;
  String selectedFamilyMemberName;

  DoctorsListBlock _doctorsListBlock;
  HospitalListBlock _hospitalListBlock;
  LabsListBlock _labsListBlock;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addProvidersBloc = AddProvidersBloc();
    updateProvidersBloc = UpdateProvidersBloc();

    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();

    _myProfileBloc = new MyProfileBloc();
    _doctorsListBlock = new DoctorsListBlock();
    _hospitalListBlock = new HospitalListBlock();
    _labsListBlock = new LabsListBlock();

//    getCurrentLocation();

    buildUI();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back_ios,
//            size: 20,
//          ),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//        title: Text(
//          CommonConstants.add_providers,
//          style: TextStyle(
//            fontWeight: FontWeight.w400,
//            color: Colors.white,
//            fontSize: 18,
//          ),
//        ),
//      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    scrollGesturesEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: kGooglePlex,
                    onCameraMove: _onCameraMove,
                    markers: Set.from(_markers),
                    onMapCreated: _onMapCreated,
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            if (widget.arguments.hasData == false) {
                              Navigator.pushNamed(
                                context,
                                '/add_address',
                                arguments: AddAddressArguments(
                                    providerType:
                                        widget.arguments.searchKeyWord),
                              ).then((value) {

                                buildUI();
                                getAddressesFromCoordinates();
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            color: Colors.white,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 40),
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 10),
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(ImageUrlUtils.backImg,
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.cover)),
                                SizedBox(width: 10),
                                Text(CommonConstants.searchPlaces,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.greycolor1)),
                              ],
                            ),
                          )),
                      Visibility(
                          visible: widget.arguments.hasData == true
                              ? latitude == 0.0 ? true : false
                              : false,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2 - 80,
                            color: ColorUtils.blackcolor.withOpacity(0.7),
                            child: Center(
                              child: Text(
                                CommonConstants.comingSoon,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                        visible:
                            widget.arguments.hasData == false ? true : false,
                        child: Text(
                          widget.arguments.hasData == false
                              ? 'Add ${widget.arguments.searchKeyWord}'
                              : '',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.blackcolor),
                        )),
                    _ShowDoctorTextField(),
                    SizedBox(height: 10),
                    Text(
                      'Associated Member',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.greycolor1),
                    ),
                    SizedBox(height: 10),
                    _showUser(),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        if (widget.arguments.fromClass !=
                            CommonConstants.myProviders) {
                          CommonUtil.showLoadingDialog(
                              context, _keyLoader, 'Please Wait');

                          if (_familyListBloc != null) {
                            _familyListBloc = null;
                            _familyListBloc = new FamilyListBloc();
                          }
                          _familyListBloc
                              .getFamilyMembersList()
                              .then((familyMembersList) {
                            // Hide Loading
                            Navigator.of(_keyLoader.currentContext,
                                    rootNavigator: true)
                                .pop();
                            getDialogBoxWithFamilyMemberScrap(
                                familyMembersList.response.data);
                          });
                        }
                      },
                      child: Text(
                        'Switch User',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color(new CommonUtil().getMyPrimaryColor())),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        IgnorePointer(
//                            ignoring: widget.arguments.fromClass ==
//                                    CommonConstants.myProviders
//                                ? true
//                                : false,
                            ignoring: false,
                            child: Switch(
                              value: isPreferred,
                              onChanged: (value) {
                                setState(() {
                                  isPreferred = value;
                                });
                              },
                              activeTrackColor: Theme.of(context).primaryColor,
                              activeColor: Theme.of(context).primaryColor,
                            )),
                        Text(
                          'Set as Preferred',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.blackcolor),
                        ),
                      ],
                    ),
                    Visibility(
//                      visible: widget.arguments.fromClass ==
//                              CommonConstants.myProviders ? false : true,
                      visible: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _showCancelButton(),
                          _showAddButton()
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            callAddDoctorProvidersStreamBuilder(addProvidersBloc),
            callAddHospitalProvidersStreamBuilder(addProvidersBloc),
            callAddLabProvidersStreamBuilder(addProvidersBloc),
            callUpdateProvidersStreamBuilder(updateProvidersBloc),
          ],
        )),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapControll = controller;
  }

  buildUI() {
    if (widget.arguments.fromClass != CommonConstants.myProviders) {
      if (widget.arguments.hasData) {
        if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
          doctorController.text = widget.arguments.data.name != null
              ? toBeginningOfSentenceCase(widget.arguments.data.name)
              : '';
          isPreferred = widget.arguments.data.isUserDefined;
        } else if (widget.arguments.searchKeyWord ==
            CommonConstants.hospitals) {
          doctorController.text = widget.arguments.hospitalData.name != null
              ? toBeginningOfSentenceCase(widget.arguments.hospitalData.name)
              : '';
          isPreferred = widget.arguments.hospitalData.isUserDefined;

          latitude = widget.arguments.hospitalData.latitude == null
              ? 0.0
              : double.parse(widget.arguments.hospitalData.latitude);
          longtiude = widget.arguments.hospitalData.longitude == null
              ? 0.0
              : double.parse(widget.arguments.hospitalData.longitude);

          center = LatLng(latitude, longtiude);

          addressLine1 = widget.arguments.hospitalData.addressLine1;
          addressLine2 = widget.arguments.hospitalData.addressLine2;
        } else {
          doctorController.text = widget.arguments.labData.name != null
              ? toBeginningOfSentenceCase(widget.arguments.labData.name)
              : '';
          isPreferred = widget.arguments.labData.isUserDefined;

          latitude = widget.arguments.labData.latitude == null
              ? 0.0
              : double.parse(widget.arguments.labData.latitude);
          longtiude = widget.arguments.labData.longitude == null
              ? 0.0
              : double.parse(widget.arguments.labData.longitude);

          center = LatLng(latitude, longtiude);

          addressLine1 = widget.arguments.labData.addressLine1;
          addressLine2 = widget.arguments.labData.addressLine2;
        }
      } else {
        isPreferred = false;
        doctorController.text = widget.arguments.searchText;

        if (widget.arguments.placeDetail != null &&
            widget.arguments.placeDetail != null) {
          if (widget.arguments.placeDetail.lat > 0 &&
              widget.arguments.placeDetail.lng > 0) {
            latitude = widget.arguments.placeDetail.lat;
            longtiude = widget.arguments.placeDetail.lng;
            center = LatLng(latitude, longtiude);

            addressLine1 = widget.arguments.placeDetail.formattedAddress;
            addressLine2 = widget.arguments.placeDetail.formattedAddress;
          }
        } else {
          getCurrentLocation();
        }
      }
    } else {
      if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
        doctorController.text = widget.arguments.doctorsModel.name != null
            ? toBeginningOfSentenceCase(widget.arguments.doctorsModel.name)
            : '';
        isPreferred = widget.arguments.doctorsModel.isDefault;
        myprovidersPreferred = widget.arguments.doctorsModel.isDefault;
//
//        latitude = double.parse(widget.doctorsModel.latitude);
//        longtiude = double.parse(widget.doctorsModel.longitude);
//
//        center = LatLng(latitude, longtiude);

        addressLine1 = widget.arguments.doctorsModel.addressLine1;
        addressLine2 = widget.arguments.doctorsModel.addressLine2;
      } else if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        doctorController.text = widget.arguments.hospitalsModel.name != null
            ? toBeginningOfSentenceCase(widget.arguments.hospitalsModel.name)
            : '';
        isPreferred = widget.arguments.hospitalsModel.isDefault;
        myprovidersPreferred = widget.arguments.hospitalsModel.isDefault;

        latitude = widget.arguments.hospitalsModel.latitude == null
            ? 0.0
            : double.parse(widget.arguments.hospitalsModel.latitude);
        longtiude = widget.arguments.hospitalsModel.longitude == null
            ? 0.0
            : double.parse(widget.arguments.hospitalsModel.longitude);

        center = LatLng(latitude, longtiude);

        addressLine1 = widget.arguments.hospitalsModel.addressLine1;
        addressLine2 = widget.arguments.hospitalsModel.addressLine2;
      } else {
        doctorController.text = widget.arguments.labsModel.name != null
            ? toBeginningOfSentenceCase(widget.arguments.labsModel.name)
            : '';
        isPreferred = widget.arguments.labsModel.isDefault;
        myprovidersPreferred = widget.arguments.labsModel.isDefault;

        latitude = widget.arguments.labsModel.latitude == null
            ? 0.0
            : double.parse(widget.arguments.labsModel.latitude);
        longtiude = widget.arguments.labsModel.longitude == null
            ? 0.0
            : double.parse(widget.arguments.labsModel.longitude);

        center = LatLng(latitude, longtiude);

        addressLine1 = widget.arguments.labsModel.addressLine1;
        addressLine2 = widget.arguments.labsModel.addressLine2;
      }
    }

    setState(() {
      lastMapPosition = center;

      kGooglePlex = CameraPosition(
        target: center,
        zoom: 12,
      );

      if (latitude != 0.0 && longtiude != 0.0) {
        addMarker();
      }

      if (googleMapControll != null) {
        googleMapControll.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: center, zoom: 12.0, bearing: 45.0, tilt: 45.0)));
      }
    });
  }

  getCurrentLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = currentLocation.latitude;
      longtiude = currentLocation.longitude;

      center = LatLng(latitude, longtiude);

      kGooglePlex = CameraPosition(
        target: center,
        zoom: 12,
      );

      if (latitude != 0.0 && longtiude != 0.0) {
        addMarker();
      }

      if (googleMapControll != null) {
        googleMapControll.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: center, zoom: 12.0, bearing: 45.0, tilt: 45.0)));
      }
    });
  }

  getAddressesFromCoordinates() async {
    final coordinates = new Coordinates(
        widget.arguments.placeDetail.lat, widget.arguments.placeDetail.lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    address = addresses.first;
}

  Future addMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset(ImageUrlUtils.markerImg, 50);
    BitmapDescriptor descriptor = BitmapDescriptor.fromBytes(markerIcon);

    _markers.clear();

    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(center.toString()),
        position: center,
        infoWindow: InfoWindow(
          title: addressLine1 != null ? addressLine1 : '',
          snippet: addressLine2 != null ? addressLine2 : '',
        ),
        icon: descriptor,
      ));
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

  Widget _showUser() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);

    return InkWell(
        onTap: () {
          if (widget.arguments.fromClass != CommonConstants.myProviders) {
            CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait');

            if (_familyListBloc != null) {
              _familyListBloc = null;
              _familyListBloc = new FamilyListBloc();
            }
            _familyListBloc.getFamilyMembersList().then((familyMembersList) {
              // Hide Loading
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              getDialogBoxWithFamilyMemberScrap(
                  familyMembersList.response.data);
            });
          }
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: UnconstrainedBox(
              child: Container(
            padding: EdgeInsets.all(5.0),
            //height: 35,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 246, 246, 246),
              border: Border.all(
                width: 0.7356,
                color: Color.fromARGB(255, 239, 239, 239),
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Row(
              children: [
                ClipOval(
                    child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: myProfile
                              .response.data.generalInfo.profilePicThumbnail !=
                          null
                      ? getProfilePicWidget(myProfile
                          .response.data.generalInfo.profilePicThumbnail)
                      : Center(
                          child: Text(
                            selectedFamilyMemberName == null
                                ? myProfile.response.data.generalInfo.name[0]
                                    .toUpperCase()
                                : selectedFamilyMemberName[0].toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(CommonUtil().getMyPrimaryColor())),
                          ),
                        ),
                )),
                SizedBox(width: 10),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    selectedFamilyMemberName == null
                        ? 'Self'
                        : toBeginningOfSentenceCase(selectedFamilyMemberName),
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 92, 89),
                      //fontFamily: "Muli",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  //  new FHBBasicWidget()
  //      .getDefaultProfileImage()

  Widget _ShowDoctorTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextField(
        cursorColor: Color(new CommonUtil().getMyPrimaryColor()),
        controller: doctorController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        focusNode: _doctorFocus,
        textInputAction: TextInputAction.done,
        autofocus: true,
        enabled: widget.arguments.fromClass == CommonConstants.myProviders
            ? false
            : true,
        onSubmitted: (term) {
          _doctorFocus.unfocus();
        },
        style: new TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            //            focusedBorder: UnderlineInputBorder(
            //              borderSide: BorderSide(color: ColorUtils.greencolor),
            //            ),
            labelText: widget.arguments.searchKeyWord,
            labelStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.greycolor1),
            hintStyle: TextStyle(
              color: ColorUtils.greycolor1,
            ),
            border: new UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _showAddButton() {
    final GestureDetector addButtonWithGesture = new GestureDetector(
      onTap: _addBtnTapped,
      child: new Container(
        width: 100,
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
            widget.arguments.fromClass == CommonConstants.myProviders
                ? 'Update'
                : 'Add',
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

  Widget _showCancelButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: _cancelBtnTapped,
      child: new Container(
        width: 100,
        height: 40.0,
        decoration: new BoxDecoration(
          color: ColorUtils.greycolor,
          borderRadius: new BorderRadius.all(Radius.circular(25.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorUtils.greycolor.withOpacity(0.2),
              blurRadius: 100,
              offset: Offset(0, 100),
            ),
          ],
        ),
        child: new Center(
          child: new Text(
            'Cancel',
            style: new TextStyle(
              color: ColorUtils.blackcolor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: loginButtonWithGesture);
  }

  Widget callAddDoctorProvidersStreamBuilder(AddProvidersBloc bloc) {
    return StreamBuilder(
        stream: addProvidersBloc.doctorsStream,
        builder: (context,
            AsyncSnapshot<ApiResponse<AddDoctorsProvidersId>> snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            updateProvidersBloc.isPreferred = isPreferred;
            updateProvidersBloc.providerId =
                snapshot.data.data.response.data.id;
            updateProvidersBloc.updateDoctorsIdWithUserDetails();

            new CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  Widget callAddHospitalProvidersStreamBuilder(AddProvidersBloc bloc) {
    return StreamBuilder(
        stream: addProvidersBloc.hospitalsStream,
        builder: (context,
            AsyncSnapshot<ApiResponse<AddHospitalsProvidersId>> snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            updateProvidersBloc.isPreferred = isPreferred;
            updateProvidersBloc.providerId =
                snapshot.data.data.response.data.id;
            updateProvidersBloc.updateHospitalsIdWithUserDetails();

            new CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  Widget callAddLabProvidersStreamBuilder(AddProvidersBloc bloc) {
    return StreamBuilder(
        stream: addProvidersBloc.labsStream,
        builder:
            (context, AsyncSnapshot<ApiResponse<AddLabsProvidersId>> snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            updateProvidersBloc.isPreferred = isPreferred;
            updateProvidersBloc.providerId =
                snapshot.data.data.response.data.id;
            updateProvidersBloc.updateLabsIdWithUserDetails();

            new CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  Widget callUpdateProvidersStreamBuilder(UpdateProvidersBloc bloc) {
    return StreamBuilder(
        stream: widget.arguments.searchKeyWord == CommonConstants.doctors
            ? updateProvidersBloc.doctorsStream
            : widget.arguments.searchKeyWord == CommonConstants.hospitals
                ? updateProvidersBloc.hospitalsStream
                : updateProvidersBloc.labsStream,
        builder:
            (context, AsyncSnapshot<ApiResponse<UpdateProvidersId>> snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            if (widget.arguments.fromClass ==
                CommonConstants.serach_specific_list) {
              widget.arguments.searchKeyWord == CommonConstants.doctors
                  ? _doctorsListBlock
                      .getDoctorObjUsingId(bloc.providerId)
                      .then((doctorsListResponse) {
                    
                      Navigator.of(context).pop();

                      Navigator.of(context).pop(
                          {'doctor': doctorsListResponse.response.data[0]});
                    })
                  : widget.arguments.searchKeyWord == CommonConstants.hospitals
                      ? _hospitalListBlock
                          .getHospitalObjectusingId(bloc.providerId)
                          .then((hospitalDataResponse) {
                          
                          Navigator.of(context).pop();

                          Navigator.of(context).pop({
                            'hospital': hospitalDataResponse.response.data[0]
                          });
                        })
                      : _labsListBlock
                          .getLabsListUsingID(bloc.providerId)
                          .then((lablistResponse) {
                        
                          Navigator.of(context).pop();
                          Navigator.of(context).pop({
                            'laborartory': lablistResponse.response.data[0]
                          });
                        });
            } else {
              //            Navigator.pop(context, 1);
              Navigator.popUntil(context, (Route<dynamic> route) {
                bool shouldPop = false;
                if (route.settings.name == '/user_accounts') {
                  shouldPop = true;
                }
                return shouldPop;
              });
            }
            return Container();
          } else {
            return Container();
          }
        });
  }

  void _addBtnTapped() {
    if (widget.arguments.hasData ||
        widget.arguments.fromClass == CommonConstants.myProviders) {
      if (widget.arguments.fromClass == CommonConstants.myProviders) {
        if (myprovidersPreferred) {
          // alert
          Alert.displayAlertPlain(context,
              title: "Error",
              content:
                  'We allow only one preferred provider for a user. To remove your preference, please set another Provider as Preferred.');
        } else {
          CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

          updateProvidersBloc.isPreferred = isPreferred;

          if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
            if (widget.arguments.fromClass == CommonConstants.myProviders) {
              updateProvidersBloc.providerId = widget.arguments.doctorsModel.id;
            } else {
              updateProvidersBloc.providerId = widget.arguments.data.id;
            }
            updateProvidersBloc.updateDoctorsIdWithUserDetails();
          } else if (widget.arguments.searchKeyWord ==
              CommonConstants.hospitals) {
            if (widget.arguments.fromClass == CommonConstants.myProviders) {
              updateProvidersBloc.providerId =
                  widget.arguments.hospitalsModel.id;
            } else {
              updateProvidersBloc.providerId = widget.arguments.hospitalData.id;
            }
            updateProvidersBloc.updateHospitalsIdWithUserDetails();
          } else {
            if (widget.arguments.fromClass == CommonConstants.myProviders) {
              updateProvidersBloc.providerId = widget.arguments.labsModel.id;
            } else {
              updateProvidersBloc.providerId = widget.arguments.labData.id;
            }
            updateProvidersBloc.updateLabsIdWithUserDetails();
          }
        }
      } else {
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

        updateProvidersBloc.isPreferred = isPreferred;

        if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
          if (widget.arguments.fromClass == CommonConstants.myProviders) {
            updateProvidersBloc.providerId = widget.arguments.doctorsModel.id;
          } else {
            updateProvidersBloc.providerId = widget.arguments.data.id;
          }
          updateProvidersBloc.updateDoctorsIdWithUserDetails();
        } else if (widget.arguments.searchKeyWord ==
            CommonConstants.hospitals) {
          if (widget.arguments.fromClass == CommonConstants.myProviders) {
            updateProvidersBloc.providerId = widget.arguments.hospitalsModel.id;
          } else {
            updateProvidersBloc.providerId = widget.arguments.hospitalData.id;
          }
          updateProvidersBloc.updateHospitalsIdWithUserDetails();
        } else {
          if (widget.arguments.fromClass == CommonConstants.myProviders) {
            updateProvidersBloc.providerId = widget.arguments.labsModel.id;
          } else {
            updateProvidersBloc.providerId = widget.arguments.labData.id;
          }
          updateProvidersBloc.updateLabsIdWithUserDetails();
        }
      }
    } else {
      var signInData = {};

      if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

        signInData['name'] = doctorController.text.toString();
        signInData['specialization'] = '';
        signInData['description'] = '';
        signInData['city'] = address == null
            ? ''
            : address.locality == null ? '' : address.locality;
        signInData['state'] = address == null
            ? ''
            : address.adminArea == null ? '' : address.adminArea;
        signInData['phoneNumbers'] = widget.arguments.placeDetail == null
            ? ''
            : widget.arguments.placeDetail.formattedPhoneNumber == null
                ? ''
                : widget.arguments.placeDetail.formattedPhoneNumber;
        signInData['email'] = '';
        signInData['isUserDefined'] = true;

        var jsonString = convert.jsonEncode(signInData);

        addProvidersBloc.doctorsJsonString = jsonString;
        addProvidersBloc.addDoctors();
      } else if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("Please choose the address"),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

          signInData['name'] = doctorController.text.toString();
          signInData['phoneNumbers'] = widget.arguments.placeDetail == null
              ? ''
              : widget.arguments.placeDetail.formattedPhoneNumber == null
                  ? ''
                  : widget.arguments.placeDetail.formattedPhoneNumber;
          signInData['description'] = 'Cancer Speciality Hospital';
          signInData['email'] = 'apollo@sample.com';
          signInData['addressLine1'] =
              widget.arguments.confirmAddressDescription == null
                  ? ''
                  : widget.arguments.confirmAddressDescription == null
                      ? ''
                      : widget.arguments.confirmAddressDescription;
          signInData['addressLine2'] =
              address.addressLine == null ? '' : address.addressLine;
          signInData['city'] = address.locality == null ? '' : address.locality;
          signInData['state'] =
              address.adminArea == null ? '' : address.adminArea;
          signInData['zipCode'] =
              address.postalCode == null ? '' : address.postalCode;
          signInData['branch'] = '';
          signInData['isUserDefined'] = true;
          signInData['website'] = widget.arguments.placeDetail.website;
          signInData['googleMapUrl'] = widget.arguments.placeDetail.url;

          var jsonString = convert.jsonEncode(signInData);

          addProvidersBloc.hospitalsJsonString = jsonString;
          addProvidersBloc.addHospitals();
        }
      } else {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("Please choose the address"),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait'); //

          signInData['name'] = doctorController.text.toString();
          signInData['phoneNumbers'] = widget.arguments.placeDetail == null
              ? ''
              : widget.arguments.placeDetail.formattedPhoneNumber == null
                  ? ''
                  : widget.arguments.placeDetail.formattedPhoneNumber;
          signInData['description'] = 'Cancer Speciality Hospital';
          signInData['email'] = 'apollo@sample.com';
          signInData['addressLine1'] =
              widget.arguments.confirmAddressDescription == null
                  ? ''
                  : widget.arguments.confirmAddressDescription == null
                      ? ''
                      : widget.arguments.confirmAddressDescription;
          signInData['addressLine2'] = address == null
              ? ''
              : address.addressLine == null ? '' : address.addressLine;
          signInData['city'] = address == null
              ? ''
              : address.locality == null ? '' : address.locality;
          signInData['state'] = address == null
              ? ''
              : address.adminArea == null ? '' : address.adminArea;
          signInData['zipCode'] = address == null
              ? ''
              : address.postalCode == null ? '' : address.postalCode;
          signInData['branch'] = '';
          signInData['isUserDefined'] = true;
          signInData['website'] = widget.arguments.placeDetail == null
              ? ''
              : widget.arguments.placeDetail.website == null
                  ? ''
                  : widget.arguments.placeDetail.website;

          var jsonString = convert.jsonEncode(signInData);
          addProvidersBloc.labsJsonString = jsonString;
          addProvidersBloc.addLabs();
        }
      }
    }
  }

  void _cancelBtnTapped() async {
    Navigator.pop(context);
  }

  Future<Widget> getDialogBoxWithFamilyMemberScrap(FamilyData familyData) {
    return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, _keyLoader, (context, userId, userName) {
      PreferenceUtil.saveString(Constants.KEY_USERID, userId).then((onValue) {
        //getUserProfileData();
        Navigator.pop(context);
        CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait');

        getUserProfileWithId();
      });
    });
  }

  getUserProfileData() async {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();

    _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        Navigator.popUntil(context, (Route<dynamic> route) {
          bool shouldPop = false;
          if (route.settings.name == '/user_accounts') {
            shouldPop = true;
          }
          return shouldPop;
        });
      });
    });
  }

  void getUserProfileWithId() {
    MyProfileBloc _myProfileBloc = new MyProfileBloc();

    _myProfileBloc.getMyProfileData(Constants.KEY_USERID).then((profileData) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
          .then((value) {
        new CommonUtil().getMedicalPreference();

        setState(() {
          selectedFamilyMemberName = profileData.response.data.generalInfo.name;
        });
      });
    });
  }

  Widget getProfilePicWidget(ProfilePicThumbnailMain profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.memory(
            Uint8List.fromList(profilePicThumbnail.data),
            height: 30,
            width: 30,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 30,
            width: 30,
          );
  }


}
