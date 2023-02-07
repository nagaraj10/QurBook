import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_query.dart';
import '../../myPlan/model/myPlanDetailModel.dart';
import '../../myPlan/model/myPlanListModel.dart';
import '../model/PlanListModel.dart';
import '../model/SearchListModel.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
import 'dart:convert' as convert;
import '../../constants/fhb_constants.dart' as Constants;

class SearchListService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<SearchListModel> getSearchList(String title) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_getSearchList+qr_qEqaul+title+qr_patientEqaul+userid;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getSearchListApi(qr_plan_list,jsonString);
    return SearchListModel.fromJson(response);
  }

  Future<SearchListModel> getUserProviderList(String patientId) async {
    final body = {};
    body['method'] = qr_get;
    body['data'] = qr_getUserSearchList+qr_patientEqaul+patientId;
    final jsonString = convert.jsonEncode(body);
    var response = await _helper.getSearchListApi(qr_plan_list,jsonString);
    return SearchListModel.fromJson(response);
  }
}
