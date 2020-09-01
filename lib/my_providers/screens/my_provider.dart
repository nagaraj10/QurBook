import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/widgets/my_providers_appbar.dart';
import 'package:myfhb/my_providers/widgets/my_providers_tab_bar.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';

class MyProvider extends StatefulWidget {
  @override
  MyProviderState createState() => MyProviderState();
}

class MyProviderState extends State<MyProvider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex = 0;

  ProvidersBloc _providersBloc;
  MyProvidersResponseList myProvidersResponseList;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);

    _providersBloc = new ProvidersBloc();
    _providersBloc.getMedicalPreferencesList().then((value) {
      setState(() {
        myProvidersResponseList = value;
      });
    });
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
  }

  void refreshPage() {
    setState(() {
      myProvidersResponseList = null;
    });
    _providersBloc = new ProvidersBloc();
    _providersBloc.getMedicalPreferencesList().then((value) {
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
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
      ),
      body: Container(
        color: Color(fhbColors.bgColorContainer),
        child: myProvidersResponseList != null
            ? MyProvidersTabBar(
                data: myProvidersResponseList.response.data,
                tabController: _tabController,
                myProviderState: this,
              )
            : Center(
                child: SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                ),
                width: 30,
                height: 30,
              )),
      ),
    );
  }
}
