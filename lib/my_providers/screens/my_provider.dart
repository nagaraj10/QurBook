import 'package:flutter/material.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/MyProvidersResponseList.dart';
import 'package:myfhb/my_providers/screens/my_providers_hospitals_list.dart';
import 'package:myfhb/my_providers/screens/my_providers_labs_list.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/search/SearchSpecificList.dart';
import 'package:myfhb/utils/colors_utils.dart';

import 'my_providers_doctors_list.dart';

class MyProvider extends StatefulWidget {
  @override
  _MyProviderState createState() => _MyProviderState();
}

class _MyProviderState extends State<MyProvider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex;

  ProvidersBloc _providersBloc;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);

    _providersBloc = new ProvidersBloc();
    _providersBloc.getMedicalPreferencesList();
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  const Color(0XFF6717CD),
                  const Color(0XFF0A41A6)
                ],
                    stops: [
                  0.3,
                  1
                ])),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Doctors',
              ),
              Tab(
                text: 'Hospitals',
              ),
              Tab(
                text: 'Laboratories',
              ),
            ],
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
          ),
          title: Text('My Providers'),
          centerTitle: false,
        ),
      ),
      //),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          switch (_activeTabIndex) {
            case 0:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchSpecificList('Doctors')));
              break;
            case 1:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchSpecificList('Hospitals')));
              break;
            case 2:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchSpecificList('Laboratories')));
              break;
            default:
          }
        },
      ),
      body: Container(
        child: getAllProviders(),
      ),
    );
  }

  Widget getAllProviders() {
    return StreamBuilder<ApiResponse<MyProvidersResponseList>>(
      stream: _providersBloc.providersListStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<MyProvidersResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              return Center(
                  child: Text('Oops, something went wrong',
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              return getMyFamilyMembers(snapshot.data.data.response.data);
              break;
          }
        } else {
          return Container(
            width: 100,
            height: 100,
          );
        }
      },
    );
  }

  Widget getMyFamilyMembers(MyProvidersData data) {
    List<HospitalsModel> hospitalsModel = new List();
    List<DoctorsModel> doctorsModel = new List();
    List<LaboratoryModel> labsModel = new List();

    hospitalsModel = data.hospitalsModel;
    doctorsModel = data.doctorsModel;
    labsModel = data.laboratoryModel;

    return doctorsModel.length > 0
        ? TabBarView(
            controller: _tabController,
            children: [
              Container(
                  color: ColorUtils.greycolor,
                  child: MyProvidersDoctorsList(doctorsModel: doctorsModel)),
              Container(
                  color: ColorUtils.greycolor,
                  child:
                      MyProvidersHospitalsList(hospitalsModel: hospitalsModel)),
              Container(
                  color: ColorUtils.greycolor,
                  child: MyProvidersLabsList(labsModel: labsModel)),
            ],
          )
        : Container(
            child: Center(
              child: Text('No Data Available'),
            ),
            color: Colors.grey[300],
          );
  }
}
