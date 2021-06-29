import 'package:flutter/foundation.dart';
import 'package:myfhb/refer_friend/service/referafriend_service.dart';
import 'package:myfhb/refer_friend/model/referafriendrequest.dart';
import 'package:myfhb/refer_friend/model/referafriendresponse.dart';

class ReferAFriendViewModel extends ChangeNotifier {
  ReferAFriendResponse _referAFriendResponse = ReferAFriendResponse();
  ReferAFriendService _referAFriendService = ReferAFriendService();

  Future<ReferAFriendResponse> referFriendVMModel(
      ReferAFriendRequest addPatientContactRequest) async {
    try {
      ReferAFriendResponse referAFriendResponse = await _referAFriendService
          .referAFriendService(addPatientContactRequest);
      _referAFriendResponse = referAFriendResponse;
      return _referAFriendResponse;
    } catch (e) {}
  }
}