import 'dart:convert';
import 'dart:math';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonDialogBox.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/global_search/bloc/GlobalSearchBloc.dart';
import 'package:myfhb/global_search/model/Data.dart';
import 'package:myfhb/global_search/model/GlobalSearch.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Category/catergory_data_list.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Media/MediaData.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/model/Media/media_data_list.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/src/model/TabModel.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/health/BillsList.dart';
import 'package:myfhb/src/ui/health/DeviceListScreen.dart';
import 'package:myfhb/src/ui/health/HealthReportListScreen.dart';
import 'package:myfhb/src/ui/health/HospitalDocuments.dart';
import 'package:myfhb/src/ui/health/IDDocsList.dart';
import 'package:myfhb/src/ui/health/LabReportListScreen.dart';
import 'package:myfhb/src/ui/health/MedicalReportListScreen.dart';
import 'package:myfhb/src/ui/health/NotesScreen.dart';
import 'package:myfhb/src/ui/health/OtherDocsList.dart';
import 'package:myfhb/src/ui/health/VoiceRecordList.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:showcaseview/showcase_widget.dart';

import '../../constants/fhb_constants.dart';

export 'package:myfhb/common/CommonUtil.dart';
export 'package:myfhb/src/model/Media/MediaTypeResponse.dart';

class MyRecords extends StatefulWidget {
  MyRecordsArgument argument;

  MyRecords({this.argument});

  @override
  _MyRecordsState createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  List<TabModel> tabModelList = new List();
  CategoryListBlock _categoryListBlocks;
  HealthReportListForUserBlock _healthReportListForUserBlock;
  MediaTypeBlock _mediaTypeBlock;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String categoryName;
  String categoryID;
  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  GlobalSearchBloc _globalSearchBloc;
  bool fromSearch = false;
  List<CategoryResult> categoryDataList = new List();
  HealthRecordList completeData;
  List<MediaData> mediaData = new List();

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  int initPosition = 0;

  final GlobalKey _cameraKey = GlobalKey();
  final GlobalKey _voiceKey = GlobalKey();
  BuildContext _myContext;
  CategoryResult categoryDataObjClone = new CategoryResult();

  List<String> selectedMedia = new List();
  static bool audioPage = false;

  @override
  void initState() {
    initPosition = widget.argument.categoryPosition;
    rebuildAllBlocks();
    searchQuery = _searchQueryController.text.toString();
    if (searchQuery != '') {
      _globalSearchBloc.searchBasedOnMediaType(
          _searchQueryController.text.toString() == null
              ? ''
              : _searchQueryController.text.toString());
    }
    super.initState();

    PreferenceUtil.init();

    var isFirstTime =
        PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_HOMESCREEN);
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirstTime
                ? null
                : ShowCaseWidget.of(_myContext)
                    .startShowCase([_cameraKey, _voiceKey]));
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(onFinish: () {
      PreferenceUtil.saveString(
          Constants.KEY_SHOWCASE_HOMESCREEN, variable.strtrue);
    }, builder: Builder(builder: (context) {
      _myContext = context;
      return getCompleteWidgets();
    }));
  }

  Widget getCompleteWidgets() {
    return Scaffold(
      key: scaffold_state,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: GradientAppBar(),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: _buildSearchField(),
      ),
      body: fromSearch
          ? getResponseForSearchedMedia()
          : getResponseFromApiWidget(),
    );
  }

  Widget getResponseForSearchedMedia() {
    _globalSearchBloc = null;
    _globalSearchBloc = new GlobalSearchBloc();
    _globalSearchBloc.searchBasedOnMediaType(
        (searchQuery == null && searchQuery == '') ? '' : searchQuery);

    return PreferenceUtil.getCompleteData(Constants.KEY_SEARCHED_LIST) != null
        ? getMainWidgets(PreferenceUtil.getCategoryTypeDisplay(
            Constants.KEY_SEARCHED_CATEGORY))
        : StreamBuilder<ApiResponse<GlobalSearch>>(
            stream: _globalSearchBloc.globalSearchStream,
            builder:
                (context, AsyncSnapshot<ApiResponse<GlobalSearch>> snapshot) {
              if (!snapshot.hasData) return Container();

              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Center(
                      child: SizedBox(
                    child: CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()),
                    ),
                    width: 30.0.h,
                    height: 30.0.h,
                  ));

                  break;

                case Status.ERROR:
                  return FHBBasicWidget.getRefreshContainerButton(
                      snapshot.data.message, () {
                    setState(() {});
                  });
                case Status.COMPLETED:
                  _categoryListBlocks = null;
                  //rebuildAllBlocks();
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
    List<CategoryResult> categoryDataList;

    // categoryDataList = new CommonUtil().getAllCategoryList(data);
    completeData = new CommonUtil().getMediaTypeInfo(data);
    PreferenceUtil.saveCompleteData(Constants.KEY_SEARCHED_LIST, completeData);
    PreferenceUtil.saveCategoryList(
        Constants.KEY_SEARCHED_CATEGORY, categoryDataList);

    initPosition = 0;

    return getMainWidgets(categoryDataList);
  }

  Widget getResponseFromApiWidget() {
    List<CategoryResult> categoryDataFromPrefernce =
        PreferenceUtil.getCategoryType();
    /* if (categoryDataFromPrefernce != null &&
        categoryDataFromPrefernce.length > 0)
      return getMainWidgets(categoryDataFromPrefernce);
    else*/
    return StreamBuilder<ApiResponse<CategoryDataList>>(
      stream: _categoryListBlocks.categoryListStreams,
      builder:
          (context, AsyncSnapshot<ApiResponse<CategoryDataList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
                ),
                width: 30.0.h,
                height: 30.0.h,
              ));
              break;

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data.message, () {
                setState(() {});
              });
              break;

            case Status.COMPLETED:
              _categoryListBlocks = null;
              _categoryListBlocks = new CategoryListBlock();

              if (categoryDataList.length > 0) {
                categoryDataList.clear();
              }
              if (snapshot.data.data.result != null &&
                  snapshot.data.data.result.length > 0) {
                categoryDataList.addAll(snapshot.data.data.result);
                return getMainWidgets(categoryDataList);
              } else {
                return Container(
                  width: 100.0.h,
                  height: 100.0.h,
                  child: Text(''),
                );
              }

              break;
          }
        } else {
          return Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
      },
    );
  }

  Widget getMainWidgets(List<CategoryResult> data) {
    _categoryListBlocks = null;
    _categoryListBlocks = new CategoryListBlock();
    List<CategoryResult> categoryData = new List();
    if (!fromSearch) {
      PreferenceUtil.saveCategoryList(Constants.KEY_CATEGORYLIST, data);

      List<CategoryResult> categoryDataFromPrefernce =
          PreferenceUtil.getCategoryTypeDisplay(
              Constants.KEY_CATEGORYLIST_VISIBLE);
      if (data != null && data.length > 0) {
        categoryData = fliterCategories(data);
        categoryData.add(categoryDataObjClone);
      } else {
        categoryData = fliterCategories(data);
        categoryData.add(categoryDataObjClone);
      }
      PreferenceUtil.saveCategoryList(
          Constants.KEY_CATEGORYLIST_VISIBLE, categoryData);
      completeData =
          PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA);
    } else {
      categoryData.addAll(data);

      if (PreferenceUtil.getCompleteData(Constants.KEY_SEARCHED_LIST) != null) {
        completeData =
            PreferenceUtil.getCompleteData(Constants.KEY_SEARCHED_LIST);
      }
    }
    return CustomTabView(
      initPosition: initPosition,
      itemCount: categoryData.length,
      fromSearch: fromSearch,
      argument: widget.argument,
      allowSelect: widget.argument.allowSelect ?? false,
      allowSelectVoice: widget.argument.isAudioSelect ?? false,
      allowSelectNotes: widget.argument.isNotesSelect ?? false,
      selectedMedia: widget.argument.selectedMedias,
      isFromChat: widget.argument.isFromChat ?? false,
      showDetails: widget.argument.showDetails ?? false,
      selectedRecordsId: widget.argument.selectedRecordIds,
      isAssociateOrChat: widget.argument.isAssociateOrChat ?? false,
      isFromBills: widget.argument.isFromBills ?? false,
      onPositionChange: (index) {
        try {
          initPosition = index;

          getDataForParticularLabel(categoryData.elementAt(index).categoryName,
              categoryData.elementAt(index).id);

          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName)
              .then((value) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID)
                .then((value) {});
          });
        } catch (e) {}
      },
      onScroll: (position) {
        try {
          initPosition = position.toInt();
          getDataForParticularLabel(
              categoryData.elementAt(position.toInt()).categoryName,
              categoryData.elementAt(position.toInt()).id);

          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName)
              .then((value) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID)
                .then((value) {});
          });
        } catch (e) {}
      },
      categoryData: categoryData,
      cameraKey: _cameraKey,
      voiceKey: _voiceKey,
      scaffold_state: scaffold_state,
      completeData: completeData,
      recordsState: this,
      userID: widget.argument.userID ?? '',
      fromAppointments: widget.argument.fromAppointments ?? false,
      fromClass: widget.argument.fromClass,
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.only(top: 2, right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: 40.0.h),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                controller: _searchQueryController,
                autofocus: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  hintText: variable.strSearchRecords,
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
                        PreferenceUtil.saveCompleteData(
                                Constants.KEY_SEARCHED_LIST, null)
                            .then((value) {
                          setState(() {
                            fromSearch = false;
                          });
                        });
                      },
                    ),
                  ),
                  border: InputBorder.none,
                  hintStyle:
                      TextStyle(color: Colors.black45, fontSize: 16.0.sp),
                ),
                style: TextStyle(color: Colors.black54, fontSize: 16.0.sp),
                onChanged: (editedValue) {
                  _globalSearchBloc = null;
                  _globalSearchBloc = new GlobalSearchBloc();
                  /*if (editedValue != '' && editedValue.length > 3) {
                    PreferenceUtil.saveCompleteData(
                            Constants.KEY_SEARCHED_LIST, null)
                        .then((value) {
                      searchQuery = editedValue;
                      _globalSearchBloc
                          .searchBasedOnMediaType(searchQuery)
                          .then((globalSearchResponse) {
                        setState(() {
                          fromSearch = true;
                        });
                      });
                    });
                  } else if (editedValue == '') {
                    PreferenceUtil.saveCompleteData(
                            Constants.KEY_SEARCHED_LIST, null)
                        .then((value) {
                      searchQuery = '';
                      setState(() {
                        fromSearch = false;
                      });
                    });
                  }*/
                },
              ),
            ),
          ),
          SizedBoxWidget(
            width: 2.0.w,
          ),
          new CommonUtil().getNotificationIcon(context),
          new SwitchProfile()
              .buildActions(context, _keyLoader, callBackToRefresh, false),
        ],
      ),
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  void rebuildAllBlocks() {
    if (_categoryListBlocks == null) {
      _categoryListBlocks = new CategoryListBlock();
      _categoryListBlocks.getCategoryLists();
    } else if (_categoryListBlocks != null) {
      _categoryListBlocks = null;
      _categoryListBlocks = new CategoryListBlock();
      _categoryListBlocks.getCategoryLists();
    }

    if (_healthReportListForUserBlock == null) {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportLists();
    } else if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;

      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportLists();
    }

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypesList();
    }
    /* if (_familyListBloc == null) {
      _familyListBloc = new FamilyListBloc();
      _familyListBloc.getFamilyMembersList();
    }*/

    if (_myProfileBloc == null) {
      _myProfileBloc = new MyProfileBloc();
    }
    if (_globalSearchBloc == null) {
      _globalSearchBloc = new GlobalSearchBloc();
    }
  }

  List<CategoryResult> fliterCategories(List<CategoryResult> data) {
    List<CategoryResult> filteredCategoryData = new List();
    for (CategoryResult dataObj in data) {
      if (dataObj.isDisplay &&
          dataObj.categoryName != Constants.STR_FEEDBACK &&
          dataObj.categoryName != Constants.STR_CLAIMSRECORD &&
          dataObj.categoryName != Constants.STR_WEARABLES) {
        if (!filteredCategoryData.contains(dataObj)) {
          filteredCategoryData.add(dataObj);
        }
      }
    }

    int i = 0;
    for (CategoryResult categoryDataObj in filteredCategoryData) {
      if (categoryDataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        categoryDataObjClone = categoryDataObj;
        filteredCategoryData.removeAt(i);
        break;
      }
      i++;
    }

    filteredCategoryData.sort((a, b) {
      return a.categoryDescription
          .toLowerCase()
          .compareTo(b.categoryDescription.toLowerCase());
    });

    return filteredCategoryData;
  }

  void getDataForParticularLabel(String category, String categoryId) {
    categoryName = category;
    categoryID = categoryId;
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;
  List<CategoryResult> categoryData;

  GlobalKey cameraKey;
  GlobalKey voiceKey;
  GlobalKey<ScaffoldState> scaffold_state;
  bool fromSearch;
  HealthRecordList completeData;
  List<String> selectedMedia = new List();
  bool allowSelect;
  bool allowSelectNotes;
  bool allowSelectVoice;
  bool isFromChat;
  bool showDetails;
  _MyRecordsState recordsState;
  HealthResult healthResult;
  List<HealthRecordCollection> selectedRecordsId = new List();
  bool isAssociateOrChat;
  bool isFromBills;
  String userID;
  bool fromAppointments;
  String fromClass;
  MyRecordsArgument argument;
  CustomTabView(
      {@required this.itemCount,
      this.tabBuilder,
      this.pageBuilder,
      this.stub,
      this.onPositionChange,
      this.onScroll,
      this.initPosition,
      this.categoryData,
      this.cameraKey,
      this.voiceKey,
      this.scaffold_state,
      this.fromSearch,
      this.completeData,
      this.allowSelect,
      this.selectedMedia,
      this.allowSelectNotes,
      this.allowSelectVoice,
      this.isFromChat,
      this.showDetails,
      this.recordsState,
      this.healthResult,
      this.selectedRecordsId,
      this.isAssociateOrChat,
      this.isFromBills,
      this.userID,
      this.fromAppointments,
      this.fromClass,
      this.argument});

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  List<TabModel> tabModelList = new List();
  CategoryListBlock _categoryListBlock;
  HealthReportListForUserBlock _healthReportListForUserBlock;
  MediaTypeBlock _mediaTypeBlock;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  String categoryName = '';
  String categoryID = '';

  FamilyListBloc _familyListBloc;
  MyProfileBloc _myProfileBloc;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  GlobalSearchBloc _globalSearchBloc;
  List<CategoryData> categoryDataList = new List();
  List<MediaData> mediaData = new List();

  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  bool containsAudio = false;
  String audioPath = '';
  HealthResult selectedResult;

  @override
  void initState() {
    if (widget.fromSearch) {
      _currentPosition = 0;
    } else {
      _currentPosition = widget.initPosition ?? 0;
    }

    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition >= widget.itemCount ? 0 : _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                Color(new CommonUtil().getMyPrimaryColor()),
                Color(new CommonUtil().getMyGredientColor())
              ],
                  stops: [
                0.3,
                1.0
              ])),
          child: TabBar(
            indicatorWeight: 4,
            isScrollable: true,
            controller: controller,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 2.0.w,
                ),
              ),
            ),
            tabs: getAllTabsToDisplayInHeader(widget.categoryData),
          ),
        ),
        Expanded(
          child: getAllTabsToDisplayInBodyClone(widget.categoryData),
        ),
      ],
    );
  }

  Widget getAllTabsToDisplayInBodyClone(List<CategoryResult> data) {
    rebuildAllBlocks();
    if (widget.selectedMedia == null) {
      widget.selectedMedia = new List();
    }

    if (widget.selectedRecordsId == null) {
      widget.selectedRecordsId = new List();
    }

    return Stack(alignment: Alignment.bottomRight, children: <Widget>[
      getAllTabsToDisplayInBody(data),
      Container(
        margin: EdgeInsets.only(right: 10, bottom: 10),
        constraints: BoxConstraints(maxHeight: 100.0.h),
        decoration: BoxDecoration(
            color: Color(new CommonUtil().getMyPrimaryColor()),
            borderRadius: BorderRadius.circular(30)),
        child: (widget.categoryData != null &&
                widget.categoryData[controller.index].categoryName ==
                    Constants.STR_NOTES)
            ? IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  onCameraClicked();
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FHBBasicWidget.customShowCase(
                      widget.cameraKey,
                      Constants.CAMERA_DESC,
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          onCameraClicked();
                        },
                      ),
                      Constants.CAMERA_TITLE),
                  Container(
                    width: 20.0.w,
                    height: 1.0.h,
                    color: Colors.white,
                  ),
                  FHBBasicWidget.customShowCase(
                      widget.voiceKey,
                      Constants.VOICE_DESC,
                      IconButton(
                        icon: Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          onVoiceRecordClicked();
                        },
                      ),
                      Constants.VOICE_TITLE),
                ],
              ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: widget.isAssociateOrChat
              /*(widget.selectedMedia != null &&
                  widget.selectedMedia.length > 0 &&
                  !widget.showDetails)*/
              ? OutlineButton(
                  onPressed: () {
                    if (widget.isFromChat) {
                      Navigator.of(context)
                          .pop({'metaId': widget.selectedRecordsId});
                    } else {
                      if (widget.allowSelect) {
                        if (widget.fromAppointments) {
                          Navigator.of(context).pop(
                              {'selectedResult': json.encode(selectedResult)});
                        } else {
                          Navigator.of(context)
                              .pop({'metaId': widget.selectedMedia});
                        }
                      } else {
                        if (widget.fromAppointments) {
                          Navigator.of(context)
                              .pop({'selectedResult': selectedResult});
                        } else {
                          Navigator.of(context)
                              .pop({'metaId': widget.selectedMedia});
                        }
                      }
                    }
                  },
                  child: widget.isFromChat ? Text('Attach') : Text('Associate'),
                  textColor: Color(new CommonUtil().getMyPrimaryColor()),
                  color: Colors.white,
                  borderSide: BorderSide(
                      color: Color(new CommonUtil().getMyPrimaryColor())),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                )
              : SizedBox()
          //: SizedBox(),
          )
    ]);
  }

  Widget getAllTabsToDisplayInBody(List<CategoryResult> data) {
    HealthRecordList completeDataFromPreference =
        PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA);
    return widget.fromSearch
        ? getMediTypeForlabels(data, widget.completeData)
        : /*completeDataFromPreference != null
            ? getMediTypeForlabels(data, completeDataFromPreference)
            : */
        StreamBuilder<ApiResponse<HealthRecordList>>(
            stream: _healthReportListForUserBlock.healthReportStreams,
            builder: (context,
                AsyncSnapshot<ApiResponse<HealthRecordList>> snapshot) {
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
                        width: 30.0.h,
                        height: 30.0.h,
                      )),
                    );
                    break;

                  case Status.ERROR:
                    return FHBBasicWidget.getRefreshContainerButton(
                        snapshot.data.message, () {
                      setState(() {});
                    });
                    break;

                  case Status.COMPLETED:
                    _healthReportListForUserBlock = null;
                    rebuildAllBlocks();
                    if (!widget.fromSearch) {
                      PreferenceUtil.saveCompleteData(
                          Constants.KEY_COMPLETE_DATA, snapshot.data.data);
                    }

                    return getMediTypeForlabels(data, snapshot.data.data);
                    break;
                }
              } else {
                return Container(height: 0.0.h, color: Colors.white);
              }
            },
          );
  }

  Widget getAllTabsToDisplayInBodyDemo(List<CategoryResult> data) {
    HealthRecordList completeDataFromPreference =
        PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA);
    return widget.fromSearch
        ? getMediTypeForlabels(data, widget.completeData)
        /*: completeDataFromPreference != null
            ? getMediTypeForlabels(data, completeDataFromPreference)
            */
        : StreamBuilder<ApiResponse<HealthRecordList>>(
            stream: _healthReportListForUserBlock.healthReportStreams,
            builder: (context,
                AsyncSnapshot<ApiResponse<HealthRecordList>> snapshot) {
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
                        width: 30.0.h,
                        height: 30.0.h,
                      )),
                    );
                    break;

                  case Status.ERROR:
                    return FHBBasicWidget.getRefreshContainerButton(
                        snapshot.data.message, () {
                      setState(() {});
                    });
                    break;

                  case Status.COMPLETED:
                    _healthReportListForUserBlock = null;
                    rebuildAllBlocks();
                    if (!widget.fromSearch) {
                      PreferenceUtil.saveCompleteData(
                          Constants.KEY_COMPLETE_DATA, snapshot.data.data);
                    }

                    return getMediTypeForlabels(data, snapshot.data.data);
                    break;
                }
              } else {
                return Container(height: 0.0.h, color: Colors.white);
              }
            },
          );
  }

  void rebuildAllBlocks() {
    if (_categoryListBlock == null) {
      _categoryListBlock = new CategoryListBlock();
      _categoryListBlock.getCategoryLists();
    } else if (_categoryListBlock != null) {
      _categoryListBlock = null;
      _categoryListBlock = new CategoryListBlock();
      _categoryListBlock.getCategoryLists();
    }

    if (_healthReportListForUserBlock == null) {
      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportLists(userID: widget.userID);
    } else if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;

      _healthReportListForUserBlock = new HealthReportListForUserBlock();
      _healthReportListForUserBlock.getHelthReportLists(userID: widget.userID);
    }

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypesList();
    }
    /*if (_familyListBloc == null) {
      _familyListBloc = new FamilyListBloc();
      _familyListBloc.getFamilyMembersList();
    }*/

    if (_myProfileBloc == null) {
      _myProfileBloc = new MyProfileBloc();
    }
    if (_globalSearchBloc == null) {
      _globalSearchBloc = new GlobalSearchBloc();
    }
  }

  Widget getMediTypeForlabels(
      List<CategoryResult> data, HealthRecordList completeData) {
    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypesList();
    } else {
      _mediaTypeBlock = null;
      _mediaTypeBlock = new MediaTypeBlock();
      _mediaTypeBlock.getMediTypesList();
    }

    List<MediaResult> selectedMediaData = PreferenceUtil.getMediaType();

    return selectedMediaData != null
        ? getStackBody(data, completeData, selectedMediaData)
        : StreamBuilder<ApiResponse<MediaDataList>>(
            stream: _mediaTypeBlock.mediaTypeStreams,
            builder:
                (context, AsyncSnapshot<ApiResponse<MediaDataList>> snapshot) {
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
                        width: 30.0.h,
                        height: 30.0.h,
                      )),
                    );

                    break;

                  case Status.ERROR:
                    return Text(variable.strNoLoadtabls,
                        style: TextStyle(color: Colors.red));
                    break;

                  case Status.COMPLETED:
                    _mediaTypeBlock = null;
                    rebuildAllBlocks();
                    PreferenceUtil.saveMediaType(
                        Constants.KEY_METADATA, snapshot.data.data.result);
                    return getStackBody(
                        data, completeData, snapshot.data.data.result);
                    break;
                }
              } else {
                return getStackBody(data, completeData, null);
              }
            },
          );
  }

  Widget getStackBody(List<CategoryResult> data, HealthRecordList completeData,
      List<MediaResult> mediaData) {
    if (mediaData == null) {
      return Container();
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        TabBarView(
          children: _getAllDataForTheTabs(data, completeData, mediaData),
          controller: controller,
        ),
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  void getDataForParticularLabel(String category, String categoryId) {
    categoryName = category;
    categoryID = categoryId;
  }

  void addHealthRecords(String metaId,
      List<HealthRecordCollection> healthRecords, bool condition) {
    if (widget.isFromChat) {
      if (condition) {
        if (!(widget.selectedRecordsId.contains(metaId))) {}
      } else {
        widget.selectedRecordsId.remove(metaId);
      }
      if (condition) {
        if (!(widget.selectedMedia.contains(metaId))) {
          widget.selectedMedia.add(metaId);
          widget.selectedRecordsId.addAll(healthRecords);
        }
      } else {
        widget.selectedMedia.remove(metaId);
        widget.selectedRecordsId.remove(healthRecords);
      }
    }
    callBackToRefresh();
  }

  void addMediaRemoveMaster(String metaId, bool condition) {
    commonMethodToAddOrRemove(metaId, condition, null);
  }

  void commonMethodToAddOrRemove(
      String metaId, bool condition, HealthResult healthCategory) {
    if (widget.allowSelect) {
      if (widget.isFromChat) {
        if (condition) {
          if (!(widget.selectedMedia.contains(metaId))) {
            widget.selectedMedia.add(metaId);
            widget.selectedRecordsId
                .addAll(healthCategory.healthRecordCollection);
          }
        } else {
          widget.selectedMedia.remove(metaId);
          widget.selectedRecordsId
              .remove(healthCategory.healthRecordCollection);
        }
      } else {
        if (condition) {
          if (!(widget.selectedMedia.contains(metaId))) {
            widget.selectedMedia.add(metaId);
          }
        } else {
          widget.selectedMedia.remove(metaId);
        }
      }
    } else if (widget.allowSelectNotes || widget.allowSelectVoice) {
      if (condition) {
        if (widget.selectedMedia.length > 0) {
          new FHBBasicWidget()
              .showInSnackBar(Constants.STR_ONLY_ONE, widget.scaffold_state);
        } else {
          widget.selectedMedia.add(metaId);
          selectedResult = healthCategory;
        }
      } else {
        widget.selectedMedia.remove(metaId);
      }
    }

    callBackToRefresh();
  }

  void addMediaRemoveMasterForNotesAndVoice(
      String metaId, bool condition, HealthResult healthCategoryID) {
    commonMethodToAddOrRemove(metaId, condition, healthCategoryID);
  }

  List<Widget> _getAllDataForTheTabs(List<CategoryResult> data,
      HealthRecordList completeData, List<MediaResult> mediaData) {
    List<Widget> tabWidgetList = new List();
    //data.sort((a, b) => a.categoryName.compareTo(b.categoryName));
    for (CategoryResult dataObj in data) {
      /* if (dataObj
                                .isDisplay && dataObj.categoryName != Constants.STR_FEEDBACK) {*/
      if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionPrescription) {
        tabWidgetList.add(new HealthReportListScreen(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionDevice) {
        tabWidgetList.add(new DeviceListScreen(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionLabReport) {
        tabWidgetList.add(new LabReportListScreen(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionMedicalReport) {
        tabWidgetList.add(new MedicalReportListScreen(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionBills) {
        tabWidgetList.add(new BillsList(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords,
            widget.isFromBills));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionIDDocs) {
        tabWidgetList.add(new IDDocsList(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        tabWidgetList.add(new OtherDocsList(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            CommonConstants.categoryDescriptionOthers,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionVoiceRecord) {
        if (CommonUtil.audioPage == false && widget.fromClass == '') {
          widget.selectedMedia = new List();
        }

        if (CommonUtil.audioPage == false && widget.fromClass == 'audio') {
          widget.fromClass = '';
        }
        tabWidgetList.add(new VoiceRecordList(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            CommonConstants.categoryDescriptionVoiceRecord,
            addMediaRemoveMasterForNotesAndVoice,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionClaimsRecord) {
        tabWidgetList.add(new OtherDocsList(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            CommonConstants.categoryDescriptionClaimsRecord,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionNotes) {
        tabWidgetList.add(new NotesScreenList(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            CommonConstants.categoryDescriptionNotes,
            addMediaRemoveMasterForNotesAndVoice,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails));
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionHospitalDocument) {
        tabWidgetList.add(new HospitalDocuments(
            completeData,
            callBackToRefresh,
            dataObj.categoryName,
            dataObj.id,
            getDataForParticularLabel,
            addMediaRemoveMaster,
            widget.allowSelect,
            widget.selectedMedia,
            widget.allowSelectNotes,
            widget.allowSelectVoice,
            widget.showDetails,
            widget.isFromChat,
            addHealthRecords));
      } else {
        tabWidgetList.add(new FHBBasicWidget().getContainerWithNoDataText());
      }
      /* }*/
    }
    return tabWidgetList;
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      setState(() {});
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);

        try {
          _currentPosition = controller.index;

          categoryName =
              categoryDataList.elementAt(_currentPosition).categoryName;
          categoryID = categoryDataList.elementAt(_currentPosition).id;
        } catch (e) {}
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);

      try {
        _currentPosition = controller.animation.value.toInt();

        categoryName = categoryDataList
            .elementAt(controller.animation.value.toInt())
            .categoryName;
        categoryID =
            categoryDataList.elementAt(controller.animation.value.toInt()).id;
      } catch (e) {}
    }
  }

  List<Widget> getAllTabsToDisplayInHeader(List<CategoryResult> data) {
    List<Widget> tabWidgetList = new List();

    data.sort((a, b) {
      return a.categoryDescription
          .toLowerCase()
          .compareTo(b.categoryDescription.toLowerCase());
    });

    for (CategoryResult dataObj in data) {
      /* if (dataObj
                                .isDisplay ) {*/
      tabWidgetList.add(Column(children: [
        Padding(padding: EdgeInsets.only(top: 10)),
        dataObj.logo != null
            ? Image.network(
                /*Constants.BASE_URL + */ dataObj.logo,
                width: 20.0.h,
                height: 20.0.h,
                color: Colors.white,
              )
            : Icon(Icons.calendar_today, size: 20.0.sp, color: Colors.white),
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
            child: Text(
          dataObj.categoryName,
          style: TextStyle(fontSize: 14.0.sp),
        )),
        Padding(padding: EdgeInsets.only(top: 10)),
      ]));
      /* }*/
    }

    return tabWidgetList;
  }

  void openNotesDialog() {
    TextEditingController fileName = new TextEditingController(
        text:
            categoryName + '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
    new CommonDialogBox().getDialogBoxForNotes(
        context,
        containsAudio,
        audioPath,
        (containsAudio, audioPath) {
          setState(() {
            audioPath = audioPath;
            containsAudio = containsAudio;
          });
        },
        null,
        (containsAudio, audioPath) {
          audioPath = audioPath;
          containsAudio = containsAudio;

          setState(() {});
        },
        null,
        false,
        fileName,
        (value) {
          if (value) {
            widget.recordsState.setState(() {});
          }
        });
  }

  void onCameraClicked() async {
//    final PermissionHandler cameraPermission = PermissionHandler();
//    var permissionStatus =
//        await cameraPermission.checkPermissionStatus(PermissionGroup.camera);
//
//    if (permissionStatus == PermissionStatus.denied ||
//        permissionStatus == PermissionStatus.unknown) {
//      await _handleCameraAndMic();
//    }
    var status = await Permission.camera.status;

    if (status.isUndetermined || status.isDenied) {
      await _handleCameraAndMic();
    } else {
      saveCategoryToPrefernce();
      if (categoryName == Constants.STR_VOICERECORDS ||
          categoryName == Constants.STR_HOSPITALDOCUMENT) {
        new FHBBasicWidget().showInSnackBar(
            Constants.MSG_NO_CAMERA_VOICERECORDS + ' ' + categoryName,
            widget.scaffold_state);
      } else if (categoryName == Constants.STR_NOTES) {
        openNotesDialog();
      } else {
        PreferenceUtil.saveString(Constants.KEY_DEVICENAME, null)
            .then((onValue) {
          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName)
              .then((onValue) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID)
                .then((value) {
              if (categoryName == STR_DEVICES) {
                PreferenceUtil.saveString(
                    Constants.stop_detecting, variable.strNO);
                PreferenceUtil.saveString(
                    Constants.stop_detecting, variable.strNO);

                Navigator.pushNamed(context, router.rt_TakePictureForDevices)
                    .then((value) {});
              } else {
                Navigator.pushNamed(context, router.rt_TakePictureScreen)
                    .then((value) {});
              }
            });
          });
        });
      }
    }
  }

  Future<void> _handleCameraAndMic() async {
    await Permission.microphone.request();
    await Permission.camera.request();
//    await PermissionHandler().requestPermissions(
//      [PermissionGroup.camera, PermissionGroup.microphone],
//    );
  }

  onVoiceRecordClicked() async {
    saveCategoryToPrefernce();
    if (categoryName == Constants.STR_HOSPITALDOCUMENT) {
      new FHBBasicWidget().showInSnackBar(
          Constants.MSG_NO_VOICERECORDS + ' ' + categoryName,
          widget.scaffold_state);
    } else {
      PreferenceUtil.saveString(
              Constants.KEY_CATEGORYNAME, Constants.STR_VOICERECORDS)
          .then((value) {
        PreferenceUtil.saveString(Constants.KEY_CATEGORYID,
                PreferenceUtil.getStringValue(Constants.KEY_VOICE_ID))
            .then((value) {
          if (widget.argument.fromClass == 'audio' ||
              widget.argument.fromClass == null) {
            Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AudioRecordScreen(
                            arguments: AudioScreenArguments(
                                fromVoice: true,
                                fromClass: categoryName ==
                                        Constants.STR_VOICERECORDS
                                    ? ''
                                    : widget.argument.fromClass ?? 'audio'))))
                .then((results) {});
          } else {
            Navigator.pushNamed(context, router.rt_AudioScreen,
                    arguments: AudioScreenArguments(
                        fromVoice: true,
                        fromClass: widget.argument.fromClass ?? 'audio'))
                .then((results) {});
          }
        });
      });
    }
  }

  saveCategoryToPrefernce() {
    categoryName = widget.categoryData.elementAt(_currentPosition).categoryName;
    categoryID = widget.categoryData.elementAt(_currentPosition).id;
  }
}
