
import 'package:myfhb/common/CommonUtil.dart';

import '../../../../constants/fhb_parameters.dart';

class GoogleTTSRequestModel {
  InputTTS? input;
  Voice? voice;
  AudioConfig? audioConfig;
  bool? isAudioFile = false;

  GoogleTTSRequestModel({
    this.input,
    this.voice,
    this.audioConfig,
    this.isAudioFile,
  });
  GoogleTTSRequestModel.fromJson(Map<String, dynamic> json) {
    try {
      input = (json[strinput] ?? '').isEmpty
              ? InputTTS.fromJson({})
              : InputTTS.fromJson(json[strinput]);
      voice = (json[strvoice] ?? '').isEmpty
              ? Voice()
              : Voice.fromJson(json[strvoice]);
      audioConfig = (json[straudioConfig] ?? '').isEmpty
              ? AudioConfig()
              : AudioConfig.fromJson(json[straudioConfig]);
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[strinput] = input!.toJson();
    data[strvoice] = voice!.toJson();
    data[straudioConfig] = audioConfig!.toJson();
    data[strisAudioFile] = isAudioFile;
    return data;
  }
}

class InputTTS {
  String? text;

  InputTTS({this.text});

  InputTTS.fromJson(Map<String, dynamic> json) {
    try {
      text = json[strtext] ?? '';
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[strtext] = text;
    return data;
  }
}

class Voice {
  String? languageCode;
  String ssmlGenderType = Female;
  Voice({this.languageCode});
  Voice.fromJson(Map<String, dynamic> json) {
    try {
      languageCode = json[strlanguageCode];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    //languageCode get from API response
    languageCode = (languageCode ?? 'en');
    data[strlanguageCode] = languageCode;
    data[ssmlGender] = ssmlGenderType;
    return data;
  }
}

class AudioConfig {
  String? audioEncodingType;
  AudioConfig({this.audioEncodingType = strMP3});
  AudioConfig.fromJson(Map<String, dynamic> json) {
    try {
      audioEncodingType = json[audioEncoding];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[audioEncoding] = audioEncodingType;
    return data;
  }
}
