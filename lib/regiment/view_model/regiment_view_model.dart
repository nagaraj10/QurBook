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

enum RegimentMode { Schedule, Symptoms }

class RegimentViewModel extends ChangeNotifier {
  Future<RegimentResponseModel> regimentsData;
  List<RegimentDataModel> regimentsList = [];
  bool regimentsDataAvailable = true;
  DateTime selectedDate = DateTime.now();
  String regimentDate = '${CommonUtil().regimentDateFormat(DateTime.now())}';
  RegimentMode regimentMode = RegimentMode.Schedule;

  Future<void> switchRegimentMode() {
    regimentMode = (regimentMode == RegimentMode.Schedule)
        ? RegimentMode.Symptoms
        : RegimentMode.Schedule;
    notifyListeners();
  }

  Future<void> fetchRegimentData({bool isInitial = false}) {
    if (PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN) ==
        PreferenceUtil.getStringValue(Constants.KEY_USERID)) {
      regimentsDataAvailable = true;
      regimentsData = RegimentService.getRegimentData(
        dateSelected: CommonUtil().dateConversionToApiFormat(selectedDate),
      );
    } else {
      regimentsDataAvailable = false;
      regimentsData = Future.value(
        RegimentResponseModel(
          isSuccess: true,
          regimentsList: [],
          message: Constants.plansForFamily,
        ),
      );
    }
    if (!isInitial) {
      notifyListeners();
    }
  }

  getRegimentList() async {
    fetchRegimentData(
      isInitial: true,
    );
    regimentsList = (await regimentsData).regimentsList;
    notifyListeners();
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
    return await RegimentService.getFormData(
      eid: eid,
    );
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
