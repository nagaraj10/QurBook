import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/HeaderRequest.dart';
import '../constants/fhb_constants.dart';
import '../constants/fhb_query.dart';
import '../reminders/QurPlanReminders.dart';
import '../src/resources/network/api_services.dart';
import 'CommonUtil.dart';
import 'PreferenceUtil.dart';
import 'models/firestore_request.dart';

class FirestoreServices {
  // Declare Firestore subscriptions as class members
  Stream<DocumentSnapshot<Map<String, dynamic>>>? fireStoreSubscription;
  Stream<DocumentSnapshot<Map<String, dynamic>>>?
      fireStoreHealthOrganisationSubscription;

// Initialize controllers
  final qurhomeDashboardController =
      CommonUtil().onInitQurhomeDashboardController();
  final qurhomeRegimenController =
      CommonUtil().onInitQurhomeRegimenController();
  final sheelaAIController = CommonUtil().onInitSheelaAIController();

  /// Updates Firestore listeners by resetting existing subscriptions
  /// and setting up a new listener for general changes.
  void updateFirestoreListner() {
    // Reset existing subscriptions
    fireStoreSubscription = null;
    fireStoreHealthOrganisationSubscription = null;

    // Set up a new listener for changes in the 'patient_list' document
    // for the current user
    setupListenerForFirestoreChanges();
  }

  /// Sets up a listener for changes in the Firestore document associated
  /// with the current user.
  /// Listens for updates in the 'patient_list' document and reacts accordingly,
  /// such as updating specific data elements and setting up additional
  /// listeners for health organization changes.
  void setupListenerForFirestoreChanges() {
    // Retrieve the user ID from preferences
    final userId = PreferenceUtil.getStringValue(KEY_USERID);
    // Check if userId is not null or empty
    if ((userId ?? '').isNotEmpty) {
      // Set up Firestore subscription for changes in the 'patient_list'
      //document for the current user

      fireStoreSubscription = FirebaseFirestore.instance
          .collection('patient_list')
          .doc(userId)
          .snapshots();
      // Check if the subscription is not null
      if (fireStoreSubscription != null) {
        // Listen for changes in the document
        fireStoreSubscription!.listen(
          (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            // Extract data from the document or use an empty map
            //if the document doesn't exist
            final firestoreInfo = documentSnapshot.data() ?? {};

            // Check if the document exists
            if (documentSnapshot.exists) {
              // Extract 'update' field from the document
              final String requiredUpdates = firestoreInfo['update'] ?? '';
              // Check if 'update' is not empty
              if (requiredUpdates.isNotEmpty) {
                // Split the 'update' string into a list
                final updatesList = requiredUpdates.split('_');
                // Check if there is more than one element in the list
                if (updatesList.length > 1) {
                  // Remove the last element and update data for each
                  // remaining element
                  updatesList
                      .take(updatesList.length - 1) // Remove the last element
                      .forEach((element) => updateDataFor(element));
                }
              }

              // Extract 'healthOrganizationId' field from the document
              final String healthOrganisationId =
                  firestoreInfo['healthOrganizationId'] ?? '';

              // Check if 'healthOrganizationId' is not empty
              if (healthOrganisationId.isNotEmpty) {
                // Set up listener for changes in the health organization
                setupListenerForHealthOrganisationChanges(healthOrganisationId);
              }
            } else {
              // If the document doesn't exist, create a
              //new patient list document in firestore
              createPatientListDocument();
            }
          },
        );
      }
    }
  }

  /// Updates data based on the specified [event].
  void updateDataFor(String event, {bool withLoading = false}) {
    //activity_vital_sos_1701347623184
    switch (event) {
      // Update data for 'activity' event
      case 'activity':
        qurhomeRegimenController.updateRegimentData();
        QurPlanReminders.getTheRemindersFromAPI();
        break;

      // Update data for 'vital' event
      case 'vital':
        qurhomeDashboardController.getModuleAccess();
        break;

      // Update data for 'sos' event
      case 'sos':
        qurhomeRegimenController.getSOSButtonStatus();
        break;

      // Update data for 'sheela' event
      case 'sheela':
        sheelaAIController.getSheelaBadgeCount(makeApiRequest: true);
        break;

      // Default case: Update data for all events
      default:
        qurhomeRegimenController.updateRegimentData(isLoading: withLoading);
        QurPlanReminders.getTheRemindersFromAPI();
        qurhomeRegimenController.getSOSButtonStatus();
        qurhomeDashboardController.getModuleAccess();
        sheelaAIController.getSheelaBadgeCount(makeApiRequest: true);
        break;
    }
  }

// This function is responsible for creating a document using Firestore.
  Future<bool> createPatientListDocument() async {
    try {
      // Fetching the headers required for the request
      // using HeaderRequest class.
      final header = await HeaderRequest().getRequestHeadersTimeSlot();

      // Retrieving the user ID from shared preferences or
      // using an empty string if not found.
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

      // Making a POST request to the specified URL with
      //the constructed headers and JSON body.
      final res = await ApiServices.post(
        BASE_URL + qr_messaging,
        headers: header,
        body: jsonBody,
      );

// Checking if the request was successful (status code 200)
// and returning true, otherwise returning false.
      if (res?.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e, stackTrace) {
      // Handling exceptions, logging the error message
      //and stack trace, then returning false.
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Sets up a listener for changes in the Firestore document
  /// associated with the specified health organization.
  void setupListenerForHealthOrganisationChanges(String healthOrganisationId) {
    // Check if there is an existing subscription and reset it
    if (fireStoreHealthOrganisationSubscription != null) {
      fireStoreHealthOrganisationSubscription = null;
    }

    // Set up Firestore subscription for changes in the 'health_org_list'
    // document for the specified health organization
    fireStoreHealthOrganisationSubscription = FirebaseFirestore.instance
        .collection('health_org_list')
        .doc(healthOrganisationId)
        .snapshots();

    // Check if the subscription is not null
    if (fireStoreHealthOrganisationSubscription != null) {
      // Listen for changes in the document
      fireStoreHealthOrganisationSubscription!.listen(
        (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
          // Extract data from the document or use an empty map
          //if the document doesn't exist
          final firestoreInfo = documentSnapshot.data() ?? {};

          // Check if the document exists
          if (documentSnapshot.exists) {
            // Extract 'update' field from the document
            final String requiredUpdates = firestoreInfo['update'] ?? '';

            // Check if 'update' is not empty
            if (requiredUpdates.isNotEmpty) {
              // Split the 'update' string into a list
              final updatesList = requiredUpdates.split('_');

              // Check if there is more than one element in the list
              if (updatesList.length > 1) {
                // Remove the last element and update data
                // for each remaining element
                updatesList
                    .take(updatesList.length - 1) // Remove the last element
                    .forEach((element) => updateDataFor(element));
              }
            }
          }
        },
      );
    }
  }
}
