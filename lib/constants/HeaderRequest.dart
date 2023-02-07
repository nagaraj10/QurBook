import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../common/CommonConstants.dart';
import '../common/PreferenceUtil.dart';
import 'fhb_constants.dart' as Constants;
import 'fhb_constants.dart';

class HeaderRequest {
  Future<Map<String, String>> getAuth() async {
    var auth = Map<String, String>();
    auth['authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    auth[Constants.KEY_OffSet] = CommonUtil().setTimeZone();
    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
    return auth;
  }

  Future<Map<String, String>> getRequesHeaderWithoutToken() async {
    final Map<String, String> requestHeadersWithoutToken = {};

    requestHeadersWithoutToken['Content-type'] = 'application/json';
    requestHeadersWithoutToken['Accept'] = 'application/json';
    requestHeadersWithoutToken[Constants.KEY_OffSet] =
        CommonUtil().setTimeZone();
    return requestHeadersWithoutToken;
  }

  Future<Map<String, String>> getRequestHeadersForSearch() async {
    //String authToken ='Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJ1c2VySWQiOiI4NTg5MmYyZC04NDY3LTQyZTYtYTJkZC02NWYyNjI3ODBhMmIiLCJ1c2VyTmFtZSI6IisxNjE0MzAxMzkwNiJ9LCJpYXQiOjE2MDAxNTEzMTIsImV4cCI6MTYwMjc0MzMxMiwiaXNzIjoiRkhCIiwic3ViIjoiRkhCIn0.UISGi0e_Z7GfWY87IJ-YAchkkg-Fk4NXr63l06-SHWgP0GIj1jMIuesoLPkDPWLGQSw6Qmr62-nD-iKi2YV_Jz5AgoWTo9dBFSzFjRBVwXWKU0qn5uDZ_F-HeyiYylAklsRsLI0dm512y5H_sAn5M85O3h5T2dtBLZbYRzV7-HUDwjz_Ua9_0UvHdo0s9_gybEg8VgUvd2YfOYz3Y4OYKjaNVGsuqRf4-nm8BgU1mA0-VPw0EOOvhhOgjvlU1N5gy36IRrJfS-wpLtZF3rp3wFH68YNxa3ixe1BKS_uPHS4Mdvu0K731ewR7O3eycCYzMhHzgh4yRL1UWH8UxrVfxw';

    var requestHeadersAuthAccept = Map<String, String>();
    requestHeadersAuthAccept['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthAccept[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    return requestHeadersAuthAccept;
  }

  Future<Map<String, String>> getRequestHeaderWithStar() async {
    var requestHeadersAuthStar = Map<String, String>();
    requestHeadersAuthStar['accept'] = '*/*';
    requestHeadersAuthStar['authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthStar[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    return requestHeadersAuthStar;
  }

  Future<Map<String, String>> getRequestHeadersWithoutOffset() async {
    final Map<String, String> requestHeadersTimeSlot = {};
    requestHeadersTimeSlot['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersTimeSlot['Content-Type'] = 'application/json';
    return requestHeadersTimeSlot;
  }

  Future<Map<String, String>> getRequestHeadersTimeSlot() async {
    final Map<String, String> requestHeadersTimeSlot = {};
    requestHeadersTimeSlot['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersTimeSlot['Content-Type'] = 'application/json';
    requestHeadersTimeSlot[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    return requestHeadersTimeSlot;
  }

  Future<Map<String, String>> getRequestHeadersAuthContent() async {
    final requestHeadersAuthContent = Map<String, String>();

    requestHeadersAuthContent['content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthContent[Constants.KEY_OffSet] =
        CommonUtil().setTimeZone();

    return requestHeadersAuthContent;
  }

  Future<Map<String, String>> getRequestHeadersAuthContents() async {
    final Map<String, String> requestHeadersAuthContent = {};
    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthContent[Constants.KEY_OffSet] =
        CommonUtil().setTimeZone();

    return requestHeadersAuthContent;
  }

  Future<Map<String, String>> getRequestHeader() async {
    var requestHeaders = Map<String, String>();

    requestHeaders['Content-type'] = 'application/json';
    requestHeaders['accept'] = 'application/json';

    requestHeaders['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    /*var token = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
        printWrapped(token);*/
    requestHeaders[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    return requestHeaders;
  }

  Future<Map<String, String>> getRequestHeadersAuthAccept() async {
    final requestHeadersAuthAccept = Map<String, String>();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthAccept[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));

    return requestHeadersAuthAccept;
  }

  Future<Map<String, String>> getRequestHeadersAuthAcceptNew() async {
    final authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    var requestHeadersAuthAccept = Map<String, String>();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['authorization'] = authToken;
    requestHeadersAuthAccept[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    return requestHeadersAuthAccept;
  }

  Future<Map<String, String>> getRequestHeadersForProvider() async {
    final requestHeadersAuthContent = Map<String, String>();

    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    requestHeadersAuthContent['accept'] = 'multipart/form-data';
    requestHeadersAuthContent[Constants.KEY_OffSet] =
        CommonUtil().setTimeZone();

    return requestHeadersAuthContent;
  }

  void printWrapped(String text) {
    var pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<Map<String, String>> getAuths() async {
    final Map<String, String> auth = {};
    auth['authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    auth[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
    return auth;
  }

  getAuthsClaimList() {
    final Map<String, String> auth = {};
    auth['authorization'] =
        '$strBearer ${PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)}';
    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
    return auth;
  }

  Future<Map<String, String>> getRequestHeadersTimeSlotWithUserId() async {
    final Map<String, String> requestHeadersTimeSlot = {};
    requestHeadersTimeSlot['Authorization'] =
        '$strBearer ${PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)}';
    requestHeadersTimeSlot['userid'] =
        '${PreferenceUtil.getStringValue(KEY_USERID)}';
    requestHeadersTimeSlot['Content-Type'] = 'application/json';
    requestHeadersTimeSlot[Constants.KEY_OffSet] = CommonUtil().setTimeZone();

    return requestHeadersTimeSlot;
  }
}
