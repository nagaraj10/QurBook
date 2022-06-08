import 'package:get/get.dart';
import 'package:myfhb/chat_socket/model/CaregiverPatientChatModel.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class ChatUserListController extends GetxController {
  var shownNewChatFloat = false.obs;

  ChatSocketService chocketService = new ChatSocketService();

  void updateNewChatFloatShown(bool value) {
    shownNewChatFloat.value = value;
  }

  bool isSelfUser() {
    bool value = false;
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    var userIdMain = PreferenceUtil.getStringValue(KEY_USERID_MAIN);
    if (userId == userIdMain) {
      value = true;
    } else {
      value = false;
    }
    return value;
  }

  Future<dynamic> getFamilyMappingList() async {
    try {
      var userId = PreferenceUtil.getStringValue(KEY_USERID);

      CaregiverPatientChatModel familyList =
          await chocketService.getFamilyListMap(userId);

      return familyList;
    } catch (e) {}
  }
}
