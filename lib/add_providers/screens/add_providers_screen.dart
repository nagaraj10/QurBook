import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:myfhb/add_providers/widgets/dropdown_with_categories.dart';
import 'package:myfhb/add_providers/widgets/sample_dropdown.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/model/Media/media_data_list.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_address/models/AddAddressArguments.dart';
import 'package:myfhb/add_providers/bloc/add_providers_bloc.dart';
import 'package:myfhb/add_providers/bloc/update_providers_bloc.dart';
import 'package:myfhb/add_providers/models/add_doctors_providers_id.dart';
import 'package:myfhb/add_providers/models/add_hospitals_providers_id.dart';
import 'package:myfhb/add_providers/models/add_labs_providers_id.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/my_providers/models/DoctorModel.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/HospitalModel.dart';
import 'package:myfhb/my_providers/models/LaborartoryModel.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/search_providers/bloc/doctors_list_block.dart';
import 'package:myfhb/search_providers/bloc/hospital_list_block.dart';
import 'package:myfhb/search_providers/bloc/labs_list_block.dart';
import 'package:myfhb/search_providers/models/doctors_data.dart';
import 'package:myfhb/search_providers/models/hospital_data.dart';
import 'package:myfhb/search_providers/models/lab_data.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';

class AddProviders extends StatefulWidget {
  DoctorsData data;
  HospitalData hospitalData;
  LabData labData;

  String searchKeyWord;
  bool hasData;
  String searchText;
  String fromClass;

  Doctors doctorsModel;
  HospitalsModel hospitalsModel;
  LaboratoryModel labsModel;
  Function isRefresh;
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
      this.labsModel,
      this.isRefresh});

  @override
  State<StatefulWidget> createState() {
    return AddProvidersState();
  }
}

class AddProvidersState extends State<AddProviders> {
  final doctorController = TextEditingController();
  final FocusNode _doctorFocus = FocusNode();
  bool isSwitched = true;

  bool isPreferred = false;
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

  CommonWidgets commonWidgets = new CommonWidgets();

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(12.861693, 80.227242),
    zoom: 12,
  );

  AddProvidersBloc addProvidersBloc;
  UpdateProvidersBloc updateProvidersBloc;

  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  Address address;

  MyProfileModel selectedProfile;
  String selectedFamilyMemberName;

  DoctorsListBlock _doctorsListBlock;
  HospitalListBlock _hospitalListBlock;
  LabsListBlock _labsListBlock;

  FlutterToast toast = new FlutterToast();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  MyProviderViewModel providerViewModel;
  bool teleHealthAlertShown = false;
  String USERID;
  MyProfileModel myProfile;
  String updatedProfilePic;
  MediaTypeBlock _mediaTypeBlock;

  List<String> selectedCategories = new List();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    addProvidersBloc = AddProvidersBloc();
    updateProvidersBloc = UpdateProvidersBloc();

    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();

    _myProfileBloc = new MyProfileBloc();
    _doctorsListBlock = new DoctorsListBlock();
    _hospitalListBlock = new HospitalListBlock();
    _labsListBlock = new LabsListBlock();
    providerViewModel = new MyProviderViewModel();
    if (widget?.arguments?.data?.isTelehealthEnabled != null) {
      teleHealthAlertShown = widget.arguments.data.isTelehealthEnabled;
    }

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypesList();
    }

    if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
      selectedCategories = widget?.arguments?.doctorsModel?.sharedCategories;
    }
    if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
      selectedCategories = widget?.arguments?.hospitalsModel?.sharedCategories;
    }
    if (widget.arguments.searchKeyWord == CommonConstants.labs) {
      selectedCategories = widget?.arguments?.labsModel?.sharedCategories;
    }

    /* if (selectedCategories == null) {
      selectedCategories = new List();
      selectedCategories.add('e70ed858-246f-4f3b-b82c-513e6f591877');
      selectedCategories.add('d4e1b1f0-ea4c-4534-a3d5-040d71d9f799');
    }*/

    buildUI();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Add Provider Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios, // add custom icons also
            size: 24.0.sp,
          ),
        ),
        title: Text(
          widget.arguments?.searchKeyWord != null &&
                  widget.arguments.searchKeyWord.isNotEmpty
              ? 'Add ${widget.arguments.searchKeyWord.substring(0, widget.arguments.searchKeyWord.length - 1)}'
              : '',
          style: TextStyle(
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.blackcolor),
                        )),
                    _ShowDoctorTextField(),
                    SizedBox(height: 10.0.h),
                    Text(
                      variable.strAssociateMember,
                      style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.greycolor1),
                    ),
                    SizedBox(height: 10.0.h),
                    _showUser(),
                    SizedBox(height: 10.0.h),
                    InkWell(
                      child: Text(
                        variable.Switch_User,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          //color: Color(new CommonUtil().getMyPrimaryColor())
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    Row(
                      children: <Widget>[
                        IgnorePointer(
                            ignoring: false,
                            child: Switch(
                              value: isPreferred,
                              onChanged: (value) {
                                setState(() {
                                  isPreferred = value;
                                });
                              },
                              activeTrackColor:
                                  Color(CommonUtil().getMyPrimaryColor()),
                              activeColor:
                                  Color(CommonUtil().getMyPrimaryColor()),
                            )),
                        Text(
                          variable.Set_as_Preferred,
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.blackcolor),
                        ),
                      ],
                    ),
                    isPreferred
                        ? (widget.arguments.searchKeyWord ==
                                CommonConstants.labs)
                            ? Container()
                            : getDropDownWithCategoriesdrop()
                        : Container(),
                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _showCancelButton(),
                          _showAddButton()
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0.h),
                  ],
                ),
              ),
            ),
            callAddDoctorProvidersStreamBuilder(addProvidersBloc),
            callAddHospitalProvidersStreamBuilder(addProvidersBloc),
            callAddLabProvidersStreamBuilder(addProvidersBloc),
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

  buildUI() async {
    USERID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (widget.arguments.fromClass != router.rt_myprovider) {
      if (widget.arguments.hasData) {
        if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
          doctorController.text = widget.arguments.data.name != null
              ? widget?.arguments?.data?.name
                  ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.data.name)
              : '';
//          isPreferred = widget.arguments.data.isUserDefined ?? false;
          isPreferred = false;
        } else if (widget.arguments.searchKeyWord ==
            CommonConstants.hospitals) {
          doctorController.text = widget
                      .arguments.hospitalData.healthOrganizationName !=
                  null
              ? widget?.arguments?.hospitalData?.healthOrganizationName
                  ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.hospitalData.healthOrganizationName)
              : '';
//          isPreferred = widget.arguments.hospitalData.isUserDefined ?? false;
          isPreferred = false;
          // latitude = widget.arguments.hospitalData.latitude == null
          //     ? 0.0
          //     : double.parse(widget.arguments.hospitalData.latitude);
          // longtiude = widget.arguments.hospitalData.longitude == null
          //     ? 0.0
          //     : double.parse(widget.arguments.hospitalData.longitude);

          center = LatLng(latitude, longtiude);

          addressLine1 = widget.arguments.hospitalData.addressLine1;
          addressLine2 = widget.arguments.hospitalData.addressLine2;
        } else {
          doctorController.text = widget
                      .arguments.labData.healthOrganizationName !=
                  null
              ? widget?.arguments?.labData?.healthOrganizationName
                  ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.labData.healthOrganizationName)
              : '';
//          isPreferred = widget.arguments.labData.isUserDefined ?? false;
          isPreferred = false;

          // latitude = widget.arguments.labData.latitude == null
          //     ? 0.0
          //     : double.parse(widget.arguments.labData.latitude);
          // longtiude = widget.arguments.labData.longitude == null
          //     ? 0.0
          //     : double.parse(widget.arguments.labData.longitude);
          //
          // center = LatLng(latitude, longtiude);
          //
          // addressLine1 = widget.arguments.labData.addressLine1;
          // addressLine2 = widget.arguments.labData.addressLine2;
        }
      } else {
        isPreferred = false;
        doctorController.text =
            widget?.arguments?.searchText?.capitalizeFirstofEach;

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
        doctorController.text = widget.arguments.doctorsModel.user.name != null
            ? widget?.arguments?.doctorsModel?.user?.name
                ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.doctorsModel.user.name)
            : '';
        isPreferred = widget.arguments.doctorsModel.isDefault;
        myprovidersPreferred = widget.arguments.doctorsModel.isDefault;
        addressLine1 = commonWidgets.getAddressLineForDoctors(
            widget.arguments.doctorsModel, 'address1');
        addressLine2 = commonWidgets.getAddressLineForDoctors(
            widget.arguments.doctorsModel, 'address2');

        /* latitude = widget.arguments.data.latitude == null
            ? 0.0
            : double.parse(widget.arguments.data.latitude);
        longtiude = widget.arguments.data.longitude == null
            ? 0.0
            : double.parse(widget.arguments.data.longitude);*/
      } else if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        doctorController.text = widget.arguments.hospitalsModel.name != null
            ? widget?.arguments?.hospitalsModel?.name
                ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.hospitalsModel.name)
            : '';
        isPreferred = widget.arguments.hospitalsModel.isDefault;
        myprovidersPreferred = widget.arguments.hospitalsModel.isDefault;

        /*latitude = widget.arguments.hospitalsModel.latitude == null
            ? 0.0
            : double.parse(widget.arguments.hospitalsModel.latitude);
        longtiude = widget.arguments.hospitalsModel.longitude == null
            ? 0.0
            : double.parse(widget.arguments.hospitalsModel.longitude);

        center = LatLng(latitude, longtiude);*/

        addressLine1 = commonWidgets.getAddressLineForHealthOrg(
            widget.arguments.hospitalsModel, 'address1');
        addressLine2 = commonWidgets.getAddressLineForHealthOrg(
            widget.arguments.hospitalsModel, 'address2');
      } else {
        doctorController.text = widget.arguments.labsModel.name != null
            ? widget?.arguments?.labsModel?.name
                ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.labsModel.name)
            : '';
        isPreferred = widget.arguments.labsModel.isDefault;
        myprovidersPreferred = widget.arguments.labsModel.isDefault;

//        latitude = widget.arguments.labsModel.latitude == null
//            ? 0.0
//            : double.parse(widget.arguments.labsModel.latitude);
//        longtiude = widget.arguments.labsModel.longitude == null
//            ? 0.0
//            : double.parse(widget.arguments.labsModel.longitude);
//
//        center = LatLng(latitude, longtiude);

        addressLine1 = commonWidgets.getAddressLineForHealthOrg(
            widget.arguments.labsModel, 'address1');
        addressLine2 = commonWidgets.getAddressLineForHealthOrg(
            widget.arguments.labsModel, 'address2');
      }
    }
    try {
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
    } catch (e) {}
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
    MyProfileModel primaryUserProfile;
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      primaryUserProfile =
          PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } catch (e) {}
    return InkWell(
        onTap: () {
          if (widget.arguments.fromClass != router.rt_myprovider) {
            CommonUtil.showLoadingDialog(
                context, _keyLoader, variable.Please_Wait);

            if (_familyListBloc != null) {
              _familyListBloc = null;
              _familyListBloc = new FamilyListBloc();
            }
            _familyListBloc.getFamilyMembersListNew().then((familyMembersList) {
              // Hide Loading
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              if (familyMembersList != null &&
                  familyMembersList.result != null &&
                  familyMembersList.result.sharedByUsers.length > 0) {
                getDialogBoxWithFamilyMemberScrap(familyMembersList.result);
              } else {
                toast.getToast(Constants.NO_DATA_FAMIY_CLONE, Colors.black54);
              }
            });
          }
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: UnconstrainedBox(
              child: Container(
            padding: EdgeInsets.all(5.0),
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
                  height: 30.0.h,
                  width: 30.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: updatedProfilePic != null
                      ? updatedProfilePic.length > 5
                          ? getProfilePicWidget(updatedProfilePic)
                          : Center(
                              child: Text(
                                selectedFamilyMemberName == null
                                    ? myProfile.result.lastName.toUpperCase()
                                    : selectedFamilyMemberName[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            )
                      : myProfile != null
                          ? myProfile.result != null
                              ? myProfile.result.profilePicThumbnailUrl != null
                                  ? getProfilePicWidget(
                                      myProfile.result.profilePicThumbnailUrl)
                                  : Center(
                                      child: Text(
                                        selectedFamilyMemberName == null
                                            ? myProfile.result.lastName
                                                .toUpperCase()
                                            : selectedFamilyMemberName[0]
                                                .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16.0.sp,
                                            color: Color(CommonUtil()
                                                .getMyPrimaryColor())),
                                      ),
                                    )
                              : Center(
                                  child: Text(
                                    selectedFamilyMemberName == null
                                        ? myProfile.result != null
                                            ? myProfile.result.lastName != null
                                                ? myProfile.result.lastName
                                                : ''
                                            : ''
                                        : selectedFamilyMemberName[0]
                                            .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor())),
                                  ),
                                )
                          : Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ),
                )),
                SizedBox(width: 10.0.w),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Text(
                    selectedFamilyMemberName == null
                        ? myProfile.result.id == primaryUserProfile.result.id
                            ? variable.Self
                            : myProfile.result.firstName
                        : selectedFamilyMemberName
                            .capitalizeFirstofEach, //toBeginningOfSentenceCase(selectedFamilyMemberName),
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 85, 92, 89),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Widget _ShowDoctorTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextField(
        cursorColor: Color(new CommonUtil().getMyPrimaryColor()),
        controller: doctorController,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        //focusNode: _doctorFocus,
        textInputAction: TextInputAction.done,
        //autofocus: true,
        enabled: false,
        //widget.arguments.fromClass == router.rt_myprovider ? false : true,
        onSubmitted: (term) {
          _doctorFocus.unfocus();
        },
        style: new TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
            color: Color(CommonUtil().getMyPrimaryColor())),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Color(CommonUtil().getMyPrimaryColor())),
            ),
            labelText: widget.arguments.searchKeyWord,
            labelStyle: TextStyle(
                fontSize: 16.0.sp,
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
        width: 100.0.w,
        height: 40.0.h,
        decoration: new BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
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
            widget.arguments.fromClass == router.rt_myprovider
                ? variable.Update
                : variable.Add,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
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
        width: 100.0.w,
        height: 40.0.h,
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
            variable.Cancel,
            style: new TextStyle(
              color: ColorUtils.blackcolor,
              fontSize: 16.0.sp,
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
            updateDoctorsIdWithUserDetails();

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
            updateHospitalsIdWithUserDetails();

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
            updateLabsIdWithUserDetails();

            new CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  updateDoctorsIdWithUserDetails() {
    updateProvidersBloc.updateDoctorsIdWithUserDetails().then((value) {
      var routeClassName = '';

      if (widget.arguments.fromClass == router.cn_AddProvider ||
          widget.arguments.fromClass == router.rt_myprovider) {
        routeClassName = router.rt_UserAccounts;
      } else if (widget.arguments.fromClass == router.rt_TelehealthProvider) {
        routeClassName = router.rt_TelehealthProvider;
      }

      Navigator.popUntil(context, (Route<dynamic> route) {
        bool shouldPop = false;
        if (route.settings.name == routeClassName || route.settings == null) {
          shouldPop = true;
        }
        return shouldPop;
      });
    });
  }

  updateHospitalsIdWithUserDetails() {
    updateProvidersBloc.updateHospitalsIdWithUserDetails().then((value) {
      var routeClassName = '';

      if (widget.arguments.fromClass == router.cn_AddProvider ||
          widget.arguments.fromClass == router.rt_myprovider) {
        routeClassName = router.rt_UserAccounts;
      } else if (widget.arguments.fromClass == router.rt_TelehealthProvider) {
        routeClassName = router.rt_TelehealthProvider;
      }

      Navigator.popUntil(context, (Route<dynamic> route) {
        bool shouldPop = false;
        if (route.settings.name == routeClassName) {
          shouldPop = true;
        }
        return shouldPop;
      });
    });
  }

  updateLabsIdWithUserDetails() {
    updateProvidersBloc.updateLabsIdWithUserDetails().then((value) {
      var routeClassName = '';

      if (widget.arguments.fromClass == router.cn_AddProvider ||
          widget.arguments.fromClass == router.rt_myprovider) {
        routeClassName = router.rt_UserAccounts;
      } else if (widget.arguments.fromClass == router.rt_TelehealthProvider) {
        routeClassName = router.rt_TelehealthProvider;
      }

      Navigator.popUntil(context, (Route<dynamic> route) {
        bool shouldPop = false;
        if (route.settings.name == routeClassName) {
          shouldPop = true;
        }
        return shouldPop;
      });
    });
  }

  void _addBtnTapped() {
    providerViewModel.userID = USERID;
    updateProvidersBloc.userId = USERID;
    if (widget.arguments.hasData ||
        widget.arguments.fromClass == router.rt_myprovider) {
      if (widget.arguments.fromClass == router.rt_myprovider) {
        //  if (myprovidersPreferred) {
        // alert
//          Alert.displayAlertPlain(context,
//              title: variable.Error, content: variable.preferred_descrip);
//        } else {

        CommonUtil.showLoadingDialog(
            context, _keyLoader, variable.Please_Wait); //

        updateProvidersBloc.isPreferred = isPreferred;
        updateProvidersBloc.selectedCategories = isPreferred
            ? selectedCategories != null && selectedCategories.length > 0
                ? selectedCategories
                : null
            : null;

        if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
          if (widget.arguments.fromClass == router.rt_myprovider) {
            /* updateProvidersBloc.providerId = widget.arguments.data.doctorId;
            updateProvidersBloc.providerReferenceId =
                widget.arguments.data.doctorReferenceId;*/
            providerViewModel
                .bookMarkDoctor(widget.arguments.doctorsModel, isPreferred, '',
                    selectedCategories)
                .then((status) {
              if (status) {
                navigateToRefresh();
              }
            });
          } else {
            /*updateProvidersBloc.providerId = widget.arguments.data.doctorId;
            updateProvidersBloc.providerReferenceId =
                widget.arguments.data.doctorReferenceId;*/
          }

          //updateDoctorsIdWithUserDetails();
        } else if (widget.arguments.searchKeyWord ==
            CommonConstants.hospitals) {
          if (widget.arguments.fromClass == router.rt_myprovider) {
            /* updateProvidersBloc.providerId = widget.arguments.hospitalData.healthOrganizationId;
            updateProvidersBloc.providerReferenceId =
               widget.arguments.hospitalData.healthOrganizationReferenceId;*/

            providerViewModel
                .bookMarkHealthOrg(widget.arguments.hospitalsModel, isPreferred,
                    '', selectedCategories)
                .then((status) {
              if (status) {
                navigateToRefresh();
              }
            });
          }
          //updateHospitalsIdWithUserDetails();
        } else {
          if (widget.arguments.fromClass == router.rt_myprovider) {
            /*updateProvidersBloc.providerId = widget.arguments.labsModel.id;*/

            providerViewModel
                .bookMarkHealthOrg(widget.arguments.labsModel, isPreferred, '',
                    selectedCategories)
                .then((status) {
              if (status) {
                navigateToRefresh();
              }
            });
          }
          //updateLabsIdWithUserDetails();
//          }
        }
      } else {
        CommonUtil.showLoadingDialog(
            context, _keyLoader, variable.Please_Wait); //

        updateProvidersBloc.isPreferred = isPreferred;

        if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
          if (teleHealthAlertShown) {
            if (widget.arguments.fromClass == router.rt_myprovider) {
              updateProvidersBloc.providerId = widget.arguments.data.doctorId;
              updateProvidersBloc.providerReferenceId =
                  widget.arguments.data.doctorReferenceId;
              updateProvidersBloc.selectedCategories = selectedCategories;
            } else {
              updateProvidersBloc.providerId = widget.arguments.data.doctorId;
              updateProvidersBloc.providerReferenceId =
                  widget.arguments.data.doctorReferenceId;
              updateProvidersBloc.selectedCategories = selectedCategories;
            }
            updateDoctorsIdWithUserDetails();
          } else {
            showDialogForDoctor();
          }
        } else if (widget.arguments.searchKeyWord ==
            CommonConstants.hospitals) {
          if (widget.arguments.fromClass == router.rt_myprovider) {
            updateProvidersBloc.providerId =
                widget.arguments.hospitalData.healthOrganizationId;
            updateProvidersBloc.providerReferenceId =
                widget.arguments.hospitalData.healthOrganizationReferenceId;
            updateProvidersBloc.selectedCategories = selectedCategories;
          } else {
            updateProvidersBloc.providerId =
                widget.arguments.hospitalData.healthOrganizationId;
            updateProvidersBloc.providerReferenceId =
                widget.arguments.hospitalData.healthOrganizationReferenceId;
            updateProvidersBloc.selectedCategories = selectedCategories;
          }
          updateHospitalsIdWithUserDetails();
        } else {
          if (widget.arguments.fromClass == router.rt_myprovider) {
            updateProvidersBloc.providerId =
                widget.arguments.labData.healthOrganizationId;
            updateProvidersBloc.providerReferenceId =
                widget.arguments.labData.healthOrganizationReferenceId;
            updateProvidersBloc.selectedCategories = selectedCategories;
          } else {
            updateProvidersBloc.providerId =
                widget.arguments.labData.healthOrganizationId;
            updateProvidersBloc.providerReferenceId =
                widget.arguments.labData.healthOrganizationReferenceId;
            updateProvidersBloc.selectedCategories = selectedCategories;
          }
          updateLabsIdWithUserDetails();
        }
      }
    } else {
      var signInData = {};

      if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(variable.strError),
                  content: Text(variable.choose_address),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 24.0.sp,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait); //

          signInData[variable.strName] = doctorController.text.toString();
          signInData[variable.strSpecialization] = '';
          signInData[variable.strDescription] = '';
          signInData[variable.strCity] = address == null
              ? ''
              : address.locality == null ? '' : address.locality;
          signInData[variable.strState] = address == null
              ? ''
              : address.adminArea == null ? '' : address.adminArea;
          signInData[variable.strPhoneNumbers] =
              widget.arguments.placeDetail == null
                  ? ''
                  : widget.arguments.placeDetail.formattedPhoneNumber == null
                      ? ''
                      : widget.arguments.placeDetail.formattedPhoneNumber;
          signInData[variable.strEmail] = '';
          signInData[variable.strIsUserDefined] = true;
          signInData[variable.strLatitude] =
              widget.arguments.placeDetail.lat == null
                  ? 0.0
                  : widget.arguments.placeDetail.lat;

          signInData[variable.strLongitute] =
              widget.arguments.placeDetail.lng == null
                  ? 0.0
                  : widget.arguments.placeDetail.lng;
          signInData['sharedCategories'] = selectedCategories;
          var jsonString = convert.jsonEncode(signInData);

          addProvidersBloc.doctorsJsonString = jsonString;
          addProvidersBloc.addDoctors();
        }
      } else if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(variable.strError),
                  content: Text(variable.choose_address),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 24.0.sp,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait); //

          signInData[variable.strName] = doctorController.text.toString();
          signInData[variable.strPhoneNumbers] =
              widget.arguments.placeDetail == null
                  ? ''
                  : widget.arguments.placeDetail.formattedPhoneNumber == null
                      ? ''
                      : widget.arguments.placeDetail.formattedPhoneNumber;
          signInData[variable.strDescription] = 'Cancer Speciality Hospital';
          signInData[variable.strEmail] = 'apollo@sample.com';
          signInData[variable.straddressLine1] =
              widget.arguments.confirmAddressDescription == null
                  ? ''
                  : widget.arguments.confirmAddressDescription == null
                      ? ''
                      : widget.arguments.confirmAddressDescription;
          signInData[variable.straddressLine2] =
              address.addressLine == null ? '' : address.addressLine;
          signInData[variable.strCity] =
              address.locality == null ? '' : address.locality;
          signInData[variable.strState] =
              address.adminArea == null ? '' : address.adminArea;
          signInData[variable.strzipCode] =
              address.postalCode == null ? '' : address.postalCode;
          signInData[variable.strbranch] = '';
          signInData[variable.strIsUserDefined] = true;
          signInData[variable.strLatitude] =
              widget.arguments.placeDetail.lat == null
                  ? 0.0
                  : widget.arguments.placeDetail.lat;
          signInData[variable.strLongitute] =
              widget.arguments.placeDetail.lng == null
                  ? 0.0
                  : widget.arguments.placeDetail.lng;
          signInData[variable.strwebsite] =
              widget.arguments.placeDetail.website;
          signInData[variable.strgoogleMapUrl] =
              widget.arguments.placeDetail.url;

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
                  title: Text(variable.strError),
                  content: Text(variable.choose_address),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 24.0.sp,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        } else {
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait); //

          signInData[variable.strName] = doctorController.text.toString();
          signInData[variable.strPhoneNumbers] =
              widget.arguments.placeDetail == null
                  ? ''
                  : widget.arguments.placeDetail.formattedPhoneNumber == null
                      ? ''
                      : widget.arguments.placeDetail.formattedPhoneNumber;
          signInData[variable.strDescription] = 'Cancer Speciality Hospital';
          signInData[variable.strEmail] = 'apollo@sample.com';
          signInData[variable.straddressLine1] =
              widget.arguments.confirmAddressDescription == null
                  ? ''
                  : widget.arguments.confirmAddressDescription == null
                      ? ''
                      : widget.arguments.confirmAddressDescription;
          signInData[variable.straddressLine2] = address == null
              ? ''
              : address.addressLine == null ? '' : address.addressLine;
          signInData[variable.strCity] = address == null
              ? ''
              : address.locality == null ? '' : address.locality;
          signInData[variable.strState] = address == null
              ? ''
              : address.adminArea == null ? '' : address.adminArea;
          signInData[variable.strzipCode] = address == null
              ? ''
              : address.postalCode == null ? '' : address.postalCode;
          signInData[variable.strbranch] = '';
          signInData[variable.strIsUserDefined] = true;
          signInData[variable.strLatitude] =
              widget.arguments.placeDetail.lat == null
                  ? 0.0
                  : widget.arguments.placeDetail.lat;
          signInData[variable.strLongitute] =
              widget.arguments.placeDetail.lng == null
                  ? 0.0
                  : widget.arguments.placeDetail.lng;
          signInData[variable.strwebsite] = widget.arguments.placeDetail == null
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

  Future<Widget> getDialogBoxWithFamilyMemberScrap(
      FamilyMemberResult familyData) {
    return new FamilyListView(familyData)
        .getDialogBoxWithFamilyMember(familyData, context, _keyLoader,
            (context, userId, userName, profilePic) {
      USERID = userId;
      selectedFamilyMemberName = userName;
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      updatedProfilePic = profilePic;
      Navigator.pop(context);
      setState(() {});
      //Navigator.pop(context);
      /* PreferenceUtil.saveString(Constants.KEY_USERID, userId).then((onValue) {
        //getUserProfileData();
        Navigator.pop(context);
        CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

        getUserProfileWithId();
      });*/
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
          if (route.settings.name == router.rt_UserAccounts) {
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
          selectedFamilyMemberName = profileData.result.firstName;
        });
      });
    });
  }

  Widget getProfilePicWidget(String profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.network(
            profilePicThumbnail,
            height: 30.0.h,
            width: 30.0.h,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 30.0.h,
            width: 30.0.h,
          );
  }

  navigateToRefresh() {
    Navigator.popUntil(context, (Route<dynamic> route) {
      bool shouldPop = false;
      var routeClassName = '';
      routeClassName = router.rt_UserAccounts;
      if (route.settings.name == routeClassName) {
        shouldPop = true;
      }
      return shouldPop;
    });
    widget.arguments.isRefresh();
  }

  void showDialogForDoctor() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(variable.strDisableTeleconsulting),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    teleHealthAlertShown = true;
                    _addBtnTapped();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  Widget getDropDownWithCategoriesdrop() {
    return FutureBuilder(
        future: _mediaTypeBlock.getMediTypesList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: new CircularProgressIndicator(
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
            );
          }
          MediaDataList mediaType = snapshot.data;
          mediaType.result.insert(
              0, new MediaResult(name: 'ALL', isChecked: false, id: '1'));
          mediaType.result.insert(
              1, new MediaResult(name: 'Devices', isChecked: false, id: '2'));

          List<MediaResult> mediaResultFiltered =
              removeUnwantedCategories(mediaType);

          setTheValuesForDropdown(mediaResultFiltered);
          return DropdownWithCategories(
            mediaData: mediaResultFiltered,
            onChecked: (result) {
              addSelectedcategoriesToList(result);
            },
          );
        });
  }

  void setTheValuesForDropdown(List<MediaResult> result) {
    if (selectedCategories != null && selectedCategories.length > 0) {
      for (MediaResult mediaResultObj in result) {
        if (selectedCategories.contains(mediaResultObj.id)) {
          mediaResultObj.isChecked = true;
        }
      }
    }
  }

  void addSelectedcategoriesToList(List<MediaResult> result) {
    selectedCategories = new List();
    for (MediaResult mediaResultObj in result) {
      if (!selectedCategories.contains(mediaResultObj.id) &&
          mediaResultObj.isChecked) {
        selectedCategories.add(mediaResultObj.id);
      }
    }
  }

  List<MediaResult> removeUnwantedCategories(MediaDataList mediaType) {
    List<MediaResult> mediaResultDuplicate = new List();
    for (int i = 0; i < mediaType.result.length; i++) {
      print(mediaType.result[i].name + ' ***********************');
      if (mediaType.result[i].name != Constants.STR_FEEDBACK &&
          mediaType.result[i].name != Constants.STR_CLAIMSRECORD &&
          mediaType.result[i].name != Constants.STR_WEARABLES &&
          mediaType.result[i].name != Constants.STR_TELEHEALTH) {
        if (!mediaResultDuplicate.contains(mediaType.result[i])) {
          mediaResultDuplicate.add(mediaType.result[i]);
        }
      }
    }
    return mediaResultDuplicate;
  }
}
