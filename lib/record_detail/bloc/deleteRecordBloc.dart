import 'dart:async';
import 'package:myfhb/record_detail/model/deleteRecord.dart';
import 'package:myfhb/record_detail/model/deleteRecordResponse.dart';
import 'package:myfhb/record_detail/services/deleteRecordRepository.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

import 'package:myfhb/src/utils/Validators.dart';
import 'dart:convert' as convert;

class DeleteRecordBloc with Validators implements BaseBloc {
  DeleteRecordRepository _deleteRecordRepository;
  StreamController _deleteRecordController;
  StreamSink<ApiResponse<DeleteRecordResponse>> get delteRecordSink =>
      _deleteRecordController.sink;
  Stream<ApiResponse<DeleteRecordResponse>> get deleteRecordStream =>
      _deleteRecordController.stream;

  DeleteRecordBloc() {
    _deleteRecordController =
        StreamController<ApiResponse<DeleteRecordResponse>>();
    _deleteRecordRepository = DeleteRecordRepository();
  }

  @override
  void dispose() {
    _deleteRecordController?.close();
  }

  Future<DeleteRecordResponse> deleteRecord(List<String> recordId) async {
    DeleteRecord deleteRecord = new DeleteRecord();
    deleteRecord.mediaMetaIds = recordId;

    var jsonString = convert.jsonEncode(deleteRecord);
    delteRecordSink.add(ApiResponse.loading('deleting record'));
    DeleteRecordResponse deleteRecordResponse;
    try {
      deleteRecordResponse =
          await _deleteRecordRepository.deleteRecordForIds(jsonString);
    } catch (e) {
      delteRecordSink.add(ApiResponse.error(e.toString()));
    }
    return deleteRecordResponse;
  }

  Future<DeleteRecordResponse> deleteRecordOnMediaMasterID(
      List<String> recordId) async {
    DeleteRecord deleteRecord = new DeleteRecord();
    deleteRecord.mediaMasterIds = recordId;

    var jsonString = convert.jsonEncode(deleteRecord);
    delteRecordSink.add(ApiResponse.loading('deleting record'));
    DeleteRecordResponse deleteRecordResponse;
    try {
      deleteRecordResponse = await _deleteRecordRepository
          .deleteRecordForMediaMasterIds(jsonString);
    } catch (e) {
      delteRecordSink.add(ApiResponse.error(e.toString()));
    }
    return deleteRecordResponse;
  }
}

abstract class BaseBloc {
  void dispose();
}
