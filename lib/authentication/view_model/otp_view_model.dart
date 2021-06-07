import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myfhb/authentication/service/authservice.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/view/confirm_via_call_widget.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/authentication/model/otp_response_model.dart';

class OtpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String timeForResend = '00:30';
  int timerSeconds = 30;
  Timer _timer;
  Timer _otpTimer;
  bool isDialogOpen = false;

  void updateDialogStatus(bool newStatus) {
    isDialogOpen = newStatus;
  }

  void startTimer() {
    timerSeconds = 30;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        timerSeconds = 30 - timer.tick;
        if (timerSeconds == 0) {
          stopTimer(resetValues: false);
        }
        timeForResend =
            '00:${timerSeconds?.toString()?.length > 1 ? timerSeconds : '0$timerSeconds'}';
        notifyListeners();
      },
    );
  }

  void stopTimer({bool resetValues = true}) {
    if (resetValues) {
      timerSeconds = 30;
      timeForResend = '00:30';
    }
    if (_timer?.isActive) _timer?.cancel();
  }

  void confirmViaCall({
    @required String phoneNumber,
    @required Function(String otpCode) onOtpReceived,
  }) async {
    LoaderClass.showLoadingDialog(Get.context, canDismiss: false);
    List<dynamic> ivrNumberslist = await getIVRNumbers();
    LoaderClass.hideLoadingDialog(Get.context);
    updateDialogStatus(true);
    Get.dialog(
      ConfirmViaCallWidget(
        ivrNumbersList: ivrNumberslist,
      ),
    );
    _otpTimer = Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) async {
        final otpResponse =
            await getOTPFromCall(phoneNumber?.replaceAll('+', ''));
        if (otpResponse?.isSuccess ?? false) {
          timer?.cancel();
          if (isDialogOpen) {
            updateDialogStatus(true);
            Get.back();
          }
          onOtpReceived(otpResponse?.otpData?.otpCode ?? '');
          notifyListeners();
        }
      },
    );
  }

  void stopOTPTimer() {
    if (_otpTimer?.isActive ?? false) _otpTimer?.cancel();
  }

  Future<dynamic> getIVRNumbers() async {
    var ivrResponse = await _authService.getIVRNumbers();
    return ivrResponse;
  }

  Future<OtpResponseModel> getOTPFromCall(String phoneNumber) async {
    var otpResponse = await _authService.getOTPFromCall(phoneNumber);
    return otpResponse;
  }
}
