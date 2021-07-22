import 'dart:async';

import '../model/GlobalSearch.dart';
import '../services/GlobalSearchRepository.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../constants/variable_constant.dart' as variable;

class GlobalSearchBloc implements BaseBloc {
  GlobalSearchrepository _globalSearchrepository;

  // 1
  StreamController _globalSearchController;

  StreamSink<ApiResponse<GlobalSearch>> get globalSearchSink =>
      _globalSearchController.sink;
  Stream<ApiResponse<GlobalSearch>> get globalSearchStream =>
      _globalSearchController.stream;

  GlobalSearchBloc() {
    _globalSearchController = StreamController<ApiResponse<GlobalSearch>>();
    _globalSearchrepository = GlobalSearchrepository();
  }

  @override
  void dispose() {
    _globalSearchController?.close();
  }

  searchBasedOnMediaType(String param) async {
    globalSearchSink.add(ApiResponse.loading(variable.strSearching));
    try {
      var globalSearch =
          await _globalSearchrepository.getSearchedMediaType(param);
      globalSearchSink.add(ApiResponse.completed(globalSearch));
    } catch (e) {
      globalSearchSink.add(ApiResponse.error(e.toString()));
    }
  }
}

abstract class BaseBloc {
  void dispose();
}
