import 'package:myfhb/common/CommonConstants.dart';
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

  Future<Map<String, String>> getRequestHeadersForSearch() async {
    //String authToken ='Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJ1c2VySWQiOiI4NTg5MmYyZC04NDY3LTQyZTYtYTJkZC02NWYyNjI3ODBhMmIiLCJ1c2VyTmFtZSI6IisxNjE0MzAxMzkwNiJ9LCJpYXQiOjE2MDAxNTEzMTIsImV4cCI6MTYwMjc0MzMxMiwiaXNzIjoiRkhCIiwic3ViIjoiRkhCIn0.UISGi0e_Z7GfWY87IJ-YAchkkg-Fk4NXr63l06-SHWgP0GIj1jMIuesoLPkDPWLGQSw6Qmr62-nD-iKi2YV_Jz5AgoWTo9dBFSzFjRBVwXWKU0qn5uDZ_F-HeyiYylAklsRsLI0dm512y5H_sAn5M85O3h5T2dtBLZbYRzV7-HUDwjz_Ua9_0UvHdo0s9_gybEg8VgUvd2YfOYz3Y4OYKjaNVGsuqRf4-nm8BgU1mA0-VPw0EOOvhhOgjvlU1N5gy36IRrJfS-wpLtZF3rp3wFH68YNxa3ixe1BKS_uPHS4Mdvu0K731ewR7O3eycCYzMhHzgh4yRL1UWH8UxrVfxw';

    Map<String, String> requestHeadersAuthAccept = new Map();
    requestHeadersAuthAccept['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    return requestHeadersAuthAccept;
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

  Future<Map<String, String>> getRequestHeadersTimeSlotDumy() async {
    Map<String, String> requestHeadersTimeSlot = new Map();
    requestHeadersTimeSlot['Authorization'] =
        'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJpc09UUFZlcmlmaWVkIjp0cnVlLCJwcm92aWRlclBheWxvYWQiOnsiQWNjZXNzVG9rZW4iOiJleUpyYVdRaU9pSTBkbHBGWkVOaE5IRTNOeXRXY1c4NWFYSTFjVms0VUhCdU4wSnpWblEzVEVaRlozbExjbmhIUzJWdlBTSXNJbUZzWnlJNklsSlRNalUySW4wLmV5SnpkV0lpT2lJeU5qaGpNVGxqTWkxallqTTJMVFEyTWpNdFlqWmhZeTAyTUdVeVltRmxOekkyT1RjaUxDSmxkbVZ1ZEY5cFpDSTZJbVJrT0RjM1pURTJMV0U1TldZdE5EbGlOUzFoTXpRM0xUVXlOekF4TlRKbE5HRTBZaUlzSW5SdmEyVnVYM1Z6WlNJNkltRmpZMlZ6Y3lJc0luTmpiM0JsSWpvaVlYZHpMbU52WjI1cGRHOHVjMmxuYm1sdUxuVnpaWEl1WVdSdGFXNGlMQ0poZFhSb1gzUnBiV1VpT2pFMk1qWXhPRGMyTnpjc0ltbHpjeUk2SW1oMGRIQnpPbHd2WEM5amIyZHVhWFJ2TFdsa2NDNWhjQzF6YjNWMGFDMHhMbUZ0WVhwdmJtRjNjeTVqYjIxY0wyRndMWE52ZFhSb0xURmZVMmhIUkdoSmEyVnRJaXdpWlhod0lqb3hOakkyTVRreE1qYzNMQ0pwWVhRaU9qRTJNall4T0RjMk56Y3NJbXAwYVNJNkltWTJaV1V5T1RRNUxXRTFOMll0TkRNek5pMDVZVGxoTFRWaE1UUXdZV1l6WXpBeFlTSXNJbU5zYVdWdWRGOXBaQ0k2SWpaeWRqaGtkbVZ5TmpJNWJuQnpPR1ExWkhZemJEUm9aMlZ2SWl3aWRYTmxjbTVoYldVaU9pSXlOamhqTVRsak1pMWpZak0yTFRRMk1qTXRZalpoWXkwMk1HVXlZbUZsTnpJMk9UY2lmUS5GaC1DcncxemRJUGNaM1duY0MxeEJLWENubmFrRUo3Y1ZVOGhabmpYZlYzaFdGdkpfbzl2aHV0SVFpdmRXbUMzNm9JdEVkWjFaa0h5aVpFLVlSZ01Rc3FWUml1cUVtTUJWZy0xZllpcXdybmRRakFFZTYzczBzY1RaUVU1enhvbzdHcW9VNllkVDZHbFVkZ2ZtZ2xIWDNMNkNUSjIxYmlGSDNpSmhubUF4QjNnUGxLV0xSRkd6dTVucHZESkI0ZmU5cGY2bUhNSlJFTXFTUFpCbjM2Vlo1ZTBKS0NNcFlER0M3bmxiSENVS2otaTJZLUF2SmktQTZ3NkxVZzVMZF85RzVNUGoyOWNxdExYV3F5S0FvQTlzdG5EQWRsQVl4X3l0TU9MbEVHTFpzMlItQzFfY2s2aFFVXzdHUUNRQVJ5Sm1pTk9VNmJjRU9xOFk4RUNjUWRFLVEiLCJFeHBpcmVzSW4iOjM2MDAsIlRva2VuVHlwZSI6IkJlYXJlciIsIklkVG9rZW4iOiJleUpyYVdRaU9pSklSSGxUZFdNeU1qUkhSMFpoVGsxSVJpdDNaRWxrT1V0Q1REQndjVFJPV1hOaGVYSm1jMGg2T1hjMFBTSXNJbUZzWnlJNklsSlRNalUySW4wLmV5SnpkV0lpT2lJeU5qaGpNVGxqTWkxallqTTJMVFEyTWpNdFlqWmhZeTAyTUdVeVltRmxOekkyT1RjaUxDSmxiV0ZwYkY5MlpYSnBabWxsWkNJNlptRnNjMlVzSW1semN5STZJbWgwZEhCek9sd3ZYQzlqYjJkdWFYUnZMV2xrY0M1aGNDMXpiM1YwYUMweExtRnRZWHB2Ym1GM2N5NWpiMjFjTDJGd0xYTnZkWFJvTFRGZlUyaEhSR2hKYTJWdElpd2ljR2h2Ym1WZmJuVnRZbVZ5WDNabGNtbG1hV1ZrSWpwMGNuVmxMQ0pqYjJkdWFYUnZPblZ6WlhKdVlXMWxJam9pTWpZNFl6RTVZekl0WTJJek5pMDBOakl6TFdJMllXTXROakJsTW1KaFpUY3lOamszSWl3aVoybDJaVzVmYm1GdFpTSTZJa1JsYlc4aUxDSmhkV1FpT2lJMmNuWTRaSFpsY2pZeU9XNXdjemhrTldSMk0ydzBhR2RsYnlJc0ltVjJaVzUwWDJsa0lqb2laR1E0TnpkbE1UWXRZVGsxWmkwME9XSTFMV0V6TkRjdE5USTNNREUxTW1VMFlUUmlJaXdpZEc5clpXNWZkWE5sSWpvaWFXUWlMQ0poZFhSb1gzUnBiV1VpT2pFMk1qWXhPRGMyTnpjc0luQm9iMjVsWDI1MWJXSmxjaUk2SWlzNU1UazFNREEzT0RnMU5URWlMQ0psZUhBaU9qRTJNall4T1RFeU56Y3NJbWxoZENJNk1UWXlOakU0TnpZM055d2labUZ0YVd4NVgyNWhiV1VpT2lKVmMyVnlJaXdpWlcxaGFXd2lPaUprWldWd1lXc3Via0J4ZFhKb1pXRnNkR2d1YVc0aWZRLkpvczU5YU1Fd1RwY1pvcXA4SHE4cHdRbXhpY3FMYXpSMnJ3MG8xUDNfOGwxNmZfYWthYzlnSS1fV20xQWt5ckEzelM2LVNicGVwYTFZRXNmMC0zaUNQYzNQbEl0RXRhd1hjazdMOTEwWmxuYmVXdFp1MEpkdS1SMi1FWl9qV0VFZk9nTTNKQ1hCS2lURnNFQjNuYXY0V2w3NjFzV19oMFdHV1Btb2RhbWYycHVDVDU2NmJwZkxlNjM0WW1oVjhlNVZvU01WNnJfRnVUb3ZTX2FmbV9zajdzaFhzUFVVbl9ua0c5S2U2dzVvbGhGN3pzal9mNnFRNnNzdUlvX2wwQzM0bTN4aTZ5NTZfYUZIYzhMdEZBT2gyS3lYRGdORldCNWI2MWR5QmRuQ0lHRXpGYjdHQnZ0ZUJOYWFTLUFRRTE5eS11Q2pISlJaWU5RYXN4U0htYmJMdyJ9LCJ1c2VySWQiOiIyNjhjMTljMi1jYjM2LTQ2MjMtYjZhYy02MGUyYmFlNzI2OTciLCJ1c2VyTmFtZSI6Iis5MTk1MDA3ODg1NTEiLCJjb250ZXh0SWQiOiIiLCJoZWFsdGhPcmdhbml6YXRpb25JZCI6bnVsbCwiaGVhbHRoT3JnYW5pemF0aW9uTmFtZSI6bnVsbCwiaXNTeXN0ZW1BZG1pbiI6ZmFsc2UsImlzRG9jdG9yIjpmYWxzZSwiaXNQYXRpZW50Ijp0cnVlLCJjbGFpbXMiOnsic3ViamVjdHMiOlt7ImlkIjoiMjNmMWI1MzAtNjgyMy00MmFjLWJiMTItMmI0YWU0YzJiM2FlIiwibmFtZSI6IlBhdGllbnQiLCJyaWdodHMiOlsiQyIsIlIiLCJVIiwiRCJdfV19LCJpc1NraXBNRkEiOnRydWV9LCJpYXQiOjE2MjYxODc2NzcsImV4cCI6MTYyODc3OTY3NywiaXNzIjoiRkhCIiwic3ViIjoiRkhCIn0.bcWy7WNfHBC73OjJhJp9pNCAyXJjf9mXxNWiKqkg_y_Q8BtjfmV8-q1sOniQxmvs9GyMhvkRgI3d__ZMELYhLmeFjDKpVVCiRLoZTJD9aiQB19alLiv7t0van7x1CbIWm8-5xIzYI2sIXD1TkEtOg2UK-_9MNM0r57rR7QWvMUB0IK_N1LLf4-1HkhxDyEUB9fSp3bCgatn-FP7L4j7WR30yypdlNvkqBmH4W3dFb9VsJAlSW9a4YDxaabTApDhEzyFsFHydjy07kCqv7CVBP-i91H9limXrM6p5uGE3uoBxqLS8KlEzGt06mJNlnj3MUWCdFrQooJOh2QhrzePX5g';
    requestHeadersTimeSlot['Content-Type'] = 'application/json';
    return requestHeadersTimeSlot;
  }

  Future<Map<String, String>> getRequestHeadersAuthContent() async {
    Map<String, String> requestHeadersAuthContent = new Map();

    requestHeadersAuthContent['content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    return requestHeadersAuthContent;
  }

  Future<Map<String, String>> getRequestHeadersAuthContents() async {
    Map<String, String> requestHeadersAuthContent = new Map();
    requestHeadersAuthContent['Content-type'] = 'application/json';
    requestHeadersAuthContent['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    return requestHeadersAuthContent;
  }

  Future<Map<String, String>> getRequestHeader() async {
    Map<String, String> requestHeaders = new Map();

    requestHeaders['Content-type'] = 'application/json';
    requestHeaders['accept'] = 'application/json';

    requestHeaders['Authorization'] =
        PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    /*var token = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
        printWrapped(token);*/

    return requestHeaders;
  }

  Future<Map<String, String>> getRequestHeadersAuthAccept() async {
    Map<String, String> requestHeadersAuthAccept = new Map();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['Authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    printWrapped(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));

    return requestHeadersAuthAccept;
  }

  Future<Map<String, String>> getRequestHeadersAuthAcceptNew() async {
    String authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    Map<String, String> requestHeadersAuthAccept = new Map();
    requestHeadersAuthAccept['accept'] = 'application/json';
    requestHeadersAuthAccept['authorization'] = authToken;
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
    auth['authorization'] =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    print(PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN));
    return auth;
  }
}
