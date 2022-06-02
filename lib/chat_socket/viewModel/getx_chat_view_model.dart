import 'package:get/get.dart';


class ChatUserListController extends GetxController {

  var shownNewChatFloat = false.obs;

  void updateNewChatFloatShown(bool value){
    shownNewChatFloat.value = value;
  }

}
