import 'package:flutter/material.dart';

import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../constants/router_variable.dart' as router;
import '../../search_providers/models/search_arguments.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../bloc/providers_block.dart';
import '../models/MyProviderResponseNew.dart';
import '../widgets/my_providers_appbar.dart';
import '../widgets/my_providers_tab_bar.dart';
import '../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';

class MyProvider extends StatefulWidget {
  @override
  MyProviderState createState() => MyProviderState();
}

class MyProviderState extends State<MyProvider>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _activeTabIndex = 0;

  late ProvidersBloc _providersBloc;
  MyProvidersResponse? myProvidersResponseList;
  MyProvidersResponse? myProvidersResponseHospitalClinicList;
  bool isFirstTymForDoctors = true;
  bool isFirstTymForHospital = true;

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAMyProviderScreen);

    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_setActiveTabIndex);

    _providersBloc = ProvidersBloc();
    _providersBloc.getMedicalPreferencesForDoctors().then((value) {
      setState(() {
        isFirstTymForDoctors = false;
        myProvidersResponseList = value;
      });
    });
    _providersBloc.getMedicalPreferencesForHospital().then((value) {
      setState(() {
        isFirstTymForHospital = false;
        myProvidersResponseHospitalClinicList = value;
      });
    });
  }

  void _setActiveTabIndex() {
    FocusManager.instance.primaryFocus!.unfocus();
    _activeTabIndex = _tabController!.index;
  }

  void refreshPage() {
    setState(() {
      myProvidersResponseList = null;
      myProvidersResponseHospitalClinicList = null;
      isFirstTymForDoctors = true;
      isFirstTymForHospital = true;
    });
    _providersBloc = ProvidersBloc();
    _providersBloc.getMedicalPreferencesForDoctors().then((value) {
      setState(() {
        myProvidersResponseList = value;
        isFirstTymForDoctors = false;
      });
    });

    _providersBloc.getMedicalPreferencesForHospital().then((value) {
      setState(() {
        myProvidersResponseHospitalClinicList = value;
        isFirstTymForHospital = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyProvidersAppBar(tabController: _tabController),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        onPressed: () {
          switch (_activeTabIndex) {
            case 0:
              Navigator.pushNamed(context, router.rt_SearchProvider,
                  arguments: SearchArguments(
                    searchWord: CommonConstants.doctors,
                    fromClass: router.cn_AddProvider,
                  )).then((value) {
                refreshPage();
              });

              break;
            case 1:
              Navigator.pushNamed(context, router.rt_SearchProvider,
                  arguments: SearchArguments(
                    searchWord: CommonConstants.hospitals,
                    fromClass: router.cn_AddProvider,
                  )).then((value) {
                refreshPage();
              });

              break;
            case 2:
              Navigator.pushNamed(context, router.rt_SearchProvider,
                  arguments: SearchArguments(
                    searchWord: CommonConstants.labs,
                    fromClass: router.cn_AddProvider,
                  )).then((value) {
                refreshPage();
              });

              break;
            default:
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24.0.sp,
        ),
      ),
      body: Container(
        color: Color(fhbColors.bgColorContainer),
        child: (isFirstTymForHospital || isFirstTymForDoctors)
            ? Center(
                child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ))
            : MyProvidersTabBar(
                data: myProvidersResponseList?.result,
                dataHospitalLab: myProvidersResponseHospitalClinicList?.result,
                tabController: _tabController,
                myProviderState: this,
                refresh: () {
                  refreshPage();
                },
              ),
      ),
    );
  }
}
