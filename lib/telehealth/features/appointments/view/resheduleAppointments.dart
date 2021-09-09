import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/my_providers/models/GetDoctorsByIdModel.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/DoctorSessionTimeSlot.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

import 'package:myfhb/constants/fhb_constants.dart' as prefKey;
import 'package:myfhb/common/errors_widget.dart';

class ResheduleAppointments extends StatefulWidget {
  Past doc;
  bool isFromNotification;
  bool isReshedule;
  bool isFromFollowUpApp;
  Function(String) closePage;
  dynamic body;

  ResheduleAppointments(
      {this.doc,
      this.isReshedule,
      this.closePage,
      this.isFromNotification,
      this.isFromFollowUpApp,
      this.body});

  @override
  _ResheduleAppointmentsState createState() => _ResheduleAppointmentsState();
}

class _ResheduleAppointmentsState extends State<ResheduleAppointments> {
  DateTime _selectedValue = DateTime.now();
  CommonWidgets commonWidgets = CommonWidgets();
  AppointmentsCommonWidget appointmentsCommonWidget =
      AppointmentsCommonWidget();
  MyProviderViewModel providerViewModel = MyProviderViewModel();
  List<DoctorIds> doctorIdsList = new List();
  DoctorIds docs = DoctorIds();
  bool noData = false;
  String placeHolder = null;
  ProvidersBloc _providersBloc = ProvidersBloc();
  DoctorResult doctors = DoctorResult();
  DateTime onUserChangedDate;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    getDoctorsData();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'TeleHealth Reshedule Appointment Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  getDoctorsData() async {
    await _providersBloc
        .getDoctorsById(doctorId: widget.doc.doctor.id)
        .then((value) => setState(() {
              doctors = value.result;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.sh * 0.12),
          child: getAppBar(doctors)),
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
              child: widget.doc.healthOrganization.id != null && doctors != null
                  ? getHospitalProviderList(widget.doc.doctor.id)
                  : Container())
        ],
      )),
    );
  }

  Widget getAppBar(DoctorResult doctors) {
    return AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor())
                ],
                    stops: [
                  0.3,
                  1.0
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24.0.sp,
                        ),
                        onTap: () {
                          //Add code for tapping back
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          doctors?.user?.profilePicThumbnailUrl != null
                              ? doctors.user.profilePicThumbnailUrl
                              : ''),
                      radius: 20,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              doctors?.user?.name != null
                                  ? doctors.user.name
                                  : '',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: variable.font_poppins,
                                  fontSize: 16.0.sp,
                                  color: Colors.white)),
                          Text(
                            (doctors?.doctorProfessionalDetailCollection !=
                                        null &&
                                    doctors.doctorProfessionalDetailCollection
                                            .length >
                                        0)
                                ? doctors?.doctorProfessionalDetailCollection[0]
                                            ?.specialty !=
                                        null
                                    ? doctors?.doctorProfessionalDetailCollection[0]
                                                ?.specialty?.name !=
                                            null
                                        ? '${doctors.doctorProfessionalDetailCollection[0].specialty.name}'
                                        : ''
                                    : ''
                                : '',
                            style: TextStyle(
                                fontFamily: variable.font_poppins,
                                fontSize: 14.0.sp,
                                color: Colors.white),
                          ),
                          Text(
                            '' + getCity(doctors),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: variable.font_poppins,
                                fontSize: 14.0.sp,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Widget providerListWidget(List<HealthOrganizationResult> hospitalList) {
    return (hospitalList != null && hospitalList.length > 0)
        ? new ListView.builder(
            itemBuilder: (BuildContext ctx, int i) =>
                hospitalListItem(ctx, i, hospitalList),
            itemCount: hospitalList.length,
          )
        : Container(
            child: Center(
              child: Text(variable.strNoHospitaldata),
            ),
          );
  }

  Widget hospitalListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return ExpandableNotifier(
      child: Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 12, right: 12, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFe3e2e2),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Expandable(
          collapsed: collapseListItem(ctx, i, docs),
          expanded: expandedListItem(ctx, i, docs),
        ),
      ),
    );
  }

  Widget collapseListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: ExpandableButton(
          child: getHospitalWidget(i, docs, doctors, i),
        ));
  }

  Widget expandedListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: 1.sw,
      child: ExpandableButton(
        child: Column(
          children: [
            getHospitalWidget(i, docs, doctors, i),
            commonWidgets.getSizedBox(20.0),
            DoctorSessionTimeSlot(
                date: _selectedValue.toString(),
                doctorId: widget.doc.doctor.id,
                docs: null,
                docsReschedule: [doctors],
                isReshedule: widget.isReshedule,
                i: i,
                doctorsData: widget.doc,
                healthOrganizationId: widget.doc.healthOrganization.id,
                healthOrganizationResult: docs,
                resultFromHospitalList: [],
                doctorListPos: 0,
                closePage: (value) {
                  widget.closePage(value);
                },
                refresh: () {
                  setState(() {});
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    onUserChangedDate = DateTime.parse(value);
                  });
                },
                onUserChangedDate: onUserChangedDate,
                isFromNotification: widget.isFromNotification,
                isFromHospital: false,
                body: widget.body,
                isFromFollowOrReschedule: true,
                isFromFollowUpApp: widget.isFromFollowUpApp,
                isFromFollowUpTake: widget.doc.isFollowUpTaken),
          ],
        ),
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getHospitalWidget(
      int i,
      List<HealthOrganizationResult> eachHospitalModel,
      DoctorResult doctors,
      int index) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          child: ClipOval(
              child: eachHospitalModel != null
                  ? eachHospitalModel[i] != null
                      ? Container(
                          height: 50.0.h,
                          width: 50.0.h,
                          color: Color(fhbColors.bgColorContainer),
                          child: Center(
                            child: Text(
                              eachHospitalModel[i].healthOrganization != null
                                  ? eachHospitalModel[i]
                                              .healthOrganization
                                              .name !=
                                          null
                                      ? eachHospitalModel[i]
                                          .healthOrganization
                                          .name[0]
                                          .toUpperCase()
                                      : ''
                                  : '',
                              style: TextStyle(
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor())),
                            ),
                          ))
                      : Container(
                          height: 50.0.h,
                          width: 50.0.h,
                          color: Color(fhbColors.bgColorContainer),
                        )
                  : Container(
                      height: 50.0.h,
                      width: 50.0.h,
                      color: Color(fhbColors.bgColorContainer),
                    )),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0.h),
              AutoSizeText(
                eachHospitalModel[i].healthOrganization.name != null
                    ? toBeginningOfSentenceCase(
                        eachHospitalModel[i].healthOrganization.name)
                    : '',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 5.0.h),
              AutoSizeText(
                (doctors.doctorProfessionalDetailCollection != null &&
                        doctors.doctorProfessionalDetailCollection.length > 0)
                    ? doctors.doctorProfessionalDetailCollection[0].specialty !=
                            null
                        ? doctors.doctorProfessionalDetailCollection[0]
                                    .specialty.name !=
                                null
                            ? doctors.doctorProfessionalDetailCollection[0]
                                .specialty.name
                            : ''
                        : ''
                    : '',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.lightgraycolor),
              ),
              SizedBox(height: 5.0.h),
              AutoSizeText(
                '' + commonWidgets.getCity(eachHospitalModel[i]) == ''
                    ? getCity(doctors)
                    : '',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.lightgraycolor),
              ),
              SizedBox(height: 5.0.h),
            ],
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: TextWidget(
                          text: 'INR ' +
                              commonWidgets.getMoneyWithForamt(widget
                                      .isReshedule
                                  ? 0.toString()
                                  : (widget.isFromFollowUpApp &&
                                          widget.doc.isFollowUpTaken == false)
                                      ? followUpFee(eachHospitalModel[i])
                                      : getFees(eachHospitalModel[i], false)),
//                                  widget.doc.plannedFollowupDate == null
//                                          ? getFees(eachHospitalModel[i])
//                                          : widget.doc.doctorFollowUpFee != null
//                                              ? widget.doc.doctorFollowUpFee
//                                              : getFees(eachHospitalModel[i])),
                          fontsize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          colors: Color(new CommonUtil().getMyPrimaryColor())),
                    ),
                  ),
                  SizedBox(height: 5),
                  widget.isReshedule || widget.isFromFollowUpApp
                      ? SizedBox.shrink()
                      : getCSRDiscount(getFees(eachHospitalModel[i], true))
                ],
              ),
            )),
      ],
    );
  }

  Widget getCSRDiscount(String fees) {
    Widget widget;
    if (fees != null && fees != '') {
      if (fees != '0.00' && fees != '0') {
        try {
          fees = new CommonUtil()
              .doubleWithoutDecimalToInt(double.parse(fees))
              .toString();
        } catch (e) {
          widget = SizedBox.shrink();
        }
        widget = Container(
          child: Center(
            child: Text('Discount ' + fees + '%',
                style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
                textAlign: TextAlign.center),
          ),
        );
      } else {
        widget = SizedBox.shrink();
      }
    } else {
      widget = SizedBox.shrink();
    }
    return widget;
  }

  String followUpFee(value) {
    if (widget.doc?.plannedFollowupDate != null &&
        widget.doc?.doctorFollowUpFee != null) {
      if (onUserChangedDate != null) {
        if (onUserChangedDate
                .difference(DateTime.parse(widget.doc.plannedFollowupDate))
                .inDays <=
            0) {
          return widget.doc.doctorFollowUpFee;
        } else {
          return getFees(value, false);
        }
      } else if (widget.doc?.plannedFollowupDate == null) {
        return getFees(value, false);
      } else {
        if (DateTime.now()
                .difference(DateTime.parse(widget.doc.plannedFollowupDate))
                .inDays <=
            0) {
          return widget.doc.doctorFollowUpFee;
        } else {
          return getFees(value, false);
        }
      }
    } else {
      return getFees(value, false);
    }
  }

  String getFees(HealthOrganizationResult result, bool isCSRDiscount) {
    String fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection.length; i++) {
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          bool isActive = result.doctorFeeCollection[i].isActive;
          if (isCSRDiscount) {
            if (feesCode == CSR_DISCOUNT && isActive == true) {
              fees = result?.doctorFeeCollection[i]?.fee;
            }
          } else {
            if (feesCode == CONSULTING && isActive == true) {
              fees = result?.doctorFeeCollection[i]?.fee;
            }
          }
        }
      } else {
        fees = '';
      }
    } else {
      fees = '';
    }
    return fees;
  }

  String getCity(DoctorResult doctors) {
    String city;

    if (doctors?.user?.userAddressCollection3 != null) {
      if (doctors.user.userAddressCollection3.length > 0) {
        if (doctors.user.userAddressCollection3[0].city != null) {
          city = doctors.user.userAddressCollection3[0].city.name;
        } else {
          city = '';
        }
      } else {
        city = '';
      }
    } else {
      city = '';
    }
    return city;
  }

  Widget getHospitalProviderList(String doctorId) {
    return new FutureBuilder<HealthOrganizationModel>(
      future: providerViewModel.getHealthOrgFromDoctor(doctorId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          List<HealthOrganizationResult> healthOrganizationResult =
              snapshot.data.result;
          healthOrganizationResult.retainWhere((element) =>
              element.healthOrganization.id ==
              widget.doc.healthOrganization.id);
          return (snapshot?.data?.isSuccess != null &&
                  !snapshot?.data?.isSuccess &&
                  (snapshot?.data?.message ?? '').isNotEmpty)
              ? Container(
                  child: Center(
                    child: Text(snapshot?.data?.message),
                  ),
                )
              : providerListWidget(healthOrganizationResult);
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return CommonCircularIndicator();
        }
      },
    );
  }
}
