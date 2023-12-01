import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class SheelaRemainderPopup {
  static checkConditionToShowPopUp() async {
    var controllerQurhomeRegimen =
        CommonUtil().onInitQurhomeRegimenController();

    if (CommonUtil().isTablet == true) {
      try {
        await CommonUtil().getSheelaConfig();
      } catch (e) {
        PreferenceUtil.saveInt(SHEELA_REMAINDER_TIME, (30));
      }
      List<RegimentDataModel>? activitiesFilteredList = [];
      await controllerQurhomeRegimen.getRegimenList();

      activitiesFilteredList =
          controllerQurhomeRegimen.qurHomeRegimenResponseModel?.regimentsList;
      if (activitiesFilteredList != null && activitiesFilteredList.length > 0) {
        int length = activitiesFilteredList?.length ?? 0;
        PreferenceUtil.saveString(Constants.SHEELA_REMAINDER_START,
            activitiesFilteredList?[0]?.estartNew ?? '');
        PreferenceUtil.saveString(Constants.SHEELA_REMAINDER_END,
            activitiesFilteredList?[length - 1]?.estartNew ?? '');
        controllerQurhomeRegimen.startTimerForSheela();
        controllerQurhomeRegimen.callMethodToSaveRemainder();
      } else {
        controllerQurhomeRegimen.startTimerForSheela();
        controllerQurhomeRegimen.callMethodToSaveRemainder();
      }
    }
  }
}
