
import '../../authentication/constants/constants.dart';
import '../../authentication/service/authservice.dart';
import '../model/referafriendrequest.dart';
import '../model/referafriendresponse.dart';
import 'dart:convert' as convert;

class ReferAFriendService{
  final AuthService _service = AuthService();
  Future<ReferAFriendResponse> referAFriendService(
      ReferAFriendRequest addPatientContactRequest) async {

    final jsonString = convert.jsonEncode(addPatientContactRequest.toJson());

    var response =
        await _service.getApiForAddContactsPatient(qr_refer_friend, jsonString);
    print(response);
    return ReferAFriendResponse.fromJson(response);
  }
}