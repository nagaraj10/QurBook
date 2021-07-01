import 'package:flutter/cupertino.dart';
import '../../common/PreferenceUtil.dart';
import '../model/myPlanDetailModel.dart';
import '../model/myPlanListModel.dart';
import '../services/myPlanService.dart';
import '../../constants/fhb_constants.dart' as Constants;

class MyPlanViewModel extends ChangeNotifier {
  MyPlanService myPlanService = MyPlanService();

  List<MyPlanListResult> myPLanListResult = [];

  Future<MyPlanListModel> getMyPlanList() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var myPlanListModel = await myPlanService.getMyPlanList(userid);
        if (myPlanListModel.isSuccess) {
          myPLanListResult = myPlanListModel.result;
        }
        return myPlanListModel;
      } catch (e) {}
    }
  }

  Future<MyPlanDetailModel> getMyPlanDetails(String packageId) async {
    try {
      var myPlanDetailModel = await myPlanService.getMyPlanDetails(packageId);
      return myPlanDetailModel;
    } catch (e) {}
  }

  List<MyPlanListResult> getProviderName(
      {List<MyPlanListResult> planList, String query}) {
    var dummyPlanList = List<MyPlanListResult>();
    dummyPlanList = planList
        .where((element) => element.providerName
            .toLowerCase()
            .trim()
            .contains(query.toLowerCase().trim()))
        .toList();
    return dummyPlanList;
  }

  List<MyPlanListResult> getProviderSearch(String doctorName) {
    var filterDoctorData = List<MyPlanListResult>();
    for (final doctorData in myPLanListResult) {
      if (doctorData.title != null && doctorData.title != '') {
        if (doctorData.title
            .toLowerCase()
            .trim()
            .contains(doctorName.toLowerCase().trim())) {
          filterDoctorData.add(doctorData);
        }
      }
    }
    return filterDoctorData;
  }
}
