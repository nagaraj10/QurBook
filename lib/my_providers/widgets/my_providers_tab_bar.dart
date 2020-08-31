import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/DoctorModel.dart';
import 'package:myfhb/my_providers/models/HospitalModel.dart';
import 'package:myfhb/my_providers/models/LaborartoryModel.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_doctors_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_hospitals_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_labs_list.dart';

class MyProvidersTabBar extends StatefulWidget {
  MyProvidersData data;
  TabController tabController;
  ProvidersBloc providersBloc;

  MyProvidersTabBar({this.data, this.tabController, this.providersBloc});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyProviderTabBarState();
  }
}

class MyProviderTabBarState extends State<MyProvidersTabBar> {
  List<HospitalsModel> hospitalsModel = new List();
  List<DoctorsModel> doctorsModel = new List();
  List<LaboratoryModel> labsModel = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hospitalsModel = widget.data.hospitalsModel;
    doctorsModel = widget.data.doctorsModel;
    labsModel = widget.data.laboratoryModel;

    // 1
    // Doctors
    doctorsModel.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));

    doctorsModel.sort((a, b) => (a.isDefault
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
            : 0));

    // 2
    // Hospital
    hospitalsModel.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));

    hospitalsModel.sort((a, b) => (a.isDefault
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
            : 0));

    // 3
    // Labs
    labsModel.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));

    labsModel.sort((a, b) => (a.isDefault
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
            : 0));
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: [
        doctorsModel.length > 0
            ? Container(
                color: Color(fhbColors.bgColorContainer),
                child: MyProvidersDoctorsList(
                    doctorsModel: doctorsModel,
                    providersBloc: widget.providersBloc))
            : Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      Constants.NO_DATA_DOCTOR,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                color: Color(fhbColors.bgColorContainer),
              ),
        hospitalsModel.length > 0
            ? Container(
                color: Color(fhbColors.bgColorContainer),
                child: MyProvidersHospitalsList(
                    hospitalsModel: hospitalsModel,
                    providersBloc: widget.providersBloc))
            : Container(
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
        labsModel.length > 0
            ? Container(
                color: Color(fhbColors.bgColorContainer),
                child: MyProvidersLabsList(
                    labsModel: labsModel, providersBloc: widget.providersBloc))
            : Container(
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
