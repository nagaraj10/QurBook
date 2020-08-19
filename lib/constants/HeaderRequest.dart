import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class HeaderRequest {
  Future<Map<String, String>> getAuth() async {
    Map<String, String> auth = new Map();
    auth['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    return auth;
  }

  Future<Map<String, String>> getRequesHeaderWithoutToken() async {
    Map<String, String> requestHeadersWithoutToken = new Map();

    requestHeadersWithoutToken['Content-type'] = 'application/json';
    requestHeadersWithoutToken['Accept'] = 'application/json';

    return requestHeadersWithoutToken;
  }

  Future<Map<String, String>> getRequestHeaderWithStar() async {
    Map<String, String> requestHeadersAuthStar = new Map();
    requestHeadersAuthStar['accept'] = '*/*';
    requestHeadersAuthStar['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    return requestHeadersAuthStar;
  }

  Future<Map<String, String>> getRequestHeadersTimeSlot() async {
    Map<String, String> requestHeadersTimeSlot = new Map();

    requestHeadersTimeSlot['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersTimeSlot['Content-Type'] = 'application/json';
    return requestHeadersTimeSlot;
  }

  Future<Map<String, String>> getRequestHeadersAuthContent() async {
    Map<String, String> requestHeadersAuthContent = new Map();

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    return requestHeadersAuthContent;
  }

  Future<Map<String, String>> getRequestHeader() async {
    Map<String, String> requestHeaders = new Map();

    requestHeaders['Content-type'] = 'application/json';
    requestHeaders['accept'] = 'application/json';

    requestHeaders['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    return requestHeaders;
  }

  Future<Map<String, String>> getRequestHeadersAuthAccept() async {
    Map<String, String> requestHeadersAuthAccept = new Map();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    //print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));

    return requestHeadersAuthAccept;
  }

  Future<Map<String, String>> getRequestHeadersForProvider() async {
    Map<String, String> requestHeadersAuthContent = new Map();

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthContent['accept'] = 'multipart/form-data';

    return requestHeadersAuthContent;
  }
}
