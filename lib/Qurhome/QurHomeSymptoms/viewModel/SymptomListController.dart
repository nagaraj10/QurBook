import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/Qurhome/QurHomeSymptoms/services/SymptomService.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/regiment_response_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_query.dart' as variable;

class SymptomListController extends GetxController {
  final _apiProvider = SymptomService();
  var loadingData = false.obs;
  RegimentResponseModel symtomListModel;
  var symptomList = [].obs;

  getSymptomList({bool isLoading}) async {
    try {
      if (isLoading) {
        loadingData.value = true;
      }
      http.Response response = await _apiProvider.getSymptomList();
      if (response == null) {
        loadingData.value = false;
        return RegimentResponseModel(
          regimentsList: [],
        );
      } else {
        symptomList.value = [];
        try {
          symtomListModel =
              RegimentResponseModel.fromJson(json.decode(response.body));

          List<RegimentDataModel> tempRegimentsList =
              symtomListModel.regimentsList;

          //print("tempRegimentsList length ${tempRegimentsList.length}");

          List<RegimentDataModel> recentRegimentsList = [];
          List<RegimentDataModel> seqRegimentsList = [];
          List<RegimentDataModel> otherRegimentsList = [];

          //finalSortList
          List<RegimentDataModel> finalRegimentsList = [];

          if (tempRegimentsList != null && tempRegimentsList.length > 0)
          {
            recentRegimentsList = tempRegimentsList.where((item) => item?.ack_local!=null).toList();
            seqRegimentsList = tempRegimentsList.where((item) => CommonUtil().validString(item?.seq) !=null&&CommonUtil().validString(item?.seq) != "0"&&CommonUtil().validString(item?.seq).trim().isNotEmpty).toList();
            seqRegimentsList.sort((b,a) => int.parse(CommonUtil().validString(a?.seq)).compareTo(int.parse(CommonUtil().validString(b?.seq))));
            otherRegimentsList = tempRegimentsList.where((item) => CommonUtil().validString(item?.seq) == "0"||CommonUtil().validString(item?.seq).trim().isEmpty).toList();

            finalRegimentsList = recentRegimentsList+seqRegimentsList+otherRegimentsList;
            finalRegimentsList = finalRegimentsList.toSet().toList();

            //print("finalRegimentsList length ${finalRegimentsList.length}");

            symptomList.value = finalRegimentsList;

          }else{
            symptomList.value = symtomListModel.regimentsList;
          }
        } on PlatformException {
          symptomList.value = [];
        }
      }
      loadingData.value = false;
    } catch (e) {
      loadingData.value = false;
    }
  }

  void startSymptomTTS(int index, {String staticText, String dynamicText}) {
    stopSymptomTTS();
    if (index < symptomList.value?.length) {
      Future.delayed(
          Duration(
            milliseconds: 100,
          ), () {
        symptomList.value[index].isPlaying = true;
      });
    }
    Provider.of<ChatScreenViewModel>(Get.context, listen: false)
        ?.startTTSEngine(
      textToSpeak: staticText,
      dynamicText: dynamicText,
      isRegiment: true,
      onStop: () {
        stopSymptomTTS();
      },
    );
    symptomList.refresh();
  }

  void stopSymptomTTS({bool isInitial = false}) {
    Provider.of<ChatScreenViewModel>(Get.context, listen: false)?.stopTTSEngine(
      isInitial: isInitial,
    );

    symptomList.value?.forEach((regimenData) {
      regimenData.isPlaying = false;
    });

    symptomList.refresh();
  }

  static Future<SaveResponseModel> saveFormData(
      {String eid,
      String events,
      bool isFollowEvent,
      String followEventContext,
      DateTime selectedDate,
      TimeOfDay selectedTime}) async {
    final userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var urlForRegiment = Constants.BASE_URL + variable.regiment;
    var localTime;
    try {
      if (Provider.of<RegimentViewModel>(Get.context, listen: false)
              .regimentFilter ==
          RegimentFilter.AsNeeded) {
        localTime = CommonUtil.dateFormatterWithdatetimeseconds(
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
              selectedTime.hour, selectedTime.minute),
          isIndianTime: true,
        );
      } else {
        localTime = CommonUtil.dateFormatterWithdatetimeseconds(
          DateTime.now(),
          isIndianTime: true,
        );
      }

      var headerRequest = await HeaderRequest().getRequestHeadersAuthContent();
      var followEventParams = '';
      if (isFollowEvent ?? false) {
        followEventParams =
            '&followevent=1&context=${followEventContext ?? ''}';
      }
      var response = await ApiServices.post(
        urlForRegiment,
        headers: headerRequest,
        body: json.encode(
          {
            'method': 'post',
            'data':
                "Action=SaveFormForEvent&eid=$eid&ack_local=$localTime${events ?? ''}${variable.qr_patientEqaul}$userId$followEventParams&source=QURHOME",
          },
        ),
      );
      if (response != null && response.statusCode == 200) {
        print(response.body);
        return SaveResponseModel.fromJson(json.decode(response.body));
      } else {
        return SaveResponseModel(
          result: SaveResultModel(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('$e was thrown');
    }
  }
}
