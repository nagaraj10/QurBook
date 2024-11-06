import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_query.dart';
import '../model/CreateSubscribeModel.dart';
import '../model/subscribeModel.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;

class SubscribeService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SubscribeModel> subscribePlan(String packageId,String patientId) async {
   
    var localTime = CommonUtil.dateFormatterWithdatetimeseconds(DateTime.now(),isIndianTime: true,);
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_subscribePlan+packageId+qr_patientEqaul+patientId+qr_timeEqaul+localTime;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getPlanList(qr_plan_list,jsonString);
    return SubscribeModel.fromJson(response);
  }

  Future<SubscribeModel> UnsubscribePlan(String packageId,String patientId) async {
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_UnsubscribePlan+packageId+qr_patientEqaul+patientId;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getPlanList(qr_plan_list,jsonString);
    return SubscribeModel.fromJson(response);
  }

  Future<CreateSubscribeModel> createSubscribe(String packageId,String patientId) async {
    final paymentInput = {};
    paymentInput['planPackageId'] = packageId;
    paymentInput['patientId'] = patientId;
    final jsonString = convert.jsonEncode(paymentInput);
    var response = await _helper.createSubscribe(qr_createSubscribe,jsonString);
    return CreateSubscribeModel.fromJson(response);
  }
}
