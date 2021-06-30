import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/Slots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/DoctorSessionTimeSlot.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/common/errors_widget.dart';

class HealthOrganization extends StatefulWidget {
  final List<Doctors> doctors;
  final int index;
  Function(String) closePage;

  @override
  _HealthOrganizationState createState() => _HealthOrganizationState();

  HealthOrganization({this.doctors, this.index, this.closePage}) {}
}

class _HealthOrganizationState extends State<HealthOrganization> {
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
    mInitialTime = DateTime.now();
    super.initState();
    getDataForProvider();
    _providersBloc = new ProvidersBloc();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Health Organization Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.sh * 0.12),
          child: getDoctorBar(widget.doctors, widget.index)),
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
          ? providerListWidget(providerViewModel.healthOrganizationResult)
          : getHospitalProviderList(widget.doctors[widget.index].id),
    );
  }

  Widget getDoctorBar(List<Doctors> doctors, int index) {
    return AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
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
                  ClipOval(
                    child: Image.network(
                        doctors[index].user.profilePicThumbnailUrl != null
                            ? doctors[index].user.profilePicThumbnailUrl
                            : '',
                        height: 40.0.h,
                        width: 40.0.h,
                        fit: BoxFit.cover, errorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                      return Container(
                        height: 40.0.h,
                        width: 40.0.h,
                        color: Colors.grey[200],
                        child: Center(
                          child: commonWidgets
                              .getFirstLastNameText(doctors[index]),
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                      child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        commonWidgets
                            .setDoctornameForTabBar(doctors[index].user),
                        Text(
                          (doctors[index].doctorProfessionalDetailCollection !=
                                      null &&
                                  doctors[index]
                                          .doctorProfessionalDetailCollection
                                          .length >
                                      0)
                              ? doctors[index]
                                          .doctorProfessionalDetailCollection[0]
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
                        ),
                        Text(
                          '' +
                              commonWidgets.getCityDoctorsModel(doctors[index]),
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
        ));
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
        child: getHospitalWidget(
            i, docs, widget.doctors[widget.index], widget.index),
      ),
    );
  }

  Widget expandedListItem(
      BuildContext ctx, int i, List<HealthOrganizationResult> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: 1.sw,
      child: ExpandableButton(
        child: Column(
          children: [
            getHospitalWidget(
                i, docs, widget.doctors[widget.index], widget.index),
            commonWidgets.getSizedBox(20.0),
            DoctorSessionTimeSlot(
              date: _selectedValue.toString(),
              doctorId: widget.doctors[widget.index].id,
              docs: widget.doctors,
              isReshedule: false,
              i: i,
              healthOrganizationId: docs[i].healthOrganization.id,
              healthOrganizationResult: docs,
              resultFromHospitalList: [],
              doctorListPos: widget.index,
              onChanged: (value) {},
              closePage: (value) {
                widget.closePage(value);
                Navigator.pop(context);
              },
              refresh: () {
                print('okok');
                setState(() {});
              },
              isFromHospital: false,
              isFromFollowOrReschedule: false,
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
          radius: 20,
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
          width: 20.0.w,
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
                    ? commonWidgets
                        .getCityDoctorsModel(widget.doctors[widget.index])
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
                          text: INR +
                              commonWidgets.getMoneyWithForamt(
                                  getFees(eachHospitalModel[i], false)),
                          fontsize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          colors: Color(new CommonUtil().getMyPrimaryColor())),
                    ),
                  ),
                  SizedBox(height: 5),
                  getCSRDiscount(getFees(eachHospitalModel[i], true))
                ],
              ),
            )),
      ],
    );
  }

  void getDataForProvider() async {
    if (firstTym == false) {
      firstTym = true;
      providerViewModel = new MyProviderViewModel();
    }
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

  String getFees(HealthOrganizationResult result, bool isCSRDiscount) {
    String fees = '';
    if (result?.doctorFeeCollection?.isNotEmpty) {
      if (result?.doctorFeeCollection?.length > 0) {
        for (int i = 0; i < result?.doctorFeeCollection?.length; i++) {
          String feesCode = result?.doctorFeeCollection[i]?.feeType?.code;
          bool isActive = result?.doctorFeeCollection[i]?.isActive;
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

  Widget getHospitalProviderList(String doctorId) {
    return new FutureBuilder<List<HealthOrganizationResult>>(
      future: providerViewModel.getHealthOrgFromDoctor(doctorId),
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
}
