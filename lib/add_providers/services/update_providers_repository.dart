import 'dart:convert' as convert;

import 'package:myfhb/add_providers/models/update_providers_id.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/webservice_call.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class UpdateProvidersRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = new WebserviceCall();

  // 1
  // Doctors
  Future<UpdateProvidersId> updateDoctorsIdWithUserDetails(
      String providerId, bool isPreferred) async {
    // final response = await _helper .updateProviders("userProfiles/$userID/?sections=${query}");
    String userID = await PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.updateTeleHealthProviders(
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
      List<String> selectedCategories) async {
    //String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    Map<String, dynamic> doctorDic = new Map();
    doctorDic[parameters.doctorId] = providerId;
    doctorDic[parameters.strDoctorReferenceId] = provideReferenceId;
    doctorDic[parameters.strisDefault] = isPreferred;
    doctorDic['sharedCategories'] = selectedCategories;

    var jsonData = {};
    jsonData[parameters.strdoctor] = [doctorDic];
    jsonData[parameters.healthOrganization] = [];

    var jsonString = convert.jsonEncode(jsonData);
    print(jsonString);

    final response = await _helper.updateTeleHealthProvidersNew(
        webserviceCall.getUrlToUpdateDoctorNew(userId), jsonString);

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

    Map<String, dynamic> hospitalDic = new Map();
    hospitalDic[parameters.doctorId] = null;
    hospitalDic[parameters.strDoctorReferenceId] = null;
    hospitalDic[parameters.strisDefault] = false;

    Map<String, dynamic> healthOrganizationDic = new Map();
    healthOrganizationDic[parameters.strHealthOrganizationId] = providerId;
    healthOrganizationDic[parameters.strHealthOrganizationReferenceId] =
        provideReferenceId;
    healthOrganizationDic[parameters.strisDefault] = isPreferred;
    healthOrganizationDic['sharedCategories'] = selectedCategories;

    var jsonData = {};
    jsonData[parameters.strdoctor] = [hospitalDic];
    jsonData[parameters.healthOrganization] = [healthOrganizationDic];

    var jsonString = convert.jsonEncode(jsonData);
    print(jsonString);

    final response = await _helper.updateTeleHealthProvidersNew(
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

    Map<String, dynamic> hospitalDic = new Map();
    hospitalDic[parameters.doctorId] = null;
    hospitalDic[parameters.strDoctorReferenceId] = null;
    hospitalDic[parameters.strisDefault] = false;

    Map<String, dynamic> healthOrganizationDic = new Map();
    healthOrganizationDic[parameters.strHealthOrganizationId] = providerId;
    healthOrganizationDic[parameters.strHealthOrganizationReferenceId] =
        provideReferenceId;
    healthOrganizationDic[parameters.strisDefault] = isPreferred;
    healthOrganizationDic['sharedCategories'] = selectedCategories;

    var jsonData = {};
    jsonData[parameters.strdoctor] = [hospitalDic];
    jsonData[parameters.healthOrganization] = [healthOrganizationDic];

    var jsonString = convert.jsonEncode(jsonData);
    print(jsonString);

    final response = await _helper.updateTeleHealthProvidersNew(
        webserviceCall.getUrlToUpdateDoctorNew(userId), jsonString);
    return UpdateProvidersId.fromJson(response);
  }
}
