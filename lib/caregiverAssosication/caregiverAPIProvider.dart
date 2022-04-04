import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../constants/HeaderRequest.dart';
import '../constants/fhb_constants.dart';
import '../constants/fhb_parameters.dart';
import '../constants/fhb_query.dart';
import '../src/resources/network/api_services.dart';
import 'caregiverAssosicationModel.dart';

class CaregiverAPIProvider {
  approveCareGiver({
    String phoneNumber,
    String code,
  }) async {
    final url = BASE_URL + qr_userlinking + qr_approve_caregiver;
    final headers = await HeaderRequest().getRequestHeadersTimeSlot();
    var param = json.encode({
      strPhoneNumber: phoneNumber,
      verificationCode: code,
    });
    try {
      final response = await ApiServices.post(
        url,
        headers: headers,
        body: param,
      );
      final model = CaregiverAssosicationModel.fromMap(
        json.decode(
          response.body,
        ),
      );
      FlutterToast().getToast(
        model.message,
        model.isSuccess ? Colors.green : Colors.red,
      );
    } catch (e) {
      FlutterToast().getToast(
        'Failed to approve the caregiver',
        Colors.red,
      );
    }
  }

  rejectCareGiver({
    String receiver,
    String requestor,
  }) async {
    final url = BASE_URL + qr_userlinking + qr_reject_caregiver;
    final headers = await HeaderRequest().getRequestHeadersTimeSlot();
    final param = json.encode({
      caregiverReceiver: receiver,
      caregiverRequestor: requestor,
    });
    try {
      final response = await ApiServices.put(
        url,
        headers: headers,
        body: param,
      );
      final model = CaregiverAssosicationModel.fromMap(
        json.decode(
          response.body,
        ),
      );
      FlutterToast().getToast(
        model.message,
        model.isSuccess ? Colors.green : Colors.red,
      );
    } catch (e) {
      FlutterToast().getToast(
        'Failed to reject the caregiver',
        Colors.red,
      );
    }
  }
}
