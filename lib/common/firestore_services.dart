import 'dart:async';
import 'dart:convert';

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
  final qurhomeRegimenController =
      CommonUtil().onInitQurhomeRegimenController();
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
                        qurhomeRegimenController.updateRegimentData();
                        QurPlanReminders.getTheRemindersFromAPI();
                        break;
                      case 'vital':
                        qurhomeDashboardController.getModuleAccess();
                        break;
                      case 'sos':
                        qurhomeRegimenController.getSOSButtonStatus();
                        break;
                      default:
                        qurhomeRegimenController.updateRegimentData();
                        QurPlanReminders.getTheRemindersFromAPI();
                        qurhomeRegimenController.getSOSButtonStatus();
                        qurhomeDashboardController.getModuleAccess();
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

// This function is responsible for creating a document using Firestore.
  Future<bool> createDocument() async {
    try {
      // Fetching the headers required for the request using HeaderRequest class.
      final header = await HeaderRequest().getRequestHeadersTimeSlot();

      // Retrieving the user ID from shared preferences or using an empty string if not found.
      final userId = PreferenceUtil.getStringValue(KEY_USERID) ?? '';

      // Creating a payload for the request.
      final payload = RequestPayload(
        isActivityRefresh: true,
        isSosEnabled: true,
        isVitalModuleDisable: true,
      );

      // Creating message details with the specified payload.
      final msgDetails = MessageDetails(payload: payload);

      // Creating the request body model for Firestore.
      final requestBody = FirestoreRequestModel(
          recipients: [userId],
          messageDetails: msgDetails,
          transportMedium: ['Firebase'],
          saveMessage: false);

      // Converting the request body to JSON format.
      final jsonBody = json.encode(requestBody.toJson());

      // Making a POST request to the specified URL with the constructed headers and JSON body.
      final res = await ApiServices.post(
        BASE_URL + qr_messaging,
        headers: header,
        body: jsonBody,
      );

// Checking if the request was successful (status code 200) and returning true, otherwise returning false.
      if (res?.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e, stackTrace) {
      // Handling exceptions, logging the error message and stack trace, then returning false.
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return false;
    }
  }
}
