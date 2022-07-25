import 'dart:convert' as convert;

import '../models/update_providers_id.dart';
import '../../common/CommonConstants.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../constants/webservice_call.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class UpdateProvidersRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = WebserviceCall();

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    // final response = await _helper .updateProviders("userProfiles/$userID/?sections=${query}");
    final userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.updateTeleHealthProviders(
        webserviceCall.getUrlToUpdateDoctor(userID),
        webserviceCall.getQueryToUpdateDoctor(isPreferred, providerId));

    return UpdateProvidersId.fromJson(response);
  }

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetailsNew(
      String providerId,
      bool isPreferred,
      String provideReferenceId,
      String userId,
      List<String> selectedCategories,
      {bool isPAR}) async {
    //String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final Map<String, dynamic> doctorDic = {};
    doctorDic[parameters.doctorId] = providerId;
    doctorDic[parameters.strDoctorReferenceId] = provideReferenceId;
    doctorDic[parameters.strisDefault] = isPreferred;
    doctorDic['sharedCategories'] = selectedCategories;

    final jsonData = {};
    jsonData[parameters.strdoctor] = [doctorDic];
    jsonData[parameters.healthOrganization] = [];

    final jsonString = convert.jsonEncode(jsonData);
    print(jsonString);

    var response = await _helper.updateTeleHealthProvidersNew(
        webserviceCall.getUrlToUpdateDoctorNew(userId), jsonString,
        isPAR: isPAR);

    return UpdateProvidersId.fromJson(response);
  }

  // 2
  // Hospitals
  Future<UpdateProvidersId> updateHospitalsIdWithUserDetails(
      String providerId,
      bool isPreferred,
      String provideReferenceId,
      String userId,
      List<String> selectedCategories) async {
    // String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final Map<String, dynamic> hospitalDic = {};
    hospitalDic[parameters.doctorId] = null;
    hospitalDic[parameters.strDoctorReferenceId] = null;
    hospitalDic[parameters.strisDefault] = false;

    var healthOrganizationDic = Map<String, dynamic>();
    healthOrganizationDic[parameters.strHealthOrganizationId] = providerId;
    healthOrganizationDic[parameters.strHealthOrganizationReferenceId] =
        provideReferenceId;
    healthOrganizationDic[parameters.strisDefault] = isPreferred;
    healthOrganizationDic['sharedCategories'] = selectedCategories;

    final jsonData = {};
    jsonData[parameters.strdoctor] = [hospitalDic];
    jsonData[parameters.healthOrganization] = [healthOrganizationDic];

    final jsonString = convert.jsonEncode(jsonData);
    print(jsonString);

    var response = await _helper.updateTeleHealthProvidersNew(
        webserviceCall.getUrlToUpdateDoctorNew(userId), jsonString);
    return UpdateProvidersId.fromJson(response);
  }

  // 3
  // Labs
  Future<UpdateProvidersId> updateLabsIdWithUserDetails(
      String providerId,
      bool isPreferred,
      String provideReferenceId,
      String userId,
      List<String> selectedCategories) async {
    // String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final hospitalDic = Map<String, dynamic>();
    hospitalDic[parameters.doctorId] = null;
    hospitalDic[parameters.strDoctorReferenceId] = null;
    hospitalDic[parameters.strisDefault] = false;

    final Map<String, dynamic> healthOrganizationDic = {};
    healthOrganizationDic[parameters.strHealthOrganizationId] = providerId;
    healthOrganizationDic[parameters.strHealthOrganizationReferenceId] =
        provideReferenceId;
    healthOrganizationDic[parameters.strisDefault] = isPreferred;
    healthOrganizationDic['sharedCategories'] = selectedCategories;

    final jsonData = {};
    jsonData[parameters.strdoctor] = [hospitalDic];
    jsonData[parameters.healthOrganization] = [healthOrganizationDic];

    final jsonString = convert.jsonEncode(jsonData);
    print(jsonString);

    var response = await _helper.updateTeleHealthProvidersNew(
        webserviceCall.getUrlToUpdateDoctorNew(userId), jsonString);
    return UpdateProvidersId.fromJson(response);
  }
}
