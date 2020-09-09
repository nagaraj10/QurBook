import 'dart:async';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class ProvidersBloc implements BaseBloc {
  ProvidersListRepository _providersListRepository;
  StreamController _providersListControlller;

  StreamSink<ApiResponse<MyProvidersResponseList>> get providersListSink =>
      _providersListControlller.sink;
  Stream<ApiResponse<MyProvidersResponseList>> get providersListStream =>
      _providersListControlller.stream;

  @override
  void dispose() {
    _providersListControlller?.close();
  }

  ProvidersBloc() {
    _providersListControlller =
        StreamController<ApiResponse<MyProvidersResponseList>>();
    _providersListRepository = ProvidersListRepository();
  }

  Future<MyProvidersResponseList> getMedicalPreferencesList() async {
    providersListSink
        .add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponseList myProvidersResponseList;
    try {
      myProvidersResponseList =
          await _providersListRepository.getMedicalPreferencesList();
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }
}
