import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/src/ui/bot/service/sheela_service.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../blocs/health/HealthReportListForUserBlock.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import '../../../model/bot/SpeechModelResponse.dart';
import '../../../model/user/MyProfile.dart';
import '../../../utils/FHBUtils.dart';

class ChatScreenViewModel extends ChangeNotifier {
  final ScrollController controller;

  ChatScreenViewModel({this.controller});

  static MyProfile prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  List<Conversation> conversations = new List();
  static var uuid = Uuid().v1();
  var user_id = PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);
  var user_name = prof.response.data.generalInfo.qualifiedFullName != null
      ? prof.response.data.generalInfo.qualifiedFullName.firstName +
          prof.response.data.generalInfo.qualifiedFullName.lastName
      : '';
  var auth_token = PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
  var isMayaSpeaks = -1;
  var isEndOfConv = false;
  var stopTTSNow = false;
  var isLoading = false;

  List<Conversation> get getMyConversations => conversations;

  int get getisMayaSpeaks => isMayaSpeaks;

  void clearMyConversation() {
    conversations = List();
    notifyListeners();
  }

  startMayaAutomatically() {
    Future.delayed(Duration(seconds: 1), () {
      sendToMaya(variable.strhiMaya);
    });

    var date = new FHBUtils().getFormattedDateString(DateTime.now().toString());
    Conversation model = new Conversation(
      isMayaSaid: false,
      text: variable.strhiMaya,
      name: prof.response.data.generalInfo.qualifiedFullName != null
          ? prof.response.data.generalInfo.qualifiedFullName.firstName +
              prof.response.data.generalInfo.qualifiedFullName.lastName
          : '',
      timeStamp: date,
    );

    conversations.add(model);
    notifyListeners();
  }

  sendToMaya(String msg) async {
    String uuidString = uuid;

    Map<String, dynamic> reqJson = {};
    reqJson[parameters.strSender] = user_id;
    reqJson[parameters.strSenderName] = user_name;
    reqJson[parameters.strMessage] = msg;
    reqJson[parameters.strSource] = variable.strdevice;
    reqJson[parameters.strSessionId] = uuidString;
    reqJson[parameters.strAuthtoken] = auth_token;

    Service mService = Service();
    final response = await mService.sendMetaToMaya(reqJson);

    if (response.statusCode == 200) {
      if (response.body != null) {
        final jsonResponse = jsonDecode(response.body);

        List<dynamic> list = jsonResponse;
        if (list.length > 0) {
          SpeechModelResponse res = SpeechModelResponse.fromJson(list[0]);
          isEndOfConv = res.endOfConv;
          var date =
              new FHBUtils().getFormattedDateString(DateTime.now().toString());
          Conversation model = new Conversation(
            isMayaSaid: true,
            text: res.text,
            name: prof.response.data.generalInfo.qualifiedFullName != null
                ? prof.response.data.generalInfo.qualifiedFullName.firstName +
                    prof.response.data.generalInfo.qualifiedFullName.lastName
                : '',
            imageUrl: res.imageURL,
            timeStamp: date,
          );
          conversations.add(model);
          notifyListeners();
          isLoading = true;
          Future.delayed(Duration(seconds: 4), () {
            isLoading = false;
            isMayaSpeaks = 0;
            if (!stopTTSNow) {
              variable.tts_platform.invokeMethod(variable.strtts, {
                parameters.strMessage: res.text,
                parameters.strIsClose: false
              }).then((res) {
                if (res == 1) {
                  isMayaSpeaks = 1;
                }
                if (!isEndOfConv) {
                  gettingReposnseFromNative();
                } else {
                  refreshData();
                }
              });
            }
          });
          return jsonResponse;
        }
      }
    }
  }

  Future<void> gettingReposnseFromNative() async {
    try {
      await variable.voice_platform
          .invokeMethod(variable.strspeakAssistant)
          .then((response) {
        sendToMaya(response);
        var date =
            new FHBUtils().getFormattedDateString(DateTime.now().toString());
        Conversation model = new Conversation(
          isMayaSaid: false,
          text: response,
          name: prof.response.data.generalInfo.qualifiedFullName != null
              ? prof.response.data.generalInfo.qualifiedFullName.firstName +
                  prof.response.data.generalInfo.qualifiedFullName.lastName
              : '',
          timeStamp: date,
        );
        conversations.add(model);
        notifyListeners();
      });
    } on PlatformException catch (e) {}
  }

  void refreshData() {
    var _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportLists().then((value) {
      PreferenceUtil.saveCompleteData(constants.KEY_COMPLETE_DATA, value);
    });
  }
}
