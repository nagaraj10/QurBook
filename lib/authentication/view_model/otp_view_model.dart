import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:myfhb/authentication/service/authservice.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/view/confirm_via_call_widget.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:mobile_number/mobile_number.dart';

class OtpViewModel extends ChangeNotifier {
  String timeForResend = '00:30';
  int timerSeconds = 30;
  Timer _timer;

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

  void confirmViaCall(String PhoneNumber) async {
    print(PhoneNumber);
    LoaderClass.showLoadingDialog(Get.context, canDismiss: false);
    List<dynamic> ivrNumberslist = await getIVRNumbers();
    print(ivrNumberslist);
    if (Platform.isAndroid) {
      bool hasPermission = await MobileNumber.hasPhonePermission;
      if (!hasPermission) {
        LoaderClass.hideLoadingDialog(Get.context);
        await MobileNumber.requestPhonePermission;
      } else {
        final List<SimCard> simCards = await MobileNumber.getSimCards;
        simCards?.forEach((simCard) { simCard });
        print(simCards);
        LoaderClass.hideLoadingDialog(Get.context);
        Get.dialog(
          ConfirmViaCallWidget(
            ivrNumbersList: ivrNumberslist,
          ),
        );
      }
    }
  }

  Future<dynamic> getIVRNumbers() async {
    final AuthService _authService = AuthService();
    var otpResponse = await _authService.getIVRNumbers();
    return otpResponse;
  }
}
