import 'package:flutter/material.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../constants/fhb_constants.dart' as Constants;
import '../bloc/providers_block.dart';
import '../models/Doctors.dart';
import '../models/Hospitals.dart';
import '../models/MyProviderResponseData.dart';
import '../screens/my_provider.dart';
import '../screens/my_providers_doctors_list.dart';
import '../screens/my_providers_hospitals_list.dart';
import '../screens/my_providers_labs_list.dart';

class MyProvidersTabBar extends StatefulWidget {
  MyProvidersResponseData data;
  TabController tabController;
  ProvidersBloc providersBloc;
  MyProviderState myProviderState;
  Function refresh;

  MyProvidersTabBar(
      {this.data,
      this.tabController,
      this.providersBloc,
      this.myProviderState,
      this.refresh});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyProviderTabBarState();
  }
}

class MyProviderTabBarState extends State<MyProvidersTabBar> {
  List<Hospitals> hospitalsModel = [];
  List<Doctors> doctorsModel = [];
  List<Hospitals> labsModel = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) {
      hospitalsModel = widget.data.hospitals;
      doctorsModel = widget.data.doctors;
      labsModel = widget.data.labs;
      if(widget.data.clinics!=null){
        hospitalsModel.addAll(widget.data.clinics);
      }
    }

    // // 1
    // // Doctors
    // doctorsModel.sort((a, b) => a.user.name
    //     .toString()
    //     .toLowerCase()
    //     .compareTo(b.user.name.toString().toLowerCase()));
    //
    // doctorsModel.sort((a, b) => (a.user.isDefault
    //         ? a.user.name
    //             .toString()
    //             .toLowerCase()
    //             .compareTo(b.user.name.toString().toLowerCase())
    //         : 0)
    //     .compareTo(b.isDefault
    //         ? a.user.name
    //             .toString()
    //             .toLowerCase()
    //             .compareTo(b.user.name.toString().toLowerCase())
    //         : 0));
    //
    // // 2
    // // Hospital
    // hospitalsModel.sort((a, b) => a.name
    //     .toString()
    //     .toLowerCase()
    //     .compareTo(b.name.toString().toLowerCase()));
    //
    // hospitalsModel.sort((a, b) => (a.isDefault
    //         ? a.name
    //             .toString()
    //             .toLowerCase()
    //             .compareTo(b.name.toString().toLowerCase())
    //         : 0)
    //     .compareTo(b.isDefault
    //         ? a.name
    //             .toString()
    //             .toLowerCase()
    //             .compareTo(b.name.toString().toLowerCase())
    //         : 0));

    // 3
    // Labs
    labsModel.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));

    /*  labsModel.sort((a, b) => (a.isDefault
            ? a.name
                .toString()
                .toLowerCase()
                .compareTo(b.name.toString().toLowerCase())
            : 0)
        .compareTo(b.isDefault
            ? a.name
                .toString()
                .toLowerCase()
                .compareTo(b.name.toString().toLowerCase())
            : 0));*/
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: [
        doctorsModel != null && doctorsModel.isNotEmpty
            ? Container(
                color: Color(fhbColors.bgColorContainer),
                child: MyProvidersDoctorsList(
                  doctorsModel: doctorsModel,
                  providersBloc: widget.providersBloc,
                  myProviderState: widget.myProviderState,
                  refresh: () {
                    widget.refresh();
                  },
                ))
            : Container(
                color: Color(fhbColors.bgColorContainer),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      Constants.NO_DATA_DOCTOR,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        if (hospitalsModel.length > 0)
          Container(
              color: Color(fhbColors.bgColorContainer),
              child: MyProvidersHospitalsList(
                hospitalsModel: hospitalsModel,
                providersBloc: widget.providersBloc,
                myProviderState: widget.myProviderState,
                isRefresh: () {
                  widget.refresh();
                },
              ))
        else
          Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Text(
                  Constants.NO_DATA_HOSPITAL,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            color: Color(fhbColors.bgColorContainer),
          ),
        if (labsModel.length > 0)
          Container(
              color: Color(fhbColors.bgColorContainer),
              child: MyProvidersLabsList(
                labsModel: labsModel,
                providersBloc: widget.providersBloc,
                myProviderState: widget.myProviderState,
                isRefresh: () {
                  widget.refresh();
                },
              ))
        else
          Container(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Text(
                  Constants.NO_DATA_LAB,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            color: Color(fhbColors.bgColorContainer),
          ),
      ],
    );
  }
}
