import 'package:flutter/material.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_doctors_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_hospitals_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_labs_list.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

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

    doctorsModel
        .sort((a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
    hospitalsModel
        .sort((a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
    labsModel
        .sort((a, b) => (b.isDefault ? 1 : 0).compareTo(a.isDefault ? 1 : 0));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TabBarView(
      controller: widget.tabController,
      children: [
        doctorsModel.length > 0
            ? Container(
                color: ColorUtils.greycolor,
                child: MyProvidersDoctorsList(
                    doctorsModel: doctorsModel,
                    providersBloc: widget.providersBloc))
            : Container(
                child: Center(
                  child: Text('No Data Available'),
                ),
                color: Colors.grey[300],
              ),
        hospitalsModel.length > 0
            ? Container(
                color: ColorUtils.greycolor,
                child: MyProvidersHospitalsList(
                    hospitalsModel: hospitalsModel,
                    providersBloc: widget.providersBloc))
            : Container(
                child: Center(
                  child: Text('No Data Available'),
                ),
                color: Colors.grey[300],
              ),
        labsModel.length > 0
            ? Container(
                color: ColorUtils.greycolor,
                child: MyProvidersLabsList(
                    labsModel: labsModel, providersBloc: widget.providersBloc))
            : Container(
                child: Center(
                  child: Text('No Data Available'),
                ),
                color: Colors.grey[300],
              ),
      ],
    );
  }
}
