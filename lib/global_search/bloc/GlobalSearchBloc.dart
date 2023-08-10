import 'dart:async';

import 'package:myfhb/common/CommonUtil.dart';

import '../model/GlobalSearch.dart';
import '../services/GlobalSearchRepository.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../constants/variable_constant.dart' as variable;

class GlobalSearchBloc implements BaseBloc {
  late GlobalSearchrepository _globalSearchrepository;

  // 1
  StreamController? _globalSearchController;

  StreamSink<ApiResponse<GlobalSearch>> get globalSearchSink =>
      _globalSearchController!.sink as StreamSink<ApiResponse<GlobalSearch>>;
  Stream<ApiResponse<GlobalSearch>> get globalSearchStream =>
      _globalSearchController!.stream as Stream<ApiResponse<GlobalSearch>>;

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
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      globalSearchSink.add(ApiResponse.error(e.toString()));
    }
  }
}

abstract class BaseBloc {
  void dispose();
}
