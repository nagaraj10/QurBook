import 'dart:async';

import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResponse.dart';
import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResult.dart';
import 'package:myfhb/claim/service/ClaimListRepository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class ClaimListBloc implements BaseBloc {
  StreamController? _claimExpiryListControlller;

  late ClaimListRepository claimLosRepository;
  StreamSink<ApiResponse<ClaimExpiryResponse>> get claimExpiryListSink =>
      _claimExpiryListControlller!.sink
          as StreamSink<ApiResponse<ClaimExpiryResponse>>;
  Stream<ApiResponse<ClaimExpiryResponse>> get claimExpiryListStream =>
      _claimExpiryListControlller!.stream
          as Stream<ApiResponse<ClaimExpiryResponse>>;

  List<ClaimExpiryResult>? claimExpiryResult;
  @override
  void dispose() {
    _claimExpiryListControlller?.close();
  }

  ClaimListBloc() {
    _claimExpiryListControlller =
        StreamController<ApiResponse<ClaimExpiryResponse>>();
    claimLosRepository = ClaimListRepository();
  }

  Future<ClaimExpiryResponse?> getExpiryListResponse() async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    ClaimExpiryResponse? claimExpiryResponse;
    try {
      claimExpiryResponse =
          await claimLosRepository.getClaimExpiryResponseList();
      claimExpiryResult = claimExpiryResponse.result;
      // hospitals = myProvidersResponseList.result.hospitals;
      // labs = myProvidersResponseList.result.labs;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
      claimExpiryListSink.add(ApiResponse.error(e.toString()));
    }

    return claimExpiryResponse;
  }
}
