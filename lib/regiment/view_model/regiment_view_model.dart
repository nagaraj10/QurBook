import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/model/patientalertlist/SuccessModel.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/regiment/models/GetEventIdModel.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaAICommonTTSServices.dart';
import 'package:path/path.dart';

import '../../common/CommonUtil.dart';
import '../../src/ui/loader_class.dart';
import '../models/field_response_model.dart';
import '../models/profile_response_model.dart';
import '../models/regiment_data_model.dart';
import '../models/regiment_response_model.dart';
import '../models/save_response_model.dart';
import '../service/regiment_service.dart';
import 'dart:convert' as convert;

enum RegimentMode { Schedule, Symptoms }

enum RegimentFilter { All, Missed, Event, AsNeeded, Scheduled }

enum RegimentStatus { Loading, Loaded, DialogOpened, DialogClosed }

enum ActivityStatus { Loading, Loaded }

class RegimentViewModel extends ChangeNotifier {
  RegimentResponseModel? regimentsData;
  RegimentResponseModel? activitiesData;
  List<RegimentDataModel> regimentsList = [];
  List<RegimentDataModel> regimentsScheduledList = [];
  List<RegimentDataModel> regimentsSymptomsList = [];
  List<RegimentDataModel> regimentsFilteredList = [];
  List<RegimentDataModel> activitiesList = [];
  List<RegimentDataModel> activitiesAllList = [];
  List<RegimentDataModel> activitiesFilteredList = [];
  bool searchExpanded = false;
  RegimentStatus regimentStatus = RegimentStatus.Loaded;
  DateTime selectedRegimenDate = DateTime.now();
  String regimentDate = '${CommonUtil().regimentDateFormat(DateTime.now())}';
  DateTime selectedActivityDate = DateTime.now();
  String activitiesDate = '${CommonUtil().regimentDateFormat(DateTime.now())}';
  RegimentMode regimentMode = RegimentMode.Schedule;
  TextEditingController searchController = TextEditingController();
  FocusNode? searchFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  int tabIndex = 0;
  double? scrollOffset;
  int? initialShowIndex;
  RegimentFilter? regimentFilter = RegimentFilter.Scheduled;
  String redirectEventId = '';
  ActivityStatus activityStatus = ActivityStatus.Loaded;
  List<String> cachedEvents = [];
  String disableComment = "";
  String eid = "";

  void updateInitialShowIndex({
    bool isDone = false,
    int? index,
    bool isInitial = false,
    String? eventId,
  }) {
    if (eventId != null) {
      redirectEventId = eventId;
    }
    if (isDone) {
      initialShowIndex = null;
    } else if (index != null) {
      initialShowIndex = index;
    } else if ((regimentsScheduledList.length) > 0) {
      var index = 0;
      if ((redirectEventId).isNotEmpty) {
        for (final event in regimentsScheduledList) {
          if (event.eid == redirectEventId) {
            initialShowIndex = index;
            break;
          } else {
            index++;
          }
        }
      } else if (regimentMode == RegimentMode.Symptoms) {
        initialShowIndex = 0;
      } else {
        for (final event in regimentsScheduledList) {
          if (event.scheduled) {
            if (event.estart!.isAfter(DateTime.now()) ||
                event.estart!.isAtSameMomentAs(DateTime.now())) {
              initialShowIndex = index;
              break;
            } else {
              index++;
            }
          }
        }
      }
      initialShowIndex ??= regimentsScheduledList.length - 1;
    }
    if (!isInitial) {
      notifyListeners();
    }
  }

  void updateTabIndex({int? currentIndex, bool isInitial = false}) {
    if (isInitial) {
      tabIndex = (regimentsData?.regimentsList?.length ?? 0) > 0 ? 0 : 2;
    } else {
      tabIndex = currentIndex ?? 0;
    }
    stopRegimenTTS(isInitial: true);
  }

  void changeSearchExpanded(
    bool newValue, {
    bool isInitial = false,
  }) {
    searchExpanded = newValue;
    stopRegimenTTS(isInitial: isInitial);
    if (!isInitial) {
      notifyListeners();
    }
  }

  void changeFilter(RegimentFilter? newFilter) {
    regimentFilter = newFilter;
    if (newFilter == RegimentFilter.Missed ||
        newFilter == RegimentFilter.AsNeeded) {
      updateInitialShowIndex(
        index: 0,
      );
    }
    searchController.clear();
    searchFocus!.unfocus();
    setViewRegimentsData();
    notifyListeners();
  }

  Future<void> switchFromSymptomToSchedule() async {
    regimentMode = RegimentMode.Schedule;
    if (regimentMode == RegimentMode.Symptoms) {
      regimentFilter = RegimentFilter.Scheduled;
      updateInitialShowIndex(index: 0);
    }
  }

  Future<void> switchRegimentMode() async {
    regimentMode = (regimentMode == RegimentMode.Schedule)
        ? RegimentMode.Symptoms
        : RegimentMode.Schedule;
    if (regimentMode == RegimentMode.Symptoms) {
      regimentFilter = RegimentFilter.Scheduled;
      updateInitialShowIndex(index: 0);
    }
    fetchRegimentData(
      isInitial: true,
    );
    // resetRegimenTab();
    notifyListeners();
  }

  void resetRegimenTab({bool isInitial = false}) {
    changeSearchExpanded(false, isInitial: isInitial);
    handleSearchField();
    setViewRegimentsData(isInitial: isInitial);
  }

  void setViewRegimentsData({
    List<RegimentDataModel>? filteredList,
    bool isInitial = false,
  }) {
    if (regimentMode == RegimentMode.Schedule &&
        (regimentFilter == RegimentFilter.Missed ||
            regimentFilter == RegimentFilter.AsNeeded ||
            regimentFilter == RegimentFilter.Scheduled)) {
      regimentsList = getFilteredList(filteredList);
    } else if (filteredList != null) {
      regimentsList = filteredList;
    } else {
      if (regimentMode == RegimentMode.Schedule) {
        regimentsList = regimentsScheduledList;
      } else {
        regimentsList = regimentsSymptomsList;
      }
    }
    stopRegimenTTS(isInitial: isInitial);
    if (!isInitial) {
      notifyListeners();
    }
  }

  List<RegimentDataModel> getFilteredList(
    List<RegimentDataModel>? filteredList,
  ) {
    final actualList = filteredList ?? regimentsScheduledList;
    final filteredRegimenList = <RegimentDataModel>[];
    actualList.forEach((regimenData) {
      if (regimentFilter == RegimentFilter.AsNeeded) {
        if (regimenData.asNeeded) {
          filteredRegimenList.add(regimenData);
        }
      }
      if (regimentFilter == RegimentFilter.Scheduled) {
        if (regimenData.scheduled) {
          filteredRegimenList.add(regimenData);
        } else if (regimenData.dayrepeat?.trim().toLowerCase() ==
            strText.trim().toLowerCase()) {
          filteredRegimenList.add(regimenData);
        }
      } else if (regimentFilter == RegimentFilter.Missed) {
        if (!(regimenData.asNeeded) &&
            (regimenData.estart
                    ?.difference(DateTime.now())
                    .inMinutes
                    .isNegative ??
                false) &&
            regimenData.ack == null) {
          if (CommonUtil.isUSRegion() &&
              regimenData?.otherinfo?.isSkipAcknowledgement != "1") {
            filteredRegimenList.add(regimenData);
          } else if (regimenData?.otherinfo?.isSkipAcknowledgement == "0") {
            filteredRegimenList.add(regimenData);
          }
        }
      }
    });
    return filteredRegimenList;
  }

  void startRegimenTTS(int index,
      {String? staticText, String? dynamicText}) async {
    stopRegimenTTS();
    if (index < regimentsList.length) {
      Future.delayed(
          Duration(
            milliseconds: 100,
          ), () {
        regimentsList[index].isPlaying.value = true;
        notifyListeners();
      });
    }
    sheelaTTSController.playTTS(staticText, () {
      stopRegimenTTS();
    });
  }

  SheelaAICommonTTSService sheelaTTSController = SheelaAICommonTTSService();

  void stopRegimenTTS({bool isInitial = false}) {
    sheelaTTSController.stopTTS();

    regimentsList.forEach((regimenData) {
      regimenData.isPlaying.value = false;
    });
    if (!isInitial) {
      notifyListeners();
    }
  }

  void updateRegimentStatus(RegimentStatus newStatus,
      {bool isInitial = false}) {
    regimentStatus = newStatus;
    if (!isInitial) {
      notifyListeners();
    }
  }

  void onSearch(String searchText) {
    updateRegimentStatus(RegimentStatus.Loading);
    if (searchText.isEmpty) {
      setViewRegimentsData();
    } else {
      regimentsFilteredList.clear();
      setViewRegimentsData();
      try {
        regimentsList.forEach((event) {
          var displayTextMatch = false;
          event.uformdata?.vitalsData?.forEach((vitals) {
            if ((vitals.display
                        ?.toLowerCase()
                        ?.contains(searchText.toLowerCase()) ??
                    false) ||
                (vitals.vitalName
                        ?.toLowerCase()
                        ?.contains(searchText.toLowerCase()) ??
                    false)) {
              displayTextMatch = true;
            }
          });

          if (event.title?.toLowerCase().contains(searchText.toLowerCase()) ||
              displayTextMatch) {
            regimentsFilteredList.add(event);
          }
        });
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        print(e);
      }
      setViewRegimentsData(
        filteredList: regimentsFilteredList,
      );
    }
    updateRegimentStatus(RegimentStatus.Loaded);
    notifyListeners();
  }

  Future<void> fetchRegimentData({
    bool isInitial = false,
    bool setIndex = false,
    bool fromPlans = false,
  }) async {
    handleSearchField();
    regimentsList.clear();
    regimentsSymptomsList.clear();
    regimentsScheduledList.clear();
    if (isInitial) {
      updateRegimentStatus(RegimentStatus.Loading, isInitial: isInitial);
    }
    regimentsData = await RegimentService.getRegimentData(
      dateSelected: CommonUtil.dateConversionToApiFormat(
        selectedRegimenDate,
        isIndianTime: true,
      ),
      isSymptoms: regimentMode == RegimentMode.Symptoms ? 1 : 0,
    );
    updateRegimentStatus(RegimentStatus.Loaded);
    regimentsData?.regimentsList?.forEach((event) {
      if (!(event.isEventDisabled)) {
        if (event.isSymptom) {
          regimentsSymptomsList.add(event);
        } else if ((event.dayrepeat != null)) {
          regimentsScheduledList.add(event);
        } else {
          regimentsScheduledList.add(event);
        }
      }
    });
    /*List<RegimentDataModel> tempRegimentsList = regimentsSymptomsList;

    if (tempRegimentsList != null && tempRegimentsList.length > 0) {
      var val = tempRegimentsList.firstWhere(
          (item) => CommonUtil().validString(item.seq) != "0",
          orElse: () => null);
      if (val != null) {
        if (tempRegimentsList.length > 10) {
          regimentsSymptomsList = tempRegimentsList.take(10).toList();
        } else {
          regimentsSymptomsList = regimentsSymptomsList;
        }
      } else {
        regimentsSymptomsList = regimentsSymptomsList;
      }
    }*/

    List<RegimentDataModel> tempRegimentsList = regimentsSymptomsList;

    //print("tempRegimentsList length ${tempRegimentsList.length}");

    List<RegimentDataModel> recentRegimentsList = [];
    List<RegimentDataModel> seqRegimentsList = [];
    List<RegimentDataModel> otherRegimentsList = [];

    //finalSortList
    List<RegimentDataModel> finalRegimentsList = [];

    if (tempRegimentsList != null && tempRegimentsList.length > 0) {
      recentRegimentsList =
          tempRegimentsList.where((item) => item.ack_local != null).toList();
      seqRegimentsList = tempRegimentsList
          .where((item) =>
              CommonUtil().validString(item.seq) != null &&
              CommonUtil().validString(item.seq) != "0" &&
              CommonUtil().validString(item.seq).trim().isNotEmpty)
          .toList();
      seqRegimentsList.sort((b, a) => int.parse(CommonUtil().validString(a.seq))
          .compareTo(int.parse(CommonUtil().validString(b.seq))));
      otherRegimentsList = tempRegimentsList
          .where((item) =>
              CommonUtil().validString(item.seq) == "0" ||
              CommonUtil().validString(item.seq).trim().isEmpty)
          .toList();

      finalRegimentsList =
          recentRegimentsList + seqRegimentsList + otherRegimentsList;
      finalRegimentsList = finalRegimentsList.toSet().toList();

      //print("finalRegimentsList length ${finalRegimentsList.length}");

      regimentsSymptomsList = finalRegimentsList;
    }

    if (setIndex) {
      updateInitialShowIndex();
    }
    setViewRegimentsData(isInitial: isInitial);
    if (isInitial && !fromPlans) {
      updateTabIndex(isInitial: isInitial);
    }
  }

  handleSearchField({
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    if (controller != null) {
      searchController = controller;
      searchFocus = focusNode;
    } else {
      searchController.clear();
      searchFocus?.unfocus();
    }
  }

  void getRegimentDate({
    bool isPrevious = false,
    bool isNext = false,
    DateTime? dateTime,
    bool isInitial = false,
    bool isDataChange = false,
  }) {
    if (dateTime != null) {
      selectedRegimenDate = dateTime;
    } else if (isPrevious) {
      selectedRegimenDate = selectedRegimenDate.subtract(Duration(days: 1));
    } else if (isNext) {
      selectedRegimenDate = selectedRegimenDate.add(Duration(days: 1));
    }
    regimentDate = '${CommonUtil().regimentDateFormat(selectedRegimenDate)}';
    if (!isInitial) {
      resetRegimenTab();
      fetchRegimentData(isInitial: true);
      notifyListeners();
    }

    if (regimentFilter != RegimentFilter.Scheduled) {
      if (isDataChange) {
        regimentFilter = RegimentFilter.Scheduled;
        updateInitialShowIndex(index: 0);
        notifyListeners();
      }
    }
  }

  Future<SaveResponseModel> saveFormData(
      {String? eid,
      String? events,
      bool? isFollowEvent,
      String? followEventContext,
      DateTime? selectedDate,
      TimeOfDay? selectedTime,
      bool isVitals = false}) async {
    updateInitialShowIndex(isDone: true);
    return await RegimentService.saveFormData(
        eid: eid,
        events: events,
        isFollowEvent: isFollowEvent,
        followEventContext: followEventContext,
        selectedDate: selectedDate ?? DateTime.now(),
        selectedTime: selectedTime ?? TimeOfDay.now(),
        isVitals: isVitals);
  }

  Future<SaveResponseModel> deletMedia({String? eid}) async {
    return await RegimentService.deleteMedia(eid: eid);
  }

  Future<SaveResponseModel> updatePhoto({String? eid, String? url}) async {
    LoaderClass.showLoadingDialog(
      Get.context!,
      canDismiss: false,
    );
    var response = await RegimentService.updatePhoto(
      eid: eid,
      url: url,
    );
    LoaderClass.hideLoadingDialog(Get.context!);
    return response;
  }

  Future<FieldsResponseModel> getFormData({
    String? eid,
  }) async {
    LoaderClass.showLoadingDialog(
      Get.context!,
      canDismiss: true,
    );
    var response = await RegimentService.getFormData(
      eid: eid,
    );
    LoaderClass.hideLoadingDialog(Get.context!);
    return response;
  }

  Future<GetEventIdModel> getEventId({
    dynamic uid,
    dynamic aid,
    dynamic formId,
    dynamic formName,
  }) async {
    LoaderClass.showLoadingDialog(
      Get.context!,
      canDismiss: false,
    );
    var response = await RegimentService.getEventId(
        uid: uid, aid: aid, formId: formId, formName: formName);
    LoaderClass.hideLoadingDialog(Get.context!);
    return response!;
  }

  Future<ProfileResponseModel> getProfile() async {
    // LoaderClass.showLoadingDialog(
    //   Get.context,
    //   canDismiss: false,
    // );
    var response = await RegimentService.getProfile();
    // LoaderClass.hideLoadingDialog(Get.context);
    return response;
  }

  Future<SaveResponseModel> saveProfile({
    String? schedules,
  }) async {
    LoaderClass.showLoadingDialog(
      Get.context!,
      canDismiss: false,
    );
    var response = await RegimentService.saveProfile(
      schedules: schedules,
    );
    LoaderClass.hideLoadingDialog(Get.context!);
    return response;
  }

  Future<SaveResponseModel> undoSaveFormData({
    String? eid,
  }) async {
    return await RegimentService.undoSaveFormData(
      eid: eid,
      activityDate: CommonUtil.dateConversionToApiFormat(
        selectedRegimenDate,
        isIndianTime: true,
      ),
    );
  }

  void getActivityDate({
    bool isPrevious = false,
    bool isNext = false,
    DateTime? dateTime,
    bool isInitial = false,
  }) {
    if (dateTime != null) {
      selectedActivityDate = dateTime;
    } else if (isPrevious) {
      selectedActivityDate = selectedActivityDate.subtract(Duration(days: 1));
    } else if (isNext) {
      selectedActivityDate = selectedActivityDate.add(Duration(days: 1));
    }
    activitiesDate = '${CommonUtil().regimentDateFormat(selectedActivityDate)}';
    if (!isInitial) {
      fetchScheduledActivities(isInitial: true);
      notifyListeners();
    }
  }

  void updateActivityStatus(ActivityStatus newStatus,
      {bool isInitial = false}) {
    activityStatus = newStatus;
    if (!isInitial) {
      notifyListeners();
    }
  }

  Future<void> fetchScheduledActivities({
    bool isInitial = false,
  }) async {
    activitiesList.clear();
    activitiesAllList.clear();
    activitiesFilteredList.clear();
    if (isInitial) {
      updateActivityStatus(ActivityStatus.Loading, isInitial: isInitial);
    }
    activitiesData = await RegimentService.getRegimentData(
        dateSelected: CommonUtil.dateConversionToApiFormat(
          selectedActivityDate,
          isIndianTime: true,
        ),
        isSymptoms: 0,
        isForMasterData: false);
    updateActivityStatus(ActivityStatus.Loaded);
    activitiesData?.regimentsList?.forEach((event) {
      if (event.scheduled) {
        activitiesAllList.add(event);
      }
    });
    setViewActivitiesData(
      isInitial: isInitial,
    );
  }

  void onSearchActivities(String searchText) {
    updateActivityStatus(ActivityStatus.Loading);
    setViewActivitiesData();
    if (searchText.isNotEmpty) {
      activitiesFilteredList.clear();
      try {
        activitiesAllList.forEach((event) {
          if (event.title?.toLowerCase().contains(searchText.toLowerCase())) {
            activitiesFilteredList.add(event);
          }
        });
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);

        print(e);
      }
      setViewActivitiesData(
        filteredList: activitiesFilteredList,
      );
    }
    updateActivityStatus(ActivityStatus.Loaded);
    notifyListeners();
  }

  void setViewActivitiesData({
    List<RegimentDataModel>? filteredList,
    bool isInitial = false,
  }) {
    if (filteredList != null) {
      activitiesList = filteredList;
    } else {
      activitiesList = activitiesAllList;
    }
    if (!isInitial) {
      notifyListeners();
    }
  }

  Future<SaveResponseModel> enableDisableActivity({
    String? eidUser,
    required DateTime startTime,
    bool isDisable = true,
  }) async {
    LoaderClass.showLoadingDialog(
      Get.context!,
      canDismiss: false,
    );
    var response = await RegimentService.enableDisableActivity(
      eidUser: eidUser,
      startTime: startTime,
      isDisable: isDisable,
    );
    if (response.isSuccess ?? false) {
      if (CommonUtil.isUSRegion()) {
        if (isDisable) {
          var disableActivityCommentResp = await disableActivity(
              eid ?? "", disableComment ?? strDisableText);

          if (disableActivityCommentResp.isSuccess ?? false) {
            FlutterToast().getToast(
                disableActivityCommentResp?.message ?? "", Colors.green);

            await fetchScheduledActivities(isInitial: true);
          } else {
            FlutterToast().getToast(
                disableActivityCommentResp?.message ?? "", Colors.red);
          }
        } else {
          await fetchScheduledActivities(isInitial: true);
        }
      } else {
        await fetchScheduledActivities(isInitial: true);
      }
    }
    if (isDisable && CommonUtil.isUSRegion()) {
      Navigator.pop(
        Get.context!,
      );
    }

    LoaderClass.hideLoadingDialog(Get.context!);
    return response;
  }

  Future<SuccessModel> disableActivity(String eid, String comment) async {
    var disableMap = {};
    var userId = await PreferenceUtil.getStringValue(KEY_USERID);
    disableMap['patientId'] = userId;
    disableMap['healthOrganizationId'] = null;
    disableMap['time'] = null;
    disableMap['screen'] = "Regimen";
    disableMap['eid'] = eid;
    disableMap['comment'] = comment;

    var jsonString = convert.jsonEncode(disableMap);
    var response = await RegimentService.disableActivityWIthComment(
        escalate_add_comments, jsonString);

    return response;
  }
}
