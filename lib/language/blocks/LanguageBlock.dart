import 'dart:async';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/language/model/Language.dart';
import 'package:myfhb/language/repository/LanguageRepository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class LanguageBlock implements BaseBloc {
  LanguageRepository _languageResponseListRepository;
  StreamController _languageControlllers;

  StreamSink<ApiResponse<LanguageModel>> get categoryListSinks =>
      _languageControlllers.sink;
  Stream<ApiResponse<LanguageModel>> get categoryListStreams =>
      _languageControlllers.stream;

  @override
  void dispose() {
    _languageControlllers?.close();
  }

  LanguageBlock() {
    _languageControlllers = StreamController<ApiResponse<LanguageModel>>();

    _languageResponseListRepository = LanguageRepository();
  }

  Future<LanguageModel> getLanguageList() async {
    LanguageModel languageModelList;
    categoryListSinks.add(ApiResponse.loading(variable.strGettingCategory));
    try {
      languageModelList = await _languageResponseListRepository.getLanguage();

      PreferenceUtil.saveLanguageList(
          Constants.KEY_LANGUAGE, languageModelList.result);

      categoryListSinks.add(ApiResponse.completed(languageModelList));
    } catch (e) {
      categoryListSinks.add(ApiResponse.error(e.toString()));
    }
    return languageModelList;
  }
}
