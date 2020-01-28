import 'package:flutter/material.dart';
import 'package:myfhb/src/search/SearchSpecificList.dart';

class MyProvider extends StatefulWidget {
  @override
  _MyProviderState createState() => _MyProviderState();
}

class _MyProviderState extends State<MyProvider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex;

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        /*  child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))), */
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
          /*  actions: <Widget>[
                new RawMaterialButton(
                  constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                  onPressed: () {},
                  child: new Icon(
                    Icons.add,
                    //color: Colors.blue,
                    size: 22.0,
                  ),
                  shape:
                      new CircleBorder(side: BorderSide(color: Colors.white)),
                  //elevation: 2.0,
                  fillColor: Colors.transparent,
                  //padding: const EdgeInsets.all(15.0),
                ),
              ], */
        ),
      ),
      //),
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

          //Na
          // moveToSearchScreen(context, 'doctors');
        },
      ),
    );
    /*  return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('My Family'),
            centerTitle: true,
            bottom: DefaultTabController(
              child: null,
              length: 3,
            ),
            actions: <Widget>[
              new RawMaterialButton(
                constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                onPressed: () {},
                child: new Icon(
                  Icons.add,
                  //color: Colors.blue,
                  size: 22.0,
                ),
                shape: new CircleBorder(side: BorderSide(color: Colors.white)),
                //elevation: 2.0,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.all(15.0),
              ),
            ],
          ),
        ),
      ),
      body: Container(
          //child: getAllFamilyMembers(),
          ),
    ); */
  }

  /* Widget getAllFamilyMembers() {
    //print('Inside getResponseFromApiWidget');
    return StreamBuilder<ApiResponse<FamilyMembersList>>(
      stream: _familyListBloc.familyMemberListStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<FamilyMembersList>> snapshot) {
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

              /* Container(
                  child: ListView.builder(
                itemBuilder: (c, i) =>
                    getCardWidgetForDevice(mediaMetaInfoObj[i], i),
                itemCount: mediaMetaInfoObj.length,
              )
                  //child: Text('Data loaded succcesfully'),
                  ); */
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

  Widget getMyFamilyMembers(Data data) {
    List<Sharedbyme> profilesSharedByMe = new List();

    profilesSharedByMe = data.sharedbyme;
    return profilesSharedByMe.length > 0
        ? Container(
            color: const Color(0xFFF7F9Fb),
            child: ListView.builder(
              itemBuilder: (c, i) =>
                  getCardWidgetForDevice(profilesSharedByMe[i], i),
              itemCount: profilesSharedByMe.length,
            ))
        : Container(
            child: Center(
              child: Text('No Data Available'),
            ),
            color: Colors.grey[300],
          );
  }

  Widget getCardWidgetForDevice(Sharedbyme data, int position) {
    return new Padding(
        padding: new EdgeInsets.only(top: 10, bottom: 5),
        child: Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey,
                  child: Image.memory(Uint8List.fromList(
                      data.profileData.profilePicThumbnail.data)),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.profileData.name != null
                            ? data.profileData.name
                            : '',
                        style: TextStyle(fontWeight: FontWeight.w500),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        data.profileData.gender != null
                            ? data.linkedData.roleName
                            : '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
 */

  /* Future moveToSearchScreen(BuildContext context, String searchParam) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchSpecificList(searchParam)));
    setState(() {});
  } */
}
