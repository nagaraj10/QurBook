
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/service/authservice.dart';
import 'package:myfhb/refer_friend/model/referafriendrequest.dart';
import 'package:myfhb/refer_friend/model/referafriendresponse.dart';
import 'dart:convert' as convert;

class ReferAFriendService{
  AuthService _service = AuthService();
  Future<ReferAFriendResponse> referAFriendService(
      ReferAFriendRequest addPatientContactRequest) async {

    var jsonString = convert.jsonEncode(addPatientContactRequest.toJson());

    final response =
        await _service.getApiForAddContactsPatient(qr_refer_friend, jsonString);
    print(response);
    return ReferAFriendResponse.fromJson(response);
  }
}