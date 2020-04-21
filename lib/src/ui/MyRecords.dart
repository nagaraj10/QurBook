import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/global_search/bloc/GlobalSearchBloc.dart';
import 'package:myfhb/global_search/model/GlobalSearch.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/screens/FamilyListView.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/model/TabModel.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/camera/TakePictureScreen.dart';
import 'package:myfhb/src/ui/health/BillsList.dart';
import 'package:myfhb/src/ui/health/DeviceListScreen.dart';
import 'package:myfhb/src/ui/health/HealthReportListScreen.dart';
import 'package:myfhb/src/ui/health/IDDocsList.dart';
import 'package:myfhb/src/ui/health/LabReportListScreen.dart';
import 'package:myfhb/src/ui/health/MedicalReportListScreen.dart';
import 'package:myfhb/src/ui/health/OtherDocsList.dart';
import 'package:myfhb/src/ui/health/VoiceRecordList.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import '../../constants/fhb_constants.dart';

export 'package:myfhb/common/CommonUtil.dart';
export 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/common/SwitchProfile.dart';

class MyRecords extends StatefulWidget {
  @override
  _MyRecordsState createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  // final String _baseUrl = 'https://healthbook.vsolgmi.com/hb/api/v2/';
  List<TabModel> tabModelList = new List();
  CategoryListBlock _categoryListBlock;
  HealthReportListForUserBlock _healthReportListForUserBlock;
  MediaTypeBlock _mediaTypeBlock;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String categoryName;
  String categoryID;

  // MediaData mediaData;

  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  GlobalSearchBloc _globalSearchBloc;
  bool fromSearch = false;
  List<CategoryData> categoryDataList = new List();
  CompleteData completeData;
  List<MediaData> mediaData = new List();

  @override
  void initState() {
    rebuildAllBlocks();
    searchQuery = _searchQueryController.text;
    print('_searchQueryController.toString() ' + searchQuery);
    if (searchQuery != '') {
      _globalSearchBloc.searchBasedOnMediaType(
          _searchQueryController.text == null
              ? ''
              : _searchQueryController.text);
    }
    super.initState();

    PreferenceUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return getCompleteWidgets();
  }

  Widget getCompleteWidgets() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: GradientAppBar(),
        leading: SizedBox(
          width: 0,
          height: 0,
        ),
        titleSpacing: 0,
        title: _buildSearchField(),
      ),
      body: fromSearch
          ? getResponseForSearchedMedia()
          : getResponseFromApiWidget(),
    );
  }

  Widget getResponseFromApiWidget() {
    List<CategoryData> categoryDataFromPrefernce =
        PreferenceUtil.getCategoryType();
    if (categoryDataFromPrefernce != null &&
        categoryDataFromPrefernce.length > 0)
      return getMainWidgets(categoryDataFromPrefernce);
    else
      return StreamBuilder<ApiResponse<CategoryResponseList>>(
        stream: _categoryListBlock.categoryListStream,
        builder: (context,
            AsyncSnapshot<ApiResponse<CategoryResponseList>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(
                    backgroundColor:
                        Color(new CommonUtil().getMyPrimaryColor()),
                  ),
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
                _categoryListBlock = null;
                _categoryListBlock = new CategoryListBlock();

                if (categoryDataList.length > 0) {
                  categoryDataList.clear();
                }

                categoryDataList.addAll(snapshot.data.data.response.data);
                return getMainWidgets(categoryDataList);
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

  Widget getMainWidgets(List<CategoryData> data) {
    _categoryListBlock = null;
    _categoryListBlock = new CategoryListBlock();

    List<CategoryData> categoryData = fliterCategories(data);
    return DefaultTabController(
        length: categoryData.length,
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                flexibleSpace: GradientAppBar(),
                titleSpacing: 0,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20.0),
                    child: Container(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: data.length == 0
                                  ? Container()
                                  : TabBar(
                                      indicatorWeight: 4,
                                      isScrollable: true,
                                      tabs: getAllTabsToDisplayInHeader(
                                          categoryData),
                                    ),
                            ))))),
            body: getAllTabsToDisplayInBodyClone(categoryData)));
  }

  Widget getAllTabsToDisplayInBodyClone(List<CategoryData> data) {
    print('Inside getAllTabsToDisplayInBodyClone');

    return Stack(alignment: Alignment.bottomRight, children: <Widget>[
      getAllTabsToDisplayInBody(data),
      Container(
        margin: EdgeInsets.only(right: 10, bottom: 10),
        constraints: BoxConstraints(maxHeight: 100),
        decoration: BoxDecoration(
            color: Color(new CommonUtil().getMyPrimaryColor()),
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
                PreferenceUtil.saveString(Constants.KEY_DEVICENAME, null)
                    .then((onValue) {
                  PreferenceUtil.saveString(
                          Constants.KEY_CATEGORYNAME, categoryName)
                      .then((onValue) {
                    PreferenceUtil.saveString(
                            Constants.KEY_CATEGORYID, categoryID)
                        .then((value) {
                      if (categoryName == STR_DEVICES) {
                        PreferenceUtil.saveString(
                            Constants.stop_detecting, 'NO');
                        PreferenceUtil.saveString(
                            Constants.stop_detecting, 'NO');

                        Navigator.pushNamed(
                                context, '/take_picture_screen_for_devices')
                            .then((value) {
                          //callBackToRefresh();
                        });
                      } else {
                        Navigator.pushNamed(context, '/take_picture_screen')
                            .then((value) {
                          //callBackToRefresh();
                        });
                      }
                    });
                  });
                });
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
              onPressed: () {
                //sliverBarHeight = 50;
                PreferenceUtil.saveString(
                        Constants.KEY_CATEGORYNAME, Constants.STR_VOICERECORDS)
                    .then((value) {
                  PreferenceUtil.saveString(Constants.KEY_CATEGORYID,
                          PreferenceUtil.getStringValue(Constants.KEY_VOICE_ID))
                      .then((value) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => AudioRecordScreen(
                            fromVoice: true,
                          ),
                        ))
                        .then((results) {});
                  });
                });
              },
            )
          ],
        ),
      )
    ]);
  }

  Widget getAllTabsToDisplayInBody(List<CategoryData> data) {
    print('Inside getAllTabsToDisplayInBody');
    /* if (_healthReportListForUserBlock == null) {
      print('inside _healthReportListForUserBlock null');
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportList();
    }*/

    CompleteData completeDataFromPreference =
        PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA);
    return fromSearch
        ? getMediTypeForlabels(data, completeData)
        : completeDataFromPreference != null
            ? getMediTypeForlabels(data, completeDataFromPreference)
            : StreamBuilder<ApiResponse<UserHealthResponseList>>(
                stream: _healthReportListForUserBlock.healthReportStream,
                builder: (context,
                    AsyncSnapshot<ApiResponse<UserHealthResponseList>>
                        snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Scaffold(
                          backgroundColor: Colors.white,
                          body: Center(
                              child: SizedBox(
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                            ),
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
                        _healthReportListForUserBlock = null;
                        rebuildAllBlocks();
                        if (!fromSearch) {
                          PreferenceUtil.saveCompleteData(
                              Constants.KEY_COMPLETE_DATA,
                              snapshot.data.data.response.data);
                        }

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

  Widget getMediTypeForlabels(
      List<CategoryData> data, CompleteData completeData) {
    print('Inside getMediTypeForlabels');
    if (_mediaTypeBlock == null) {
      print('inside mediaBlock null');
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypes();
    }
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
                  child: CircularProgressIndicator(
                    backgroundColor:
                        Color(new CommonUtil().getMyPrimaryColor()),
                  ),
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
              _mediaTypeBlock = null;
              rebuildAllBlocks();
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

  Widget getStackBody(List<CategoryData> data, CompleteData completeData,
      List<MediaData> mediaData) {
    print('Inside getStackbody');
    if (mediaData == null) {
      return Container();
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        TabBarView(
            children: _getAllDataForTheTabs(data, completeData, mediaData)),
      ],
    );
  }

  List<Widget> _getAllDataForTheTabs(List<CategoryData> data,
      CompleteData completeData, List<MediaData> mediaData) {
    print('inside _getAllDataForTheTabs');

    List<Widget> tabWidgetList = new List();
    //data.sort((a, b) => a.categoryName.compareTo(b.categoryName));
    for (CategoryData dataObj in data) {
      print(dataObj.categoryName + ' /// ' + dataObj.categoryDescription);
      if (dataObj
          .isDisplay /*&& dataObj.categoryName != Constants.STR_FEEDBACK*/) {
        if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionPrescription) {
          tabWidgetList.add(new HealthReportListScreen(
              completeData,
              callBackToRefresh,
              dataObj.categoryName,
              dataObj.id,
              getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionDevice) {
          tabWidgetList.add(new DeviceListScreen(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
          ));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionLabReport) {
          tabWidgetList.add(new LabReportListScreen(
              completeData,
              callBackToRefresh,
              dataObj.categoryName,
              dataObj.id,
              getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionMedicalReport) {
          tabWidgetList.add(new MedicalReportListScreen(
              completeData,
              callBackToRefresh,
              dataObj.categoryName,
              dataObj.id,
              getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionBills) {
          tabWidgetList.add(new BillsList(completeData, callBackToRefresh,
              dataObj.categoryName, dataObj.id, getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionIDDocs) {
          tabWidgetList.add(new IDDocsList(completeData, callBackToRefresh,
              dataObj.categoryName, dataObj.id, getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionOthers) {
          tabWidgetList.add(new OtherDocsList(
              completeData,
              callBackToRefresh,
              dataObj.categoryName,
              dataObj.id,
              getDataForParticularLabel,
              CommonConstants.categoryDescriptionOthers));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionVoiceRecord) {
          tabWidgetList.add(new VoiceRecordList(completeData, callBackToRefresh,
              dataObj.categoryName, dataObj.id, getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionClaimsRecord) {
          tabWidgetList.add(new OtherDocsList(
              completeData,
              callBackToRefresh,
              dataObj.categoryName,
              dataObj.id,
              getDataForParticularLabel,
              CommonConstants.categoryDescriptionClaimsRecord));
        }
        /*  else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionWearable) {
          tabWidgetList.add(new IDDocsList(completeData, callBackToRefresh,
              categoryName, dataObj.id, getDataForParticularLabel));
        } else if (dataObj.categoryDescription ==
            CommonConstants.categoryDescriptionFeedback) {
          tabWidgetList.add(new IDDocsList(completeData, callBackToRefresh,
              categoryName, dataObj.id, getDataForParticularLabel));
        }  */
        else {
          tabWidgetList.add(new FHBBasicWidget().getContainerWithNoDataText());
        }
      }
    }
    return tabWidgetList;
  }

  List<Widget> getAllTabsToDisplayInHeader(List<CategoryData> data) {
    print('Inside getAllTabsToDisplayInHeader');

    List<Widget> tabWidgetList = new List();
    //tabWidgetList.add(SizedBox(height: 5));

    if (!fromSearch)
      PreferenceUtil.saveCategoryList(Constants.KEY_CATEGORYLIST, data);

    data.sort((a, b) {
      return a.categoryDescription
          .toLowerCase()
          .compareTo(b.categoryDescription.toLowerCase());
    });

    /* data.sort((a, b) {
      return a.categoryDescription
          .toLowerCase()
          .compareTo(b.categoryDescription.toLowerCase());
    }); */

    for (CategoryData dataObj in data) {
      if (dataObj
          .isDisplay /*&& dataObj.categoryName != Constants.STR_FEEDBACK*/) {
        tabWidgetList.add(Column(children: [
          Padding(padding: EdgeInsets.only(top: 10)),
          Image.network(
            Constants.BASERURL + dataObj.logo,
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

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  void getDataForParticularLabel(String category, String categoryId) {
    categoryName = category;
    categoryID = categoryId;

    print(categoryName + ' parvathi ' + categoryID);
  }

  Widget _buildSearchField() {
    print('inside buildsearchFields');
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  suffixIcon: Visibility(
                    visible:
                        _searchQueryController.text.length >= 3 ? true : false,
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        _searchQueryController.clear();
                        setState(() {
                          fromSearch = false;
                        });
                      },
                    ),
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 12),
                ),
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
                onChanged: (editedValue) {
                  _globalSearchBloc = null;
                  _globalSearchBloc = new GlobalSearchBloc();
                  if (editedValue != '' && editedValue.length > 3) {
                    searchQuery = editedValue;
                    _globalSearchBloc
                        .searchBasedOnMediaType(searchQuery)
                        .then((globalSearchResponse) {
                      setState(() {
                        fromSearch = true;
                      });
                    });
                  } else if (editedValue == '') {
                    searchQuery = '';
                    setState(() {
                      fromSearch = false;
                    });
                  }
                },
              ),
            ),
          ),
          //_buildActions(),
          new SwitchProfile()
              .buildActions(context, _keyLoader, callBackToRefresh)
        ],
      ),
    );
  }

  Widget _buildActions() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);

    return Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              print('Profile Pressed');
              //getAllFamilyMembers();
              CommonUtil.showLoadingDialog(context, _keyLoader, 'Please Wait');

              if (_familyListBloc != null) {
                _familyListBloc = null;
                _familyListBloc = new FamilyListBloc();
              }
              _familyListBloc.getFamilyMembersList().then((familyMembersList) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                getDialogBoxWithFamilyMemberScrap(
                    familyMembersList.response.data);
              });

              //return new FamilyListDialog();
            },
            child: CircleAvatar(
              radius: 15,
              child: ClipOval(
                  child: new FHBBasicWidget().getProfilePicWidget(
                      myProfile.response.data.generalInfo.profilePicThumbnail)),
            )));

    //}

    /*  return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ]; */
  }

  Future<Widget> getDialogBoxWithFamilyMemberScrap(FamilyData familyData) {
    return new FamilyListView(familyData).getDialogBoxWithFamilyMember(
        familyData, context, _keyLoader, (context, userId, userName) {
      PreferenceUtil.saveString(Constants.KEY_USERID, userId).then((onValue) {
        Navigator.of(context).pop();

        getUserProfileData();
      });
    });
  }

  getUserProfileData() async {
    CommonUtil.showLoadingDialog(context, _keyLoader, 'Relaoding');

    _myProfileBloc.getMyProfileData(Constants.KEY_USERID).then((profileData) {
      print('inside myrecprds' + profileData.toString());
      PreferenceUtil.saveProfileData(Constants.KEY_PROFILE, profileData)
          .then((value) {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        new CommonUtil()
            .getMedicalPreference(callBackToRefresh: callBackToRefresh);
      });

      //Navigator.of(context).pop();
      //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });
  }

  Widget getResponseForSearchedMedia() {
    /*  _globalSearchBloc = null;
    _globalSearchBloc = new GlobalSearchBloc();*/
    _globalSearchBloc.searchBasedOnMediaType(
        (searchQuery == null && searchQuery == '') ? '' : searchQuery);

    return StreamBuilder<ApiResponse<GlobalSearch>>(
      stream: _globalSearchBloc.globalSearchStream,
      builder: (context, AsyncSnapshot<ApiResponse<GlobalSearch>> snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            // rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
              width: 30,
              height: 30,
            ));

            break;

          case Status.ERROR:
            // rebuildBlockObject();
            return Text(snapshot.data.message,
                style: TextStyle(color: Colors.red));
            break;

          case Status.COMPLETED:
            _categoryListBlock = null;
            rebuildAllBlocks();
            return snapshot.data.data.response.count == 0
                ? getEmptyCard()
                : Container(
                    child: getWidgetForSearchedMedia(
                        snapshot.data.data.response.data),
                  );
            break;
        }
      },
    );
  }

  getEmptyCard() {
    return Container();
  }

  Widget getWidgetForSearchedMedia(List<Data> data) {
    List<CategoryData> categoryDataList =
        new CommonUtil().getAllCategoryList(data);

    completeData = new CommonUtil().getMediaTypeInfo(data);

    return getMainWidgets(categoryDataList);
  }

  void rebuildAllBlocks() {
    if (_categoryListBlock == null) {
      _categoryListBlock = new CategoryListBlock();
      _categoryListBlock.getCategoryList();
    } else if (_categoryListBlock != null) {
      _categoryListBlock = null;
      _categoryListBlock = new CategoryListBlock();
      _categoryListBlock.getCategoryList();
    }

    if (_healthReportListForUserBlock == null) {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportList();
    } else if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;

      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportList();
    }

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypes();
    }
    if (_familyListBloc == null) {
      _familyListBloc = new FamilyListBloc();
      _familyListBloc.getFamilyMembersList();
    }

    if (_myProfileBloc == null) {
      _myProfileBloc = new MyProfileBloc();
    }
    if (_globalSearchBloc == null) {
      _globalSearchBloc = new GlobalSearchBloc();
    }
  }

  List<CategoryData> fliterCategories(List<CategoryData> data) {
    List<CategoryData> filteredCategoryData = new List();
    for (CategoryData dataObj in data) {
      if (dataObj
          .isDisplay /*&& dataObj.categoryName != Constants.STR_FEEDBACK*/) {
        filteredCategoryData.add(dataObj);
      }
    }
    return filteredCategoryData;
  }
}
