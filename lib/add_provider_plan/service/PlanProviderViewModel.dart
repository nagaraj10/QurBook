import 'package:flutter/cupertino.dart';
import 'package:myfhb/add_provider_plan/model/AddProviderPlanResponse.dart';
import 'package:myfhb/add_provider_plan/model/ProviderOrganizationResponse.dart';
import 'package:myfhb/add_provider_plan/service/AddProviderService.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:scroll_to_index/util.dart';


class PlanProviderViewModel extends ChangeNotifier {
  AddProviderService _addProviderService = new AddProviderService();
  List<Result> providerPlanResult;
  bool hasSelectAllData=false;

  void updateBool(bool condition){
    hasSelectAllData=condition;
    print(hasSelectAllData);
    Future.delayed(Duration(milliseconds: 100),(){
      notifyListeners();

    });
  }
  Future<ProviderOrganisationResponse> getCarePlanList(String selectedTag) async {
    try {
      var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      ProviderOrganisationResponse myPlanListModel =
          await _addProviderService.getUnassociatedProvider(userId,selectedTag);
      if (myPlanListModel.isSuccess) {
        providerPlanResult = myPlanListModel.result;
      } else {
        providerPlanResult = [];
      }
      return myPlanListModel;
    } catch (e) {}
  }

  Future<AddProviderPlanResponse> addproviderPlan(List<String> healthOrganization)async{
    final addProvider = {};

    var userId =await PreferenceUtil.getStringValue(Constants.KEY_USERID);
    addProvider['userId'] = userId;
    addProvider['healthOrganizations'] = healthOrganization;
    final jsonString = convert.jsonEncode(addProvider);

    AddProviderPlanResponse addProviderPlanResponse=await _addProviderService.addProviderPlan(jsonString);
    return addProviderPlanResponse;

  }
}
