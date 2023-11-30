import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../constants/HeaderRequest.dart';
import '../constants/fhb_constants.dart';
import '../constants/fhb_query.dart';
import '../reminders/QurPlanReminders.dart';
import '../src/resources/network/api_services.dart';
import 'CommonUtil.dart';
import 'PreferenceUtil.dart';
import 'models/firestore_request.dart';

class FirestoreServices {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? fireStoreSubscription;
  final qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();
  void setupListenerForFirestoreChanges() {
    final userId = PreferenceUtil.getStringValue(KEY_USERID);
    fireStoreSubscription = FirebaseFirestore.instance
        .collection('patient_list')
        .doc(userId)
        .snapshots();
    if ((userId ?? '').isNotEmpty) {
      if (fireStoreSubscription != null) {
        fireStoreSubscription!.listen(
          (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            final firestoreInfo = documentSnapshot.data() ?? {};
            if (documentSnapshot.exists) {
              final String requiredUpdates = firestoreInfo['update'] ?? '';
              if (requiredUpdates.isNotEmpty) {
                final updatesList = requiredUpdates.split('_');
                if (updatesList.length > 1) {
                  updatesList.removeLast();
                  for (final current in updatesList) {
                    switch (current) {
                      //activity_vital_sos_1701347623184
                      case 'activity':
                        QurPlanReminders.getTheRemindersFromAPI();
                        break;
                      case 'vital':
                        qurhomeDashboardController.getModuleAccess();
                        break;
                      case 'sos':
                        print('sos');
                        break;
                      default:
                        print('non');
                    }
                  }
                }
              }
            } else {
              createDocument();
            }
          },
        );
      }
    }
  }

  void updateFirestoreListner() {
    fireStoreSubscription = null;
    setupListenerForFirestoreChanges();
  }

  Future<bool> createDocument() async {
    try {
      final header = await HeaderRequest().getRequestHeadersTimeSlot();
      final userId = PreferenceUtil.getStringValue(KEY_USERID) ?? '';
      final payload = RequestPayload(
        isActivityRefresh: true,
        isSosEnabled: true,
        isVitalModuleDisable: true,
      );
      final msgDetails = MessageDetails(payload: payload);
      final requestBody = FirestoreRequestModel(
          recipients: [userId],
          messageDetails: msgDetails,
          transportMedium: ['Firebase'],
          saveMessage: false);
      final jsonBody = requestBody.toJson();
      final res = await ApiServices.post(
        BASE_URL + qr_messaging,
        headers: header,
        body: jsonBody,
      );

      if (res?.statusCode == 200) {
        return true;
      } else {
        FlutterToast().getToast(
          'Failed to subscribe for updates.',
          Colors.red,
        );
        return false;
      }
    } on Exception catch (e, stackTrace) {
      FlutterToast().getToast(
        'Failed to subscribe for updates.',
        Colors.red,
      );
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return false;
    }
  }
}
