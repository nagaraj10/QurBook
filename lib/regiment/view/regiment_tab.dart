import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/main.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/regiment/view/widgets/filter_widget.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/SearchWidget/view/SearchWidget.dart';
import '../models/profile_response_model.dart';
import '../models/regiment_data_model.dart';
import '../view_model/regiment_view_model.dart';
import 'widgets/event_list_widget.dart';
import 'widgets/regiment_data_card.dart';

class RegimentTab extends StatefulWidget {
  final String? eventId;

  const RegimentTab({this.eventId});

  @override
  _RegimentTabState createState() => _RegimentTabState();
}

class _RegimentTabState extends State<RegimentTab> with WidgetsBindingObserver {
  late RegimentViewModel _regimentViewModel;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  final scrollController =
      AutoScrollController(axis: Axis.vertical, suggestedRowHeight: 150);
  final GlobalKey _SymptomsKey = GlobalKey();
  final GlobalKey _DailyKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _SymptomsCardKey = GlobalKey();

  late bool isFirst;
  late bool isFirstSymptom;
  bool isSettingsOpen = false;

  late BuildContext _myContext;
  ProfileResponseModel? profileResponseModel;

  var qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();

  final sheelBadgeController = Get.put(SheelaAIController());

  @override
  void initState() {
    qurhomeDashboardController.getModuleAccess();
    mInitialTime = DateTime.now();
    FocusManager.instance.primaryFocus!.unfocus();
    super.initState();
    getProfile();
    WidgetsBinding.instance!.addObserver(this);
    Provider.of<RegimentViewModel>(context, listen: false).getRegimentDate(
      dateTime: DateTime.now(),
      isInitial: true,
    );
    Provider.of<RegimentViewModel>(
      context,
      listen: false,
    ).updateTabIndex(
      currentIndex: 0,
      isInitial: true,
    );
    if (Provider.of<RegimentViewModel>(context, listen: false).regimentFilter !=
        RegimentFilter.Event) {
      Provider.of<RegimentViewModel>(context, listen: false).redirectEventId =
          '';
    }
    Provider.of<RegimentViewModel>(context, listen: false)
        .updateInitialShowIndex(
      index: Provider.of<RegimentViewModel>(context, listen: false)
                      .regimentFilter ==
                  RegimentFilter.Missed &&
              widget.eventId == null
          ? 0
          : null,
      isInitial: true,
      eventId: widget.eventId,
    );

    Provider.of<RegimentViewModel>(context, listen: false).resetRegimenTab(
      isInitial: true,
    );
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );

    PreferenceUtil.init();

    Provider.of<RegimentViewModel>(Get.context!, listen: false).cachedEvents =
        [];
  }

  @override
  void deactivate() {
    Provider.of<RegimentViewModel>(context, listen: false).stopRegimenTTS(
      isInitial: true,
    );
    super.deactivate();
  }

  Future<RegimentResponseModel> getMasterData() async {
    RegimentResponseModel regimentsData;

    regimentsData = await RegimentService.getRegimentData(
      dateSelected: CommonUtil.dateConversionToApiFormat(
        Provider.of<RegimentViewModel>(context, listen: false)
            .selectedRegimenDate,
        isIndianTime: true,
      ),
      isSymptoms:
          Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
                  RegimentMode.Symptoms
              ? 1
              : 0,
      isForMasterData: true,
      searchText: searchController.text,
    );

    return regimentsData;
  }

  void showShowcase() {
    isFirst = PreferenceUtil.isKeyValid(KEY_SHOWCASE_Regimen);
    isFirstSymptom = PreferenceUtil.isKeyValid(KEY_SHOWCASE_Symptom);

    try {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (!isFirst) _regimentViewModel.updateInitialShowIndex(index: 0);
        Future.delayed(
            Duration(milliseconds: 1000),
            () => isFirst || isSettingsOpen
                ? null
                : ShowCaseWidget.of(_myContext)!
                    .startShowCase([_DailyKey, _cardKey, _SymptomsKey]));
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  getProfile() async {
    profileResponseModel =
        await Provider.of<RegimentViewModel>(context, listen: false)
            .getProfile();
    if (profileResponseModel?.result?.profileData?.isDefault ?? false) {
      await openScheduleDialog();
      showShowcase();
    } else {
      showShowcase();
    }
  }

  openScheduleDialog() async {
    if (profileResponseModel!.isSuccess! &&
        profileResponseModel?.result?.profileData != null &&
        _regimentViewModel.regimentStatus != RegimentStatus.DialogOpened) {
      _regimentViewModel.updateRegimentStatus(RegimentStatus.DialogOpened);
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => EventListWidget(
          profileResultModel: profileResponseModel!.result,
        ),
      );
      _regimentViewModel.updateRegimentStatus(RegimentStatus.DialogClosed);
      profileResponseModel =
          await Provider.of<RegimentViewModel>(context, listen: false)
              .getProfile();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    // searchController?.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Regimen Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
    scrollController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Color getColor(
      Activityname? activityname, Uformname? uformName, Metadata? metadata) {
    Color cardColor;
    try {
      if ((metadata?.color?.length ?? 0) == 7) {
        cardColor =
            Color(int.parse(metadata!.color!.replaceFirst('#', '0xFF')));
      } else {
        switch (activityname) {
          case Activityname.DIET:
            cardColor = Colors.green;
            break;
          case Activityname.VITALS:
            if (uformName == Uformname.BLOODPRESSURE) {
              cardColor = Color(0xFF059192);
            } else if (uformName == Uformname.BLOODSUGAR) {
              cardColor = Color(0xFFb70a80);
            } else if (uformName == Uformname.PULSE) {
              cardColor = Color(0xFF8600bd);
            } else {
              cardColor = Colors.lightBlueAccent;
            }
            break;
          case Activityname.MEDICATION:
            cardColor = Colors.blue;
            break;
          case Activityname.SCREENING:
            cardColor = Colors.teal;
            break;
          default:
            cardColor = Color(CommonUtil().getMyPrimaryColor());
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      cardColor = Color(CommonUtil().getMyPrimaryColor());
    }
    return cardColor;
  }

  dynamic getIcon(RegimentDataModel regimen, Activityname? activityname,
      Uformname? uformName, Metadata? metadata) {
    final iconSize = (_regimentViewModel.regimentMode == RegimentMode.Schedule)
        ? 40.0.sp
        : 40.0.sp;
    try {
      if (metadata?.icon != null) {
        if (metadata?.icon?.toLowerCase().contains('.svg') ?? false) {
          return SvgPicture.network(
            metadata!.icon!,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
          );
        } else {
          return CachedNetworkImage(
            imageUrl: metadata!.icon!,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
            errorWidget: (context, url, error) {
              return getDefaultIcon(regimen, activityname, uformName, iconSize);
            },
          );
        }
      } else {
        return getDefaultIcon(regimen, activityname, uformName, iconSize);
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return getDefaultIcon(regimen, activityname, uformName, iconSize);
    }
  }

  dynamic getDefaultIcon(
    RegimentDataModel regimen,
    Activityname? activityname,
    Uformname? uformName,
    double iconSize,
  ) {
    var isDefault = true;
    dynamic cardIcon = 'assets/launcher/myfhb.png';
    switch (activityname) {
      case Activityname.DIET:
        cardIcon = Icons.fastfood_rounded;
        break;
      case Activityname.VITALS:
        if (uformName == Uformname.BLOODPRESSURE) {
          cardIcon = 'assets/devices/bp_dashboard.png';
          isDefault = false;
        } else if (uformName == Uformname.BLOODSUGAR) {
          isDefault = false;
          cardIcon = 'assets/devices/gulcose_dashboard.png';
        } else if (uformName == Uformname.PULSE) {
          isDefault = false;
          cardIcon = 'assets/devices/os_dashboard.png';
        } else {
          cardIcon = 'assets/Qurhome/Qurhome.png';
        }
        break;
      case Activityname.MEDICATION:
        cardIcon = Icons.medical_services;
        break;
      case Activityname.SCREENING:
        cardIcon = Icons.screen_search_desktop;
        break;
      default:
        if (CommonUtil().checkIfSkipAcknowledgemnt(regimen)) {
          cardIcon = 'assets/icons/icon_acknowledgement.png';
        } else {
          cardIcon = 'assets/Qurhome/Qurhome.png';
        }
    }
    var cardIconWidget = (cardIcon is String)
        ? Image.asset(cardIcon,
            height: isDefault ? iconSize : iconSize - 5.0.sp,
            width: isDefault ? iconSize : iconSize - 5.0.sp,
            color: (CommonUtil().checkIfSkipAcknowledgemnt(regimen))
                ? Colors.white
                : null)
        : Icon(
            cardIcon,
            size: iconSize - 5.0.sp,
            color: Colors.white,
          );
    return cardIconWidget;
  }

  @override
  Widget build(BuildContext context) {
    _regimentViewModel = Provider.of<RegimentViewModel>(context);
    _regimentViewModel.handleSearchField(
      controller: searchController,
      focusNode: searchFocus,
    );
    return ShowCaseWidget(onFinish: () {
      if (!isFirst) {
        PreferenceUtil.saveString(KEY_SHOWCASE_Regimen, variable.strtrue);
        _regimentViewModel.updateInitialShowIndex();
      }
      if (!isFirstSymptom) {
        PreferenceUtil.saveString(KEY_SHOWCASE_Symptom, variable.strtrue);
      }
    }, builder: Builder(builder: (context) {
      _myContext = context;
      return Column(
        children: [
          Container(
            width: 1.sw,
            padding: EdgeInsets.all(10.0.sp),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _regimentViewModel.handleSearchField();
                          _regimentViewModel.getRegimentDate(
                              isPrevious: true, isDataChange: true);
                        },
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 24.0.sp,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                            initialDate: _regimentViewModel.selectedRegimenDate,
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light().copyWith(
                                  primary:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                ),
                              ),
                              child: child!,
                            ),
                          );
                          if (selectedDate != null) {
                            _regimentViewModel.handleSearchField();
                            _regimentViewModel.getRegimentDate(
                                dateTime: selectedDate, isDataChange: true);
                          }
                        },
                        child: Text(
                          _regimentViewModel.regimentDate,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Color(CommonUtil().getMyPrimaryColor()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _regimentViewModel.handleSearchField();
                          _regimentViewModel.getRegimentDate(
                              isNext: true, isDataChange: true);
                        },
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 24.0.sp,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 2.0.w,
                  ),
                  child: Row(
                    children: [
                      FHBBasicWidget.customShowCase(
                          _SymptomsKey,
                          SymptomsDescription,
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if ((_regimentViewModel.regimentMode ==
                                        RegimentMode.Schedule) &&
                                    (CommonUtil.isUSRegion()) &&
                                    (qurhomeDashboardController
                                        .isSymptomModuleDisable.value)) {
                                  FlutterToast().getToast(
                                      strFeatureNotEnable, Colors.black);
                                } else {
                                  _regimentViewModel.handleSearchField();
                                  _regimentViewModel.switchRegimentMode();
                                  if (_regimentViewModel.regimentMode ==
                                          RegimentMode.Symptoms &&
                                      !isFirstSymptom) {
                                    Future.delayed(
                                        Duration(milliseconds: 1000),
                                        () => ShowCaseWidget.of(_myContext)
                                            ?.startShowCase(
                                                [_SymptomsCardKey]));
                                  }
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.0.sp,
                                  vertical: 2.0.sp,
                                ),
                                child: Text(
                                  _regimentViewModel.regimentMode ==
                                          RegimentMode.Schedule
                                      ? symptoms
                                      : scheduled,
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Symptoms),
                      FHBBasicWidget.customShowCase(
                          _DailyKey,
                          DailyScheduleDescription,
                          Padding(
                            padding: EdgeInsets.only(
                              left: 5.0.w,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: PopupMenuButton<int>(
                                onCanceled: () {
                                  isSettingsOpen = false;
                                },
                                icon: Icon(
                                  Icons.settings_outlined,
                                ),
                                iconSize: 30.0.sp,
                                itemBuilder: (context) {
                                  isSettingsOpen = true;
                                  return [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Text(
                                        Schedule,
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        strManageActivities,
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (index) async {
                                  isSettingsOpen = false;
                                  if (index == 0) {
                                    await openScheduleDialog();
                                  } else if (index == 1) {
                                    Get.toNamed(rt_ManageActivitiesScreen);
                                  }
                                },
                              ),
                            ),
                          ),
                          RegimenSettings)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.w,
              vertical: 5.0.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _regimentViewModel.regimentMode == RegimentMode.Schedule
                        ? scheduled
                        : planSymptoms,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_regimentViewModel.regimentMode == RegimentMode.Schedule)
                  Flexible(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const FilterWidget(
                            title: scheduledActivities,
                            value: RegimentFilter.Scheduled,
                          ),
                          const FilterWidget(
                            title: asNeededActivities,
                            value: RegimentFilter.AsNeeded,
                          ),
                          const FilterWidget(
                            title: missedActivities,
                            value: RegimentFilter.Missed,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10.0.w,
              right: 10.0.w,
              bottom: 10.0.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SearchWidget(
                    searchController: searchController,
                    searchFocus: searchFocus,
                    onChanged: _regimentViewModel.onSearch,
                    padding: 0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<RegimentViewModel>(
              builder: (context, regimentViewModel, child) {
                print(regimentViewModel.regimentsData?.message);
                if (regimentViewModel.regimentStatus ==
                    RegimentStatus.Loading) {
                  return CommonCircularIndicator();
                } else if ((regimentViewModel.regimentsList.length) > 0) {
                  final regimentsList = regimentViewModel.regimentsList;
                  if ((regimentsList.length) > 0) {
                    if (regimentViewModel.initialShowIndex != null) {
                      Future.delayed(Duration(microseconds: 1), () {
                        scrollController.scrollToIndex(
                          regimentViewModel.initialShowIndex!,
                          preferPosition: AutoScrollPosition.begin,
                          duration: const Duration(
                            milliseconds: 1,
                          ),
                        );
                        regimentViewModel.updateInitialShowIndex(
                          isDone: true,
                        );
                      });
                    }
                    return ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        bottom: 10.0.h,
                      ),
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: regimentsList.length,
                      itemBuilder: (context, index) {
                        final regimentData = (index < regimentsList.length)
                            ? regimentsList[index]
                            : RegimentDataModel();
                        return AutoScrollTag(
                            key: ValueKey(index),
                            index: index,
                            controller: scrollController,
                            child: index != 0
                                ? RegimentDataCard(
                                    selectedDate:
                                        _regimentViewModel.selectedRegimenDate,
                                    index: index,
                                    title: regimentData.title,
                                    time: regimentData.estart != null
                                        ? DateFormat('hh:mm\na')
                                            .format(regimentData.estart!)
                                        : '',
                                    color: getColor(
                                        regimentData.activityname,
                                        regimentData.uformname,
                                        regimentData.metadata),
                                    icon: getIcon(
                                        regimentData,
                                        regimentData.activityname,
                                        regimentData.uformname,
                                        regimentData.metadata),
                                    vitalsData:
                                        regimentData.uformdata?.vitalsData,
                                    eid: regimentData.eid,
                                    mediaData: regimentData.otherinfo,
                                    startTime: regimentData.estart,
                                    regimentData: regimentData,
                                    onLoggedSuccess: () {
                                      callQueueCountApi();
                                    },
                                  )
                                : FHBBasicWidget.customShowCase(
                                    _regimentViewModel.regimentMode ==
                                            RegimentMode.Schedule
                                        ? _cardKey
                                        : _SymptomsCardKey,
                                    _regimentViewModel.regimentMode ==
                                            RegimentMode.Schedule
                                        ? CardTap
                                        : symptomCardTap,
                                    RegimentDataCard(
                                      selectedDate: _regimentViewModel
                                          .selectedRegimenDate,
                                      index: index,
                                      title: regimentData.title,
                                      time: regimentData.estart != null
                                          ? DateFormat('hh:mm\na')
                                              .format(regimentData.estart!)
                                          : '',
                                      color: getColor(
                                          regimentData.activityname,
                                          regimentData.uformname,
                                          regimentData.metadata),
                                      icon: getIcon(
                                          regimentData,
                                          regimentData.activityname,
                                          regimentData.uformname,
                                          regimentData.metadata),
                                      vitalsData:
                                          regimentData.uformdata?.vitalsData,
                                      eid: regimentData.eid,
                                      mediaData: regimentData.otherinfo,
                                      startTime: regimentData.estart,
                                      regimentData: regimentData,
                                      onLoggedSuccess: () {
                                        callQueueCountApi();
                                      },
                                    ),
                                    _regimentViewModel.regimentMode ==
                                            RegimentMode.Schedule
                                        ? LogActivity
                                        : LogSymptoms));
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            10.0.sp,
                          ),
                          child: Text(
                            regimentViewModel.regimentMode ==
                                    RegimentMode.Schedule
                                ? noRegimentScheduleData
                                : noRegimentSymptomsData,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                          10.0.sp,
                        ),
                        child: Text(
                          regimentViewModel.regimentsData?.message ??
                              (regimentViewModel.regimentMode ==
                                      RegimentMode.Schedule
                                  ? noRegimentScheduleData
                                  : noRegimentSymptomsData),
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      (regimentViewModel.regimentMode == RegimentMode.Symptoms)
                          ? getMasterRegimenList()
                          : SizedBox.shrink(),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      );
    }));
  }

  Widget getMasterRegimenList() {
    return FutureBuilder<RegimentResponseModel>(
      future: getMasterData(),
      builder: (BuildContext context, snapshot) {
        /*if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else*/
        if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data!.regimentsList!.length > 0) {
                final regimentsList = snapshot.data!.regimentsList;
                return Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      bottom: 10.0.h,
                    ),
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: regimentsList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final regimentData = (index < regimentsList!.length)
                          ? regimentsList[index]
                          : RegimentDataModel();
                      return RegimentDataCard(
                        selectedDate: _regimentViewModel.selectedRegimenDate,
                        index: index,
                        title: regimentData.title,
                        time: regimentData.estart != null
                            ? DateFormat('hh:mm\na')
                                .format(regimentData.estart!)
                            : '',
                        color: getColor(regimentData.activityname,
                            regimentData.uformname, regimentData.metadata),
                        icon: getIcon(regimentData, regimentData.activityname,
                            regimentData.uformname, regimentData.metadata),
                        vitalsData: regimentData.uformdata?.vitalsData,
                        eid: regimentData.eid,
                        mediaData: regimentData.otherinfo,
                        startTime: regimentData.estart,
                        regimentData: regimentData,
                        aid: regimentData.aid,
                        uid: regimentData.uid,
                        formId: regimentData.uformid,
                        formName: regimentData.uformname1,
                        onLoggedSuccess: () {
                          callQueueCountApi();
                        },
                      );
                    },
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            } else {
              return SizedBox.shrink();
            }
          } else {
            return SizedBox.shrink();
          }
        }
      },
    );
  }

  getTextColor() {
    Color colors;
    try {
      if ((_regimentViewModel.regimentMode == RegimentMode.Schedule) &&
          (CommonUtil.isUSRegion()) &&
          (qurhomeDashboardController.isSymptomModuleDisable.value)) {
        colors = Colors.grey;
      } else {
        colors = Color(CommonUtil().getMyPrimaryColor());
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return colors = Color(CommonUtil().getMyPrimaryColor());
    }
    return colors;
  }

  callQueueCountApi() {
    try {
      if (sheelBadgeController.sheelaIconBadgeCount.value > 0) {
        sheelBadgeController.getSheelaBadgeCount();
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}
