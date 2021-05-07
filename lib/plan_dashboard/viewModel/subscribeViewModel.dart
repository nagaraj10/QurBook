import 'package:flutter/cupertino.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/myPlan/model/myPlanDetailModel.dart';
import 'package:myfhb/myPlan/model/myPlanListModel.dart';
import 'package:myfhb/myPlan/services/myPlanService.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_dashboard/model/subscribeModel.dart';
import 'package:myfhb/plan_dashboard/services/planService.dart';
import 'package:myfhb/plan_dashboard/services/subscribeService.dart';

class SubscribeViewModel extends ChangeNotifier {

  SubscribeService myPlanService = new SubscribeService();

  Future<SubscribeModel> subScribePlan(String packageId) async {
    try {
      SubscribeModel myPlanListModel =
      await myPlanService.subscribePlan(packageId);
      return myPlanListModel;
    } catch (e) {}
  }

  Future<SubscribeModel> UnsubScribePlan(String packageId) async {
    try {
      SubscribeModel myPlanListModel =
      await myPlanService.UnsubscribePlan(packageId);
      return myPlanListModel;
    } catch (e) {}
  }

}