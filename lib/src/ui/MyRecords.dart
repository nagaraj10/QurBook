import 'package:flutter/material.dart';
import 'package:myfhb/common/AppDrawer.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
export 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/model/TabModel.dart';
import 'package:myfhb/src/ui/health/HealthReportListScreen.dart';
import 'package:myfhb/src/ui/health/DeviceListScreen.dart';
import 'package:myfhb/src/ui/health/LabReportListScreen.dart';
import 'package:myfhb/src/ui/health/MedicalReportListScreen.dart';
import 'package:myfhb/src/ui/health/BillsList.dart';
import 'package:myfhb/src/ui/health/IDDocsList.dart';
import 'package:myfhb/src/ui/health/OtherDocsList.dart';
import 'package:myfhb/src/ui/health/VoiceRecordList.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';

import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/common/CommonConstants.dart';
export 'package:myfhb/common/CommonUtil.dart';

class MyRecords extends StatefulWidget {
  @override
  _MyRecordsState createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  final String _baseUrl = 'https://healthbook.vsolgmi.com/hb/api/v3/';
  List<TabModel> tabModelList = new List();
  CategoryListBlock _categoryListBlock;
  HealthReportListForUserBlock _healthReportListForUserBlock;
  MediaTypeBlock _mediaTypeBlock;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  void initState() {
    _categoryListBlock = new CategoryListBlock();
    _categoryListBlock.getCategoryList();

    _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportList();

    _mediaTypeBlock = new MediaTypeBlock();
    _mediaTypeBlock.getMediTypes();

    super.initState();
  }

  void callBackToRefresh() {
    setState(() {
      //print('setState of home Screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return getResponseFromApiWidget();
  }

  Widget getMainWidgets(List<Data> data) {
    print('Inside getMainWidgets');

    return DefaultTabController(
        length: data.length,
        child: Scaffold(
            //backgroundColor: Colors.red,
            //drawer: AppDrawer(),
            appBar: AppBar(
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
                    Icons.home,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                //leading: _isSearching ? const BackButton() : Container(),
                /*  leading: Container(
                  width: 0,
                ), */
                //title: _isSearching ? _buildSearchField() : Text(''),

                title: _buildSearchField(),
                titleSpacing: 0,
                actions: _buildActions(),
                //leading: ,
                /*  title: Text(Constants.APP_NAME,
                  style: TextStyle(color: Colors.white)), */
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(80.0),
                  child: data.length == 0
                      ? Container(
                          /* child: Text('Unable To load Tabs',
                          style: TextStyle(color: Colors.red)) */
                          )
                      : TabBar(
                          indicatorWeight: 4,
                          isScrollable: true,
                          tabs: getAllTabsToDisplayInHeader(data),
                        ),
                )),
            body: getAllTabsToDisplayInBody(data)));
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: 40),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                controller: _searchQueryController,
                autofocus: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  hintText: "Search your records",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black45),
                ),
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
                onChanged: (query) => updateSearchQuery,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    /*  return <Widget>[
      IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: () {},
      ),
      /* IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {},
      ) */
    ]; */

    //if (_isSearching) {
    return <Widget>[
      /*  _isSearching
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                if (_searchQueryController == null ||
                    _searchQueryController.text.isEmpty) {
                  Navigator.pop(context);
                  return;
                }
                _clearSearchQuery();
              },
            )
          : IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ), */
      IconButton(
        icon: const Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: CircleAvatar(
          radius: 18,
          child: ClipOval(
            child: Image.network(
              'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
            ),
          ),

          /*  backgroundColor: Colors.white54,
          child: IconButton(
            color: Colors.black54,
            icon: const Icon(Icons.person),
            onPressed: _startSearch,
          ), */
        ),
      )
    ];
    //}

    /*  return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ]; */
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  Widget getResponseFromApiWidget() {
    //print('Inside getResponseFromApiWidget');
    return StreamBuilder<ApiResponse<CategoryResponseList>>(
      stream: _categoryListBlock.categoryListStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<CategoryResponseList>> snapshot) {
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
              return getMainWidgets(snapshot.data.data.response.data);
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

  List<Widget> getAllTabsToDisplayInHeader(List<Data> data) {
    //print('Inside getAllTabsToDisplayInHeader');

    List<Widget> tabWidgetList = new List();
    //tabWidgetList.add(SizedBox(height: 5));

    data.sort((a, b) {
      return a.categoryDescription
          .toLowerCase()
          .compareTo(b.categoryDescription.toLowerCase());
    });

    for (Data dataObj in data) {
      if (dataObj.isActive) {
        tabWidgetList.add(Column(children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Image.network(
            _baseUrl + dataObj.logo,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
              child: Text(
            dataObj.categoryName,
            style: TextStyle(fontSize: 12),
          )),
          Padding(padding: EdgeInsets.only(top: 10)),
        ]));
      }
    }

    return tabWidgetList;
  }

  Widget getAllTabsToDisplayInBody(List<Data> data) {
    //print('Inside getAllTabsToDisplayInBody');

    return StreamBuilder<ApiResponse<UserHealthResponseList>>(
      stream: _healthReportListForUserBlock.healthReportStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<UserHealthResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                )),
              );
              break;

            case Status.ERROR:
              return Center(
                  child: Text('Oops, something went wrong',
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              return getMediTypeForlabels(
                  data, snapshot.data.data.response.data);
              break;
          }
        } else {
          return Container(height: 0, color: Colors.white);
        }
      },
    );
  }

  Widget getMediTypeForlabels(List<Data> data, CompleteData completeData) {
    //print('Inside getMediTypeForlabels');

    return StreamBuilder<ApiResponse<MediaTypesResponse>>(
      stream: _mediaTypeBlock.mediaTypeStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<MediaTypesResponse>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                )),
              );

              break;

            case Status.ERROR:
              return Text('Unable To load Tabs',
                  style: TextStyle(color: Colors.red));
              break;

            case Status.COMPLETED:
              return getStackBody(
                  data, completeData, snapshot.data.data.response.data);
              break;
          }
        } else {
          return getStackBody(data, completeData, null);
        }
      },
    );
  }

  Widget getStackBody(
      List<Data> data, CompleteData completeData, List<MediaData> mediaData) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        TabBarView(
            children: _getAllDataForTheTabs(data, completeData, mediaData)),
        Container(
          margin: EdgeInsets.only(right: 10, bottom: 10),
          constraints: BoxConstraints(maxHeight: 100),
          decoration: BoxDecoration(
              color: Colors.deepPurple[800],
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  PageNavigator.goTo(context, '/take_picture_screen');
                },
              ),
              Container(
                width: 20,
                height: 1,
                color: Colors.white,
              ),
              IconButton(
                icon: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _getAllDataForTheTabs(
      List<Data> data, CompleteData completeData, List<MediaData> mediaData) {
    //print('inside _getAllDataForTheTabs');

    List<Widget> tabWidgetList = new List();
    //data.sort((a, b) => a.categoryName.compareTo(b.categoryName));

    for (Data dataObj in data) {
      MediaData mediaDataObj = new MediaData();
      if (dataObj.isDisplay) {
        if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionPrescription) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);

          /*  print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */
          tabWidgetList
              .add(new HealthReportListScreen(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionDevice) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);
          /* print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList
              .add(new DeviceListScreen(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionLabReport) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);

          /*    print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList
              .add(new LabReportListScreen(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionMedicalReport) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);

          /*  print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList.add(
              new MedicalReportListScreen(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionBills) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);
/* 
          print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList.add(new BillsList(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionIDDocs) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);

          /*  print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList.add(new IDDocsList(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionOthers) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);
          /*  print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList.add(new OtherDocsList(completeData, callBackToRefresh));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionVoiceRecord) {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);

          /* print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList
              .add(new VoiceRecordList(completeData, callBackToRefresh));
        } else {
          mediaDataObj = new CommonUtil()
              .getMediaTypeInfoForParticularLabel(dataObj.id, mediaData);

          /*   print('Media Data Object for ' +
              dataObj.categoryName +
              '\n' +
              mediaDataObj.toString()); */

          tabWidgetList
              .add(new HealthReportListScreen(completeData, callBackToRefresh));
        }
      }
    }
    return tabWidgetList;
  }
}
