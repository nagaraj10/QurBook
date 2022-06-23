import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/services/ticket_service.dart';

class AddProvidersController extends GetxController {
  var isLoadingProgress = false.obs;
  TicketTypesResult labTicketTypesResult;
  UserTicketService userTicketService = UserTicketService();

  @override
  void onClose() {
    try {
      super.onClose();
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    try {
      super.onInit();
    } catch (e) {
      print(e);
    }
  }

  getTicketTypesList() async {
    try {
      isLoadingProgress.value = true;
      var userTicketModel = await userTicketService.getTicketTypesList();
      if (userTicketModel != null &&
          userTicketModel.ticketTypeResults != null &&
          userTicketModel.ticketTypeResults.isNotEmpty) {
        isLoadingProgress.value = false;
        final index = userTicketModel.ticketTypeResults.indexWhere((element) =>
            (CommonUtil()
                .validString(element.name)
                .toLowerCase()
                .contains("lab appointment")));
        if (index >= 0) {
          labTicketTypesResult = userTicketModel.ticketTypeResults[index];
        } else {
          labTicketTypesResult = null;
        }
      } else {
        labTicketTypesResult = null;
        isLoadingProgress.value = false;
      }
    } catch (e) {
      labTicketTypesResult = null;
      isLoadingProgress.value = false;
    }
  }
}
