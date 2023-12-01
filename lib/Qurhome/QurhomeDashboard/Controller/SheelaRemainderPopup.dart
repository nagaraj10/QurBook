import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class SheelaRemainderPopup {
  /**
   * This method invoke a timer which will help show remainder dialog
   * at a particular interval of time 
   */
  static checkConditionToShowPopUp() async {
    var controllerQurhomeRegimen =
        CommonUtil().onInitQurhomeRegimenController();

    if (CommonUtil().isTablet == true) {
      try {
        //helps get the interval time from api
        await CommonUtil().getSheelaConfig();
      } catch (e) {
        PreferenceUtil.saveInt(SHEELA_REMAINDER_TIME, (30));
      }
      List<RegimentDataModel>? activitiesFilteredList = [];
      await controllerQurhomeRegimen.getRegimenList();

      //get the regiment list from api
      activitiesFilteredList =
          controllerQurhomeRegimen.qurHomeRegimenResponseModel?.regimentsList;
      //Check if length is greater tha 0 or else start the timer
      if (activitiesFilteredList != null && activitiesFilteredList.length > 0) {
        int length = activitiesFilteredList?.length ?? 0;
        PreferenceUtil.saveString(Constants.SHEELA_REMAINDER_START,
            activitiesFilteredList?[0]?.estartNew ?? '');
        PreferenceUtil.saveString(Constants.SHEELA_REMAINDER_END,
            activitiesFilteredList?[length - 1]?.estartNew ?? '');
        controllerQurhomeRegimen.startTimerForSheela();
        //Save the first and last activity of the day in preference
        controllerQurhomeRegimen.callMethodToSaveRemainder();
      } else {
        controllerQurhomeRegimen.startTimerForSheela();
        controllerQurhomeRegimen.callMethodToSaveRemainder();
      }
    }
  }
}
