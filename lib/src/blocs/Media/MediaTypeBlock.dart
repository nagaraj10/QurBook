import 'dart:async';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/model/Media/media_data_list.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/resources/repository/Media/MediaTypeRepository.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_query.dart' as query;

class MediaTypeBlock implements BaseBloc {
  MediaTypeRepository _mediaTypeRepository;
  StreamController _mediaTypeControlller;
  StreamController _mediaTypeControlllers;

  StreamSink<ApiResponse<MediaTypesResponse>> get mediaTypeSink =>
      _mediaTypeControlller.sink;
  Stream<ApiResponse<MediaTypesResponse>> get mediaTypeStream =>
      _mediaTypeControlller.stream;

  StreamSink<ApiResponse<MediaDataList>> get mediaTypeSinks =>
      _mediaTypeControlllers.sink;
  Stream<ApiResponse<MediaDataList>> get mediaTypeStreams =>
      _mediaTypeControlllers.stream;

  @override
  void dispose() {
    _mediaTypeControlller?.close();
    _mediaTypeControlllers?.close();
  }

  MediaTypeBlock() {
    _mediaTypeControlller = StreamController<ApiResponse<MediaTypesResponse>>();
    _mediaTypeControlllers = StreamController<ApiResponse<MediaDataList>>();

    _mediaTypeRepository = MediaTypeRepository();
  }

  getMediTypes() async {
    mediaTypeSink.add(ApiResponse.loading(variable.strgetMediaTypes));
    try {
      MediaTypesResponse mediaTypesResponse =
          await _mediaTypeRepository.getMediaType();

      PreferenceUtil.init();
      //PreferenceUtil.saveMediaType(Constants.KEY_METADATA, mediaTypesResponse.response.data);
      mediaTypeSink.add(ApiResponse.completed(mediaTypesResponse));
    } catch (e) {
      mediaTypeSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<MediaDataList> getMediTypesList() async {
    MediaDataList mediaTypesResponse;
    mediaTypeSinks.add(ApiResponse.loading(variable.strgetMediaTypes));
    try {
      mediaTypesResponse = await _mediaTypeRepository.getMediaTypes();

      PreferenceUtil.init();
      PreferenceUtil.saveMediaType(
          Constants.KEY_METADATA, mediaTypesResponse.result);
      mediaTypeSinks.add(ApiResponse.completed(mediaTypesResponse));
    } catch (e) {
      mediaTypeSinks.add(ApiResponse.error(e.toString()));
    }

    return mediaTypesResponse;
  }
}
