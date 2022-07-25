import 'package:flutter/material.dart';
import 'package:myfhb/my_providers/models/ProviderRequestCollection3.dart';
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
  MyProvidersResponseData dataHospitalLab;
  TabController tabController;
  ProvidersBloc providersBloc;
  MyProviderState myProviderState;
  Function refresh;

  MyProvidersTabBar(
      {this.data,
      this.dataHospitalLab,
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
  List<Doctors> doctorsModelPatientAssociated = [];

  List<Hospitals> labsModel = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) {
      hospitalsModel = widget.dataHospitalLab?.hospitals;
      doctorsModel = widget.data?.doctors;
      if (widget.data?.providerRequestCollection3 != null &&
          widget.data?.providerRequestCollection3.length > 0)
        for (ProviderRequestCollection3 providerRequestCollection3
            in widget.data?.providerRequestCollection3) {
          Doctors patientAddedDoctor = providerRequestCollection3.doctor;
          patientAddedDoctor.isPatientAssociatedRequest = true;
          doctorsModelPatientAssociated.add(providerRequestCollection3.doctor);
        }

      if (doctorsModelPatientAssociated.isNotEmpty &&
          doctorsModelPatientAssociated.length > 0) {
        doctorsModel.addAll(doctorsModelPatientAssociated);
      }
      labsModel = widget.dataHospitalLab.labs;
      if (widget.data.clinics != null) {
        hospitalsModel.addAll(widget.dataHospitalLab.clinics);
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
