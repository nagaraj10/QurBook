import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:intl/intl.dart';
import '../../add_providers/models/add_providers_arguments.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../bloc/labs_list_block.dart';
import '../models/doctor_list_response_new.dart';
import '../models/hospital_list_response_new.dart';
import '../models/labs_list_response_new.dart';
import '../models/search_arguments.dart';
import '../services/doctors_list_repository.dart';
import '../../src/blocs/health/HealthReportListForUserBlock.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/colors_utils.dart';
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

import '../bloc/doctors_list_block.dart';
import '../bloc/hospital_list_block.dart';

export '../models/hospital_list_response.dart';

class SearchSpecificList extends StatefulWidget {
  SearchArguments arguments;

  bool toPreviousScreen;
  bool isSkipUnknown;

  SearchSpecificList(
      {this.arguments, this.toPreviousScreen, this.isSkipUnknown});

  @override
  State<StatefulWidget> createState() {
    return SearchSpecificListState();
  }
}

class SearchSpecificListState extends State<SearchSpecificList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  DoctorsListBlock _doctorsListBlock;

  HospitalListBlock _hospitalListBlock;

  LabsListBlock _labsListBlock;

  final TextEditingController _textFieldController =
      TextEditingController(text: '');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String value;

  final mobileNoController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();

  final nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();

  final firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();

  final lastNameController = TextEditingController();
  FocusNode lastNameFocus = FocusNode();

  final specializationController = TextEditingController();
  FocusNode specializationFocus = FocusNode();

  final hospitalNameController = TextEditingController();
  FocusNode hospitalNameFocus = FocusNode();

  DoctorsListRepository doctorsListRepository = DoctorsListRepository();

  var _selected = Country.IN;
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    _doctorsListBlock = DoctorsListBlock();
    _hospitalListBlock = HospitalListBlock();
    _labsListBlock = LabsListBlock();

    _healthReportListForUserBlock = HealthReportListForUserBlock();

    value = _textFieldController.text.toString();

    if (value != '') {
      _doctorsListBlock.getDoctorsListNew(
          _textFieldController.text.toString() ?? '', widget.isSkipUnknown);
    } else {
      if (widget.arguments.searchWord == CommonConstants.doctors) {
        _doctorsListBlock.getExistingDoctorList('40');
      } else if (widget.arguments.searchWord == CommonConstants.hospitals) {
        _hospitalListBlock
            .getExistingHospitalListNew(Constants.STR_HEALTHORG_HOSPID);
      } else if (widget.arguments.searchWord == CommonConstants.labs) {
        _labsListBlock.getExistingLabsListNew(Constants.STR_HEALTHORG_LABID);
      }
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Search List Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          flexibleSpace: GradientAppBar(),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              Navigator.pop(context, [1]);
            },
          ),
          title: Text('${widget.arguments.searchWord} ' + variable.strSearch)),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Column(
        children: <Widget>[
          Container(
            //margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(CommonUtil().getMyPrimaryColor()),
                    Color(CommonUtil().getMyGredientColor())
                  ],
                  stops: [
                    0.3,
                    1
                  ]),
            ),
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            //margin: EdgeInsets.all(5),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
                controller: _textFieldController,
                autofocus: true,
                onChanged: (editedValue) {
                  if (editedValue != '') {
                    value = editedValue;
                    widget.arguments.searchWord == CommonConstants.doctors
                        ? _doctorsListBlock.getDoctorsListNew(
                            value, widget.isSkipUnknown)
                        : widget.arguments.searchWord ==
                                CommonConstants.hospitals
                            ? _hospitalListBlock.getHospitalListNew(value)
                            : _labsListBlock.getLabsListNew(value);
                    setState(() {});
                  } else {
                    widget.arguments.searchWord == CommonConstants.doctors
                        ? _doctorsListBlock.getExistingDoctorList('50')
                        : widget.arguments.searchWord ==
                                CommonConstants.hospitals
                            ? _hospitalListBlock.getExistingHospitalListNew(
                                Constants.STR_HEALTHORG_HOSPID)
                            : _labsListBlock.getExistingLabsListNew(
                                Constants.STR_HEALTHORG_LABID);
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  hintText: variable.strSearch,
                  hintStyle:
                      TextStyle(color: Colors.black54, fontSize: 16.0.sp),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
              child: value == ''
                  ?
                  //getEmptyCard()
                  /* Container(
                      child: Center(
                        child: Text(variable.strNodata),
                      ),
                    )*/
                  widget.arguments.searchWord == CommonConstants.doctors
                      ? getResponseFromApiWidgetForDoctors()
                      : widget.arguments.searchWord == CommonConstants.hospitals
                          ? getResponseFromApiWidgetForHospital()
                          : getResponseFromApiWidgetForLabs()
                  : widget.arguments.searchWord == CommonConstants.doctors
                      ? getResponseFromApiWidgetForDoctors()
                      : widget.arguments.searchWord == CommonConstants.hospitals
                          ? getResponseFromApiWidgetForHospital()
                          : getResponseFromApiWidgetForLabs()),
        ],
      ),
    );
  }

  Widget getResponseFromApiWidgetForDoctors() {
    return StreamBuilder<ApiResponse<DoctorsSearchListResponse>>(
      stream: _doctorsListBlock.doctorsNewStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CommonCircularIndicator(),
              width: 30.0.h,
              height: 30.0.h,
            ));

            break;

          case Status.ERROR:
            rebuildBlockObject();
            return Text(
                variable.strNoDataAvailable + ' ' + CommonConstants.doctors,
                style: TextStyle(color: Colors.red));
            break;

          case Status.COMPLETED:
            rebuildBlockObject();
            return (snapshot.data.data.isSuccess == false &&
                    widget.isSkipUnknown == true)
                ? Container(
                    margin: EdgeInsets.all(5),
                    child: getAllDatasInDoctorsListScrap(snapshot.data.data),
                  )
                : (snapshot.data.data.result == null)
                    ? Container(
                        child: Center(
                          child: Text(variable.strNodata),
                        ),
                      )
                    //getEmptyCard()
                    : snapshot.data.data.result.isEmpty
                        ? Container(
                            child: Center(
                              child: Text(variable.strNodata),
                            ),
                          )
                        //getEmptyCard()
                        : Container(
                            margin: EdgeInsets.all(5),
                            child: getAllDatasInDoctorsList(
                                snapshot.data.data.result),
                          );
            break;
        }
      },
    );
  }

  Widget getResponseFromApiWidgetForHospital() {
    return StreamBuilder<ApiResponse<HospitalsSearchListResponse>>(
      stream: _hospitalListBlock.hospitalNewStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              width: 30.0.h,
              height: 30.0.h,
              child: CommonCircularIndicator(),
            ));

            break;

          case Status.ERROR:
            rebuildBlockObject();
            return Text(
                variable.strNoDataAvailable + ' ' + CommonConstants.hospitals,
                style: TextStyle(color: Colors.red));
            break;

          case Status.COMPLETED:
            rebuildBlockObject();

            return snapshot.data.data.result == null
                ? Container(
                    child: Center(
                      child: Text(variable.strNodata),
                    ),
                  )
                //getEmptyCard()
                : snapshot.data.data.result.isEmpty
                    ? Container(
                        child: Center(
                          child: Text(variable.strNodata),
                        ),
                      )
                    //getEmptyCard()
                    : Container(
                        child: getAllDatasInHospitalList(
                            snapshot.data.data.result),
                        margin: EdgeInsets.all(5),
                      );
            break;
        }
      },
    );
  }

  Widget getResponseFromApiWidgetForLabs() {
    return StreamBuilder<ApiResponse<LabsSearchListResponse>>(
      stream: _labsListBlock.labNewStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              width: 30.0.h,
              height: 30.0.h,
              child: CommonCircularIndicator(),
            ));

            break;

          case Status.ERROR:
            rebuildBlockObject();
            return Text(
                variable.strNoDataAvailable + ' ' + CommonConstants.labs,
                style: TextStyle(color: Colors.red));
            break;

          case Status.COMPLETED:
            rebuildBlockObject();
            return snapshot.data.data.result == null
                ? Container(
                    child: Center(
                      child: Text(variable.strNodata),
                    ),
                  )
                //getEmptyCard()
                : snapshot.data.data.result.isEmpty
                    ? Container(
                        child: Center(
                          child: Text(variable.strNodata),
                        ),
                      )
                    //getEmptyCard()
                    : Container(
                        margin: EdgeInsets.all(5),
                        child: getAllDatasInLabsList(snapshot.data.data.result),
                      );

            break;

          default:
            break;
        }
      },
    );
  }

  void rebuildBlockObject() {
    _doctorsListBlock = null;
    _doctorsListBlock = DoctorsListBlock();

    _hospitalListBlock = null;
    _hospitalListBlock = HospitalListBlock();

    _labsListBlock = null;
    _labsListBlock = LabsListBlock();
  }

  Widget getEmptyCard(Diagnostics diagnostics) {
    return !widget.toPreviousScreen
        ? Center(
            child: Text(
              'No Records Found ',
              style: TextStyle(
                color: ColorUtils.blackcolor,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Records Found ',
                  style: TextStyle(
                    color: ColorUtils.blackcolor,
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                fhbBasicWidget.getSaveButton(() {
                  if (widget.toPreviousScreen) {
                    widget.arguments.searchWord == CommonConstants.doctors
                        ? saveMediaDialog(context)
                        : widget.arguments.searchWord ==
                                CommonConstants.hospitals
                            ? passHospitalValue(null, context)
                            : passLaboratoryValue(null, context);
                  }
                }, text: 'Click here to add', width: 150.w),
              ],
            ),
          );
  }

  Future<void> _refresh() async {
    await _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 300));
  }

  Widget _showAddButton(Diagnostics diagnostics) {
    final loginButtonWithGesture = GestureDetector(
      onTap: () {
        if (widget.toPreviousScreen) {
          widget.arguments.searchWord == CommonConstants.doctors
              ? passDoctorsValue(diagnostics.errorData, context)
              : widget.arguments.searchWord == CommonConstants.hospitals
                  ? passHospitalValue(null, context)
                  : passLaboratoryValue(null, context);
        }
      },
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
            'Click Here',
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
        child: loginButtonWithGesture);
  }

  Widget getAllDatasInDoctorsList(List<DoctorsListResult> data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: data != null
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      (data[i].name != null && data[i].name != '')
                          ? data[i]?.name?.capitalizeFirstofEach
                          : data[i]?.firstName?.capitalizeFirstofEach +
                              ' ' +
                              data[i]?.lastName?.capitalizeFirstofEach,
                      getDoctorsAddress(data[i]),
                      data[i].doctorId,
                      data[i].profilePicThumbnailUrl,
                      data[i],
                      HospitalsListResult(),
                      LabListResult()),
                ),
                itemCount: data.length,
              ))
          : Container(
              color: Color(fhbColors.bgColorContainer),
              child: Center(
                child: Text(variable.strNodata),
              ),
            ),
    );
  }

  Widget getAllDatasInDoctorsListScrap(DoctorsSearchListResponse data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: (data.isSuccess == false &&
              widget.isSkipUnknown == true &&
              data?.diagnostics?.errorData != null)
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: getEmptyCard(data.diagnostics),
            )
          : data.result != null
              ? Container(
                  color: Color(fhbColors.bgColorContainer),
                  child: ListView.builder(
                    itemBuilder: (c, i) => Container(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: getCardToDisplaySearchList(
                          (data.result[i].name != null &&
                                  data.result[i].name != '')
                              ? data?.result[i]?.name?.capitalizeFirstofEach
                              : data?.result[i]?.firstName
                                      ?.capitalizeFirstofEach +
                                  ' ' +
                                  data?.result[i]?.lastName
                                      ?.capitalizeFirstofEach,
                          getDoctorsAddress(data.result[i]),
                          data.result[i].doctorId,
                          data.result[i].profilePicThumbnailUrl,
                          data.result[i],
                          HospitalsListResult(),
                          LabListResult()),
                    ),
                    itemCount: data.result.length,
                  ))
              : Container(
                  color: Color(fhbColors.bgColorContainer),
                  child: Center(
                    child: Text(variable.strNodata),
                  ),
                ),
    );
  }

  getAllDatasInHospitalList(List<HospitalsListResult> data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: data != null
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      data[i].healthOrganizationName,
                      data[i].addressLine1,
                      data[i].healthOrganizationId ??
                          data[i].healthOrganizationReferenceId,
                      null,
                      DoctorsListResult(),
                      data[i],
                      LabListResult(),
                      cityAndState: getHospitalCityAndState(data[i])),
                ),
                itemCount: data.length,
              ))
          : Container(
              color: Color(fhbColors.bgColorContainer),
              child: Center(
                child: Text(variable.strNodata),
              ),
            ),
    );
  }

  Widget getAllDatasInLabsList(List<LabListResult> data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: data != null
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      data[i].healthOrganizationName,
                      data[i].addressLine1,
                      data[i].healthOrganizationId ??
                          data[i].healthOrganizationReferenceId,
                      '',
                      DoctorsListResult(),
                      HospitalsListResult(),
                      data[i]),
                ),
                itemCount: data.length,
              ))
          : Container(
              color: Color(fhbColors.bgColorContainer),
              child: Center(
                child: Text(variable.strNodata),
              ),
            ),
    );
  }

  Widget getCardToDisplaySearchList(
      String name,
      String address,
      String id,
      String logo,
      DoctorsListResult data,
      HospitalsListResult hospitalData,
      LabListResult labData,
      {String cityAndState}) {
    return GestureDetector(
        child: Padding(
            padding: EdgeInsets.only(bottom: 4, left: 10, right: 10),
            child: Container(
                padding: EdgeInsets.only(bottom: 2),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: <Widget>[
                  SizedBox(
                    width: 10.0.w,
                  ),
                  ClipOval(
                      child: Container(
                    height: 50.0.h,
                    width: 50.0.h,
                    color: Color(fhbColors.bgColorContainer),
                    child:
                        widget.arguments.searchWord == CommonConstants.doctors
                            ? getHospitalLogoImage(logo, data)
                            : getHospitalLogoImage(logo, data),
                  )),
                  SizedBox(width: 10.0.w),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: getDataToView(
                            widget.arguments.searchWord ==
                                    CommonConstants.doctors
                                ? name
                                : widget.arguments.searchWord ==
                                        CommonConstants.hospitals
                                    ? hospitalData.healthOrganizationName
                                    : labData.healthOrganizationName,
                            address,
                            id,
                            data),
                      ))
                ]))),
        onTap: () {
          if (widget.toPreviousScreen) {
            widget.arguments.searchWord == CommonConstants.doctors
                ? passDoctorsValue(data, context)
                : widget.arguments.searchWord == CommonConstants.hospitals
                    ? passHospitalValue(hospitalData, context)
                    : passLaboratoryValue(labData, context);
          } else {
            passdataToNextScreen(data?.name.capitalizeFirstofEach, context,
                data, hospitalData, labData);
          }
        });
  }

  getCorrespondingImageWidget(String id) {
    return Icon(Icons.verified_user);
  }

  void passDoctorsValue(DoctorsListResult doctorData, BuildContext context) {
    Navigator.of(context).pop({Constants.keyDoctor: json.encode(doctorData)});
  }

  void passHospitalValue(
      HospitalsListResult hospitaData, BuildContext context) {
    Navigator.of(context)
        .maybePop({Constants.keyHospital: json.encode(hospitaData)});
  }

  void passLaboratoryValue(LabListResult laboratoryData, BuildContext context) {
    Navigator.of(context).pop({Constants.keyLab: json.encode(laboratoryData)});
  }

  getDataToView(String name, String address, String id, DoctorsListResult data,
      {String cityAndState}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          name != null ? name.capitalizeFirstofEach : '',
          style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
              color: ColorUtils.blackcolor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10.0.h),
        if (address != null)
          Text(
            address,
            style: TextStyle(
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.lightgraycolor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        if (cityAndState != null)
          Text(
            cityAndState,
            style: TextStyle(
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.lightgraycolor),
          ),
        widget.arguments.searchWord == CommonConstants.doctors
            ? (data.specialty != null && data.specialty != '')
                ? Text(
                    toBeginningOfSentenceCase(data.specialty ?? ''),
                    style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.lightgraycolor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : SizedBox(height: 10.0.h)
            : SizedBox(height: 10.0.h),
      ],
    );
  }

  getDoctorProfileImageWidget(String id) {
    return FutureBuilder(
      future: _healthReportListForUserBlock.getProfilePic(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            height: 50.0.h,
            width: 50.0.h,
            fit: BoxFit.cover,
          );
        } else {
          return ImageIcon(
            AssetImage(variable.icon_stetho),
            size: 40.0.sp,
            color: Color(CommonUtil().getMyPrimaryColor()),
          );
        }
      },
    );
  }

  Widget getHospitalLogoImage(String logo, DoctorsListResult docs) {
    if (logo == null || logo == '') {
      return Container();
    } else {
      return Image.network(logo,
          errorBuilder: (context, exception, stackTrace) {
        return Container(
          height: 50.0.h,
          width: 50.0.h,
          color: Colors.grey[200],
          child: Center(
            child: getFirstLastNameText(docs),
          ),
        );
      });
    }
  }

  Widget getFirstLastNameText(DoctorsListResult myProfile) {
    if (myProfile != null &&
        myProfile.firstName != null &&
        myProfile.lastName != null) {
      return Text(
        myProfile.firstName[0].toUpperCase() +
            myProfile.lastName[0].toUpperCase(),
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (myProfile != null && myProfile.firstName != null) {
      return Text(
        myProfile.firstName[0].toUpperCase(),
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w200,
        ),
      );
    }
  }

  void passdataToNextScreen(
      String name,
      BuildContext context,
      DoctorsListResult data,
      HospitalsListResult hospitalData,
      LabListResult labData) {
    if (widget.arguments.searchWord == CommonConstants.doctors) {
      Navigator.pushNamed(
        context,
        router.rt_AddProvider,
        arguments: AddProvidersArguments(
            data: data,
            searchKeyWord: CommonConstants.doctors,
            fromClass: widget.arguments.fromClass == router.cn_AddProvider
                ? widget.arguments.fromClass
                : router.rt_TelehealthProvider,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    } else if (widget.arguments.searchWord == CommonConstants.hospitals) {
      Navigator.pushNamed(
        context,
        router.rt_AddProvider,
        arguments: AddProvidersArguments(
            hospitalData: hospitalData,
            searchKeyWord: CommonConstants.hospitals,
            fromClass: widget.arguments.fromClass == router.cn_AddProvider
                ? widget.arguments.fromClass
                : router.rt_TelehealthProvider,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    } else {
      Navigator.pushNamed(
        context,
        router.rt_AddProvider,
        arguments: AddProvidersArguments(
            labData: labData,
            searchKeyWord: CommonConstants.labs,
            fromClass: widget.arguments.fromClass == router.cn_AddProvider
                ? widget.arguments.fromClass
                : router.rt_TelehealthProvider,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    }
  }

  _addBtnTapped(Diagnostics diagnostics) {
    /* Navigator.pushNamed(context, router.rt_AddProvider,
        arguments: AddProvidersArguments(
          searchText: value,
          fromClass: widget.arguments.fromClass == router.cn_AddProvider
              ? widget.arguments.fromClass
              : router.rt_TelehealthProvider,
          searchKeyWord: widget.arguments.searchWord == CommonConstants.doctors
              ? CommonConstants.doctors
              : widget.arguments.searchWord == CommonConstants.hospitals
                  ? CommonConstants.hospitals
                  : CommonConstants.labs,
          hasData: false,
        )).then((results) {
      if (results != null) {
        widget.arguments.searchWord == CommonConstants.doctors
            ? passDoctorsValueSample(results, context)
            : widget.arguments.searchWord == CommonConstants.hospitals
                ? passHospitalValueSample(results, context)
                : passLaboratoryValueSample(results, context);
      }
    });*/

    if (widget.toPreviousScreen) {
      widget.arguments.searchWord == CommonConstants.doctors
          ? passDoctorsValue(diagnostics.errorData, context)
          : widget.arguments.searchWord == CommonConstants.hospitals
              ? passHospitalValue(null, context)
              : passLaboratoryValue(null, context);
    }
  }

  passDoctorsValueSample(results, BuildContext context) {
    final DoctorsListResult jsonDecodeForDoctor = results[Constants.keyDoctor];

    passDoctorsValue(jsonDecodeForDoctor, context);
  }

  passHospitalValueSample(results, BuildContext context) {
    final HospitalsListResult jsonDecodeForDoctor =
        results[Constants.keyHospital];

    passHospitalValue(jsonDecodeForDoctor, context);
  }

  passLaboratoryValueSample(results, BuildContext context) {
    final LabListResult jsonDecodeForDoctor = results[Constants.keyLab];

    passLaboratoryValue(jsonDecodeForDoctor, context);
  }

  String getDoctorsAddress(DoctorsListResult data) {
    var address = '';
    if (data.addressLine1 != '' && data.addressLine1 != null) {
      address = toBeginningOfSentenceCase(data.addressLine1);
    }
    if (data.addressLine2 != '' && data.addressLine2 != null) {
      address = address + ',' + toBeginningOfSentenceCase(data.addressLine2);
    }
    if (data.city != '' && data.city != null) {
      address = address + '\n' + toBeginningOfSentenceCase(data.city);
    }
    if (data.state != '' && data.state != null) {
      address = address + ',' + toBeginningOfSentenceCase(data.state);
    }
    return address;
  }

  String getHospitalCityAndState(HospitalsListResult data) {
    var city = '';

    if (data.cityName != '' && data.cityName != null) {
      city = toBeginningOfSentenceCase(data.cityName);
    }
    if (data.stateName != '' && data.stateName != null) {
      city = city + ',' + toBeginningOfSentenceCase(data.stateName);
    }
    return city;
  }

  saveMediaDialog(BuildContext context) {
    firstNameController.text = _textFieldController.text;
    lastNameController.text = '';
    mobileNoController.text = '';
    specializationController.text = '';
    hospitalNameController.text = '';
    _textFieldController.text = '';

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            content: Container(
                width: 1.sw,
                height: 1.sh / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 24.0.sp,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            ),

                            Row(
                              children: <Widget>[
                                _showFirstNameTextField(),
                              ],
                            ),

                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showLastNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                CountryPicker(
                                  nameTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  dialingCodeTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  showFlag: false,
                                  //displays flag, true by default
                                  showDialingCode: true,
                                  //displays dialing code, false by default
                                  showName: false,
                                  //eg. 'GBP'
                                  onChanged: (country) {
                                    setState(() {
                                      _selected = country;
                                    });
                                  },
                                  selectedCountry: _selected,
                                ),
                                _ShowMobileNoTextField()
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),

                            Row(
                              children: <Widget>[
                                _showSpecializationTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showHospitalNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showAddDoctorButton(),
                              ],
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                            // callAddFamilyStreamBuilder(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  Widget _showFirstNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: firstNameController,
      keyboardType: TextInputType.text,
      focusNode: firstNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(firstNameFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.firstNameWithStar,
        hintText: CommonConstants.firstName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showLastNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: lastNameController,
      keyboardType: TextInputType.text,
      focusNode: lastNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        lastNameFocus.unfocus();
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.lastName,
        hintText: CommonConstants.lastName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _ShowMobileNoTextField() {
    return Expanded(
      child: TextField(
          cursorColor: Color(CommonUtil().getMyPrimaryColor()),
          controller: mobileNoController,
          enabled: true,
          keyboardType: TextInputType.text,
          focusNode: mobileNoFocus,
          textInputAction: TextInputAction.done,
          onSubmitted: (term) {
            mobileNoFocus.unfocus();
          },
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0.sp,
              color: ColorUtils.blackcolor),
          decoration: InputDecoration(
            hintText: CommonConstants.mobile_number,
            labelStyle: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.myFamilyGreyColor),
            hintStyle: TextStyle(
              fontSize: 16.0.sp,
              color: ColorUtils.myFamilyGreyColor,
              fontWeight: FontWeight.w400,
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
          )),
    );
  }

  Widget _showSpecializationTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: specializationController,
      keyboardType: TextInputType.text,
      focusNode: specializationFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(lastNameFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.specialization,
        hintText: CommonConstants.specialization,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showHospitalNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: hospitalNameController,
      keyboardType: TextInputType.text,
      focusNode: hospitalNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(specializationFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.hospitalName,
        hintText: CommonConstants.hospitalName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  _showAddDoctorButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _addDoctorToList,
      child: Container(
        width: 130.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(2)),
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
            'Add Doctor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  void _addDoctorToList() {
    final addDoctorData = {};
    final doctorReferenced = {};
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    if (firstNameController.text.trim() != '') {
      addDoctorData['firstName'] =
          toBeginningOfSentenceCase(firstNameController.text);
      addDoctorData['lastName'] = lastNameController.text.trim() == ''
          ? ''
          : toBeginningOfSentenceCase(lastNameController.text);
      addDoctorData['specialization'] =
          specializationController.text.trim() == ''
              ? null
              : specializationController.text;
      if (mobileNoController.text.trim() == '' ||
          mobileNoController.text == null) {
        addDoctorData['phoneNumber'] = mobileNoController.text.trim() == ''
            ? null
            : mobileNoController.text;
      } else {
        final phoneNumber = '+' +
            _selected.dialingCode.toString() +
            '' +
            mobileNoController.text;
        addDoctorData['phoneNumber'] = phoneNumber;
      }
      addDoctorData['hospitalName'] = hospitalNameController.text.trim() == ''
          ? null
          : hospitalNameController.text;
      addDoctorData['email'] = null;
      addDoctorData['addressLine1'] = null;
      addDoctorData['addressLine2'] = null;
      addDoctorData['city'] = null;
      addDoctorData['state'] = null;
      addDoctorData['isReferenced'] = null;
      addDoctorData['pincode'] = null;

      doctorReferenced['id'] = userid;
      addDoctorData['referredPatient'] = doctorReferenced;
      final params = json.encode(addDoctorData);
      print(params.toString());

      doctorsListRepository.addDoctorFromProvider(params).then((value) {
        Navigator.pop(context);
        passDoctorsValue(value, context);
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(variable.strAPP_NAME),
                content: Text('Enter First Name'),
              ));
    }
  }
}
