import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:myfhb/my_providers/models/MyProviderResponseData.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/AvailableTimeSlotsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/Slots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import '../../SearchWidget/view/SearchWidget.dart';
import 'healthOrganization/HealthOrganization.dart';

class MyProviders extends StatefulWidget {
  Function(String) closePage;
  @override
  _MyProvidersState createState() => _MyProvidersState();

  MyProviders({this.closePage});
}

class _MyProvidersState extends State<MyProviders> {
  MyProviderViewModel providerViewModel;
  int selectedPosition = 0;
  bool firstTym = false;
  String doctorsName;
  CommonWidgets commonWidgets = new CommonWidgets();
  bool isSearch = false;

  List<DoctorIds> doctorData = new List();
  List<Doctors> doctors = new List();

  List<AvailableTimeSlotsModel> doctorTimeSlotsModel =
      new List<AvailableTimeSlotsModel>();
  List<SlotSessionsModel> sessionTimeModel = new List<SlotSessionsModel>();
  List<Slots> slotsModel = new List<Slots>();
  ProvidersBloc _providersBloc;
  MyProvidersResponse myProvidersResponseList;
  List<Doctors> copyOfdoctorsModel;

  @override
  void initState() {
    super.initState();
    getDataForProvider();
    _providersBloc = new ProvidersBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
          children: [
            SearchWidget(
              onChanged: (doctorsName) {
                if (doctorsName != '' && doctorsName.length > 3) {
                  isSearch = true;
                  onSearchedNew(doctorsName);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
            Expanded(
              child: myProvidersResponseList != null ??
                      myProvidersResponseList.isSuccess
                  ? myProviderList(myProvidersResponseList)
                  : getDoctorProviderListNew(),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            Navigator.pushNamed(context, router.rt_SearchProvider,
                arguments: SearchArguments(
                  searchWord: CommonConstants.doctors,
                  fromClass: router.cn_teleheathProvider,
                )).then((value) {
              providerViewModel.doctorIdsList = null;
              setState(() {});
            });
          },
          child: Icon(
            Icons.add,
            color: Color(new CommonUtil().getMyPrimaryColor()),
            size: 24.0.sp,
          ),
        ));
  }

  /*Widget collapseListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ExpandableButton(
        child: getDoctorsWidget(i, docs),
      ),
    );
  }

  Widget expandedListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: 1.sw,
      child: ExpandableButton(
        child: Column(
          children: [
            getDoctorsWidget(i, docs),
            commonWidgets.getSizedBox(20.0),
          ],
        ),
      ),
    );
  }*/

  /*Widget getDoctorsWidget(int i, List<DoctorIds> docs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImageNew(
                  docs[i].profilePicThumbnailURL, fhbStyles.cardClipImage),
            ),
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: commonWidgets.getDoctorStatusWidget(docs[i], i),
            )
          ],
        ),
        commonWidgets.getSizeBoxWidth(10.0),
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
                      commonWidgets.getTextForDoctors('${docs[i].name}'),
                      commonWidgets.getSizeBoxWidth(10.0),
                      commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            commonWidgets.showDoctorDetailView(
                                docs[i], context);
                          }),
                    ],
                  )),
                  docs[i].isActive
                      ? commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.check_circle,
                          onTap: () {})
                      : SizedBox(),
                  commonWidgets.getSizeBoxWidth(15.0),
                  commonWidgets.getBookMarkedIcon(docs[i], () {}),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: (docs[i].professionalDetails != null &&
                            docs[i].professionalDetails.length > 0)
                        ? docs[i].professionalDetails[0].specialty != null
                            ? docs[i].professionalDetails[0].specialty.name !=
                                    null
                                ? commonWidgets.getDoctoSpecialist(
                                    '${docs[i].professionalDetails[0].specialty.name}')
                                : SizedBox()
                            : SizedBox()
                        : SizedBox()),
                docs[i].fees != null
                    ? docs[i].fees.consulting != null
                        ? (docs[i].fees.consulting != null &&
                                docs[i].fees.consulting != '')
                            ? commonWidgets.getDoctoSpecialist(
                                'INR ${docs[i].fees.consulting.fee}')
                            : SizedBox()
                        : SizedBox()
                    : SizedBox(),
                commonWidgets.getSizeBoxWidth(10.0),
              ]),
              commonWidgets.getSizedBox(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child:
                          commonWidgets.getDoctorsAddress('${docs[i].city}')),
                  docs[i].isMCIVerified
                      ? commonWidgets.getMCVerified(
                          docs[i].isMCIVerified, STR_MY_VERIFIED)
                      : commonWidgets.getMCVerified(
                          docs[i].isMCIVerified, STR_NOT_VERIFIED),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }*/

  void getDataForProvider() async {
    if (firstTym == false) {
      firstTym = true;
      providerViewModel = new MyProviderViewModel();
    }
  }

  onSearched(String doctorName) {
    doctorData.clear();
    if (doctorName != null) {
      for (DoctorIds fiterData
          in providerViewModel.getFilterDoctorList(doctorName)) {
        doctorData.add(fiterData);
      }
    }

    setState(() {});
  }

  onSearchedNew(String doctorName) async {
    doctors.clear();
    if (doctorName != null) {
      doctors = await _providersBloc.getFilterDoctorListNew(doctorName);
    }
    setState(() {});
  }

  Widget getFees(DoctorIds doctorId) {
    return doctorId.fees != null
        ? commonWidgets.getHospitalDetails(doctorId.fees.consulting != null
            ? variable.strRs + ' ' + doctorId.fees.consulting.fee
            : '')
        : Text('');
  }

  Widget getDoctorProviderListNew() {
    return new FutureBuilder<MyProvidersResponse>(
      future: _providersBloc.getMedicalPreferencesList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor())),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          final items = snapshot.data ??
              <MyProvidersResponseData>[]; // handle the case that data is null

          return (snapshot.data != null &&
                  snapshot.data.result != null &&
                  snapshot.data.result.doctors != null &&
                  snapshot.data.result.doctors.length > 0)
              ? myProviderList(snapshot.data)
              : Container(
                  child: Center(
                  child: Text(variable.strNoDoctordata),
                ));
        }
      },
    );
  }

  Widget myProviderList(MyProvidersResponse myProvidersResponse) {
    if (myProvidersResponse != null && myProvidersResponse.isSuccess) {
      copyOfdoctorsModel = myProvidersResponse?.result?.doctors;
      final ids = copyOfdoctorsModel.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel.retainWhere((x) => ids.remove(x?.user?.id));
      return ListView.separated(
        itemBuilder: (BuildContext context, index) => providerDoctorItemWidget(
            index, isSearch ? doctors : copyOfdoctorsModel),
        separatorBuilder: (BuildContext context, index) {
          return Divider(
            height: 0.0.h,
            color: Colors.transparent,
          );
        },
        itemCount: isSearch ? doctors.length : copyOfdoctorsModel.length,
      );
    } else {
      return Container(
        child: Center(
          child: Text(variable.strNoDoctordata),
        ),
      );
    }
  }

  Widget providerDoctorItemWidget(int i, List<Doctors> docs) {
    return InkWell(
      onTap: () {
        navigateToHelathOrganizationList(context, docs, i);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: commonWidgets.getClipOvalImageNew(docs[i]),
                ),
                new Positioned(
                  bottom: 0.0,
                  right: 2.0,
                  child: commonWidgets.getDoctorStatusWidgetNew(docs[i], i),
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
                          commonWidgets.setDoctorname(docs[i].user),
                          commonWidgets.getSizeBoxWidth(10.0.w),
                          commonWidgets.getIcon(
                              width: fhbStyles.imageWidth,
                              height: fhbStyles.imageHeight,
                              icon: Icons.info,
                              onTap: () {
                                commonWidgets.showDoctorDetailViewNew(
                                    docs[i], context);
                              }),
                        ],
                      )),
                      commonWidgets.getSizeBoxWidth(10.0.w),
                      commonWidgets.getBookMarkedIconNew(docs[i], () {
                        providerViewModel
                            .bookMarkDoctor(docs[i], false, 'ListItem')
                            .then((status) {
                          if (status) {
                            setState(() {});
                          }
                        });
                      }),
                      commonWidgets.getSizeBoxWidth(15.0.w),
                      docs[i].isTelehealthEnabled
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
                        child: (docs[i].doctorProfessionalDetailCollection !=
                                    null &&
                                docs[i]
                                        .doctorProfessionalDetailCollection
                                        .length >
                                    0)
                            ? docs[i]
                                        .doctorProfessionalDetailCollection[0]
                                        .specialty !=
                                    null
                                ? docs[i]
                                            .doctorProfessionalDetailCollection[
                                                0]
                                            .specialty
                                            .name !=
                                        null
                                    ? commonWidgets.getDoctoSpecialist(
                                        '${docs[i].doctorProfessionalDetailCollection[0].specialty.name}')
                                    : SizedBox()
                                : SizedBox()
                            : SizedBox()),
                    commonWidgets.getSizeBoxWidth(10.0.w),
                  ]),
                  commonWidgets.getSizedBox(5.0.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        '' + commonWidgets.getCityDoctorsModel(docs[i]),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.grey[600],
                            fontSize: fhbStyles.fnt_city),
                      )),
                      docs[i].isMciVerified
                          ? commonWidgets.getMCVerified(
                              docs[i].isMciVerified, STR_MY_VERIFIED)
                          : commonWidgets.getMCVerified(
                              docs[i].isMciVerified, STR_NOT_VERIFIED),
                      commonWidgets.getSizeBoxWidth(10.0.w),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToHelathOrganizationList(
      BuildContext context, List<Doctors> docs, int i) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HealthOrganization(
            doctors: docs,
            index: i,
            closePage: (value) {
              widget.closePage(value);
            },
          ),
        ));
  }
}
