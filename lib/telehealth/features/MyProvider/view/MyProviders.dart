import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import '../../SearchWidget/view/SearchWidget.dart';

import 'package:myfhb/telehealth/features/MyProvider/model/Data.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class MyProviders extends StatefulWidget {
  @override
  _MyProvidersState createState() => _MyProvidersState();
}

class _MyProvidersState extends State<MyProviders> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  MyProviderViewModel providerViewModel;
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  bool firstTym = false;
  String doctorsName;
  CommonWidgets commonWidgets = new CommonWidgets();
  bool isSearch = false;

  List<Data> doctorData = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDataForProvider();
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons
              .arrow_back_ios), // you can put Icon as well, it accepts any widget.
          title: Column(
            children: [
              Text("MyProviders"),
            ],
          ),
          actions: [
            Icon(Icons.notifications),
            new SwitchProfile()
                .buildActions(context, _keyLoader, callBackToRefresh),
            Icon(Icons.more_vert),
          ],
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
              child: ListView.builder(
                itemBuilder: (BuildContext ctx, int i) => doctorsListItem(
                    ctx, i, isSearch ? doctorData : providerViewModel.docsList),
                itemCount: isSearch
                    ? doctorData.length
                    : providerViewModel.docsList.length,
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //PageNavigator.goTo(context, '/add_appointments');
          },
          child: Icon(
            Icons.add,
            color: Color(new CommonUtil().getMyPrimaryColor()),
          ),
        ));
  }

  

  Widget doctorsListItem(BuildContext ctx, int i, List<Data> docs) {
    return ExpandableNotifier(
      child: Container(
        padding: EdgeInsets.all(4.0),
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

  Widget collapseListItem(BuildContext ctx, int i, List<Data> docs) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: ExpandableButton(
        child: getDoctorsWidget(i, docs),
      ),
    );
  }

  Widget expandedListItem(BuildContext ctx, int i, List<Data> docs) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width,
      child: ExpandableButton(
        child: Column(
          children: [
            getDoctorsWidget(i, docs),
            commonWidgets.getSizedBox(20.0),
            commonWidgets.getDatePickerSlot(_controller, (dateTime) {
              setState(() {
                _selectedValue = dateTime;
              });
            }),
            commonWidgets.getSizedBox(5.0),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Column(
                children: commonWidgets
                    .getTimeSlots(providerViewModel.dateSlotTimings),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorsWidget(int i, List<Data> docs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImage(
                  '${docs[i].profileimage}', fhbStyles.cardClipImage),
            ),
            new Positioned(
              bottom: -1.0,
              right: -4.0,
              child: commonWidgets.getDoctorStatusWidget(docs[i]),
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
                      commonWidgets.getTextForDoctors('${docs[i].fullname}'),
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
                  commonWidgets.getIcon(
                      width: fhbStyles.imageWidth,
                      height: fhbStyles.imageHeight,
                      icon: Icons.check_circle,
                      onTap: () {
                        print('on check  pressed');
                      }),
                  commonWidgets.getSizeBoxWidth(15.0),
                  commonWidgets.getBookMarkedIcon(docs[i]),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              commonWidgets.getDoctoSpecialist('${docs[i].specialist}'),
              commonWidgets.getSizedBox(5.0),
              commonWidgets.getDoctorsAddress('${docs[i].city}')
            ],
          ),
        ),
      ],
    );
  }

  void getDataForProvider() {
    if (firstTym == false) {
      firstTym = true;
      providerViewModel = Provider.of<MyProviderViewModel>(context);
      providerViewModel.fetchDoctors();
      //doctorData .addAll(providerViewModel.docsList);
      providerViewModel.getDateSlots();
    }
  }

  onSearched(String doctorName) {
    print(doctorName);
    doctorData.clear();
    if (doctorName != null) {
      for (Data fiterData
          in providerViewModel.getFilterDoctorList(doctorName)) {
        doctorData.add(fiterData);
      }
      print(doctorData.length);
    }

    setState(() {});
  }
}
