import 'package:flutter/cupertino.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class MyPlanViewModel extends ChangeNotifier {
  MyPlanService myPlanService = new MyPlanService();

  List<MyPlanListResult> myPLanListResult = List();

  Future<MyPlanListModel> getMyPlanList() async {
    var userid = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    if (userid != null) {
      try {
        MyPlanListModel myPlanListModel = await myPlanService.getMyPlanList();
        if (myPlanListModel.isSuccess) {
          myPLanListResult = myPlanListModel.result;
        }
        return myPlanListModel;
      } catch (e) {}
    }
  }

  Future<MyPlanDetailModel> getMyPlanDetails(String packageId) async {
    try {
      MyPlanDetailModel myPlanDetailModel =
          await myPlanService.getMyPlanDetails(packageId);
      return myPlanDetailModel;
    } catch (e) {}
  }

  List<MyPlanListResult> getProviderName(
      {List<MyPlanListResult> planList, String query}) {
    List<MyPlanListResult> dummyPlanList = List();
    dummyPlanList = planList
        .where((element) => element.providerName
            .toLowerCase()
            .trim()
            .contains(query.toLowerCase().trim()))
        .toList();
    return dummyPlanList;
  }

  List<MyPlanListResult> getProviderSearch(String doctorName) {
    List<MyPlanListResult> filterDoctorData = new List();
    for (MyPlanListResult doctorData in myPLanListResult) {
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
