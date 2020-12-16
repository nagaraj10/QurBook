import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/bot/common/botutils.dart';
import 'package:myfhb/src/ui/bot/service/sheela_service.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../blocs/health/HealthReportListForUserBlock.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import '../../../model/bot/SpeechModelResponse.dart';
import '../../../utils/FHBUtils.dart';

class ChatScreenViewModel extends ChangeNotifier {

  static MyProfileModel prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  List<Conversation> conversations = new List();
  static var uuid = Uuid().v1();
  var user_id = PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);
  var user_name = prof.result != null
      ? prof.result.firstName +
          prof.result.lastName
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
      name: prof.result != null
          ? prof.result.firstName +
              prof.result.lastName
          : '',
      timeStamp: date,
    );

    conversations.add(model);
    notifyListeners();
  }

  askUserForLanguage() {
    Future.delayed(Duration(seconds: 1), () {
      sendToMaya(variable.strhiMaya);
    });

    var date = new FHBUtils().getFormattedDateString(DateTime.now().toString());
    Conversation model = new Conversation(
      isMayaSaid: false,
      text: variable.strhiMaya,
      name: prof.result != null
          ? prof.result.firstName +
              prof.result.lastName
          : '',
      timeStamp: date,
    );

    conversations.add(model);
    notifyListeners();
  }

  sendToMaya(String msg) async {
    String uuidString = uuid;
    String tzOffset = DateTime.now().timeZoneOffset.toString();
    var splitedArr = tzOffset.split(':');
    Map<String, dynamic> reqJson = {};
    reqJson[parameters.strSender] = user_id;
    reqJson[parameters.strSenderName] = user_name;
    reqJson[parameters.strMessage] = msg;
    reqJson[parameters.strSource] = variable.strdevice;
    reqJson[parameters.strSessionId] = uuidString;
    reqJson[parameters.strAuthtoken] = auth_token;
    reqJson[parameters.strLanguage] = Utils.getCurrentLanCode();
    reqJson[parameters.strtimezone] =
        splitedArr.length > 0 ? '${splitedArr[0]}:${splitedArr[1]}' : '';

    Service mService = Service();
    final response = await mService.sendMetaToMaya(reqJson);

    if (response.statusCode == 200) {
      if (response.body != null) {
        final jsonResponse = jsonDecode(response.body);

        List<dynamic> list = jsonResponse;
        if (list.length > 0) {
          SpeechModelResponse res = SpeechModelResponse.fromJson(list[0]);
          isEndOfConv = res.endOfConv;
          PreferenceUtil.saveString(constants.SHEELA_LANG, res.lang);
          var date =
              new FHBUtils().getFormattedDateString(DateTime.now().toString());
          Conversation model = new Conversation(
            isMayaSaid: true,
            text: res.text,
            name: prof.result != null
                ? prof.result.firstName +
                    prof.result.lastName
                : '',
            imageUrl: res.imageURL,
            timeStamp: date,
            buttons: res.buttons,
            langCode: res.lang
          );
          conversations.add(model);
           isLoading = true;
          notifyListeners();
          Future.delayed(Duration(seconds: 4), () {
            isLoading = false;
            notifyListeners();
            isMayaSpeaks = 0;
            if (!stopTTSNow) {
              variable.tts_platform.invokeMethod(variable.strtts, {
                parameters.strMessage: res.text,
                parameters.strIsClose: false,
                parameters.strLanguage:res.lang
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
    }else{
      FlutterToast().getToast('There is some issue with sheela,\n Please try after some time', Colors.black54);
    }
  }

  Future<void> gettingReposnseFromNative() async {
    try {
      await variable.voice_platform
          .invokeMethod(variable.strspeakAssistant,{
            'langcode':Utils.getCurrentLanCode()
          }) 
          .then((response) {
        sendToMaya(response);
        var date =
            new FHBUtils().getFormattedDateString(DateTime.now().toString());
        Conversation model = new Conversation(
          isMayaSaid: false,
          text: response,
          name: prof.result != null
              ? prof.result.firstName +
                  prof.result.lastName
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
