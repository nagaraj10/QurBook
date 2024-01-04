
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseData.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/Slots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/healthOrganization/DoctorsListFromHospital.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:path/path.dart';

import '../../SearchWidget/view/SearchWidget.dart';
import 'healthOrganization/HealthOrganization.dart';
import 'package:myfhb/common/errors_widget.dart';

class MyProvidersHospitals extends StatefulWidget {
  Function(String)? closePage;
  bool? isRefresh;

  @override
  _MyProvidersState createState() => _MyProvidersState();

  MyProvidersHospitals({this.closePage, this.isRefresh});
}

class _MyProvidersState extends State<MyProvidersHospitals> {
  MyProviderViewModel providerViewModel = MyProviderViewModel();
  MyProvidersResponse? myProvidersResponseList;
  CommonWidgets commonWidgets = CommonWidgets();
  bool isSearch = false;
  late ProvidersBloc _providersBloc;
  List<Hospitals> myProviderHospitalList = [];
  List<Hospitals>? initialHospitalList = [];
  Future<MyProvidersResponse?>? _medicalPreferenceList;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    _providersBloc = ProvidersBloc();
    _medicalPreferenceList = _providersBloc.getMedicalPreferencesForHospital();
    print('init hospital');
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'MyProvider Hospitals List Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  getHospitalsList() {
    if (myProvidersResponseList != null) {
      setState(() {
        initialHospitalList = myProvidersResponseList!.result!.hospitals;
      });
    } else {
      _providersBloc.getMedicalPreferencesForHospital().then((value) {
        if ((value!.result != null &&
            value.result?.hospitals != null &&
            value.result!.hospitals!.length > 0)) {
          setState(() {
            initialHospitalList = value.result!.hospitals;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('inside build of doctors');
    if (!widget.isRefresh!) {
      providerViewModel.doctorIdsList = null;
      setState(() {
        _medicalPreferenceList =
            _providersBloc.getMedicalPreferencesForHospital();
      });
      widget.isRefresh != widget.isRefresh;
    }
    return Scaffold(
        body: Container(
          child: Column(
            children: [
              SearchWidget(
                onChanged: (hospitalsName) {
                  if (hospitalsName != '' && hospitalsName.length > 2) {
                    setState(() {
                      isSearch = true;
                      myProviderHospitalList =
                          providerViewModel.getHospitalName(
                              hospitalList: initialHospitalList!,
                              query: hospitalsName);
                    });
                  } else {
                    setState(() {
                      isSearch = false;
                    });
                  }
                },onClosePress: (){
                FocusManager.instance.primaryFocus!.unfocus();
              },
              ),
              Expanded(
                child: myProvidersResponseList != null
                    ? hospitalList(isSearch
                        ? myProviderHospitalList
                        : myProvidersResponseList!.result!.hospitals)
                    : getDoctorProviderListNew(),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () {
            FocusManager.instance.primaryFocus!.unfocus();
            Navigator.pushNamed(context, router.rt_SearchProvider,
                arguments: SearchArguments(
                  searchWord: CommonConstants.hospitals,
                  fromClass: router.cn_teleheathProvider,
                )).then((value) {
              getHospitalsList();
              _medicalPreferenceList =
                  _providersBloc.getMedicalPreferencesForHospital();
              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Color(CommonUtil().getMyPrimaryColor()),
          ),
        ));
  }

  Widget getDoctorProviderListNew() {
    return FutureBuilder<MyProvidersResponse?>(
      future: _medicalPreferenceList,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          final items = snapshot.data ??
              <MyProvidersResponseData>[];
          if(initialHospitalList!=null && initialHospitalList!.length>0){
            // handle the case that data is null
            return hospitalList(isSearch
                ? myProviderHospitalList
                : snapshot.data?.result?.hospitals);
          }
          else if (snapshot.hasData &&
              snapshot.data!.result != null &&
              snapshot.data!.result!.hospitals != null &&
              snapshot.data!.result!.hospitals!.length > 0) {
            initialHospitalList = snapshot.data!.result!.hospitals;
            if (snapshot.hasData &&
                snapshot.data!.result != null &&
                snapshot.data!.result!.clinics != null &&
                snapshot.data!.result!.clinics!.length > 0) {
              initialHospitalList!.addAll(snapshot.data!.result!.clinics!);
            }
            return hospitalList(isSearch
                ? myProviderHospitalList
                : snapshot.data!.result!.hospitals);
          } else {
            initialHospitalList = snapshot.data!.result!.hospitals;
            return Container(
                child: Center(
              child: Text(variable.strNoHospitaldata),
            ));
          }
        }
      },
    );
  }

  Widget hospitalList(List<Hospitals>? hospitalList) {
    return (hospitalList != null && hospitalList.length > 0)
        ? ListView.builder(
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
      BuildContext context, int i, List<Hospitals> hospitals) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        navigateToDoctorList(context, hospitals, i);
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 8),
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
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              child: ClipOval(
                  child: hospitals != null
                      ? hospitals[i] != null
                          ? Container(
                              height: 50.0.h,
                              width: 50.0.h,
                              color: Color(fhbColors.bgColorContainer),
                              child: Center(
                                child: Text(
                                  getHospitalName(hospitals[i])![0].toUpperCase(),
                                  style: TextStyle(
                                    color:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                    fontSize: 16.0.sp,
                                  ),
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
                //  AutoSizeText( FU2.5
                  Text( // FU2.5
                    getHospitalName(hospitals[i])!,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0.h),
                  /*AutoSizeText(
                    (doctors.doctorProfessionalDetailCollection !=
                        null &&
                        doctors.doctorProfessionalDetailCollection
                            .length > 0)
                        ? doctors.doctorProfessionalDetailCollection[0]
                        .specialty !=
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
                  ),*/
                  SizedBox(height: 5.0.h),
                  if (commonWidgets
                          .getCityHospitalAddress(hospitals[i])!
                          .length >
                      1)
                    Column(
                      children: [
                       // AutoSizeText(  FU2.5
                        Text(
                          commonWidgets.getCityHospitalAddress(hospitals[i])!,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        SizedBox(height: 5.0.h),
                      ],
                    )
                  else
                    Container(),
                  if (commonWidgets.getCityHospital(hospitals[i])!.length > 1)
                    Column(
                      children: [
                        // AutoSizeText( FU2.5
                        Text( //  FU2.5
                          commonWidgets.getCityHospital(hospitals[i])!,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.lightgraycolor),
                        ),
                        SizedBox(height: 5.0.h),
                      ],
                    )
                  else
                    Container(),
                ],
              ),
            ),
            /*Expanded(
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
                                      getFees(eachHospitalModel[i])),
                              fontsize: 14.0,
                              fontWeight: FontWeight.w400,
                              colors: Colors.blue[800]),
                        ),
                      ),
                    ],
                  ),
                )),*/
          ],
        ),
      ),
    );
  }

  navigateToDoctorList(BuildContext context, List<Hospitals> docs, int i) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorListFromHospital(
            hospitals: docs,
            index: i,
            closePage: (value) {
              widget.closePage!(value);
            },
          ),
        ));
  }
  String? getHospitalName(Hospitals eachHospitalModel) {
    String? name="";

    if (eachHospitalModel.name != null) {
      if (eachHospitalModel.name != "Self" &&
          eachHospitalModel.name != "self") {
        name = eachHospitalModel.name?.capitalizeFirstofEach;
      } else {
        if (eachHospitalModel.createdBy != null) {
          if (eachHospitalModel.createdBy!.firstName != "" &&
              eachHospitalModel.createdBy!.firstName != null) {
            name = eachHospitalModel.createdBy!.firstName;
          }
          if (eachHospitalModel.createdBy!.lastName != "" &&
              eachHospitalModel.createdBy!.lastName != null) {
            name = name! + " " + eachHospitalModel.createdBy!.lastName!;
          }
        }
      }
    }
    return name;
  }

}
