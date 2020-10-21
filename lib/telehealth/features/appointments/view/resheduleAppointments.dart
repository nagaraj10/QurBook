import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/DoctorSessionTimeSlot.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

class ResheduleAppointments extends StatefulWidget {
  Past doc;
  bool isReshedule;

  ResheduleAppointments({this.doc, this.isReshedule});

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
  Doctors doctors = Doctors();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoctorsData();
  }

  getDoctorsData() async {
    await _providersBloc
        .getMedicalPreferencesList()
        .then((value) => setState(() {
              doctors = value.result.doctors
                  .firstWhere((element) => element.id == widget.doc.doctor.id);
              print(doctors.id);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
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

  Widget appBar() {
    return AppBar(
      flexibleSpace: GradientAppBar(),
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBoxWidget(
            height: 0,
            width: 30,
          ),
          IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 20,
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      title: TextWidget(
        text: widget.doc.doctor.user.name ?? '',
        colors: Colors.white,
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontsize: 18,
        softwrap: true,
      ),
    );
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
      width: MediaQuery.of(context).size.width,
      child: ExpandableButton(
        child: Column(
          children: [
            getHospitalWidget(i, docs, doctors, i),
            commonWidgets.getSizedBox(20.0),
            DoctorSessionTimeSlot(
              date: _selectedValue.toString(),
              doctorId: widget.doc.doctor.id,
              docs: [doctors],
              isReshedule: widget.isReshedule,
              i: i,
              doctorsData: widget.doc,
              healthOrganizationId: widget.doc.healthOrganization.id,
              healthOrganizationResult: docs,
              doctorListPos: 0,
            ),
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
      Doctors doctors,
      int index) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          child: ClipOval(
              child: eachHospitalModel != null
                  ? eachHospitalModel[i] != null
                      ? Container(
                          height: 50,
                          width: 50,
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
                          height: 50,
                          width: 50,
                          color: Color(fhbColors.bgColorContainer),
                        )
                  : Container(
                      height: 50,
                      width: 50,
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
              SizedBox(height: 5),
              AutoSizeText(
                eachHospitalModel[i].healthOrganization.name != null
                    ? toBeginningOfSentenceCase(
                        eachHospitalModel[i].healthOrganization.name)
                    : '',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 5),
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
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.lightgraycolor),
              ),
              SizedBox(height: 5),
              AutoSizeText(
                '' + commonWidgets.getCity(eachHospitalModel[i]) == ''
                    ? getCity(widget.doc)
                    : '',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.lightgraycolor),
              ),
              SizedBox(height: 5),
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
                              commonWidgets.getMoneyWithForamt(
                                  widget.isReshedule
                                      ? 0.toString()
                                      : widget.doc.doctorFollowUpFee != null
                                          ? widget.doc.doctorFollowUpFee
                                          : getFees(eachHospitalModel[i])),
                          fontsize: 14.0,
                          fontWeight: FontWeight.w400,
                          colors: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  String getFees(HealthOrganizationResult result) {
    String fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection.length; i++) {
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          bool isActive = result.doctorFeeCollection[i].isActive;
          if (feesCode == CONSULTING && isActive == true) {
            fees = result.doctorFeeCollection[i].fee;
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

  getCity(Past doc) {
    String city = '';
    if (doc.doctor?.user?.userAddressCollection3[0]?.city != null) {
      city = doc.doctor?.user?.userAddressCollection3[0]?.city?.name ?? '';
    } else {
      city = '';
    }
    return city;
  }

  Widget getHospitalProviderList(String doctorId) {
    return new FutureBuilder<List<HealthOrganizationResult>>(
      future: providerViewModel.getHealthOrgFromDoctor(doctorId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        } else if (snapshot.hasData) {
          List<HealthOrganizationResult> healthOrganizationResult =
              snapshot.data;
          healthOrganizationResult.retainWhere((element) =>
              element.healthOrganization.id ==
              widget.doc.healthOrganization.id);
          return providerListWidget(healthOrganizationResult);
        } else {
          return Container();
        }
      },
    );
  }
}
