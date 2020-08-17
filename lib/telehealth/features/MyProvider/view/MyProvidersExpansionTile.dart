import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';

import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/ExpansionTileWidget.dart' as expansion;
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import '../../SearchWidget/view/SearchWidget.dart';

import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:flutter/material.dart';

import 'DoctorSessionTimeSlot.dart';

class MyProvidersNew extends StatefulWidget {
  @override
  _MyProvidersState createState() => _MyProvidersState();
}

class _MyProvidersState extends State<MyProvidersNew> {
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
            title: getTitle()),
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
            style: TextStyle(fontWeight: FontWeight.w500),
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
    return Card(
        elevation: 5,
        margin: EdgeInsets.only(left:15.0,right: 15.0,top:5,bottom: 5),
        child: expansion.ExpansionTileWidget(

          title: collapseListItem(ctx, i, docs),
          children: [expandedListItem(ctx, i, docs)],
        ));
  }

  Widget collapseListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: getDoctorsWidget(i, docs),
    );
  }

  Widget expandedListItem(BuildContext ctx, int i, List<DoctorIds> docs) {
    return Container(
      padding: EdgeInsets.all(2.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          commonWidgets.getSizedBox(20.0),
          DoctorSessionTimeSlot(
              date: _selectedValue.toString(),
              doctorId: docs[i].id,
              docs: docs,
              i: i,isReshedule: false,),
        ],
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorsWidget(int i, List<DoctorIds> docs) {
    print(docs[i].name);
    print(docs[i].id);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        setState(() {});
                      }
                    });
                  }),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                docs[i].specialization != null
                    ? commonWidgets
                        .getDoctoSpecialist('${docs[i].specialization}')
                    : SizedBox(),
              ]),
              commonWidgets.getSizedBox(5.0),
              commonWidgets.getDoctorsAddress('${docs[i].city}')
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
    return new ListView.builder(
      itemBuilder: (BuildContext ctx, int i) =>
          doctorsListItem(ctx, i, isSearch ? doctorData : doctorList),
      itemCount:
          isSearch ? doctorData.length : providerViewModel.doctorIdsList.length,
    );
  }
}
