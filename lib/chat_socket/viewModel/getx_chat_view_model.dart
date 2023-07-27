import 'package:get/get.dart';
import 'package:myfhb/chat_socket/model/CaregiverPatientChatModel.dart';
import 'package:myfhb/chat_socket/model/GetUnreadCountFamily.dart';
import 'package:myfhb/chat_socket/model/UserChatListModel.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

class ChatUserListController extends GetxController {
  var shownNewChatFloat = false.obs;

  ChatSocketService chocketService = new ChatSocketService();

  var userChatList = [].obs;

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
      var userId = PreferenceUtil.getStringValue(KEY_USERID)!;

      CaregiverPatientChatModel familyList =
          await chocketService.getFamilyListMap(userId);

      return familyList;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Future<GetUnreadCountFamily?> getUnreadCountFamily() async {
    try {
      var userId = PreferenceUtil.getStringValue(KEY_USERID)!;

      GetUnreadCountFamily getUserIdModel =
          await chocketService.getUnreadCountFamily(userId);

      return getUserIdModel;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  void updateChatUserList(UserChatListModel userChatListModel) {
    userChatList.value = userChatListModel.payload!;
  }
}
