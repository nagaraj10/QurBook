import 'dart:async';

import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Family/FamilyMembersResponse.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/Providers/providers_repository.dart';

class ProvidersBloc implements BaseBloc {
  ProvidersListRepository _providersListRepository;
  StreamController _providersListControlller;

  StreamSink<ApiResponse<FamilyMembersList>> get providersListSink =>
      _providersListControlller.sink;
  Stream<ApiResponse<FamilyMembersList>> get providersListStream =>
      _providersListControlller.stream;

  @override
  void dispose() {
    _providersListControlller?.close();
  }

  ProvidersBloc() {
    _providersListControlller =
        StreamController<ApiResponse<FamilyMembersList>>();
    _providersListRepository = ProvidersListRepository();
  }

  getFamilyMembersList() async {
    providersListSink.add(ApiResponse.loading('Signing in user'));
    try {
      FamilyMembersList familyResponseList =
          await _providersListRepository.getFamilyMembersList();
      providersListSink.add(ApiResponse.completed(familyResponseList));
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
}
