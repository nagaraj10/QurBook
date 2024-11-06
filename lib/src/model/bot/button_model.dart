
import 'package:myfhb/common/CommonUtil.dart';

class Buttons {
  String? payload;
  String? title;
  bool? isPlaying;
  bool? skipTTS;
  bool? isSelected;
  String? redirectTo;

  Buttons({
    this.payload,
    this.title,
    this.isPlaying,
    this.skipTTS,
    this.isSelected,
    this.redirectTo,
  });

  Buttons.fromJson(Map<String, dynamic> json) {
    try {
      payload = json['payload'];
      title = json['title'];
      skipTTS = json['skip_tts'] ?? false;
      isPlaying = false;
      isSelected = false;
      redirectTo = json['redirectTo'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['payload'] = payload;
    data['title'] = title;
    data['redirectTo'] = redirectTo;
    return data;
  }
}
