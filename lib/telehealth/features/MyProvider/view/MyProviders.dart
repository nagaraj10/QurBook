import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
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
import 'package:myfhb/widgets/GradientAppBar.dart';

import '../../SearchWidget/view/SearchWidget.dart';
import 'DoctorSessionTimeSlot.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

import 'healthOrganization/HealthOrganization.dart';

class MyProviders extends StatefulWidget {
  @override
  _MyProvidersState createState() => _MyProvidersState();
}

class _MyProvidersState extends State<MyProviders> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  MyProviderViewModel providerViewModel;
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();
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

  @override
  void initState() {
    super.initState();
    getDataForProvider();
    _providersBloc = new ProvidersBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios, // add custom icons also
              ),
            ),
            // you can put Icon as well, it accepts any widget.
            title:
                getTitle() /* Column(
            children: [
              Text("My Providers"),
            ],
          ),
          actions: [
            Icon(Icons.notifications),
            new SwitchProfile()
                .buildActions(context, _keyLoader, callBackToRefresh),
            Icon(Icons.more_vert),
          ],*/
            ),
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
              /* child: (providerViewModel.doctorIdsList != null &&
                      providerViewModel.doctorIdsList.length > 0)
                  ? providerListWidget(providerViewModel.doctorIdsList)
                  : getDoctorProviderList(),*/
              child: myProvidersResponseList != null ??
                      myProvidersResponseList.isSuccess
                  ? myProviderList(myProvidersResponseList)
                  : getDoctorProviderListNew(),
              /*:Container(
                    child: Center(
                      child: Text(variable.strNoDoctordata),
                    ),
                  ),*/
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //PageNavigator.goTo(context, '/add_appointments');

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
          ),
        ));
  }

  Widget getTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "My Providers",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(Icons.notifications),
        new SwitchProfile()
            .buildActions(context, _keyLoader, callBackToRefresh),
        // Icon(Icons.more_vert),
      ],
    );
  }

  /* Widget doctorsListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return ExpandableNotifier(
      child: Container(
        padding: EdgeInsets.all(2.0),
        margin: EdgeInsets.only(left: 20, right: 20, top: 8),
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
  }*/

  Widget collapseListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
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
      width: MediaQuery.of(context).size.width,
      child: ExpandableButton(
        child: Column(
          children: [
            getDoctorsWidget(i, docs),
            commonWidgets.getSizedBox(20.0),
            /*DoctorSessionTimeSlot(
                date: _selectedValue.toString(),
                doctorId: docs[i].id,
                docs: docs,
                isReshedule: false,
                i: i),*/
          ],
        ),
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorsWidget(int i, List<DoctorIds> docs) {
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
                            print('on Info pressed');
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
                          onTap: () {
                            print('on check  pressed');
                          })
                      : SizedBox(),
                  commonWidgets.getSizeBoxWidth(15.0),
                  commonWidgets.getBookMarkedIcon(docs[i], () {
                    /*providerViewModel
                        .bookMarkDoctor(!(docs[i].isDefault), docs[i])
                        .then((status) {
                      if (status) {
                        print('onClick');
                        providerViewModel.doctorIdsList.clear();
                        setState(() {});
                      }
                    });*/
                  }),
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
                          docs[i].isMCIVerified, 'Verified')
                      : commonWidgets.getMCVerified(
                          docs[i].isMCIVerified, 'Not Verified'),
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
      /*for (Doctors fiterData
      in _providersBloc.getFilterDoctorListNew(doctorName)) {
        doctors.add(fiterData);*/
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

  /* Widget getDoctorProviderList() {
    return new FutureBuilder<List<DoctorIds>>(
      future: providerViewModel.fetchProviderDoctors(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          final items = snapshot.data ??
              <DoctorIds>[]; // handle the case that data is null

          return providerListWidget(snapshot.data);
        }
      },
    );
  }*/

  Widget getDoctorProviderListNew() {
    return new FutureBuilder<MyProvidersResponse>(
      future: _providersBloc.getMedicalPreferencesList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(
              backgroundColor: Colors.grey,
            ),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          final items = snapshot.data ??
              <MyProvidersResponseData>[]; // handle the case that data is null

          return (snapshot.data.result.doctors != null &&
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

/*  Widget providerListWidget(List<DoctorIds> doctorList) {
    return (doctorList != null && doctorList.length > 0)
        ? new ListView.builder(
      itemBuilder: (BuildContext ctx, int i) =>
          doctorsListItem(ctx, i, isSearch ? doctorData : doctorList),
      itemCount: isSearch
          ? doctorData.length
          : providerViewModel.doctorIdsList.length,
    )
        : Container(
      child: Center(
        child: Text(variable.strNoDoctordata),
      ),
    );
  }*/

  Widget myProviderList(MyProvidersResponse myProvidersResponse) {
    return (myProvidersResponse != null && myProvidersResponse.isSuccess)
        ? ListView.separated(
            itemBuilder: (BuildContext context, index) =>
                providerDoctorItemWidget(index,
                    isSearch ? doctors : myProvidersResponse.result.doctors),
            separatorBuilder: (BuildContext context, index) {
              return Divider(
                height: 0,
                color: Colors.transparent,
              );
            },
            itemCount: isSearch
                ? doctors.length
                : myProvidersResponse.result.doctors.length,
          )
        : Container(
            child: Center(
              child: Text(variable.strNoDoctordata),
            ),
          );
  }

  Widget providerListItem(Doctors eachDoctorModel) {
    return InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 12, right: 12, top: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(fhbColors.cardShadowColor),
                  blurRadius: 16, // has the effect of softening the shadow
                  spreadRadius: 0, // has the effect of extending the shadow
                )
              ],
            ),
            child: Row(
              children: <Widget>[
                ClipOval(
                    child: eachDoctorModel.user != null
                        ? eachDoctorModel.user.profilePicThumbnailUrl != null
                            ? Image.network(
                                eachDoctorModel.user.profilePicThumbnailUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                padding: EdgeInsets.all(12),
                                color: Color(fhbColors.bgColorContainer))
                        : Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(12),
                            color: Color(fhbColors.bgColorContainer))),
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
                        eachDoctorModel.user != null
                            ? eachDoctorModel.user.name != null
                                ? toBeginningOfSentenceCase(
                                    eachDoctorModel.user.name)
                                : ''
                            : '',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 5),
                      eachDoctorModel.doctorProfessionalDetailCollection != null
                          ? AutoSizeText(
                              (eachDoctorModel.doctorProfessionalDetailCollection !=
                                          null &&
                                      eachDoctorModel
                                              .doctorProfessionalDetailCollection
                                              .length >
                                          0)
                                  ? eachDoctorModel
                                              .doctorProfessionalDetailCollection[
                                                  0]
                                              .specialty !=
                                          null
                                      ? toBeginningOfSentenceCase(eachDoctorModel
                                          .doctorProfessionalDetailCollection[0]
                                          .specialty
                                          .name)
                                      : ''
                                  : '',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.lightgraycolor),
                              textAlign: TextAlign.start,
                            )
                          : SizedBox(height: 0, width: 0),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              child: eachDoctorModel.isActive == true
                                  ? ImageIcon(
                                      AssetImage(
                                          variable.icon_record_fav_active),
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      size: 20,
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    )),
                        ],
                      ),
                    )),
              ],
            )));
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
                  child: commonWidgets.getClipOvalImageNew(
                      docs[i].user.profilePicThumbnailUrl,
                      fhbStyles.cardClipImage),
                ),
                new Positioned(
                  bottom: 0.0,
                  right: 2.0,
                  child: commonWidgets.getDoctorStatusWidgetNew(docs[i], i),
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
                          commonWidgets
                              .getTextForDoctors('${docs[i].user.name}'),
                          commonWidgets.getSizeBoxWidth(10.0),
                          commonWidgets.getIcon(
                              width: fhbStyles.imageWidth,
                              height: fhbStyles.imageHeight,
                              icon: Icons.info,
                              onTap: () {
                                print('on Info pressed');
                                commonWidgets.showDoctorDetailViewNew(
                                    docs[i], context);
                              }),
                        ],
                      )),
                      docs[i].isTelehealthEnabled
                          ? commonWidgets.getIcon(
                              width: fhbStyles.imageWidth,
                              height: fhbStyles.imageHeight,
                              icon: Icons.check_circle,
                              onTap: () {
                                print('on check  pressed');
                              })
                          : SizedBox(),
                      /*commonWidgets.getSizeBoxWidth(15.0),
                      commonWidgets.getBookMarkedIconNew(docs[i], () {
                      providerViewModel
                          .bookMarkDoctor(!(docs[i].isActive), docs[i])
                          .then((status) {
                        if (status) {
                          print('onClick');
                          providerViewModel.doctorIdsList.clear();
                          setState(() {});
                        }
                      });
                    }),
                      commonWidgets.getSizeBoxWidth(10.0),*/
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
                    /*docs[i].fees != null
                      ? docs[i].fees.consulting != null
                      ? (docs[i].fees.consulting != null &&
                      docs[i].fees.consulting != '')
                      ? commonWidgets.getDoctoSpecialist(
                      'INR ${docs[i].fees.consulting.fee}')
                      : SizedBox()
                      : SizedBox()
                      : SizedBox(),*/
                    commonWidgets.getSizeBoxWidth(10.0),
                  ]),
                  commonWidgets.getSizedBox(5.0),
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
                              docs[i].isMciVerified, 'Verified')
                          : commonWidgets.getMCVerified(
                              docs[i].isMciVerified, 'Not Verified'),
                      commonWidgets.getSizeBoxWidth(10.0),
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
          ),
        ));
  }
}
