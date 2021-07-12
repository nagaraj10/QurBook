import 'dart:async';

import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/add_new_plan/model/AddPlanSuccessResponse.dart';
import 'package:myfhb/add_new_plan/model/PlanCode.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class AddNewBlock implements BaseBloc {

  StreamController addPlanController;


  StreamSink<ApiResponse<AddPlanSuccessResponse>> get addPlanSink =>
      addPlanController.sink;
  Stream<ApiResponse<AddPlanSuccessResponse>> get addPlanStream =>
      addPlanController.stream;

  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  void dispose() {
    addPlanController?.close();
  }

  AddNewBlock(){
    addPlanController =
        StreamController<ApiResponse<AddPlanSuccessResponse>>();
  }

  Future<AddPlanSuccessResponse> addNewPlan(
      String jsonData,) async {
    AddPlanSuccessResponse addPlanSuccessResponse;
    addPlanSink.add(ApiResponse.loading(variable.strSubmitting));
    try {
      final response = await _helper
          .addNewPlan(jsonData);
    addPlanSuccessResponse= AddPlanSuccessResponse.fromJson(response);
      // healthRecordSink.add(ApiResponse.completed(healthRecordSuccess));
    } catch (e) {
      addPlanSink.add(ApiResponse.error(e.toString()));
    }
    return addPlanSuccessResponse;
  }

  Future<List<PlanCodeResult>> getPlanCode() async {
    PlanCode planCode;
    AddFamilyUserInfoRepository resposiory = AddFamilyUserInfoRepository();
    planCode = await resposiory
        .getPlanCode();
    return planCode.result;
  }
}