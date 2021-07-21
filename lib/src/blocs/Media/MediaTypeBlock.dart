import 'dart:async';

import '../../../common/PreferenceUtil.dart';
import '../Authentication/LoginBloc.dart';
import '../../model/Media/MediaTypeResponse.dart';
import '../../model/Media/media_data_list.dart';
import '../../resources/network/ApiResponse.dart';
import '../../resources/repository/Media/MediaTypeRepository.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/variable_constant.dart' as variable;
import '../../../constants/fhb_query.dart' as query;

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
      var mediaTypesResponse =
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
      await PreferenceUtil.saveMediaType(
          Constants.KEY_METADATA, mediaTypesResponse.result);
      mediaTypeSinks.add(ApiResponse.completed(mediaTypesResponse));
    } catch (e) {
      mediaTypeSinks.add(ApiResponse.error(e.toString()));
    }

    return mediaTypesResponse;
  }
}
