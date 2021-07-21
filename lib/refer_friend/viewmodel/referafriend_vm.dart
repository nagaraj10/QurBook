import 'package:flutter/foundation.dart';
import '../service/referafriend_service.dart';
import '../model/referafriendrequest.dart';
import '../model/referafriendresponse.dart';

class ReferAFriendViewModel extends ChangeNotifier {
  ReferAFriendResponse _referAFriendResponse = ReferAFriendResponse();
  final ReferAFriendService _referAFriendService = ReferAFriendService();

  Future<ReferAFriendResponse> referFriendVMModel(
      ReferAFriendRequest addPatientContactRequest) async {
    try {
      var referAFriendResponse = await _referAFriendService
          .referAFriendService(addPatientContactRequest);
      _referAFriendResponse = referAFriendResponse;
      return _referAFriendResponse;
    } catch (e) {}
  }
}