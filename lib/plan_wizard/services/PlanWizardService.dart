import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:provider/provider.dart';

class PlanWizardService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PlanListModel> getPlanList(String patientId, String isFrom) async {
    String tag = Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        .selectedTag;
    var body = {};
    var inputForFilter = '';
    if (isFrom == strProviderCare) {
      inputForFilter = onlyProvider;
    } else {
      inputForFilter = onlyFreePlans;
    }
    body['method'] = qr_get;
    body['data'] = getMenuCarePlans +
        tag +
        excludeDiet +
        inputForFilter +
        qr_patientEqaul +
        patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list, jsonString);
    return PlanListModel.fromJson(response);
  }

  Future<PlanListModel> getDietPlanListNew({String patientId,String isFrom, bool isVeg = false}) async {
    String tag = Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        .selectedTag;
    var body = {};
    var inputForFilter = '';
    if (isFrom == strProviderDiet) {
      inputForFilter = onlyProvider;
    } else {
      inputForFilter = onlyFreePlans;
    }
    body['method'] = qr_get;
    body['data'] = getMenuDietPlans +
        tag +
        diet +
        (isVeg ? veg : '') +
        exact +
        inputForFilter +
        qr_patientEqaul +
        patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list, jsonString);
    return PlanListModel.fromJson(response);
  }

  Future<DietPlanModel> getDietPlanList(
      {String patientId, bool isVeg = false}) async {
    String tag = Provider.of<PlanWizardViewModel>(Get.context, listen: false)
        .selectedTag;
    String providerId =
        Provider.of<PlanWizardViewModel>(Get.context, listen: false).providerId;
    var body = {};
    body['method'] = qr_get;
    body['data'] = getMenuDietPlans +
        tag +
        diet +
        (isVeg ? veg : '') +
        prid +
        providerId +
        exact +
        qr_patientEqaul +
        patientId;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list, jsonString);
    return DietPlanModel.fromJson(response);
  }

  Future<AddToCartModel> addToCartService(
      {String packageId, String price, bool isRenew, String tag,String remarks,bool isMemberShipAvail,String actualFee,String planType}) async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var createdBy = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    var paymentInput = {};
    var additionalInfo = {};
    paymentInput['userId'] = userId;
    paymentInput['createdBy'] = createdBy;
    paymentInput['productId'] = packageId;
    paymentInput['productType'] = 'PRD_PLAN';
    paymentInput['paidAmount'] = price;
    additionalInfo['isRenewal'] = isRenew;
    additionalInfo['isMembershipAvail'] = isMemberShipAvail;
    additionalInfo['remarks'] = remarks;
    additionalInfo['PlanType'] = planType;
    additionalInfo['actualFee'] = actualFee;
    additionalInfo['newFee'] = isMemberShipAvail?0:price;
    additionalInfo['tag'] = tag;
    paymentInput['additionalInfo'] = additionalInfo;
    var jsonString = convert.jsonEncode(paymentInput);
    print(jsonString);
    final response = await _helper.addToCartHelper(qr_add_cart, jsonString);
    return AddToCartModel.fromJson(response);
  }

  Future<HealthConditionResponseModel> getHealthConditions(
    String patientId,
  ) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = qr_health_conditions + qr_patientEqaul + patientId;
    var jsonString = convert.jsonEncode(body);
    final response =
        await _helper.getHealthConditions(qr_plan_list, jsonString);
    print(response);
    return HealthConditionResponseModel.fromJson(response);
  }
}
