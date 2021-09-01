import 'package:flutter/material.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/router_variable.dart' as router;
import '../bloc/providers_block.dart';
import '../models/MyProviderResponseNew.dart';
import '../widgets/my_providers_appbar.dart';
import '../widgets/my_providers_tab_bar.dart';
import '../../search_providers/models/search_arguments.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class MyProvider extends StatefulWidget {
  @override
  MyProviderState createState() => MyProviderState();
}

class MyProviderState extends State<MyProvider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex = 0;

  ProvidersBloc _providersBloc;
  MyProvidersResponse myProvidersResponseList;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);

    _providersBloc = ProvidersBloc();
    _providersBloc.getMedicalPreferencesAll().then((value) {
      setState(() {
        myProvidersResponseList = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'My Providers Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  void _setActiveTabIndex() {
    FocusManager.instance.primaryFocus.unfocus();
    _activeTabIndex = _tabController.index;
  }

  void refreshPage() {
    setState(() {
      myProvidersResponseList = null;
    });
    _providersBloc = ProvidersBloc();
    _providersBloc.getMedicalPreferencesAll().then((value) {
      setState(() {
        myProvidersResponseList = value;
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
        child: myProvidersResponseList != null
            ? MyProvidersTabBar(
                data: myProvidersResponseList.result,
                tabController: _tabController,
                myProviderState: this,
                refresh: () {
                  refreshPage();
                },
              )
            : Center(
                child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              )),
      ),
    );
  }
}
