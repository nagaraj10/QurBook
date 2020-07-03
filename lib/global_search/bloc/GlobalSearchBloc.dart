import 'dart:async';

import 'package:myfhb/global_search/model/GlobalSearch.dart';
import 'package:myfhb/global_search/services/GlobalSearchRepository.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

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
    _globalSearchrepository = new GlobalSearchrepository();
  }

  @override
  void dispose() {
    _globalSearchController?.close();
  }

  searchBasedOnMediaType(String param) async {
    globalSearchSink.add(ApiResponse.loading('Searching'));
    try {
      GlobalSearch globalSearch =
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
