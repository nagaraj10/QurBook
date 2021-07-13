import 'dart:convert' as convert;
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';

class PlanWizardService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PlanListModel> getPlanList(String patientId) async {
    var body = {};
    body['method'] = qr_get;
    body['data'] = getMenuCarePlans;
    var jsonString = convert.jsonEncode(body);
    final response = await _helper.getPlanList(qr_plan_list, jsonString);
    return PlanListModel.fromJson(response);
  }

  Future<AddToCartModel> addToCartService({String packageId,String price,bool isRenew}) async {
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
    paymentInput['additionalInfo'] = additionalInfo;
    var jsonString = convert.jsonEncode(paymentInput);
    print(jsonString);
    final response = await _helper.addToCartHelper(qr_add_cart,jsonString);
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
