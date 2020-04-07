import 'dart:async';

import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Family/FamilyMembersResponse.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/Family/FamilyMemberListRepository.dart';

class FamilyListBloc implements BaseBloc {
  FamilyMemberListRepository _familyResponseListRepository;
  StreamController _familyListControlller;

  StreamSink<ApiResponse<FamilyMembersList>> get familyMemberListSink =>
      _familyListControlller.sink;
  Stream<ApiResponse<FamilyMembersList>> get familyMemberListStream =>
      _familyListControlller.stream;

  @override
  void dispose() {
    _familyListControlller?.close();
  }

  FamilyListBloc() {
    _familyListControlller = StreamController<ApiResponse<FamilyMembersList>>();
    _familyResponseListRepository = FamilyMemberListRepository();
  }

  getFamilyMembersList() async {
    familyMemberListSink.add(ApiResponse.loading('Fetching family details'));
    try {
      FamilyMembersList familyResponseList =
          await _familyResponseListRepository.getFamilyMembersList();
      familyMemberListSink.add(ApiResponse.completed(familyResponseList));
    } catch (e) {
      familyMemberListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
}
