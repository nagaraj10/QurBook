import 'package:flutter/material.dart';
import 'package:myfhb/my_providers/widgets/my_providers_appbar.dart';
import 'package:myfhb/src/search/SearchSpecificList.dart';

class MyProvidersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyProvidersScreenState();
  }
}

class MyProvidersScreenState extends State<MyProvidersScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex;

//  PlayerListingBloc _playerListingBloc;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyProvidersAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: Center(
              child: Text('No doctors added yet'),
            ),
          ),
          Center(
            child: Text('No hospitals added yet'),
          ),
          Center(
            child: Text('No laboratories added yet'),
          ),
        ],
      ),
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
    );
  }
}
