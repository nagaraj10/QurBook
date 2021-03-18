import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_response.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorsFromHospitalModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/Slots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/DoctorSessionTimeSlot.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/common/errors_widget.dart';

class DoctorListFromHospital extends StatefulWidget {
  final List<Hospitals> hospitals;
  final int index;
  Function(String) closePage;

  @override
  _HealthOrganizationState createState() => _HealthOrganizationState();

  DoctorListFromHospital({this.hospitals, this.index, this.closePage}) {}
}

class _HealthOrganizationState extends State<DoctorListFromHospital> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  MyProviderViewModel providerViewModel;
  DateTime _selectedValue = DateTime.now();
  int selectedPosition = 0;
  bool firstTym = false;
  String doctorsName;
  CommonWidgets commonWidgets = new CommonWidgets();

  List<AvailableTimeSlotsModel> doctorTimeSlotsModel =
      new List<AvailableTimeSlotsModel>();
  List<SlotSessionsModel> sessionTimeModel = new List<SlotSessionsModel>();
  List<Slots> slotsModel = new List<Slots>();
  ProvidersBloc _providersBloc;
  MyProvidersResponse myProvidersResponseList;
  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  @override
  void initState() {
    super.initState();
    getDataForProvider();
    _providersBloc = new ProvidersBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.sh * 0.12),
          child: getDoctorBar(widget.hospitals, widget.index)),
      body: Container(
          child: Column(
        children: [
          getMainList(),
        ],
      )),
    );
  }

  Widget getMainList() {
    return Expanded(
      child: (providerViewModel.healthOrganizationResult != null &&
              providerViewModel.healthOrganizationResult.length > 0)
          ? providerListWidget(providerViewModel.doctorsFromHospital)
          : getHospitalProviderList(widget.hospitals[widget.index].id),
    );
  }

  Widget getDoctorBar(List<Hospitals> hospitals, int index) {
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
                      padding: EdgeInsets.only(left: 20),
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
                      width: 2.0.w,
                    ),
                    CircleAvatar(
                      radius: 20.0.sp,
                      child: ClipOval(
                          child: hospitals != null
                              ? hospitals[index] != null
                                  ? Container(
                                      height: 50.0.h,
                                      width: 50.0.h,
                                      color: Color(fhbColors.bgColorContainer),
                                      child: Center(
                                        child: Text(
                                          hospitals[index].name != null
                                              ? hospitals[index]
                                                  .name[0]
                                                  .toUpperCase()
                                              : '',
                                          style: TextStyle(
                                              color: Color(CommonUtil()
                                                  .getMyPrimaryColor())),
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
                    SizedBoxWidget(
                      width: 10.0.w,
                    ),
                    Container(
                        child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              hospitals[index].name != null
                                  ? hospitals[index].name
                                  : '',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: variable.font_poppins,
                                  fontSize: 16.0.sp,
                                  color: Colors.white)),
                          /*Text(
                                (doctors[index].doctorProfessionalDetailCollection !=
                                    null &&
                                    doctors[index]
                                        .doctorProfessionalDetailCollection
                                        .length >
                                        0)
                                    ? doctors[index]
                                    .doctorProfessionalDetailCollection[
                                0]
                                    .specialty !=
                                    null
                                    ? doctors[index]
                                    .doctorProfessionalDetailCollection[
                                0]
                                    .specialty
                                    .name !=
                                    null
                                    ? '${doctors[index].doctorProfessionalDetailCollection[0].specialty.name}'
                                    : ''
                                    : ''
                                    : '',
                                style: TextStyle(
                                    fontFamily: variable.font_poppins,
                                    fontSize: 14.0.sp,
                                    color: Colors.white),
                              ),*/
                          commonWidgets.getCityHospital(hospitals[index]) != ''
                              ? Text(
                                  commonWidgets
                                      .getCityHospital(hospitals[index]),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: variable.font_poppins,
                                      fontSize: 14.0.sp,
                                      color: Colors.white),
                                )
                              : Container(),
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

  Widget doctorListItem(
      BuildContext ctx, int i, List<ResultFromHospital> docs) {
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
      BuildContext ctx, int i, List<ResultFromHospital> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ExpandableButton(
        child: getDoctorWidget(i, docs),
      ),
    );
  }

  Widget expandedListItem(
      BuildContext ctx, int i, List<ResultFromHospital> docs) {
    return Container(
      padding: EdgeInsets.all(10.0.sp),
      width: 1.sw,
      child: ExpandableButton(
        child: Column(
          children: [
            getDoctorWidget(i, docs),
            commonWidgets.getSizedBox(20.0.h),
            DoctorSessionTimeSlot(
                date: _selectedValue.toString(),
                doctorId: docs[i].doctor.id,
                isReshedule: false,
                i: i,
                doctorListIndex: i,
                healthOrganizationId: docs[i].healthOrganization.id,
                healthOrganizationResult: [],
                resultFromHospitalList: docs,
                doctorListPos: widget.index,
                onChanged: (value) {},
                closePage: (value) {
                  widget.closePage(value);
                  Navigator.pop(context);
                },
                refresh: () {
                  setState(() {});
                },
                isFromHospital: true),
          ],
        ),
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorWidget(int i, List<ResultFromHospital> docs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImageForHos(docs[i].doctor),
            ),
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: commonWidgets.getDoctorStatusWidgetNewForHos(
                  docs[i].doctor, i),
            )
          ],
        ),
        commonWidgets.getSizeBoxWidth(10.0.w),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      commonWidgets.setDoctornameForHos(docs[i].doctor.user),
                      commonWidgets.getSizeBoxWidth(10.0.w),
                      commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            commonWidgets.showDoctorDetailViewNewForHos(
                                docs[i].doctor, context);
                          }),
                    ],
                  )),
                  commonWidgets.getSizeBoxWidth(10.0),
                  /* commonWidgets.getBookMarkedIconNew(docs[i].doctor, () {
                    providerViewModel
                        .bookMarkDoctor(docs[i].doctor, false, 'ListItem')
                        .then((status) {
                      if (status) {
                        setState(() {});
                      }
                    });
                  }),*/
                  commonWidgets.getSizeBoxWidth(15.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: TextWidget(
                                text: INR +
                                    commonWidgets
                                        .getMoneyWithForamt(getFees(docs[i])),
                                fontsize: 16.0.sp,
                                fontWeight: FontWeight.w400,
                                colors: Color(
                                    new CommonUtil().getMyPrimaryColor())),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBoxWidget(
                    width: 10,
                  ),
                  docs[i].doctor.isTelehealthEnabled
                      ? commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.check_circle,
                          onTap: () {
                            //print('on check  pressed');
                          })
                      : SizedBox(),
                  //commonWidgets.getFlagIcon(docs[i], () {})
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: (docs[i].doctor.doctorProfessionalDetailCollection !=
                                null &&
                            docs[i]
                                    .doctor
                                    .doctorProfessionalDetailCollection
                                    .length >
                                0)
                        ? docs[i]
                                    .doctor
                                    .doctorProfessionalDetailCollection[0]
                                    .specialty !=
                                null
                            ? docs[i]
                                        .doctor
                                        .doctorProfessionalDetailCollection[0]
                                        .specialty
                                        .name !=
                                    null
                                ? commonWidgets.getDoctoSpecialist(
                                    '${docs[i].doctor.doctorProfessionalDetailCollection[0].specialty.name}')
                                : SizedBox()
                            : SizedBox()
                        : SizedBox()),
                commonWidgets.getSizeBoxWidth(10.0),
              ]),
              commonWidgets.getSizedBox(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    '' +
                        commonWidgets.getCityDoctorsModelForHos(docs[i].doctor),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[600],
                        fontSize: fhbStyles.fnt_city),
                  )),
                  docs[i].doctor.isMciVerified
                      ? commonWidgets.getMCVerified(
                          docs[i].doctor.isMciVerified, STR_MY_VERIFIED)
                      : commonWidgets.getMCVerified(
                          docs[i].doctor.isMciVerified, STR_NOT_VERIFIED),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  void getDataForProvider() async {
    if (firstTym == false) {
      firstTym = true;
      providerViewModel = new MyProviderViewModel();
    }
  }

  String getFees(ResultFromHospital result) {
    String fees;
    if (result.doctorFeeCollection.isNotEmpty) {
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

  Widget getHospitalProviderList(String healthOrgId) {
    return new FutureBuilder<List<ResultFromHospital>>(
      future: providerViewModel.getDoctorsFromHospital(healthOrgId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor())),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          final items = snapshot.data ??
              <DoctorIds>[]; // handle the case that data is null

          return providerListWidget(snapshot.data);
        }
      },
    );
  }

  Widget providerListWidget(List<ResultFromHospital> doctorList) {
    return (doctorList != null && doctorList.length > 0)
        ? new ListView.builder(
            itemBuilder: (BuildContext ctx, int i) =>
                doctorListItem(ctx, i, doctorList),
            itemCount: doctorList.length,
          )
        : Container(
            child: Center(
              child: Text(variable.strNoDoctordata),
            ),
          );
  }
}
