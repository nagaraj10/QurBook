import 'dart:async';

import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/Media/MediaTypeRepository.dart';

class MediaTypeBlock implements BaseBloc {
  MediaTypeRepository _mediaTypeRepository;
  StreamController _mediaTypeControlller;

  StreamSink<ApiResponse<MediaTypesResponse>> get mediaTypeSink =>
      _mediaTypeControlller.sink;
  Stream<ApiResponse<MediaTypesResponse>> get mediaTypeStream =>
      _mediaTypeControlller.stream;

  @override
  void dispose() {
    _mediaTypeControlller?.close();
  }

  MediaTypeBlock() {
    _mediaTypeControlller = StreamController<ApiResponse<MediaTypesResponse>>();

    _mediaTypeRepository = MediaTypeRepository();
  }

  getMediTypes() async {
    mediaTypeSink.add(ApiResponse.loading('Signing in user'));
    try {
      MediaTypesResponse mediaTypesResponse =
          await _mediaTypeRepository.getMediaType();
      mediaTypeSink.add(ApiResponse.completed(mediaTypesResponse));
    } catch (e) {
      mediaTypeSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
}
