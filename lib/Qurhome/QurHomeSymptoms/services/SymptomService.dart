import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/Loaders/loader_qurhome.dart';
import 'package:myfhb/Qurhome/QurHomeSymptoms/viewModel/SymptomListController.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/regiment/models/GetEventIdModel.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/src/resources/network/api_services.dart';

class SymptomService {

  Future<dynamic> getSymptomList() async {
    var response;
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    String dateSelected = CommonUtil.dateConversionToApiFormat(
      DateTime.now(),
      isIndianTime: true,
    );
    var urlForRegiment = BASE_URL + regiment;
    try {
      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var currentLanguage = '';
      var lan = CommonUtil.getCurrentLanCode();
      if (lan != 'undef') {
        var langCode = lan.split('-').first;
        currentLanguage = langCode;
      } else {
        currentLanguage = 'en';
      }
      response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            "method": "get",
            "data":
            "Action=GetUserActivities&lang=$currentLanguage&date=$dateSelected&issymptom=1${qr_patientEqaul}$userId",
          },
        ),
        timeOutSeconds: 60,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }

      /* if (response != null && response.statusCode == 200) {
        print(response.body);
        return RegimentResponseModel.fromJson(json.decode(response.body));
      } else {
        return RegimentResponseModel(
          regimentsList: [],
        );
      }*/
    } catch (e) {
      return null;
    }
  }

  Future<GetEventIdModel> getEventIdQurHome({
    dynamic uid, dynamic aid,
    dynamic formId, dynamic formName,
  }) async {
    LoaderQurHome.showLoadingDialog(
      Get.context,
      canDismiss: false,
    );
    var response = await RegimentService.getEventId(
        uid: uid,aid: aid,formId: formId,formName: formName
    );
    LoaderQurHome.hideLoadingDialog(Get.context);
    return response;
  }

  Future<FieldsResponseModel> getFormDataQurHome({
    String eid,
  }) async {
    LoaderQurHome.showLoadingDialog(
      Get.context,
      canDismiss: false,
    );
    var response = await RegimentService.getFormData(
      eid: eid,
    );
    LoaderQurHome.hideLoadingDialog(Get.context);
    return response;
  }

  Future<SaveResponseModel> saveFormDataQurHome({
    String eid,
    String events,
    bool isFollowEvent,
    String followEventContext,
    DateTime selectedDate,
    TimeOfDay selectedTime
  }) async {
    //updateInitialShowIndex(isDone: true);
    return await SymptomListController.saveFormData(
      eid: eid,
      events: events,
      isFollowEvent: isFollowEvent,
      followEventContext: followEventContext,
      selectedDate: selectedDate??DateTime.now(),
      selectedTime: selectedTime??TimeOfDay.now(),
    );
  }

}
