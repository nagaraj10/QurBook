import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/search_providers/bloc/labs_list_block.dart';
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/search_providers/models/hospital_list_response_new.dart';
import 'package:myfhb/search_providers/models/labs_list_response_new.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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

  TextEditingController _textFieldController =
      new TextEditingController(text: '');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String value;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    _doctorsListBlock = new DoctorsListBlock();
    _hospitalListBlock = new HospitalListBlock();
    _labsListBlock = new LabsListBlock();

    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    value = _textFieldController.text.toString();

    if (value != '') {
      _doctorsListBlock.getDoctorsListNew(
          _textFieldController.text.toString() == null
              ? ''
              : _textFieldController.text.toString(),
          widget.isSkipUnknown);
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
          new Container(
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
                  value = editedValue;
                  widget.arguments.searchWord == CommonConstants.doctors
                      ? _doctorsListBlock.getDoctorsListNew(
                          value, widget.isSkipUnknown)
                      : widget.arguments.searchWord == CommonConstants.hospitals
                          ? _hospitalListBlock.getHospitalListNew(value)
                          : _labsListBlock.getLabsListNew(value);
                  setState(() {});
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
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(new CommonUtil().getMyPrimaryColor()),
                    Color(new CommonUtil().getMyGredientColor())
                  ],
                  stops: [
                    0.3,
                    1
                  ]),
            ),
            padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          ),
          new Expanded(
              child: value == ''
                  ?
                  //getEmptyCard()
                  Container(
                      child: Center(
                        child: Text(variable.strNodata),
                      ),
                    )
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
      builder: (context,
          AsyncSnapshot<ApiResponse<DoctorsSearchListResponse>> snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
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
                    child: getAllDatasInDoctorsListScrap(snapshot.data.data),
                    margin: EdgeInsets.all(5),
                  )
                : (snapshot.data.data.result == null)
                    ? Container(
                        child: Center(
                          child: Text(variable.strNodata),
                        ),
                      )
                    //getEmptyCard()
                    : snapshot.data.data.result.length == 0
                        ? Container(
                            child: Center(
                              child: Text(variable.strNodata),
                            ),
                          )
                        //getEmptyCard()
                        : Container(
                            child: getAllDatasInDoctorsList(
                                snapshot.data.data.result),
                            margin: EdgeInsets.all(5),
                          );
            break;
        }
      },
    );
  }

  Widget getResponseFromApiWidgetForHospital() {
    return StreamBuilder<ApiResponse<HospitalsSearchListResponse>>(
      stream: _hospitalListBlock.hospitalNewStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<HospitalsSearchListResponse>> snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 30.0.h,
              height: 30.0.h,
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
                : snapshot.data.data.result.length == 0
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
      builder: (context,
          AsyncSnapshot<ApiResponse<LabsSearchListResponse>> snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 30.0.h,
              height: 30.0.h,
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
                : snapshot.data.data.result.length == 0
                    ? Container(
                        child: Center(
                          child: Text(variable.strNodata),
                        ),
                      )
                    //getEmptyCard()
                    : Container(
                        child: getAllDatasInLabsList(snapshot.data.data.result),
                        margin: EdgeInsets.all(5),
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
    _doctorsListBlock = new DoctorsListBlock();

    _hospitalListBlock = null;
    _hospitalListBlock = new HospitalListBlock();

    _labsListBlock = null;
    _labsListBlock = new LabsListBlock();
  }

  Widget getEmptyCard(Diagnostics diagnostics) {
    /*return SingleChildScrollView(
        child: Container(
      width: 1.sw,
      height: 1.sh,
      child: Center(
        child:
            */ /* Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0.h),
          Image.asset(ImageUrlUtils.fileImg, width: 65.0.w, height: 90.0.h),
          SizedBox(height: 30.0.h),
          Text(
              "Looks like the Doctor you're searching is not available in the system,please check the spelling or",
              style: new TextStyle(
                color: ColorUtils.blackcolor,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              )),
          _showAddButton(diagnostics),
          Text('to add the Doctor as',
              style: new TextStyle(
                color:  Color(CommonUtil().getMyPrimaryColor()),
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              )),
          Text('Unknown Doctor ',
              style: new TextStyle(
                color:  Color(CommonUtil().getMyPrimaryColor()),
                fontSize: 15.0.sp,
                fontWeight: FontWeight.bold,
              )),
          Text('temporarily',
              style: new TextStyle(
                color:  Color(CommonUtil().getMyPrimaryColor()),
                fontSize: 15.0.sp,
                fontWeight: FontWeight.bold,
              )),

        ],
      )*/ /*

      ),
      color: Colors.white,
    ));*/
    return Center(
      child: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
              text:
                  'Looks like the Doctor you\'re searching is not available in the system,please check the spelling or ',
              style: new TextStyle(
                color: ColorUtils.blackcolor,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            new TextSpan(
              text: 'Click here ',
              style: new TextStyle(
                  color: Color(new CommonUtil().getMyPrimaryColor())),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  if (widget.toPreviousScreen) {
                    widget.arguments.searchWord == CommonConstants.doctors
                        ? passDoctorsValue(diagnostics.errorData, context)
                        : widget.arguments.searchWord ==
                                CommonConstants.hospitals
                            ? passHospitalValue(null, context)
                            : passLaboratoryValue(null, context);
                  }
                },
            ),
            new TextSpan(
              text: ' to add the Doctor as ',
              style: new TextStyle(
                color: ColorUtils.blackcolor,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            new TextSpan(
              text: ' Unknown Doctor ',
              style: new TextStyle(
                color: ColorUtils.blackcolor,
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            new TextSpan(
              text: ' temporarily',
              style: new TextStyle(
                color: ColorUtils.blackcolor,
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 300));
  }

  Widget _showAddButton(Diagnostics diagnostics) {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: () {
        if (widget.toPreviousScreen) {
          widget.arguments.searchWord == CommonConstants.doctors
              ? passDoctorsValue(diagnostics.errorData, context)
              : widget.arguments.searchWord == CommonConstants.hospitals
                  ? passHospitalValue(null, context)
                  : passLaboratoryValue(null, context);
        }
      },
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
            'Click Here',
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
                          ? data[i].name
                          : data[i].firstName + ' ' + data[i].lastName,
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
              child: Center(
                child: Text(variable.strNodata),
              ),
              color: Color(fhbColors.bgColorContainer),
            ),
    );
  }

  Widget getAllDatasInDoctorsListScrap(DoctorsSearchListResponse data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: (data.isSuccess == false && widget.isSkipUnknown == true)
          ? Container(
              child: getEmptyCard(data.diagnostics),
              color: Color(fhbColors.bgColorContainer),
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
                              ? data.result[i].name
                              : data.result[i].firstName +
                                  ' ' +
                                  data.result[i].lastName,
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
                  child: Center(
                    child: Text(variable.strNodata),
                  ),
                  color: Color(fhbColors.bgColorContainer),
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
                      data[i].healthOrganizationId != null
                          ? data[i].healthOrganizationId
                          : data[i].healthOrganizationReferenceId,
                      null,
                      DoctorsListResult(),
                      data[i],
                      LabListResult(),
                      cityAndState: getHospitalCityAndState(data[i])),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text(variable.strNodata),
              ),
              color: Color(fhbColors.bgColorContainer),
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
                      data[i].healthOrganizationId != null
                          ? data[i].healthOrganizationId
                          : data[i].healthOrganizationReferenceId,
                      '',
                      DoctorsListResult(),
                      HospitalsListResult(),
                      data[i]),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text(variable.strNodata),
              ),
              color: Color(fhbColors.bgColorContainer),
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
            padding:
                new EdgeInsets.only(top: 0, bottom: 4, left: 10, right: 10),
            child: Container(
                padding: EdgeInsets.only(bottom: 2.0),
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
            passdataToNextScreen(
                data.name, context, data, hospitalData, labData);
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
          name != null ? name : '',
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
                    toBeginningOfSentenceCase(
                        data.specialty != null ? data.specialty : ''),
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
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
      return Image.network(logo, errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
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
          color: Color(new CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (myProfile != null && myProfile.firstName != null) {
      return Text(
        myProfile.firstName[0].toUpperCase(),
        style: TextStyle(
          color: Color(new CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: Color(new CommonUtil().getMyPrimaryColor()),
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

  passDoctorsValueSample(dynamic results, BuildContext context) {
    DoctorsListResult jsonDecodeForDoctor = results[Constants.keyDoctor];

    passDoctorsValue(jsonDecodeForDoctor, context);
  }

  passHospitalValueSample(dynamic results, BuildContext context) {
    HospitalsListResult jsonDecodeForDoctor = results[Constants.keyHospital];

    passHospitalValue(jsonDecodeForDoctor, context);
  }

  passLaboratoryValueSample(dynamic results, BuildContext context) {
    LabListResult jsonDecodeForDoctor = results[Constants.keyLab];

    passLaboratoryValue(jsonDecodeForDoctor, context);
  }

  String getDoctorsAddress(DoctorsListResult data) {
    String address = '';
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
    String city = '';

    if (data.cityName != '' && data.cityName != null) {
      city = toBeginningOfSentenceCase(data.cityName);
    }
    if (data.stateName != '' && data.stateName != null) {
      city = city + ',' + toBeginningOfSentenceCase(data.stateName);
    }
    return city;
  }
}
