import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/resources/network/AppException.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleModel.dart';

class ResheduleAppointmentsService {
  final String _baseUrl = Constants.BASE_URL;
  String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

  HeaderRequest headerRequest = new HeaderRequest();

  Future<ResheduleModel> resheduleAppointment(List<String> doctorIds,
      String slotNumber, String resheduleDate, String doctorSessionId) async {
    var inputBody = {};
    inputBody[BOOKING_IDS] = doctorIds;
    inputBody[RESHEDULED_DATE] = resheduleDate;
    inputBody[SLOTMUNBER] = slotNumber;
    inputBody[RESHEDULE_SOURCE] = PATIENT;
    inputBody[DOCTOR_SESSION_ID] = doctorSessionId;
    var jsonString = convert.jsonEncode(inputBody);
    final response = await getApiForresheduleAppointment(
        qr_appoinment_reshedule, jsonString);
    return ResheduleModel.fromJson(response);
  }

  Future<dynamic> getApiForresheduleAppointment(
      String url, String jsonBody) async {
//    Map<String, String> requestHeadersAuthContent = new Map();
//
//    requestHeadersAuthContent['Content-type'] = 'application/json';
//    requestHeadersAuthContent['authorization'] =
//    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6eyJpc09UUFZlcmlmaWVkIjp0cnVlLCJwcm92aWRlclBheWxvYWQiOnsiQWNjZXNzVG9rZW4iOiJleUpyYVdRaU9pSnJablZGWnpsY0wwMU5hM3ByUVhBeFJsd3ZaV2ROZDA4MGVFeFlhR3RaWjA5YVltUkNORXQ2UVhaeWJWazlJaXdpWVd4bklqb2lVbE15TlRZaWZRLmV5SnpkV0lpT2lJMU9HWTJNVFF5T0Mwek9EUTVMVFExTm1NdE9HWmlPUzAyTXpKaU1ETXpPV1l4WXpNaUxDSmxkbVZ1ZEY5cFpDSTZJamRrTUdJMVpqRmpMV0ZsWVRFdE5ETTBZUzA1WVRJeExXRmxPREZqWkRaaFpESXpOU0lzSW5SdmEyVnVYM1Z6WlNJNkltRmpZMlZ6Y3lJc0luTmpiM0JsSWpvaVlYZHpMbU52WjI1cGRHOHVjMmxuYm1sdUxuVnpaWEl1WVdSdGFXNGlMQ0poZFhSb1gzUnBiV1VpT2pFMk1ERXdORGMyT1RRc0ltbHpjeUk2SW1oMGRIQnpPbHd2WEM5amIyZHVhWFJ2TFdsa2NDNWhjQzF6YjNWMGFDMHhMbUZ0WVhwdmJtRjNjeTVqYjIxY0wyRndMWE52ZFhSb0xURmZNVGxEY0UxUVZrcDVJaXdpWlhod0lqb3hOakF4TURVeE1qazBMQ0pwWVhRaU9qRTJNREV3TkRjMk9UUXNJbXAwYVNJNklqTXlZakJoTldObExXSXlNVGd0TkdRMVlpMWhObVUyTFRneFlqazNNamN4TkdOaFppSXNJbU5zYVdWdWRGOXBaQ0k2SWpVeGRURmxPREE0T0hFeFlXTm9NVGQyY0RKdmJXdG9hakl5SWl3aWRYTmxjbTVoYldVaU9pSTFPR1kyTVRReU9DMHpPRFE1TFRRMU5tTXRPR1ppT1MwMk16SmlNRE16T1dZeFl6TWlmUS5RcHV2anFnZmx5OUxwc1FMR0d5M0d6c1lnMkt0ZTg0dDVlU2lSYUJ5MnN6UDJ2b3pFMFc0aFE1XzBmSmFDN3A5ZjFVaERMNGVTSzdHMTJ6a3BSZzBsaWhMUEhQeGRJZm4xZUlhUF9SNXc5dTFaX3hlMl9OSTl0NkNlbHRNNVBLWmdxb2lFM1BGc040emZOOXRqTk1xMmM5eExqakpsbGNnRUlDcDlvNzZ2WFBlQ0RpSUJNWkxnVE40bVRxamNXdUV0VW1UV1FQMUMyaDlhY0ViQW1sSVdTcUh3c21qVno2empRVGg3N25pVkNnLUNWc0JKbEU5eTEydk9iQ2VlRllXa0k4QkNsVFVEd1hqRVdnTmNKSzFhTVRDaHZVaXJZdzNvZFpzZlNrenRqODgwcmtfYlJ1eHVGa0lTbGdENVdRemg5aE1DZi1QTHEyckpyc29vQTVFUGciLCJFeHBpcmVzSW4iOjM2MDAsIlRva2VuVHlwZSI6IkJlYXJlciIsIlJlZnJlc2hUb2tlbiI6ImV5SmpkSGtpT2lKS1YxUWlMQ0psYm1NaU9pSkJNalUyUjBOTklpd2lZV3huSWpvaVVsTkJMVTlCUlZBaWZRLmNlbVhRaXVnLTUwVFYtRkhPM1Z6Y3RhcHVId1p2YlZyX1BSYXE5aHUtMm4ydF9qS29oQVdFSXBsR2JxTy1lN3VOemFnYU5KaGVqWlNKYlZrVnBhMHlsMkcwc2JhbUNuUXYwdEYwU0V6bkIySGM1cmlZZGtwRWdxUlI0cjlNOWtfM1VKaE83WDQ0S1RVcGtXdmNmbllwd3NnQVRBRU5zbWpuVENUM3E0VWQ5dkJRLVNzdEo0a0lwakN6cTlhRkszdnpoc1VkbFVVS3ZhbGJBVkRFOHZvOVFIVU5fSndxLWZUMWdpanBpYnYwUXd1ZU1tNERwVmRFT1pZY3plalpobVRlbzc2aHdac3pwVmRPQWZpXzg1aHR0QTBLSGVXelBicjZjeUZSbUVlV25LcFc1QzFIVThtOGo2VXpMc3Q1V2VhN2dQMEM2SDd2dXVOclJ2WGIwaFV2US51RGpHNzRyc2taWHkxSkc5LlpOQmhUdlFkWi1QcHhHRlV3YXdYYW5lb3Z1X1V5OWZQRy02Mm91ek9LUFdJWm9CWXZoYlZQZ3VPMFlNYkhjRWthQ0hYVzREanVfZ0UySmlfU1FEbFIzWEZDSlhWT0NndEFmQkd3UFNrakg2UFlMT0trV2lWeU5OOFZtbG45WmRtM1ZhWFFJQW4wVVc3Zms0bzlSTmd4ZFF0SEpVUF9vZzNSekZOZHNJeVFIcVZjUmVrSXNCdUZfcFY4WGFndWowRUZYRENuV09ITnlFSjhoNmtQUUFYUUJ3cnRfelppR0MxaU9rQkVsdUdmbmxTbDJyMDhYUnhNSFJ2LVBWRTRoOTFIYkZETlNQM0l0dHM3ZkJOWlptNjk1eWRudTBqMl9lRUo3MUp5V0dLTjl2U0E4YVdockFXLUF5bzl4dzBhMmpBSHF4WE9qS0hlUlZ4c1dyQWcyeG1jZ3lubjN2VC0wX0xFTFVfM0o0RGhwQmRXNXZMQVcyT3g3OFZlRGhRNDN6SlRjQWpvNGpUQk1Bd2RWdWI4cm5TSGoyTlZ3STEySmMtM25kZGxPOV9ycHpyUHM4MGJTcDVlOXJWX19HdUE2Wjl4S0ZIZVlaSWVBcGd3MW01ZkU2Zl9KUFFwUmhXZWdFdUlqcUJtTnFFUHBPbHZVTWEyNjRtcFJ5WURLam9NVHdkNzBLREZKc0tBYUkxdU9tSjBhWU5KZGFuLTAwekJJWWZHeDN3dTZmcWlQMWVpSEJ2V1lUSWVpbWdXUkZheFZCYTBvZmlkeWQzT1FlcUFsWDN2MUhYQzlGWG53VkdrRFUySXFoNWVZeUxNcjB4R2REbnRSbGRGQXltRVJHWk9MZG1HUWpIVDVDWUdBdFlRa3k0bnRtWFc5NFRraUZNUUFyOVlUVVhpaEVjaC1oSFBuR2R2X0Q3eW53MFd0X3d5Vk80TXhFQ1VncVRsaTZpVlFDR0lZeEZ2ZzNyRVU2NmI0eEV6T01QWXpjNll6ZS02ZExaYThBRGZPSi00bGlXaTc1SXdYX2o0UFJFR2lFS21KSjUtNW1zRWp0LUdZVk5pamExOHdMMFJ6dU5BaEJhei0zaWFQZ0s0SkU0S0hacWt1SGlWSzMwbW1qeVFaeF9GcW82UFYxVF85dUx0M19qVE5iM1FCMGtNWjFmdktPZG52TFVGWklIWTRRdk1RaUV5OUxNeGJrUVU0TERvMlJ0Yy0xcWg2dW1Ma05ZazdMWHVGVC03eVlaT3Rxa3A0M2ZsQ0JUMjVMNnNWbnF6X281ZVhTVHRlMkNuY1J2TFBveEJpYTJCWXVpUDZSOGtnZWJCSlk4NjF0M2NRbkl1U05rYURUX2pkSFItVFJZU0o1V2liTTQtU3QzMDBwYVdLN2VHNS15VGtwQ2h2TnRtTzN6dmJpRkhfZUNqMHpQOVkzNm1fbTJXbFR2dldOMC1iNy1ZY3dINTY2WkhZMk9NWlpIQ1JOSlFRY1kxZ3phbmFHYURGMVVBSWUzNGJRVUFCS29rMXN2Uk45NmFNNjB6M3FYWHhfclpTNDhmTHBIRldSYXVjdzJfZ0d3Vy1TZjdzWVRNeVNUSTh1cVRtNzBlbFR3QWhfRWhEODdWV21rV3EyT3dWSHBmTWVLbk9KSlZUcURsR2kwNEhaZFhNVUQ2MFJCaDlJWFRvUVFGUDh0QlFzY1lWMXBDSm15QXVUNTFHU0dYenhTWFp5QjR5LU1mRHZEVnl2aExfZV9GT05XUmFDRGNiOEpSX3dsVGpZdmtnYzVlUEE0MVpLQ2pYTEZOeUtSOVEuUnN1aWM3cUhFRmhCbGUxTGhQSFVXQSIsIklkVG9rZW4iOiJleUpyYVdRaU9pSjNia00wZG1kMGRVMXRja3QwU0c1dFVtZFhXV1J6U1dGd1dYcE1YQzlLTTI1cVNIVk9ORVJZWVhSR1VUMGlMQ0poYkdjaU9pSlNVekkxTmlKOS5leUp6ZFdJaU9pSTFPR1kyTVRReU9DMHpPRFE1TFRRMU5tTXRPR1ppT1MwMk16SmlNRE16T1dZeFl6TWlMQ0psYldGcGJGOTJaWEpwWm1sbFpDSTZabUZzYzJVc0ltbHpjeUk2SW1oMGRIQnpPbHd2WEM5amIyZHVhWFJ2TFdsa2NDNWhjQzF6YjNWMGFDMHhMbUZ0WVhwdmJtRjNjeTVqYjIxY0wyRndMWE52ZFhSb0xURmZNVGxEY0UxUVZrcDVJaXdpY0dodmJtVmZiblZ0WW1WeVgzWmxjbWxtYVdWa0lqcDBjblZsTENKamIyZHVhWFJ2T25WelpYSnVZVzFsSWpvaU5UaG1OakUwTWpndE16ZzBPUzAwTlRaakxUaG1Zamt0TmpNeVlqQXpNemxtTVdNeklpd2laMmwyWlc1ZmJtRnRaU0k2SWxKaFozVnNJaXdpWVhWa0lqb2lOVEYxTVdVNE1EZzRjVEZoWTJneE4zWndNbTl0YTJocU1qSWlMQ0psZG1WdWRGOXBaQ0k2SWpka01HSTFaakZqTFdGbFlURXRORE0wWVMwNVlUSXhMV0ZsT0RGalpEWmhaREl6TlNJc0luUnZhMlZ1WDNWelpTSTZJbWxrSWl3aVlYVjBhRjkwYVcxbElqb3hOakF4TURRM05qazBMQ0p3YUc5dVpWOXVkVzFpWlhJaU9pSXJPVEU1TlRJME5USTNNRFF3SWl3aVpYaHdJam94TmpBeE1EVXhNamswTENKcFlYUWlPakUyTURFd05EYzJPVFFzSW1aaGJXbHNlVjl1WVcxbElqb2lWbWxxWVhsaGEzVnRZWElpTENKbGJXRnBiQ0k2SW5KaFozVnNRSGx2Y0cxaGFXd3VZMjl0SW4wLmpRVGduZ1AxQ2EwWGhhNjU3cGt0aDc1bWYyLUtkWWo4UVZ5a25jbnFpUFU4WE1SbWRJY0s5U0NRd3pjVUhkMkU3ME54TW5pQUJWSGVodG50cTlwTTZhNjRyZTB6NTNFc1BmQ001VDlqUXExWXJfR09mU0c5cWVHV3NNVDI3dm5ZUmM4X0w1N0lNa1FIUC1jemRFcGl4a1FZeEYwWGNWWDVDaW56V3R1Vzh0X2JyVE04RFFCY0xjd2wtWXY2aDR3T1liNVNyZmt3R09UTURrNm96b3FjTWtBbGd1VGxKRWVuTktTb3RBVUtsUUMyRW9xckU1X091LWlfRDAxU1FEX1ktOS11cWJDSEhSTll3dm9zQjRndFBXQ002aWFBcnNIckNkalhjVV81ZlhNdGxpMU5SYW1ibF9MQlpQTEVYbVJjalFjY2NubE5lX0xsN2E1TVlLMGVjZyJ9LCJ1c2VySWQiOiI1OGY2MTQyOC0zODQ5LTQ1NmMtOGZiOS02MzJiMDMzOWYxYzMiLCJ1c2VyTmFtZSI6Iis5MTk1MjQ1MjcwNDAiLCJjbGFpbXMiOnsic3ViamVjdHMiOlt7ImlkIjoiMThhZGViOGEtODQ5ZS00NGZjLTkwNzQtNDU1MDNmOTE2MWFkIiwicmlnaHRzIjpbIkMiLCJSIiwiVSIsIkQiXX1dfSwiY29udGV4dElkIjoiIn0sImlhdCI6MTYwMTA0NzY5NCwiZXhwIjoxNjAzNjM5Njk0LCJpc3MiOiJGSEIiLCJzdWIiOiJGSEIifQ.iONc5mPU2dMeQ6X0QmfhRstDzGGXjEWgCEOi8OxZkiucPIpoUOwBMtaTu5zd5wgLRc6NPmjGfvE87fgVcbqJvLbqEzbG6oE2HXnjjwvDKdc_gfvEdaXxfInpOOGsVQ-vkVp_iL_2os675lVk5NkC4oROjBdp5nvgeXLfFdaVysWZsdvnYBVUA5HRR6xA_xoI70JtnVE99Y-mnFBFBWnwR5nYb0xDHeWN7pLzEwOUUhrdkbljlwhEXD4WOsCzVqQLXaWI5tfz1WIi_xhF019cIB0EqoYnWxURj9-zrtcOozJmQuIAGoKTQoHuEDUqGXzwEOmmFiMaZ8VDpIlC3ZvM_Q';
    var responseJson;
    try {
      final response =
          await http.put(_baseUrl + url,
              headers: await headerRequest.getRequestHeadersAuthContent(),
              //await headerRequest.getRequestHeadersTimeSlot(),
              body: jsonBody);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(variable.strNoInternet);
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson;
        if (response.headers[variable.strcontenttype] ==
                variable.file_img_jpg ||
            response.headers[variable.strcontenttype] ==
                variable.file_img_png ||
            response.headers[variable.strcontenttype] ==
                variable.file_img_all ||
            response.headers[variable.strcontenttype] ==
                variable.file_audio_mp) {
          responseJson = response.bodyBytes;
        } else {
          responseJson = convert.jsonDecode(response.body.toString());
        }
        print(response.body.toString());

        return responseJson;

      case 201:
        var responseJson = convert.jsonDecode(response.body.toString());

        return responseJson;

      case 400:
        var responseJson = convert.jsonDecode(response.body.toString());

        return responseJson;
      case 401:
        var responseJson = convert.jsonDecode(response.body.toString());

        if (responseJson[parameters.strMessage] == Constants.STR_UN_AUTH_USER) {
          SnackbarToLogout();
        } else {
          return responseJson;
        }
        break;

      case 403:
        var responseJson = convert.jsonDecode(response.body.toString());

        if (responseJson[parameters.strMessage] ==
            Constants.STR_OTPMISMATCHEDFOREMAIL) {
          return responseJson;
        } else {
          // SnackbarToLogout();
        }
        break;

      case 500:
        var responseJson = convert.jsonDecode(response.body.toString());

        return responseJson;

        break;

      default:
        throw FetchDataException(
            variable.strErrComm + '${response.statusCode}');
    }
  }

  void SnackbarToLogout() {
    PreferenceUtil.clearAllData().then((value) {
      Get.offAll(SignInScreen());
      Get.snackbar(variable.strMessage, variable.strlogInDeviceOthr);
    });
  }
}
