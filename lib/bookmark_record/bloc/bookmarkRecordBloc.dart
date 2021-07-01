import 'dart:async';
import '../model/bookmarkRequest.dart';
import '../model/bookmarkResponse.dart';
import '../services/bookmark_repository.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/Validators.dart';
import 'dart:convert' as convert;
import '../../constants/variable_constant.dart' as variable;

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
    var bookmarkRequest = Map<String, dynamic>();

    //BookmarkRequest bookmarkRequest = new BookmarkRequest();
    bookmarkRequest['healthRecordMetaIds'] = recordId;
    bookmarkRequest['isBookmarked'] = bookMarkFlag;

    final jsonString = convert.jsonEncode(bookmarkRequest);
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
