import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/add_provider_plan/model/ProviderOrganizationResponse.dart';
import 'package:myfhb/add_provider_plan/service/PlanProviderViewModel.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/my_reports/model/report_model.dart';
import 'package:myfhb/my_reports/services/report_service.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/model/AddToCartModel.dart';
import 'package:myfhb/plan_wizard/models/DietPlanModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/services/PlanWizardService.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/widgets/checkout_page.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/fetching_cart_items_model.dart';
import 'package:provider/provider.dart';

class MyReportViewModel extends ChangeNotifier {

  ReportService reportService = ReportService();

  Future<ReportModel> getReportList() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var myPlanListModel = await reportService.getReportList(userid);
        return myPlanListModel;
      } catch (e) {}
    }
  }

}
