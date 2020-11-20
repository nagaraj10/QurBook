import 'dart:async';
import 'package:myfhb/bookmark_record/model/bookmarkRequest.dart';
import 'package:myfhb/bookmark_record/model/bookmarkResponse.dart';
import 'package:myfhb/bookmark_record/services/bookmark_repository.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/Validators.dart';
import 'dart:convert' as convert;
import 'package:myfhb/constants/variable_constant.dart' as variable;

class BookmarkRecordBloc with Validators implements BaseBloc {
  BookmarkRepository _bookmarkRepository;
  StreamController _bookmarkController;
  StreamSink<ApiResponse<BookmarkResponse>> get bookmarkSink =>
      _bookmarkController.sink;
  Stream<ApiResponse<BookmarkResponse>> get bookmarkStream =>
      _bookmarkController.stream;

  BookmarkRecordBloc() {
    _bookmarkController = StreamController<ApiResponse<BookmarkResponse>>();
    _bookmarkRepository = BookmarkRepository();
  }

  @override
  void dispose() {
    _bookmarkController?.close();
  }

  Future<BookmarkResponse> bookMarcRecord(
      List<String> recordId, bool bookMarkFlag) async {
    Map<String, dynamic> bookmarkRequest = new Map();

    //BookmarkRequest bookmarkRequest = new BookmarkRequest();
    bookmarkRequest['healthRecordMetaIds'] = recordId;
    bookmarkRequest['isBookmarked'] = bookMarkFlag;

    var jsonString = convert.jsonEncode(bookmarkRequest);
    bookmarkSink.add(ApiResponse.loading(variable.strBookmarkRecord));
    BookmarkResponse bookmarkResponse;
    try {
      bookmarkResponse =
          await _bookmarkRepository.bookmarkRecordForIds(jsonString);
    } catch (e) {
      bookmarkSink.add(ApiResponse.error(e.toString()));
    }
    return bookmarkResponse;
  }
}

abstract class BaseBloc {
  void dispose();
}
