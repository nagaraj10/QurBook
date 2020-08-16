import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';

import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import '../../SearchWidget/view/SearchWidget.dart';

import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;

import 'DoctorSessionTimeSlot.dart';

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

  List<DoctorTimeSlotsModel> doctorTimeSlotsModel =
      new List<DoctorTimeSlotsModel>();
  List<SessionsTime> sessionTimeModel = new List<SessionsTime>();
  List<Slots> slotsModel = new List<Slots>();

  @override
  void initState() {
    super.initState();
    getDataForProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: GradientAppBar(),
            leading: Icon(Icons.arrow_back_ios),
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
                  onSearched(doctorsName);
                } else {
                  setState(() {
                    isSearch = false;
                  });
                }
              },
            ),
            Expanded(
              child: (providerViewModel.doctorIdsList != null &&
                      providerViewModel.doctorIdsList.length > 0)
                  ? providerListWidget(providerViewModel.doctorIdsList)
                  : getDoctorProviderList(),
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
        Icon(Icons.more_vert),
      ],
    );
  }

  Widget doctorsListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
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
  }

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
            DoctorSessionTimeSlot(
                date: _selectedValue.toString(),
                doctorId: docs[i].id,
                docs: docs,isReshedule: false,
                i: i),
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
                  docs[i].profilePicThumbnail, fhbStyles.cardClipImage),
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
                    providerViewModel
                        .bookMarkDoctor(!(docs[i].isDefault), docs[i])
                        .then((status) {
                      if (status) {
                        print('onClick');
                        providerViewModel.doctorIdsList.clear();
                        setState(() {});
                      }
                    });
                  }),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: docs[i].professionalDetails != null
                            ? docs[i].professionalDetails[0].specialty != null
                                ? docs[i]
                                            .professionalDetails[0]
                                            .specialty
                                            .name !=
                                        null
                                    ? commonWidgets.getDoctoSpecialist(
                                        '${docs[i].professionalDetails[0].specialty.name}')
                                    : SizedBox()
                                : SizedBox()
                            : SizedBox()
                        ),
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

  Widget getFees(DoctorIds doctorId) {
    return doctorId.fees != null
        ? commonWidgets.getHospitalDetails(doctorId.fees.consulting != null
            ? variable.strRs + ' ' + doctorId.fees.consulting.fee
            : '')
        : Text('');
  }

  Widget getDoctorProviderList() {
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
  }

  Widget providerListWidget(List<DoctorIds> doctorList) {
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
  }
}
