import 'dart:async';

import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class ProvidersBloc implements BaseBloc {
  ProvidersListRepository _providersListRepository;
  StreamController _providersListControlller;

  StreamSink<ApiResponse<MyProvidersResponse>> get providersListSink =>
      _providersListControlller.sink;
  Stream<ApiResponse<MyProvidersResponse>> get providersListStream =>
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

  Future<MyProvidersResponse> getMedicalPreferencesList() async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList =
          await _providersListRepository.getMedicalPreferencesList();
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }
}
