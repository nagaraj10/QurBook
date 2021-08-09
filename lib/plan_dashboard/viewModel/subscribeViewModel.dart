import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myfhb/user_plans/view_model/user_plans_view_model.dart';
import 'package:provider/provider.dart';
import '../../common/PreferenceUtil.dart';
import '../../myPlan/model/myPlanDetailModel.dart';
import '../../myPlan/model/myPlanListModel.dart';
import '../../myPlan/services/myPlanService.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../model/CreateSubscribeModel.dart';
import '../model/PlanListModel.dart';
import '../model/subscribeModel.dart';
import '../services/planService.dart';
import '../services/subscribeService.dart';

class SubscribeViewModel extends ChangeNotifier {
  SubscribeService myPlanService = SubscribeService();

  Future<SubscribeModel> subScribePlan(String packageId) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    try {
      var myPlanListModel =
          await myPlanService.subscribePlan(packageId, userid);
      await Provider.of<UserPlansViewModel>(Get.context, listen: false)
          ?.getUserPlanInfo();
      return myPlanListModel;
    } catch (e) {}
  }

  Future<SubscribeModel> UnsubScribePlan(String packageId) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    try {
      var myPlanListModel =
          await myPlanService.UnsubscribePlan(packageId, userid);
      await Provider.of<UserPlansViewModel>(Get.context, listen: false)
          ?.getUserPlanInfo();
      return myPlanListModel;
    } catch (e) {}
  }

  Future<CreateSubscribeModel> createSubscribePayment(String packageId) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    try {
      var createSubscribeModel =
          await myPlanService.createSubscribe(packageId, userid);
      return createSubscribeModel;
    } catch (e) {}
  }
}
