import 'package:myfhb/add_provider_plan/model/AddProviderPlanResponse.dart';
import 'package:myfhb/add_provider_plan/model/ProviderOrganizationResponse.dart';
import 'package:myfhb/common/PreferenceUtil.dart';

import '../../src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class AddProviderService{
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ProviderOrganisationResponse> getUnassociatedProvider(String patientId,String selectedTag) async {
    String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    String url="provider-mapping/unassociated-providers/"+userID+"?condition="+selectedTag;
    final response = await _helper.getProviderPlan(url);
    return ProviderOrganisationResponse.fromJson(response);
  }

  Future<AddProviderPlanResponse> addProviderPlan(String jsonString)async{
    final response=await _helper.addProvidersForPlan("patient-provider-mapping/add-qurplan-provider",jsonString);
    return AddProviderPlanResponse.fromJson(response);
  }
 }