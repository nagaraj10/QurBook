import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:myfhb/add_providers/controller/add_providers_controller.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view/create_ticket_screen.dart';

import '../widgets/dropdown_with_categories.dart';
import '../../src/blocs/Media/MediaTypeBlock.dart';
import '../../src/model/Media/media_data_list.dart';
import '../../src/model/Media/media_result.dart';
import '../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/add_providers_bloc.dart';
import '../bloc/update_providers_bloc.dart';
import '../models/add_providers_arguments.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/screens/FamilyListView.dart';
import '../../my_providers/models/Doctors.dart';
import '../../my_providers/models/HospitalModel.dart';
import '../../my_providers/models/LaborartoryModel.dart';
import '../../search_providers/bloc/doctors_list_block.dart';
import '../../search_providers/bloc/hospital_list_block.dart';
import '../../search_providers/bloc/labs_list_block.dart';
import '../../search_providers/models/doctors_data.dart';
import '../../search_providers/models/hospital_data.dart';
import '../../search_providers/models/lab_data.dart';
import '../../src/blocs/User/MyProfileBloc.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/colors_utils.dart';
import '../../telehealth/features/MyProvider/view/CommonWidgets.dart';
import '../../telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';

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
  final List<Marker> _markers = [];

  double latitude = 0;
  double longtiude = 0;

  String addressLine1 = '';
  String addressLine2 = '';

  LatLng center = LatLng(0, 0);
  LatLng lastMapPosition;

  CommonWidgets commonWidgets = CommonWidgets();

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

  FlutterToast toast = FlutterToast();

  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  MyProviderViewModel providerViewModel;
  bool teleHealthAlertShown = false;
  String USERID, switchedUserId;
  MyProfileModel myProfile;
  String updatedProfilePic;
  MediaTypeBlock _mediaTypeBlock;

  List<String> selectedCategories = [];

  bool labBookAppointmentBtnShown = false;
  final controller = Get.put(AddProvidersController());

  @override
  void initState() {
    try {
      mInitialTime = DateTime.now();
      super.initState();

      addProvidersBloc = AddProvidersBloc();
      updateProvidersBloc = UpdateProvidersBloc();

      _familyListBloc = FamilyListBloc();
      _familyListBloc.getFamilyMembersListNew();

      _myProfileBloc = MyProfileBloc();
      _doctorsListBlock = DoctorsListBlock();
      _hospitalListBlock = HospitalListBlock();
      _labsListBlock = LabsListBlock();
      providerViewModel = MyProviderViewModel();
      if (widget?.arguments?.data?.isTelehealthEnabled != null) {
        teleHealthAlertShown = widget.arguments.data.isTelehealthEnabled;
      }

      if (_mediaTypeBlock == null) {
        _mediaTypeBlock = MediaTypeBlock();
        _mediaTypeBlock.getMediTypesList();
      }

      if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
        selectedCategories = widget?.arguments?.doctorsModel?.sharedCategories;
      }
      if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        selectedCategories =
            widget?.arguments?.hospitalsModel?.sharedCategories;
      }
      if (widget.arguments.searchKeyWord == CommonConstants.labs) {
        selectedCategories = widget?.arguments?.labsModel?.sharedCategories;
        if (widget.arguments.fromClass == router.rt_myprovider) {
          getTicketList();
          labBookAppointmentBtnShown = true;
        }
      }

      buildUI();
    } catch (e) {
      print(e);
    }
  }

  getTicketList() async {
    await controller.getTicketTypesList();
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
              ? (widget.arguments.fromClass == router.rt_myprovider
                      ? variable.Update
                      : variable.Add) +
                  ' ' +
                  widget.arguments.searchKeyWord
                      .substring(0, widget.arguments.searchKeyWord.length - 1)
              : '',
          style: TextStyle(
            fontSize: 18.0.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Obx(
        () {
          return controller.isLoadingProgress.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  constraints: BoxConstraints.expand(),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 20, top: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                  visible: widget.arguments.hasData == false
                                      ? true
                                      : false,
                                  child: Text(
                                    widget.arguments.hasData == false
                                        ? (widget.arguments.fromClass ==
                                                    router.rt_myprovider
                                                ? variable.Update
                                                : variable.Add) +
                                            ' ' +
                                            widget.arguments.searchKeyWord
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
                                        activeTrackColor: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                        activeColor: Color(
                                            CommonUtil().getMyPrimaryColor()),
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
                              if (isPreferred)
                                (widget.arguments.searchKeyWord ==
                                        CommonConstants.labs)
                                    ? Container()
                                    : getDropDownWithCategoriesdrop()
                              else
                                Container(),
                              Visibility(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _showCancelButton(),
                                    _showAddButton()
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: labBookAppointmentBtnShown
                                      ? 90.0.h
                                      : 20.0.h),
                            ],
                          ),
                        ),
                      ),
                      callAddDoctorProvidersStreamBuilder(addProvidersBloc),
                      callAddHospitalProvidersStreamBuilder(addProvidersBloc),
                      callAddLabProvidersStreamBuilder(addProvidersBloc),
                    ],
                  )),
                );
        },
      ),
      bottomSheet: Obx(
        () {
          return controller.isLoadingProgress.value
              ? SizedBox.shrink()
              : Visibility(
                  visible: labBookAppointmentBtnShown,
                  child: showLabBookAppointmentButton());
        },
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
    USERID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    switchedUserId = USERID;
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
          doctorController.text = widget.arguments.hospitalData.name != null
              ? widget?.arguments?.hospitalData?.name
                  ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.hospitalData.healthOrganizationName)
              : widget.arguments.hospitalData.healthOrganizationName;
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
      } else if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        doctorController.text = widget.arguments.hospitalsModel.name != null
            ? widget?.arguments?.hospitalsModel?.name
                ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.hospitalsModel.name)
            : '';
        isPreferred = widget.arguments.hospitalsModel.isDefault;
        myprovidersPreferred = widget.arguments.hospitalsModel.isDefault;

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
              CameraPosition(target: center, zoom: 12, bearing: 45, tilt: 45)));
        }
      });
    } catch (e) {}
  }

  getCurrentLocation() async {
    final currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
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
            CameraPosition(target: center, zoom: 12, bearing: 45, tilt: 45)));
      }
    });
  }

  getAddressesFromCoordinates() async {
    var coordinates = Coordinates(
        widget.arguments.placeDetail.lat, widget.arguments.placeDetail.lng);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    address = addresses.first;
  }

  Future addMarker() async {
    final markerIcon = await getBytesFromAsset(ImageUrlUtils.markerImg, 50);
    final descriptor = BitmapDescriptor.fromBytes(markerIcon);

    _markers.clear();

    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(center.toString()),
        position: center,
        infoWindow: InfoWindow(
          title: addressLine1 ?? '',
          snippet: addressLine2 ?? '',
        ),
        icon: descriptor,
      ));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    var data = await rootBundle.load(path);
    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    var fi = await codec.getNextFrame();
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
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait);

          if (_familyListBloc != null) {
            _familyListBloc = null;
            _familyListBloc = FamilyListBloc();
          }
          _familyListBloc.getFamilyMembersListNew().then((familyMembersList) {
            // Hide Loading
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            if (familyMembersList != null &&
                familyMembersList.result != null &&
                familyMembersList.result?.sharedByUsers?.length > 0) {
              getDialogBoxWithFamilyMemberScrap(familyMembersList.result);
            } else {
              toast.getToast(Constants.NO_DATA_FAMIY_CLONE, Colors.black54);
            }
          });
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: UnconstrainedBox(
              child: Container(
            padding: EdgeInsets.all(5),
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
                                    ? myProfile.result?.lastName.toUpperCase()
                                    : selectedFamilyMemberName[0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            )
                      : myProfile != null
                          ? myProfile?.result != null
                              ? myProfile?.result?.profilePicThumbnailUrl !=
                                      null
                                  ? getProfilePicWidget(
                                      myProfile.result.profilePicThumbnailUrl)
                                  : Center(
                                      child: Text(
                                        selectedFamilyMemberName == null
                                            ? myProfile?.result?.lastName
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
                                        ? myProfile?.result != null
                                            ? myProfile?.result.lastName ?? ''
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
                        ? myProfile?.result?.id ==
                                primaryUserProfile?.result?.id
                            ? variable.Self
                            : myProfile?.result?.firstName
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextField(
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: doctorController,
        keyboardType: TextInputType.emailAddress,
        //focusNode: _doctorFocus,
        textInputAction: TextInputAction.done,
        //autofocus: true,
        enabled: false,
        //widget.arguments.fromClass == router.rt_myprovider ? false : true,
        onSubmitted: (term) {
          _doctorFocus.unfocus();
        },
        style: TextStyle(
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
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _showAddButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _addBtnTapped,
      child: Container(
        width: 100.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.arguments.fromClass == router.rt_myprovider
                ? variable.Update
                : variable.Add,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  Widget _showCancelButton() {
    final loginButtonWithGesture = GestureDetector(
      onTap: _cancelBtnTapped,
      child: Container(
        width: 100.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: ColorUtils.greycolor,
          borderRadius: BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorUtils.greycolor.withOpacity(0.2),
              blurRadius: 100,
              offset: Offset(0, 100),
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.Cancel,
            style: TextStyle(
              color: ColorUtils.blackcolor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: loginButtonWithGesture);
  }

  Widget showLabBookAppointmentButton() {
    final labBookAppointmentWithGesture = InkWell(
      onTap: () {
        try {
          labBookAppointmentBtnTapped();
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        //width: 100.0.w,
        height: 45.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.bookAnAppointment,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: labBookAppointmentWithGesture);
  }

  labBookAppointmentBtnTapped() async {
    try {
      var createTicketController = Get.put(CreateTicketController());
      createTicketController.labBookAppointment.value = true;
      createTicketController.selPrefLab.value =
          CommonUtil().validString(widget.arguments.labsModel.name);
      createTicketController.selPrefLabId.value =
          CommonUtil().validString(widget.arguments.labsModel.id);
      createTicketController.labsList = widget.arguments.labsDataList;
      if (createTicketController.labsList?.length > 0) {
        await createTicketController.getLabList(updateLab: true);
      } else {
        await createTicketController.getLabList(updateLab: false);
      }

      if (controller.labTicketTypesResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CreateTicketScreen(controller.labTicketTypesResult)),
        );
      } else {
        FlutterToast().getToast(
            '${CommonUtil().validString(strNoTicketTypesAvaliable)}',
            Colors.red);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget callAddDoctorProvidersStreamBuilder(AddProvidersBloc bloc) {
    return StreamBuilder(
        stream: addProvidersBloc.doctorsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            updateProvidersBloc.isPreferred = isPreferred;
            updateProvidersBloc.providerId =
                snapshot.data.data.response.data.id;
            updateDoctorsIdWithUserDetails();

            CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  Widget callAddHospitalProvidersStreamBuilder(AddProvidersBloc bloc) {
    return StreamBuilder(
        stream: addProvidersBloc.hospitalsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            updateProvidersBloc.isPreferred = isPreferred;
            updateProvidersBloc.providerId =
                snapshot.data.data.response.data.id;
            updateHospitalsIdWithUserDetails();

            CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  Widget callAddLabProvidersStreamBuilder(AddProvidersBloc bloc) {
    return StreamBuilder(
        stream: addProvidersBloc.labsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          if (snapshot.data.status == Status.COMPLETED) {
            updateProvidersBloc.isPreferred = isPreferred;
            updateProvidersBloc.providerId =
                snapshot.data.data.response.data.id;
            updateLabsIdWithUserDetails();

            CommonUtil().getMedicalPreference();

            return Container();
          } else {
            return Container();
          }
        });
  }

  updateDoctorsIdWithUserDetails() {
    updateProvidersBloc
        .updateDoctorsIdWithUserDetails(isPAR: false)
        .then((value) {
      var routeClassName = '';

      if (widget.arguments.fromClass == router.cn_AddProvider ||
          widget.arguments.fromClass == router.rt_myprovider) {
        routeClassName = router.rt_UserAccounts;
      } else if (widget.arguments.fromClass == router.rt_TelehealthProvider) {
        routeClassName = router.rt_TelehealthProvider;
      }

      Navigator.popUntil(context, (route) {
        var shouldPop = false;
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

      Navigator.popUntil(context, (route) {
        var shouldPop = false;
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

      Navigator.popUntil(context, (route) {
        var shouldPop = false;
        if (route.settings.name == routeClassName) {
          shouldPop = true;
        }
        return shouldPop;
      });
    });
  }

  void _addBtnTapped() {
    providerViewModel.userID = switchedUserId;
    updateProvidersBloc.userId = switchedUserId;
    if (widget.arguments.hasData ||
        widget.arguments.fromClass == router.rt_myprovider) {
      if (widget.arguments.fromClass == router.rt_myprovider &&
          switchedUserId == USERID) {
        //  if (myprovidersPreferred) {
        // alert
//          Alert.displayAlertPlain(context,
//              title: variable.Error, content: variable.preferred_descrip);
//        } else {

        CommonUtil.showLoadingDialog(
            context, _keyLoader, variable.Please_Wait); //

        updateProvidersBloc.isPreferred = isPreferred;
        updateProvidersBloc.selectedCategories = isPreferred
            ? selectedCategories != null && selectedCategories.isNotEmpty
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
              if (switchedUserId != USERID) {
                updateProvidersBloc.providerId =
                    widget.arguments.doctorsModel.id;
                updateProvidersBloc.providerReferenceId = null;
              } else {
                updateProvidersBloc.providerId = widget.arguments.data.doctorId;
                updateProvidersBloc.providerReferenceId =
                    widget.arguments.data.doctorReferenceId;
              }
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
            if (switchedUserId != USERID) {
              updateProvidersBloc.providerId =
                  widget.arguments.hospitalsModel.id;
              updateProvidersBloc.providerReferenceId = null;
            } else {
              updateProvidersBloc.providerId =
                  widget.arguments.hospitalData.healthOrganizationId;
              updateProvidersBloc.providerReferenceId =
                  widget.arguments.hospitalData.healthOrganizationReferenceId;
            }
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
            if (switchedUserId != USERID) {
              updateProvidersBloc.providerId = widget.arguments.labsModel.id;
              updateProvidersBloc.providerReferenceId = null;
            } else {
              updateProvidersBloc.providerId =
                  widget.arguments.labData.healthOrganizationId;
              updateProvidersBloc.providerReferenceId =
                  widget.arguments.labData.healthOrganizationReferenceId;
            }
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
      final signInData = {};

      if (widget.arguments.searchKeyWord == CommonConstants.doctors) {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (context) {
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
          signInData[variable.strCity] =
              address == null ? '' : address.locality ?? '';
          signInData[variable.strState] =
              address == null ? '' : address.adminArea ?? '';
          signInData[variable.strPhoneNumbers] =
              widget.arguments.placeDetail == null
                  ? ''
                  : widget.arguments.placeDetail.formattedPhoneNumber ?? '';
          signInData[variable.strEmail] = '';
          signInData[variable.strIsUserDefined] = true;
          signInData[variable.strLatitude] =
              widget.arguments.placeDetail.lat ?? 0.0;

          signInData[variable.strLongitute] =
              widget.arguments.placeDetail.lng ?? 0.0;
          signInData['sharedCategories'] = selectedCategories;
          final jsonString = convert.jsonEncode(signInData);

          addProvidersBloc.doctorsJsonString = jsonString;
          addProvidersBloc.addDoctors();
        }
      } else if (widget.arguments.searchKeyWord == CommonConstants.hospitals) {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (context) {
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
                  : widget.arguments.placeDetail.formattedPhoneNumber ?? '';
          signInData[variable.strDescription] = 'Cancer Speciality Hospital';
          signInData[variable.strEmail] = 'apollo@sample.com';
          signInData[variable.straddressLine1] =
              widget.arguments.confirmAddressDescription == null
                  ? ''
                  : widget.arguments.confirmAddressDescription ?? '';
          signInData[variable.straddressLine2] = address.addressLine ?? '';
          signInData[variable.strCity] = address.locality ?? '';
          signInData[variable.strState] = address.adminArea ?? '';
          signInData[variable.strzipCode] = address.postalCode ?? '';
          signInData[variable.strbranch] = '';
          signInData[variable.strIsUserDefined] = true;
          signInData[variable.strLatitude] =
              widget.arguments.placeDetail.lat ?? 0.0;
          signInData[variable.strLongitute] =
              widget.arguments.placeDetail.lng ?? 0.0;
          signInData[variable.strwebsite] =
              widget.arguments.placeDetail.website;
          signInData[variable.strgoogleMapUrl] =
              widget.arguments.placeDetail.url;

          final jsonString = convert.jsonEncode(signInData);

          addProvidersBloc.hospitalsJsonString = jsonString;
          addProvidersBloc.addHospitals();
        }
      } else {
        if (address == null || widget.arguments.placeDetail == null) {
          showDialog(
              context: context,
              builder: (context) {
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
                  : widget.arguments.placeDetail.formattedPhoneNumber ?? '';
          signInData[variable.strDescription] = 'Cancer Speciality Hospital';
          signInData[variable.strEmail] = 'apollo@sample.com';
          signInData[variable.straddressLine1] =
              widget.arguments.confirmAddressDescription == null
                  ? ''
                  : widget.arguments.confirmAddressDescription ?? '';
          signInData[variable.straddressLine2] =
              address == null ? '' : address.addressLine ?? '';
          signInData[variable.strCity] =
              address == null ? '' : address.locality ?? '';
          signInData[variable.strState] =
              address == null ? '' : address.adminArea ?? '';
          signInData[variable.strzipCode] =
              address == null ? '' : address.postalCode ?? '';
          signInData[variable.strbranch] = '';
          signInData[variable.strIsUserDefined] = true;
          signInData[variable.strLatitude] =
              widget.arguments.placeDetail.lat ?? 0.0;
          signInData[variable.strLongitute] =
              widget.arguments.placeDetail.lng ?? 0.0;
          signInData[variable.strwebsite] = widget.arguments.placeDetail == null
              ? ''
              : widget.arguments.placeDetail.website ?? '';

          final jsonString = convert.jsonEncode(signInData);
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
    return FamilyListView(familyData)
        .getDialogBoxWithFamilyMember(familyData, context, _keyLoader,
            (context, userId, userName, profilePic) {
      switchedUserId = userId;
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
    var _myProfileBloc = MyProfileBloc();

    await _myProfileBloc
        .getMyProfileData(Constants.KEY_USERID_MAIN)
        .then((profileData) {
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE_MAIN, profileData)
          .then((value) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        Navigator.popUntil(context, (route) {
          var shouldPop = false;
          if (route.settings.name == router.rt_UserAccounts) {
            shouldPop = true;
          }
          return shouldPop;
        });
      });
    });
  }

  void getUserProfileWithId() {
    final _myProfileBloc = MyProfileBloc();

    _myProfileBloc.getMyProfileData(Constants.KEY_USERID).then((profileData) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
          .then((value) {
        CommonUtil().getMedicalPreference();

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
    Navigator.popUntil(context, (route) {
      var shouldPop = false;
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
        builder: (context) {
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
            return CommonCircularIndicator();
          }
          final MediaDataList mediaType = snapshot.data;
          mediaType.result
              .insert(0, MediaResult(name: 'ALL', isChecked: false, id: '1'));
          mediaType.result.insert(
              1, MediaResult(name: 'Devices', isChecked: false, id: '2'));

          final mediaResultFiltered = removeUnwantedCategories(mediaType);

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
    if (selectedCategories != null && selectedCategories.isNotEmpty) {
      for (var mediaResultObj in result) {
        if (selectedCategories.contains(mediaResultObj.id)) {
          mediaResultObj.isChecked = true;
        }
      }
    }
  }

  void addSelectedcategoriesToList(List<MediaResult> result) {
    selectedCategories = [];
    for (final mediaResultObj in result) {
      if (!selectedCategories.contains(mediaResultObj.id) &&
          mediaResultObj.isChecked) {
        selectedCategories.add(mediaResultObj.id);
      }
    }
  }

  List<MediaResult> removeUnwantedCategories(MediaDataList mediaType) {
    final mediaResultDuplicate = List<MediaResult>();
    for (var i = 0; i < mediaType.result.length; i++) {
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
