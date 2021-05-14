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

enum RegimentMode { Schedule, Symptoms }

enum RegimentStatus { Loading, Loaded, DialogOpened, DialogClosed }

class RegimentViewModel extends ChangeNotifier {
  RegimentResponseModel regimentsData;
  List<RegimentDataModel> regimentsList = [];
  List<RegimentDataModel> regimentsScheduledList = [];
  List<RegimentDataModel> regimentsAsNeededList = [];
  List<RegimentDataModel> regimentsFilteredList = [];
  bool regimentsDataAvailable = true;
  bool searchExpanded = false;
  RegimentStatus regimentStatus = RegimentStatus.Loaded;
  DateTime selectedDate = DateTime.now();
  String regimentDate = '${CommonUtil().regimentDateFormat(DateTime.now())}';
  RegimentMode regimentMode = RegimentMode.Schedule;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  int tabIndex;
  double scrollOffset;

  void updateTabIndex({int currentIndex, bool isInitial = false}) {
    if (isInitial) {
      tabIndex = (regimentsData?.regimentsList?.length ?? 0) > 0 ? 0 : 2;
    } else {
      tabIndex = currentIndex;
    }
  }

  void changeSearchExpanded(bool newValue) {
    searchExpanded = newValue;
    notifyListeners();
  }

  Future<void> switchRegimentMode() {
    regimentMode = (regimentMode == RegimentMode.Schedule)
        ? RegimentMode.Symptoms
        : RegimentMode.Schedule;
    resetRegimenTab();
    notifyListeners();
  }

  void resetRegimenTab() {
    changeSearchExpanded(false);
    updateScroll(isReset: true);
    handleSearchField();
    setViewRegimentsData();
  }

  void setViewRegimentsData({List<RegimentDataModel> filteredList}) {
    if (filteredList != null) {
      regimentsList = filteredList;
    } else {
      if (regimentMode == RegimentMode.Schedule) {
        regimentsList = regimentsScheduledList;
      } else {
        regimentsList = regimentsAsNeededList;
      }
    }
    notifyListeners();
  }

  void updateRegimentStatus(RegimentStatus newStatus) {
    regimentStatus = newStatus;
    notifyListeners();
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

  Future<void> fetchRegimentData({bool isInitial = false}) async {
    handleSearchField();
    regimentsList.clear();
    regimentsAsNeededList.clear();
    regimentsScheduledList.clear();
    if (PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN) ==
        PreferenceUtil.getStringValue(Constants.KEY_USERID)) {
      updateRegimentStatus(RegimentStatus.Loading);
      regimentsDataAvailable = true;
      regimentsData = await RegimentService.getRegimentData(
        dateSelected: CommonUtil().dateConversionToApiFormat(selectedDate),
      );
      updateRegimentStatus(RegimentStatus.Loaded);
    } else {
      regimentsDataAvailable = false;
      regimentsData = RegimentResponseModel(
        isSuccess: true,
        regimentsList: [],
        message: Constants.plansForFamily,
      );
    }
    regimentsData?.regimentsList?.forEach((event) {
      if (event.doseMeal) {
        regimentsAsNeededList.add(event);
      } else {
        regimentsScheduledList.add(event);
      }
    });
    setViewRegimentsData();
    if (isInitial) {
      updateTabIndex(isInitial: true);
    }
    if (!isInitial) {
      notifyListeners();
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

  updateScroll({bool isReset = false}) {
    if (isReset) {
      scrollOffset = 0.0;
    } else if (scrollController?.hasClients) {
      scrollOffset = scrollController.offset;
    }
  }

  handleScroll({
    ScrollController controller,
  }) {
    if (controller != null) {
      scrollController = controller;
    } else if (scrollController?.hasClients) {
      scrollController.jumpTo(scrollOffset ?? 0.0);
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
    regimentDate = '${CommonUtil().regimentDateFormat(selectedDate)}';
    resetRegimenTab();
    fetchRegimentData();
    notifyListeners();
  }

  Future<SaveResponseModel> saveFormData({
    String eid,
    String events,
  }) async {
    return await RegimentService.saveFormData(
      eid: eid,
      events: events,
    );
  }

  Future<FieldsResponseModel> getFormData({
    String eid,
  }) async {
    final response = await RegimentService.getFormData(
      eid: eid,
    );
    return response;
  }

  Future<ProfileResponseModel> getProfile() async {
    return await RegimentService.getProfile();
  }

  Future<SaveResponseModel> saveProfile({
    String schedules,
  }) async {
    return await RegimentService.saveProfile(
      schedules: schedules,
    );
  }
}
