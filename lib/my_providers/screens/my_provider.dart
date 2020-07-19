import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/widgets/my_providers_appbar.dart';
import 'package:myfhb/my_providers/widgets/my_providers_stream_data.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/constants/router_variable.dart' as router;


class MyProvider extends StatefulWidget {
  @override
  _MyProviderState createState() => _MyProviderState();
}

class _MyProviderState extends State<MyProvider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex = 0;

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
                _providersBloc = new ProvidersBloc();
                _providersBloc.getMedicalPreferencesList();
              });

              break;
            case 1:
              Navigator.pushNamed(context,router.rt_SearchProvider,
                  arguments: SearchArguments(
                    searchWord: CommonConstants.hospitals,
                      fromClass: router.cn_AddProvider,
                    
                  )).then((value) {
                _providersBloc = new ProvidersBloc();
                _providersBloc.getMedicalPreferencesList();
              });

              break;
            case 2:
              Navigator.pushNamed(context, router.rt_SearchProvider,
                  arguments: SearchArguments(
                    searchWord: CommonConstants.labs,
                      fromClass: router.cn_AddProvider,
                     )).then((value) {
                _providersBloc = new ProvidersBloc();
                _providersBloc.getMedicalPreferencesList();
              });

              break;
            default:
          }
        },
      ),
      body: Container(
        color: Color(fhbColors.bgColorContainer),
        child: MyProvidersStreamData(
            providersBloc: _providersBloc, tabController: _tabController),
      ),
    );
  }
}
