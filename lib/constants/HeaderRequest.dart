import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class HeaderRequest {
  Future<Map<String, String>> getAuth() async {
    Map<String, String> auth = new Map();
    auth['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
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
    requestHeadersAuthStar['authorization'] =
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
    requestHeadersAuthContent['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    return requestHeadersAuthContent;
  }

  Future<Map<String, String>> getRequestHeadersAuthContents() async {
    Map<String, String> requestHeadersAuthContent = new Map();
    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJ1c2VySWQiOiI4NTg5MmYyZC04NDY3LTQyZTYtYTJkZC02NWYyNjI3ODBhMmIiLCJ1c2VyTmFtZSI6IisxNjE0MzAxMzkwNiJ9LCJpYXQiOjE2MDAxNTEzMTIsImV4cCI6MTYwMjc0MzMxMiwiaXNzIjoiRkhCIiwic3ViIjoiRkhCIn0.UISGi0e_Z7GfWY87IJ-YAchkkg-Fk4NXr63l06-SHWgP0GIj1jMIuesoLPkDPWLGQSw6Qmr62-nD-iKi2YV_Jz5AgoWTo9dBFSzFjRBVwXWKU0qn5uDZ_F-HeyiYylAklsRsLI0dm512y5H_sAn5M85O3h5T2dtBLZbYRzV7-HUDwjz_Ua9_0UvHdo0s9_gybEg8VgUvd2YfOYz3Y4OYKjaNVGsuqRf4-nm8BgU1mA0-VPw0EOOvhhOgjvlU1N5gy36IRrJfS-wpLtZF3rp3wFH68YNxa3ixe1BKS_uPHS4Mdvu0K731ewR7O3eycCYzMhHzgh4yRL1UWH8UxrVfxw';

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

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<Map<String, String>> getAuths() async {
    Map<String, String> auth = new Map();
    auth['authorization'] = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJ1c2VySWQiOiI4NTg5MmYyZC04NDY3LTQyZTYtYTJkZC02NWYyNjI3ODBhMmIiLCJ1c2VyTmFtZSI6IisxNjE0MzAxMzkwNiJ9LCJpYXQiOjE2MDAxNTEzMTIsImV4cCI6MTYwMjc0MzMxMiwiaXNzIjoiRkhCIiwic3ViIjoiRkhCIn0.UISGi0e_Z7GfWY87IJ-YAchkkg-Fk4NXr63l06-SHWgP0GIj1jMIuesoLPkDPWLGQSw6Qmr62-nD-iKi2YV_Jz5AgoWTo9dBFSzFjRBVwXWKU0qn5uDZ_F-HeyiYylAklsRsLI0dm512y5H_sAn5M85O3h5T2dtBLZbYRzV7-HUDwjz_Ua9_0UvHdo0s9_gybEg8VgUvd2YfOYz3Y4OYKjaNVGsuqRf4-nm8BgU1mA0-VPw0EOOvhhOgjvlU1N5gy36IRrJfS-wpLtZF3rp3wFH68YNxa3ixe1BKS_uPHS4Mdvu0K731ewR7O3eycCYzMhHzgh4yRL1UWH8UxrVfxw';


    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
    return auth;
  }
}
