import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class IosNotificationHandler {
  final _pushStreamCOntroller = StreamController<CallArguments>.broadcast();
  final myDB = Firestore.instance;
  Stream<CallArguments> get pushController => _pushStreamCOntroller.stream;
  final _pushNotificationStreamController =
      StreamController<dynamic>.broadcast();
  Stream<dynamic> get pushNotificationController =>
      _pushNotificationStreamController.stream;

  var callArguments = CallArguments();
  bool isAlreadyLoaded = false;
  String doctorName;
  String patientName;
  String hospitalOrgName;
  String startDate;
  String endDate;
  String planName;
  String orgLogo;
  String title;
  String body;
  String ringtone;
  String templateName;
  Map<int, String> redirectData;
  Map<String, dynamic> redirectDataForWelcomeMessage = null;
  String redirect;
  String healthRecordMetaIds = null;
  bool isCall = false;
  bool isCancellation = false;

  onSelectNotificationFromNative(String payload) {
    if (isCall) {
      updateStatus(parameters.accept.toLowerCase());
    } else if (isCancellation) {
      _pushNotificationStreamController.add(parameters.doctorCancellation);
    } else if (templateName != null && templateName == parameters.chat) {
      _pushNotificationStreamController.add(parameters.chat);
    } else if (redirect != null) {
      if (redirect.toLowerCase() ==
              parameters.UserPlanPackageAssociation.toLowerCase() &&
          redirectDataForWelcomeMessage != null) {
        _pushNotificationStreamController.add(redirectDataForWelcomeMessage);
      } else if (redirectData != null) {
        _pushNotificationStreamController.add(redirectData);
      } else {
        _pushNotificationStreamController.add(redirect);
      }
    } else {
      _pushNotificationStreamController.add("normal");
    }
  }

  setUpListerForTheNotification() {
    variable.reponseToRemoteNotificationMethodChannel
        .setMethodCallHandler((call) {
      if (call.method == variable.notificationResponseMethod) {
        final data = Map<String, dynamic>.from(call.arguments);
        if (!isAlreadyLoaded) {
          Future.delayed(const Duration(seconds: 5), () {
            setResponseMessage(data);
            onSelectNotificationFromNative("");
          });
        } else {
          setResponseMessage(data);
          onSelectNotificationFromNative("");
        }
      }
    });
  }

  setResponseMessage(Map<String, dynamic> message) {
    title = null;
    body = null;
    redirect = null;

    if (message[parameters.notification] != null) {
      final notification = message[parameters.notification];
      setdata(notification);
    } else if (message[parameters.aps] != null) {
      final aps = message[parameters.aps];
      final alert = aps[parameters.alert];
      setdata(alert);
    } else {
      setdata(message);
    }

    if (redirect == null && message[parameters.redirectTo] != null) {
      redirect = message[parameters.redirectTo];
    }
    if (healthRecordMetaIds == null &&
        message[parameters.healthRecordMetaIds] != null) {
      healthRecordMetaIds = message[parameters.healthRecordMetaIds];
    }

    if (redirect.contains('|')) {
      final split = redirect.split('|');
      redirectData = {for (int i = 0; i < split.length; i++) i: split[i]};
      redirectData[split.length] = healthRecordMetaIds;
    }

    if (title == null) {
      title = "title";
      body = "body";
    }
    isCall = message[parameters.strtype] == parameters.call;
    isCancellation =
        message[parameters.templateName] == parameters.doctorCancellation ||
            message[parameters.templateName] == parameters.doctorRescheduling;
    if (message[parameters.strtype] == parameters.call) {
      final userName = message[parameters.username];
      final channelName = message[parameters.meeting_id];
      final doctorId = message[parameters.doctorId];
      callArguments = CallArguments(
          role: ClientRole.Broadcaster,
          channelName: channelName,
          userName: userName,
          doctorId: doctorId);
    }
    if (redirect != null &&
        redirect.toLowerCase() ==
            parameters.UserPlanPackageAssociation.toLowerCase()) {
      redirectDataForWelcomeMessage = {
        parameters.redirectTo: redirect,
        parameters.patientName: patientName,
        parameters.planName: planName,
        parameters.healthOrganizationName: hospitalOrgName,
        parameters.healthOrganizationLogo: orgLogo,
        parameters.userPlanStartDate: startDate,
        parameters.userPlanEndDate: endDate,
        parameters.doctorName: doctorName
      };
    }
  }

  setdata(Map message) {
    title = message[parameters.title];
    body = message[parameters.body];
    ringtone = message[parameters.sound];
    templateName = message[parameters.templateName];
    redirect = message[parameters.redirectTo];
    healthRecordMetaIds = message[parameters.healthRecordMetaIds];
    patientName = message[parameters.patientName];
    hospitalOrgName = message[parameters.healthOrganizationName];
    planName = message[parameters.planName];
    orgLogo = message[parameters.healthOrganizationLogo];
    startDate = message[parameters.userPlanStartDate];
    endDate = message[parameters.userPlanEndDate];
    doctorName = message[parameters.doctorName];
  }

  void dispose() {
    _pushStreamCOntroller.close();
    _pushNotificationStreamController.close();
  }

  void updateStatus(String status) async {
    try {
      await myDB
          .collection("call_log")
          .document("${callArguments.channelName}")
          .setData({"call_status": status});
    } catch (e) {
      print(e);
    }
    if (callArguments != null) {
      _pushStreamCOntroller.sink.add(callArguments);
    }
  }
}
