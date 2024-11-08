
import 'dart:async';
import 'package:myfhb/common/CommonUtil.dart';

import '../model/deleteRecord.dart';
import '../model/deleteRecordResponse.dart';
import '../services/deleteRecordRepository.dart';
import '../../src/resources/network/ApiResponse.dart';

import '../../src/utils/Validators.dart';
import 'dart:convert' as convert;

import '../../constants/variable_constant.dart' as variable;

class DeleteRecordBloc with Validators implements BaseBloc {
  late DeleteRecordRepository _deleteRecordRepository;
  StreamController? _deleteRecordController;
  StreamSink<ApiResponse<DeleteRecordResponse>> get delteRecordSink =>
      _deleteRecordController!.sink as StreamSink<ApiResponse<DeleteRecordResponse>>;
  Stream<ApiResponse<DeleteRecordResponse>> get deleteRecordStream =>
      _deleteRecordController!.stream as Stream<ApiResponse<DeleteRecordResponse>>;

  DeleteRecordBloc() {
    _deleteRecordController =
        StreamController<ApiResponse<DeleteRecordResponse>>();
    _deleteRecordRepository = DeleteRecordRepository();
  }

  @override
  void dispose() {
    _deleteRecordController?.close();
  }

  Future<DeleteRecordResponse?> deleteRecord(String metaId) async {
    delteRecordSink.add(ApiResponse.loading(variable.strDeletingRecords));
    DeleteRecordResponse? deleteRecordResponse;
    try {
      deleteRecordResponse =
          await _deleteRecordRepository.deleteRecordForIds(metaId);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      delteRecordSink.add(ApiResponse.error(e.toString()));
    }
    return deleteRecordResponse;
  }

  Future<DeleteRecordResponse?> deleteRecordOnMediaMasterID(
      String metaId) async {
    final deleteRecord = DeleteRecord();

    delteRecordSink.add(ApiResponse.loading(variable.strDeletingRecords));
    DeleteRecordResponse? deleteRecordResponse;
    try {
      deleteRecordResponse =
          await _deleteRecordRepository.deleteRecordForMediaMasterIds(metaId);
    } catch (e,stackTrace) {
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      delteRecordSink.add(ApiResponse.error(e.toString()));
    }
    return deleteRecordResponse;
  }
}

abstract class BaseBloc {
  void dispose();
}
