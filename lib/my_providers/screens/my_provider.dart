import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/widgets/my_providers_appbar.dart';
import 'package:myfhb/my_providers/widgets/my_providers_stream_data.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';

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
        child: Icon(Icons.add),
        onPressed: () {
          switch (_activeTabIndex) {
            case 0:
              Navigator.pushNamed(context, '/search_providers',
                  arguments: SearchArguments(
                    searchWord: CommonConstants.doctors,
                  )).then((value) {
                _providersBloc = new ProvidersBloc();
                _providersBloc.getMedicalPreferencesList();
              });

              break;
            case 1:
              Navigator.pushNamed(context, '/search_providers',
                  arguments: SearchArguments(
                    searchWord: CommonConstants.hospitals,
                  )).then((value) {
                _providersBloc = new ProvidersBloc();
                _providersBloc.getMedicalPreferencesList();
              });

              break;
            case 2:
              Navigator.pushNamed(context, '/search_providers',
                  arguments: SearchArguments(
                    searchWord: CommonConstants.labs,
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
        child: MyProvidersStreamData(
            providersBloc: _providersBloc, tabController: _tabController),
      ),
    );
  }
}
