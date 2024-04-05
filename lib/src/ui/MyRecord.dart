import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import '../../common/CommonConstants.dart';
import '../../common/CommonDialogBox.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/SwitchProfile.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/firestore_services.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../global_search/bloc/GlobalSearchBloc.dart';
import '../../global_search/model/Data.dart';
import '../../global_search/model/GlobalSearch.dart';
import '../../landing/controller/landing_screen_controller.dart';
import '../../landing/view_model/landing_view_model.dart';
import '../../main.dart';
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../widgets/GradientAppBar.dart';
import '../blocs/Category/CategoryListBlock.dart';
import '../blocs/Media/MediaTypeBlock.dart';
import '../blocs/User/MyProfileBloc.dart';
import '../blocs/health/HealthReportListForUserBlock.dart';
import '../model/Category/CategoryData.dart';
import '../model/Category/catergory_data_list.dart';
import '../model/Category/catergory_result.dart';
import '../model/Health/asgard/health_record_collection.dart';
import '../model/Health/asgard/health_record_list.dart';
import '../model/Media/MediaData.dart';
import '../model/Media/media_data_list.dart';
import '../model/Media/media_result.dart';
import '../model/TabModel.dart';
import '../resources/network/ApiResponse.dart';
import '../utils/language/language_utils.dart';
import '../utils/screenutils/size_extensions.dart';
import 'MyRecordsArguments.dart';
import 'audio/AudioRecorder.dart';
import 'audio/AudioScreenArguments.dart';
import 'health/BillsList.dart';
import 'health/DeviceListScreen.dart';
import 'health/HealthReportListScreen.dart';
import 'health/HospitalDocuments.dart';
import 'health/IDDocsList.dart';
import 'health/LabReportListScreen.dart';
import 'health/MedicalReportListScreen.dart';
import 'health/NotesScreen.dart';
import 'health/OtherDocsList.dart';
import 'health/VoiceRecordList.dart';

export 'package:myfhb/common/CommonUtil.dart';
export 'package:myfhb/src/model/Media/MediaTypeResponse.dart';

class MyRecords extends StatefulWidget {
  MyRecordsArgument? argument;
  final bool isHome;
  final Function? onBackPressed;
  final bool isPatientSwitched;
  final String patientName;
  final String patientId;

  MyRecords(
      {this.argument,
      this.isHome = false,
      this.onBackPressed,
      this.isPatientSwitched = false,
      this.patientName = '',
      this.patientId = ''});

  @override
  _MyRecordsState createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  List<TabModel> tabModelList = [];
  CategoryListBlock? _categoryListBlocks;
  HealthReportListForUserBlock? _healthReportListForUserBlock;
  MediaTypeBlock? _mediaTypeBlock;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = 'Search query';
  String? categoryName;
  String? categoryID;
  FamilyListBloc? _familyListBloc;
  MyProfileBloc? _myProfileBloc;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  GlobalSearchBloc? _globalSearchBloc;
  bool fromSearch = false;
  List<CategoryResult> categoryDataList = [];
  HealthRecordList? completeData;
  List<MediaData> mediaData = [];

  GlobalKey<ScaffoldMessengerState> scaffold_state =
      GlobalKey<ScaffoldMessengerState>();
  int? initPosition = 0;

  final GlobalKey _cameraKey = GlobalKey();
  final GlobalKey _voiceKey = GlobalKey();
  late BuildContext _myContext;
  CategoryResult categoryDataObjClone = CategoryResult();

  List<String> selectedMedia = [];
  static bool audioPage = false;
  LandingViewModel? landingViewModel;
  late BuildContext context;
  QurhomeDashboardController qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();
  LandingScreenController landingScreenController =
      CommonUtil().onInitLandingScreenController();

  @override
  void initState() {
    qurhomeDashboardController.getModuleAccess();
    initPosition = widget.argument!.categoryPosition;
    rebuildAllBlocks();
    searchQuery = _searchQueryController.text.toString();
    if (searchQuery != '') {
      _globalSearchBloc!.searchBasedOnMediaType(
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
            const Duration(milliseconds: 1000),
            () => isFirstTime
                ? null
                : ShowCaseWidget.of(_myContext)!
                    .startShowCase([_cameraKey, _voiceKey]));
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    landingViewModel = Provider.of<LandingViewModel>(context);

    return WillPopScope(
      onWillPop: () {
        if (widget.isHome) {
          if (landingScreenController?.isSearchVisible.value ?? false) {
            landingScreenController?.changeSearchBar();
          } else {
            widget.onBackPressed!();
          }
        }
        return Future.value(widget.isHome ? false : true);
      },
      child: ShowCaseWidget(onFinish: () {
        PreferenceUtil.saveString(
            Constants.KEY_SHOWCASE_HOMESCREEN, variable.strtrue);
      }, builder: Builder(builder: (context) {
        _myContext = context;
        return getCompleteWidgets();
      })),
    );
  }

  Widget getCompleteWidgets() => Scaffold(
        key: scaffold_state,
        appBar: widget.isHome &&
                !(landingScreenController?.isSearchVisible.value ?? false)
            ? null
            : AppBar(
                toolbarHeight: CommonUtil().isTablet!
                    ? 80
                    : 60, //Set width and height to maintain UI similar in tablet and mobile ,to increase the space above the tabbar

                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: GradientAppBar(),
                leading: IconWidget(
                  icon: widget.isHome ? Icons.cancel : Icons.arrow_back_ios,
                  colors: Colors.white,
                  size: 24.0.sp,
                  onTap: () {
                    if (widget.isHome) {
                      if (landingScreenController?.isSearchVisible.value ??
                          false) {
                        _searchQueryController.clear();
                        landingScreenController?.changeSearchBar();
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                titleSpacing: 0,
                title: _buildSearchField(),
              ),
        body: fromSearch
            ? getResponseForSearchedMedia()
            : getResponseFromApiWidget(),
      );

  Widget getResponseForSearchedMedia() {
    _globalSearchBloc = null;
    _globalSearchBloc = GlobalSearchBloc();
    _globalSearchBloc!.searchBasedOnMediaType(
        (searchQuery == null && searchQuery == '') ? '' : searchQuery);

    return PreferenceUtil.getCompleteData(Constants.KEY_SEARCHED_LIST) != null
        ? getMainWidgets(PreferenceUtil.getCategoryTypeDisplay(
            Constants.KEY_SEARCHED_CATEGORY)!)
        : StreamBuilder<ApiResponse<GlobalSearch>>(
            stream: _globalSearchBloc!.globalSearchStream,
            builder:
                (context, AsyncSnapshot<ApiResponse<GlobalSearch>> snapshot) {
              if (!snapshot.hasData) return Container();

              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Center(
                      child: SizedBox(
                    width: 30.0.h,
                    height: 30.0.h,
                    child: CommonCircularIndicator(),
                  ));

                case Status.ERROR:
                  return FHBBasicWidget.getRefreshContainerButton(
                      snapshot.data!.message, () {
                    setState(() {});
                  });
                case Status.COMPLETED:
                  _categoryListBlocks = null;
                  //rebuildAllBlocks();
                  return snapshot.data!.data!.response!.count == 0
                      ? getEmptyCard()
                      : Container(
                          child: getWidgetForSearchedMedia(
                              snapshot.data!.data!.response!.data!),
                        );
              }
            },
          );
  }

  Container getEmptyCard() => Container();

  Widget getWidgetForSearchedMedia(List<Data> data) {
    List<CategoryResult> categoryDataList = [];

    // categoryDataList = CommonUtil().getAllCategoryList(data);
    completeData = CommonUtil().getMediaTypeInfo(data);
    PreferenceUtil.saveCompleteData(Constants.KEY_SEARCHED_LIST, completeData);
    PreferenceUtil.saveCategoryList(
        Constants.KEY_SEARCHED_CATEGORY, categoryDataList);

    initPosition = 0;

    return getMainWidgets(categoryDataList);
  }

  Widget getResponseFromApiWidget() {
    List<CategoryResult>? categoryDataFromPrefernce =
        PreferenceUtil.getCategoryType();

    return StreamBuilder<ApiResponse<CategoryDataList>>(
      stream: _categoryListBlocks!.categoryListStreams,
      builder:
          (context, AsyncSnapshot<ApiResponse<CategoryDataList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data!.message, () {
                setState(() {});
              });

            case Status.COMPLETED:
              _categoryListBlocks = null;
              _categoryListBlocks = CategoryListBlock();

              if (categoryDataList.length > 0) {
                categoryDataList.clear();
              }
              if (snapshot.data!.data!.result != null &&
                  snapshot.data!.data!.result!.length > 0) {
                categoryDataList.addAll(snapshot.data!.data!.result!);
                return getMainWidgets(categoryDataList);
              } else {
                return Container(
                  width: 100.0.h,
                  height: 100.0.h,
                  child: const Text(''),
                );
              }
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
    _categoryListBlocks = CategoryListBlock();
    List<CategoryResult> categoryData = [];
    if (!fromSearch) {
      PreferenceUtil.saveCategoryList(Constants.KEY_CATEGORYLIST, data);

      List<CategoryResult>? categoryDataFromPrefernce =
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
      allowSelect: widget.argument!.allowSelect ?? false,
      allowSelectVoice: widget.argument!.isAudioSelect ?? false,
      allowSelectNotes: widget.argument!.isNotesSelect ?? false,
      selectedMedia: widget.argument!.selectedMedias,
      isFromChat: widget.argument!.isFromChat ?? false,
      showDetails: widget.argument!.showDetails ?? false,
      selectedRecordsId: widget.argument!.selectedRecordIds,
      isAssociateOrChat: widget.argument!.isAssociateOrChat ?? false,
      isFromBills: widget.argument!.isFromBills ?? false,
      onPositionChange: (index) {
        try {
          initPosition = index;

          getDataForParticularLabel(categoryData.elementAt(index!).categoryName,
              categoryData.elementAt(index).id);

          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName!)
              .then((value) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID!)
                .then((value) {});
          });
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      },
      onScroll: (position) {
        try {
          initPosition = position.toInt();
          getDataForParticularLabel(
              categoryData.elementAt(position.toInt()).categoryName,
              categoryData.elementAt(position.toInt()).id);

          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName!)
              .then((value) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID!)
                .then((value) {});
          });
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      },
      categoryData: categoryData,
      cameraKey: _cameraKey,
      voiceKey: _voiceKey,
      scaffold_state: scaffold_state,
      completeData: completeData,
      recordsState: this,
      userID: widget.argument!.userID ?? '',
      fromAppointments: widget.argument!.fromAppointments ?? false,
      fromClass: widget.argument!.fromClass,
      isFromVideoCall: widget.argument?.isFromVideoCall ?? false,
      isPatientSwitched: widget.isPatientSwitched,
      patientId: widget.patientId,
      patientName: widget.patientName,
    );
  }

  Widget _buildSearchField() => Padding(
        padding: const EdgeInsets.only(top: 2, right: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxHeight: 40.0.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _searchQueryController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(2),
                    hintText: variable.strSearchRecords,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    suffixIcon: Visibility(
                      visible: _searchQueryController.text.length >= 3,
                      child: IconButton(
                        icon: const Icon(
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
                    _globalSearchBloc = GlobalSearchBloc();
                  },
                ),
              ),
            ),
            SizedBoxWidget(
              width: 2.0.w,
            ),
            CommonUtil().getNotificationIcon(context),
            SwitchProfile().buildActions(
                context, _keyLoader, callBackToRefresh, false,
                changeWhiteBg: true),
          ],
        ),
      );

  void callBackToRefresh() {
    FirestoreServices().updateFirestoreListner();

    (context as Element).markNeedsBuild();
  }

  void rebuildAllBlocks() {
    if (_categoryListBlocks == null) {
      _categoryListBlocks = CategoryListBlock();
      _categoryListBlocks!.getCategoryLists();
    } else if (_categoryListBlocks != null) {
      _categoryListBlocks = null;
      _categoryListBlocks = CategoryListBlock();
      _categoryListBlocks!.getCategoryLists();
    }

    if (_healthReportListForUserBlock == null) {
      _healthReportListForUserBlock = HealthReportListForUserBlock();
      _healthReportListForUserBlock!.getHelthReportLists();
    } else if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;

      _healthReportListForUserBlock = HealthReportListForUserBlock();
      _healthReportListForUserBlock!.getHelthReportLists();
    }

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = MediaTypeBlock();
      _mediaTypeBlock!.getMediTypesList();
    }

    if (_myProfileBloc == null) {
      _myProfileBloc = MyProfileBloc();
    }
    if (_globalSearchBloc == null) {
      _globalSearchBloc = GlobalSearchBloc();
    }
  }

  List<CategoryResult> fliterCategories(List<CategoryResult> data) {
    List<CategoryResult> filteredCategoryData = [];
    for (CategoryResult dataObj in data) {
      if (dataObj.isDisplay! &&
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

    filteredCategoryData.sort((a, b) => a.categoryDescription!
        .toLowerCase()
        .compareTo(b.categoryDescription!.toLowerCase()));

    return filteredCategoryData;
  }

  void getDataForParticularLabel(String? category, String? categoryId) {
    categoryName = category;
    categoryID = categoryId;
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  CustomTabView(
      {required this.itemCount,
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
      this.argument,
      this.isFromVideoCall,
      this.isPatientSwitched,
      this.patientName,
      this.patientId});
  final int itemCount;
  final IndexedWidgetBuilder? tabBuilder;
  final IndexedWidgetBuilder? pageBuilder;
  final Widget? stub;
  final ValueChanged<int?>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;
  List<CategoryResult>? categoryData;

  GlobalKey? cameraKey;
  GlobalKey? voiceKey;
  GlobalKey<ScaffoldMessengerState>? scaffold_state;
  bool? fromSearch;
  HealthRecordList? completeData;
  List<String?>? selectedMedia = [];
  bool? allowSelect;
  bool? allowSelectNotes;
  bool? allowSelectVoice;
  bool? isFromChat;
  bool? showDetails;
  _MyRecordsState? recordsState;
  HealthResult? healthResult;
  List<HealthRecordCollection>? selectedRecordsId = [];
  bool? isAssociateOrChat;
  bool? isFromBills;
  String? userID;
  bool? fromAppointments;
  String? fromClass;
  MyRecordsArgument? argument;
  bool? isFromVideoCall = false;
  bool? isPatientSwitched;
  String? patientName;
  String? patientId;

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController? controller;
  int? _currentCount;
  int? _currentPosition;

  List<TabModel> tabModelList = [];
  CategoryListBlock? _categoryListBlock;
  HealthReportListForUserBlock? _healthReportListForUserBlock;
  MediaTypeBlock? _mediaTypeBlock;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = 'Search query';
  String? categoryName = '';
  String? categoryID = '';

  FamilyListBloc? _familyListBloc;
  MyProfileBloc? _myProfileBloc;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  GlobalSearchBloc? _globalSearchBloc;
  List<CategoryData> categoryDataList = [];
  List<MediaData> mediaData = [];

  GlobalKey<ScaffoldMessengerState> scaffold_state =
      GlobalKey<ScaffoldMessengerState>();
  bool containsAudio = false;
  String audioPath = '';
  HealthResult? selectedResult;
  late CommonUtil commonUtil;

  final qurhomeDashboardController = Get.put(QurhomeDashboardController());
  LandingScreenController landingScreenController =
      CommonUtil().onInitLandingScreenController();

  @override
  void initState() {
    commonUtil = CommonUtil();
    if (widget.fromSearch!) {
      _currentPosition = 0;
    } else {
      _currentPosition = widget.initPosition ?? 0;
    }

    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex:
          _currentPosition! >= widget.itemCount ? 0 : _currentPosition!,
    );
    controller!.addListener(onPositionChange);
    controller!.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller!.animation!.removeListener(onScroll);
      controller!.removeListener(onPositionChange);
      controller!.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition! > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition! < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller!.addListener(onPositionChange);
        controller!.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller!.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller!.animation!.removeListener(onScroll);
    controller!.removeListener(onPositionChange);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.patientId != '') {
      var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      if (userId == widget.patientId) {
        widget.isPatientSwitched = false;
      } else {
        widget.isPatientSwitched = true;
      }
    }
    if (widget.isPatientSwitched!) {
      if (CommonUtil.dialogboxOpen != true) {
        Future.delayed(
          Duration.zero,
          () => commonUtil.showCommonDialogBox(
            'Switch to ${widget.patientName} profile to view the Prescription',
            context,
          ),
        );
      }
    }

    if (widget.itemCount < 1) {
      return widget.stub ?? Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                mAppThemeProvider.primaryColor,
                mAppThemeProvider.gradientColor
              ],
              stops: const [
                0.3,
                1.0,
              ],
            ),
          ),
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
            tabs: getAllTabsToDisplayInHeader(widget.categoryData!),
          ),
        ),
        Expanded(
          child: getAllTabsToDisplayInBodyClone(widget.categoryData),
        ),
      ],
    );
  }

  Widget getAllTabsToDisplayInBodyClone(List<CategoryResult>? data) {
    rebuildAllBlocks();
    widget.selectedMedia ??= [];
    widget.selectedRecordsId ??= [];
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        getAllTabsToDisplayInBody(data),
        Container(
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            constraints: BoxConstraints(maxHeight: 120.0.h),
            decoration: BoxDecoration(
                color: mAppThemeProvider.primaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: (widget.categoryData != null &&
                    widget.categoryData![controller!.index].categoryName ==
                        AppConstants.notes)
                ? IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      onCameraClicked();
                    },
                  )
                : ((CommonUtil.isUSRegion()) &&
                        (controller!.index == 1) &&
                        (qurhomeDashboardController.isVitalModuleDisable.value))
                    ? const SizedBox.shrink()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FHBBasicWidget.customShowCase(
                              widget.cameraKey,
                              Constants.CAMERA_DESC,
                              Tooltip(
                                message: 'Camera disabled',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: widget.isFromVideoCall!
                                        ? Colors.black38
                                        : Colors.white,
                                    size: CommonUtil().isTablet!
                                        ? 20.0.sp
                                        : 30.0.sp,
                                  ),
                                  onPressed: widget.isFromVideoCall!
                                      ? null
                                      : () {
                                          onCameraClicked();
                                        },
                                ),
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
                              Tooltip(
                                message: 'Microphone disabled',
                                child: IconButton(
                                  icon: Icon(
                                    Icons.mic,
                                    color: widget.isFromVideoCall!
                                        ? Colors.black38
                                        : Colors.white,
                                    size: CommonUtil().isTablet!
                                        ? 20.0.sp
                                        : 30.0.sp,
                                  ),
                                  onPressed: widget.isFromVideoCall!
                                      ? null
                                      : () {
                                          onVoiceRecordClicked();
                                        },
                                ),
                              ),
                              Constants.VOICE_TITLE),
                        ],
                      )),
        Align(
            alignment: Alignment.bottomCenter,
            child: widget.isAssociateOrChat!
                ? OutlinedButton(
                    onPressed: () {
                      if (widget.isFromChat!) {
                        Navigator.of(context)
                            .pop({'metaId': widget.selectedRecordsId});
                      } else {
                        if (widget.allowSelect!) {
                          if (widget.fromAppointments!) {
                            Navigator.of(context).pop({
                              'selectedResult': json.encode(selectedResult)
                            });
                          } else {
                            Navigator.of(context)
                                .pop({'metaId': widget.selectedMedia});
                          }
                        } else {
                          if (widget.fromAppointments!) {
                            Navigator.of(context)
                                .pop({'selectedResult': selectedResult});
                          } else {
                            Navigator.of(context)
                                .pop({'metaId': widget.selectedMedia});
                          }
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: mAppThemeProvider.primaryColor,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: mAppThemeProvider.primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: widget.isFromChat!
                        ? const Text('Attach')
                        : const Text('Associate'),
                  )
                : const SizedBox())
      ],
    );
  }

  Widget getAllTabsToDisplayInBody(List<CategoryResult>? data) =>
      widget.fromSearch!
          ? getMediTypeForlabels(data, widget.completeData)
          : StreamBuilder<ApiResponse<HealthRecordList>>(
              stream: _healthReportListForUserBlock!.healthReportStreams,
              builder: (context,
                  AsyncSnapshot<ApiResponse<HealthRecordList>> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                            child: SizedBox(
                          width: 30.0.h,
                          height: 30.0.h,
                          child: CommonCircularIndicator(),
                        )),
                      );

                    case Status.ERROR:
                      return FHBBasicWidget.getRefreshContainerButton(
                          snapshot.data!.message, () {
                        setState(() {});
                      });

                    case Status.COMPLETED:
                      _healthReportListForUserBlock = null;
                      rebuildAllBlocks();
                      if (!widget.fromSearch!) {
                        PreferenceUtil.saveCompleteData(
                            Constants.KEY_COMPLETE_DATA, snapshot.data!.data);
                      }

                      return getMediTypeForlabels(data, snapshot.data!.data);
                  }
                } else {
                  return Container(height: 0.0.h, color: Colors.white);
                }
              },
            );

  Widget getAllTabsToDisplayInBodyDemo(List<CategoryResult> data) {
    HealthRecordList? completeDataFromPreference =
        PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA);
    return widget.fromSearch!
        ? getMediTypeForlabels(data, widget.completeData)
        : StreamBuilder<ApiResponse<HealthRecordList>>(
            stream: _healthReportListForUserBlock!.healthReportStreams,
            builder: (context,
                AsyncSnapshot<ApiResponse<HealthRecordList>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                          child: SizedBox(
                        width: 30.0.h,
                        height: 30.0.h,
                        child: CommonCircularIndicator(),
                      )),
                    );

                  case Status.ERROR:
                    return FHBBasicWidget.getRefreshContainerButton(
                        snapshot.data!.message, () {
                      setState(() {});
                    });

                  case Status.COMPLETED:
                    _healthReportListForUserBlock = null;
                    rebuildAllBlocks();
                    if (!widget.fromSearch!) {
                      PreferenceUtil.saveCompleteData(
                          Constants.KEY_COMPLETE_DATA, snapshot.data!.data);
                    }

                    return getMediTypeForlabels(data, snapshot.data!.data);
                }
              } else {
                return Container(height: 0.0.h, color: Colors.white);
              }
            },
          );
  }

  void rebuildAllBlocks() {
    if (_categoryListBlock == null) {
      _categoryListBlock = CategoryListBlock();
      _categoryListBlock!.getCategoryLists();
    } else if (_categoryListBlock != null) {
      _categoryListBlock = null;
      _categoryListBlock = CategoryListBlock();
      _categoryListBlock!.getCategoryLists();
    }

    if (_healthReportListForUserBlock == null) {
      _healthReportListForUserBlock = HealthReportListForUserBlock();
      _healthReportListForUserBlock!.getHelthReportLists(userID: widget.userID);
    } else if (_healthReportListForUserBlock != null) {
      _healthReportListForUserBlock = null;

      _healthReportListForUserBlock = HealthReportListForUserBlock();
      _healthReportListForUserBlock!.getHelthReportLists(userID: widget.userID);
    }

    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = MediaTypeBlock();
      _mediaTypeBlock!.getMediTypesList();
    }

    if (_myProfileBloc == null) {
      _myProfileBloc = MyProfileBloc();
    }
    if (_globalSearchBloc == null) {
      _globalSearchBloc = GlobalSearchBloc();
    }
  }

  Widget getMediTypeForlabels(
      List<CategoryResult>? data, HealthRecordList? completeData) {
    if (_mediaTypeBlock == null) {
      _mediaTypeBlock = MediaTypeBlock();
      _mediaTypeBlock!.getMediTypesList();
    } else {
      _mediaTypeBlock = null;
      _mediaTypeBlock = MediaTypeBlock();
      _mediaTypeBlock!.getMediTypesList();
    }

    List<MediaResult> selectedMediaData = PreferenceUtil.getMediaType();

    return selectedMediaData != null
        ? getStackBody(data, completeData, selectedMediaData)
        : StreamBuilder<ApiResponse<MediaDataList>>(
            stream: _mediaTypeBlock!.mediaTypeStreams,
            builder:
                (context, AsyncSnapshot<ApiResponse<MediaDataList>> snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                          child: SizedBox(
                        width: 30.0.h,
                        height: 30.0.h,
                        child: CommonCircularIndicator(),
                      )),
                    );

                  case Status.ERROR:
                    return const Text(variable.strNoLoadtabls,
                        style: TextStyle(color: Colors.red));

                  case Status.COMPLETED:
                    _mediaTypeBlock = null;
                    rebuildAllBlocks();
                    PreferenceUtil.saveMediaType(
                        Constants.KEY_METADATA, snapshot.data!.data!.result);
                    return getStackBody(
                        data, completeData, snapshot.data!.data!.result!);
                }
              } else {
                return getStackBody(data, completeData, null);
              }
            },
          );
  }

  Widget getStackBody(List<CategoryResult>? data,
      HealthRecordList? completeData, List<MediaResult>? mediaData) {
    if (mediaData == null) {
      return Container();
    }
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        TabBarView(
          controller: controller,
          children: _getAllDataForTheTabs(data!, completeData, mediaData),
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

  void addHealthRecords(String? metaId,
      List<HealthRecordCollection>? healthRecords, bool? condition) {
    if (widget.isFromChat!) {
      if (condition!) {
        if (!widget.selectedRecordsId!.contains(metaId)) {}
      } else {
        widget.selectedRecordsId!.remove(metaId);
      }
      if (condition) {
        if (!widget.selectedMedia!.contains(metaId!)) {
          widget.selectedMedia!.add(metaId);
          widget.selectedRecordsId!.addAll(healthRecords!);
        }
      } else {
        widget.selectedMedia!.remove(metaId!);
        if ((healthRecords != null) && (healthRecords?.length ?? 0) > 0) {
          for (final healthRecord in healthRecords) {
            widget.selectedRecordsId?.removeWhere(
                (item) => (item.id ?? '') == (healthRecord.id ?? ''));
          }
        }
      }
    }
    callBackToRefresh();
  }

  void addMediaRemoveMaster(String? metaId, bool? condition) {
    commonMethodToAddOrRemove(metaId!, condition!, null);
  }

  void commonMethodToAddOrRemove(
      String metaId, bool condition, HealthResult? healthCategory) {
    if (widget.allowSelect!) {
      if (widget.isFromChat!) {
        if (condition) {
          if (!widget.selectedMedia!.contains(metaId)) {
            widget.selectedMedia!.add(metaId);
            widget.selectedRecordsId!
                .addAll(healthCategory!.healthRecordCollection!);
          }
        } else {
          widget.selectedMedia!.remove(metaId);
          widget.selectedRecordsId!
              .remove(healthCategory!.healthRecordCollection);
        }
      } else {
        if (condition) {
          if (!widget.selectedMedia!.contains(metaId)) {
            widget.selectedMedia!.add(metaId);
          }
        } else {
          widget.selectedMedia!.remove(metaId);
        }
      }
    } else if (widget.allowSelectNotes! || widget.allowSelectVoice!) {
      if (condition) {
        if (widget.selectedMedia!.length > 0) {
          FHBBasicWidget()
              .showInSnackBar(Constants.STR_ONLY_ONE, widget.scaffold_state!);
        } else {
          widget.selectedMedia!.add(metaId);
          selectedResult = healthCategory;
        }
      } else {
        widget.selectedMedia!.remove(metaId);
      }
    }

    callBackToRefresh();
  }

  void addMediaRemoveMasterForNotesAndVoice(
      String? metaId, bool? condition, HealthResult? healthCategoryID) {
    commonMethodToAddOrRemove(metaId!, condition!, healthCategoryID);
  }

  List<Widget> _getAllDataForTheTabs(List<CategoryResult> data,
      HealthRecordList? completeData, List<MediaResult> mediaData) {
    var tabWidgetList = <Widget>[];

    for (var dataObj in data) {
      if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionPrescription) {
        tabWidgetList.add(
          HealthReportListScreen(
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
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionDevice) {
        if ((CommonUtil.isUSRegion()) &&
            (qurhomeDashboardController.isVitalModuleDisable.value)) {
          tabWidgetList.add(
            FHBBasicWidget().getContainerFeatureDisableDataText(),
          );
        } else {
          tabWidgetList.add(
            DeviceListScreen(
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
            ),
          );
        }
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionLabReport) {
        tabWidgetList.add(
          LabReportListScreen(
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
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionMedicalReport) {
        tabWidgetList.add(
          MedicalReportListScreen(
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
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionBills) {
        tabWidgetList.add(
          BillsList(
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
            widget.isFromBills,
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionIDDocs) {
        tabWidgetList.add(
          IDDocsList(
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
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionOthers) {
        tabWidgetList.add(
          OtherDocsList(
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
            addHealthRecords,
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionVoiceRecord) {
        if (CommonUtil.audioPage == false && widget.fromClass == '') {
          widget.selectedMedia = [];
        }

        if (CommonUtil.audioPage == false && widget.fromClass == 'audio') {
          widget.fromClass = '';
        }
        tabWidgetList.add(
          VoiceRecordList(
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
            widget.showDetails,
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionClaimsRecord) {
        tabWidgetList.add(
          OtherDocsList(
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
            addHealthRecords,
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionNotes) {
        tabWidgetList.add(
          NotesScreenList(
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
            widget.showDetails,
          ),
        );
      } else if (dataObj.categoryDescription ==
          CommonConstants.categoryDescriptionHospitalDocument) {
        tabWidgetList.add(
          HospitalDocuments(
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
          ),
        );
      } else {
        tabWidgetList.add(
          FHBBasicWidget().getContainerWithNoDataText(),
        );
      }
    }
    return tabWidgetList;
  }

  void onPositionChange() {
    FocusManager.instance.primaryFocus!.unfocus();
    if (!controller!.indexIsChanging) {
      setState(() {});
      _currentPosition = controller!.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);

        try {
          _currentPosition = controller!.index;

          if ((categoryDataList != null) &&
              (categoryDataList?.length ?? 0) > 0) {
            categoryName =
                categoryDataList.elementAt(_currentPosition!).categoryName;
            categoryID = categoryDataList.elementAt(_currentPosition!).id;
          }
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller!.animation!.value);

      try {
        _currentPosition = controller!.animation!.value.toInt();

        if ((categoryDataList != null) && (categoryDataList?.length ?? 0) > 0) {
          categoryName = categoryDataList
              .elementAt(controller!.animation!.value.toInt())
              .categoryName;
          categoryID = categoryDataList
              .elementAt(controller!.animation!.value.toInt())
              .id;
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  List<Widget> getAllTabsToDisplayInHeader(List<CategoryResult> data) {
    List<Widget> tabWidgetList = [];

    data.sort((a, b) => a.categoryDescription!
        .toLowerCase()
        .compareTo(b.categoryDescription!.toLowerCase()));

    for (CategoryResult dataObj in data) {
      tabWidgetList.add(Column(children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        dataObj.logo != null
            ? Image.network(dataObj.logo!,
                width: 20.0.h,
                height: 20.0.h,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) => const SizedBox())
            : Icon(Icons.calendar_today, size: 20.0.sp, color: Colors.white),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Container(
            child: Text(
          dataObj.categoryName!,
          style: TextStyle(fontSize: 14.0.sp),
        )),
        const Padding(padding: EdgeInsets.only(top: 10)),
      ]));
    }

    return tabWidgetList;
  }

  void openNotesDialog() async {
    await saveCategoryToPrefernce();
    PreferenceUtil.saveString(Constants.KEY_DEVICENAME, '').then((onValue) {
      PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName!)
          .then((onValue) {
        PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID!)
            .then((value) {});
      });
    });

    TextEditingController fileName = TextEditingController(
        text:
            '${categoryName!}_${DateTime.now().toUtc().millisecondsSinceEpoch}');
    CommonDialogBox().getDialogBoxForNotes(
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
            widget.recordsState!.setState(() {});
          }
        });
  }

  void onCameraClicked() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      await _handleCameraAndMic();
    } else {
      saveCategoryToPrefernce();
      if (categoryName == AppConstants.voiceRecords ||
          categoryName ==
              (CommonUtil.isUSRegion()
                  ? Constants.STR_PROVIDERDOCUMENTS
                  : Constants.STR_HOSPITALDOCUMENT)) {
        FHBBasicWidget().showInSnackBar(
            '${Constants.MSG_NO_CAMERA_VOICERECORDS} ${categoryName!}',
            widget.scaffold_state!);
      } else if (categoryName == AppConstants.notes) {
        openNotesDialog();
      } else {
        PreferenceUtil.saveString(Constants.KEY_DEVICENAME, '').then((onValue) {
          PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName!)
              .then((onValue) {
            PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID!)
                .then((value) {
              if (categoryName == STR_DEVICES) {
                PreferenceUtil.saveString(
                    Constants.stop_detecting, variable.strNO);
                PreferenceUtil.saveString(
                    Constants.stop_detecting, variable.strNO);

                Navigator.pushNamed(context, router.rt_TakePictureForDevices)
                    .then((value) {
                  onRefreshWidgets();
                });
              } else {
                Navigator.pushNamed(context, router.rt_TakePictureScreen)
                    .then((value) {
                  onRefreshWidgets();
                });
              }
            });
          });
        });
      }
    }
  }

  Future<void> _handleCameraAndMic() async {
    final status = await CommonUtil.askPermissionForCameraAndMic();
    if (!status) {
      FlutterToast toastToShow = FlutterToast();
      toastToShow.getToast(
        strCameraPermission,
        Colors.red,
      );
    }
  }

  onVoiceRecordClicked() async {
    saveCategoryToPrefernce();
    if (categoryName ==
        (CommonUtil.isUSRegion()
            ? Constants.STR_PROVIDERDOCUMENTS
            : Constants.STR_HOSPITALDOCUMENT)) {
      FHBBasicWidget().showInSnackBar(
          '${Constants.MSG_NO_VOICERECORDS} ${categoryName!}',
          widget.scaffold_state!);
    } else {
      PreferenceUtil.saveString(
              Constants.KEY_CATEGORYNAME, AppConstants.voiceRecords)
          .then((value) {
        PreferenceUtil.saveString(Constants.KEY_CATEGORYID,
                PreferenceUtil.getStringValue(Constants.KEY_VOICE_ID)!)
            .then((value) {
          if (widget.argument!.fromClass == 'audio' ||
              widget.argument!.fromClass == null) {
            Get.to(
              () => AudioRecorder(
                arguments: AudioScreenArguments(
                    fromVoice: true,
                    fromClass: categoryName == AppConstants.voiceRecords
                        ? ''
                        : widget.argument!.fromClass ?? 'audio'),
              ),
            )!
                .then((results) {
              onRefreshWidgets();
            });
          } else {
            Navigator.pushNamed(context, router.rt_AudioScreen,
                    arguments: AudioScreenArguments(
                        fromVoice: true,
                        fromClass: widget.argument!.fromClass ?? 'audio'))
                .then((results) {
              onRefreshWidgets();
            });
          }
        });
      });
    }
  }

  saveCategoryToPrefernce() async {
    if ((widget.categoryData != null) &&
        (widget.categoryData?.length ?? 0) > 0) {
      categoryName =
          widget.categoryData!.elementAt(_currentPosition!).categoryName;
      categoryID = widget.categoryData!.elementAt(_currentPosition!).id;
    }
  }

  onRefreshWidgets() {
    if (landingScreenController.ishealthRecordsScreenRefreshNeeded.value) {
      landingScreenController.ishealthRecordsScreenRefreshNeeded.value = false;
      setState(() {});
    }
  }
}
