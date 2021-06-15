import 'package:flutter/foundation.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:myfhb/regiment/models/profile_response_model.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/ui/loader_class.dart';

enum RegimentMode { Schedule, Symptoms }

enum RegimentFilter { All, Missed }

enum RegimentStatus { Loading, Loaded, DialogOpened, DialogClosed }

class RegimentViewModel extends ChangeNotifier {
  RegimentResponseModel regimentsData;
  List<RegimentDataModel> regimentsList = [];
  List<RegimentDataModel> regimentsScheduledList = [];
  List<RegimentDataModel> regimentsAsNeededList = [];
  List<RegimentDataModel> regimentsFilteredList = [];
  bool searchExpanded = false;
  RegimentStatus regimentStatus = RegimentStatus.Loaded;
  DateTime selectedDate = DateTime.now();
  String regimentDate = '${CommonUtil().regimentDateFormat(DateTime.now())}';
  RegimentMode regimentMode = RegimentMode.Schedule;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  int tabIndex = 0;
  double scrollOffset;
  int initialShowIndex;
  RegimentFilter regimentFilter = RegimentFilter.All;

  void updateInitialShowIndex({
    bool isDone = false,
    int index,
    bool isInitial = false,
    String eventId,
  }) {
    if (isDone) {
      initialShowIndex = null;
    } else if (index != null) {
      initialShowIndex = index;
    } else if ((regimentsScheduledList?.length ?? 0) > 0) {
      int index = 0;
      if (eventId != null) {
        for (final event in regimentsScheduledList) {
          if (event.eid == eventId ) {
            initialShowIndex = index;
            break;
          } else {
            index++;
          }
        }
      } else {
        for (final event in regimentsScheduledList) {
          if (event.estart.isAfter(DateTime.now()) ||
              event.estart.isAtSameMomentAs(DateTime.now())) {
            initialShowIndex = index;
            break;
          } else {
            index++;
          }
        }
      }
      initialShowIndex ??= regimentsScheduledList.length - 1;
    }
    if (!isInitial) {
      notifyListeners();
    }
  }

  void updateTabIndex({int currentIndex, bool isInitial = false}) {
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

  void changeFilter(RegimentFilter newFilter) {
    regimentFilter = newFilter;
    if (newFilter == RegimentFilter.Missed) {
      updateInitialShowIndex(
        index: 0,
      );
    }
    setViewRegimentsData();
    notifyListeners();
  }

  Future<void> switchRegimentMode() {
    regimentMode = (regimentMode == RegimentMode.Schedule)
        ? RegimentMode.Symptoms
        : RegimentMode.Schedule;
    if (regimentMode == RegimentMode.Symptoms) {
      regimentFilter = RegimentFilter.All;
      updateInitialShowIndex(index: 0);
    }
    resetRegimenTab();
    notifyListeners();
  }

  void resetRegimenTab({bool isInitial = false}) {
    changeSearchExpanded(false, isInitial: isInitial);
    handleSearchField();
    setViewRegimentsData(isInitial: isInitial);
  }

  void setViewRegimentsData({
    List<RegimentDataModel> filteredList,
    bool isInitial = false,
  }) {
    if (regimentFilter == RegimentFilter.Missed &&
        regimentMode == RegimentMode.Schedule) {
      regimentsList = getMissedFilter(filteredList);
    } else if (filteredList != null) {
      regimentsList = filteredList;
    } else {
      if (regimentMode == RegimentMode.Schedule) {
        regimentsList = regimentsScheduledList;
      } else {
        regimentsList = regimentsAsNeededList;
      }
    }
    stopRegimenTTS(isInitial: isInitial);
    if (!isInitial) {
      notifyListeners();
    }
  }

  List<RegimentDataModel> getMissedFilter(
    List<RegimentDataModel> filteredList,
  ) {
    List<RegimentDataModel> actualList = filteredList ?? regimentsScheduledList;
    List<RegimentDataModel> missedRegimenList = [];
    actualList?.forEach((regimenData) {
      if (regimenData?.estart
              ?.difference(DateTime.now())
              ?.inMinutes
              ?.isNegative &&
          regimenData.ack == null) {
        missedRegimenList.add(regimenData);
      }
    });
    return missedRegimenList;
  }

  void startRegimenTTS(int index, String saytext) {
    stopRegimenTTS();
    if (index < regimentsList.length) {
      Future.delayed(
          Duration(
            milliseconds: 100,
          ), () {
        regimentsList[index].isPlaying = true;
        notifyListeners();
      });
    }
    Provider.of<ChatScreenViewModel>(Get.context, listen: false)
        ?.startTTSEngine(
      textToSpeak: saytext,
      isRegiment: true,
      onStop: () {
        stopRegimenTTS();
      },
    );
  }

  void stopRegimenTTS({bool isInitial = false}) {
    Provider.of<ChatScreenViewModel>(Get.context, listen: false)?.stopTTSEngine(
      isInitial: isInitial,
    );

    regimentsList?.forEach((regimenData) {
      regimenData.isPlaying = false;
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
          bool displayTextMatch = false;
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
      } catch (e) {
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
    regimentsAsNeededList.clear();
    regimentsScheduledList.clear();
    if (isInitial) {
      updateRegimentStatus(RegimentStatus.Loading, isInitial: isInitial);
    }
    regimentsData = await RegimentService.getRegimentData(
      dateSelected: CommonUtil().dateConversionToApiFormat(selectedDate),
    );
    updateRegimentStatus(RegimentStatus.Loaded);
    regimentsData?.regimentsList?.forEach((event) {
      if (event.doseMeal) {
        regimentsAsNeededList.add(event);
      } else {
        regimentsScheduledList.add(event);
      }
    });
    if (setIndex) {
      updateInitialShowIndex();
    }
    setViewRegimentsData(isInitial: isInitial);
    if (isInitial && !fromPlans) {
      updateTabIndex(isInitial: isInitial);
    }
  }

  handleSearchField({
    TextEditingController controller,
    FocusNode focusNode,
  }) {
    if (controller != null) {
      searchController = controller;
      searchFocus = focusNode;
    } else {
      searchController?.clear();
      searchFocus?.unfocus();
    }
  }

  void getRegimentDate({
    bool isPrevious: false,
    bool isNext: false,
    DateTime dateTime,
  }) {
    if (dateTime != null) {
      selectedDate = dateTime;
    } else if (isPrevious) {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    } else if (isNext) {
      selectedDate = selectedDate.add(Duration(days: 1));
    }
    regimentDate =
        '${CommonUtil().regimentDateFormat(selectedDate ?? DateTime.now())}';
    resetRegimenTab();
    fetchRegimentData(isInitial: true);
    notifyListeners();
  }

  Future<SaveResponseModel> saveFormData({
    String eid,
    String events,
  }) async {
    updateInitialShowIndex(isDone: true);
    return await RegimentService.saveFormData(
      eid: eid,
      events: events,
    );
  }

  Future<FieldsResponseModel> getFormData({
    String eid,
  }) async {
    LoaderClass.showLoadingDialog(
      Get.context,
      canDismiss: false,
    );
    final response = await RegimentService.getFormData(
      eid: eid,
    );
    LoaderClass.hideLoadingDialog(Get.context);
    return response;
  }

  Future<ProfileResponseModel> getProfile() async {
    LoaderClass.showLoadingDialog(
      Get.context,
      canDismiss: false,
    );
    final response = await RegimentService.getProfile();
    LoaderClass.hideLoadingDialog(Get.context);
    return response;
  }

  Future<SaveResponseModel> saveProfile({
    String schedules,
  }) async {
    LoaderClass.showLoadingDialog(
      Get.context,
      canDismiss: false,
    );
    final response = await RegimentService.saveProfile(
      schedules: schedules,
    );
    LoaderClass.hideLoadingDialog(Get.context);
    return response;
  }

  Future<SaveResponseModel> undoSaveFormData({
    String eid,
  }) async {
    return await RegimentService.undoSaveFormData(
      eid: eid,
    );
  }
}
