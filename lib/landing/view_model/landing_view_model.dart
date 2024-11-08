
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/landing/model/membership_detail_response.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../main.dart';
import '../model/qur_plan_dashboard_model.dart';
import '../service/landing_service.dart';

enum LandingScreenStatus { Loading, Loaded }

class LandingViewModel extends ChangeNotifier {
  Color primaryColor = mAppThemeProvider.primaryColor;
  /*int currentTabIndex = 0;
  var appBarTitle = constants.strMyDashboard;
  bool isSearchVisible = false;*/
  LandingScreenStatus landingScreenStatus = LandingScreenStatus.Loaded;
  LandingScreenStatus widgetScreenStatus = LandingScreenStatus.Loaded;
  DashboardModel? dashboardData;
  DashboardModel? widgetsData;
  bool isLoadDone = true;
  bool isURLCome = false;
  bool isUserMainId = true;

  /*void changeSearchBar({bool isEnabled = false, bool needNotify = true}) {
    isSearchVisible = isEnabled;
    if (needNotify) {
      notifyListeners();
    }
  }

  void updateTabIndex(int newIndex) {
    currentTabIndex = newIndex;
    changeSearchBar(needNotify: false);
    switch (currentTabIndex) {
      case 1:
        appBarTitle = constants.CHAT;
        break;
      case 2:
        appBarTitle = constants.strSheelaG;
        break;
      case 3:
        appBarTitle = constants.strAppointment;
        break;
      case 4:
        appBarTitle = constants.RECORDS_TITLE;
        break;
      default:
        appBarTitle = constants.strMyDashboard;
        break;
    }
    notifyListeners();
  }*/

  void updatePrimaryColor() {
    primaryColor = mAppThemeProvider.primaryColor;
    notifyListeners();
  }

  void updateStatus(LandingScreenStatus newStatus, {bool needNotify = false}) {
    landingScreenStatus = newStatus;
    if (needNotify) {
      notifyListeners();
    }
  }

  Future<bool> checkIfUserIdSame()async {
    final userId = await PreferenceUtil.getStringValue(constants.KEY_USERID);
    final userIdMain =
    await PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);

    if (userId != userIdMain) {
      isUserMainId = false;
    }else{
      isUserMainId = true;

    }
    return isUserMainId;


  }

  Future<void> getQurPlanDashBoard({bool needNotify = false}) async {
    if (isLoadDone) {
      if (needNotify) {
        updateStatus(LandingScreenStatus.Loading, needNotify: needNotify);
      }
      isLoadDone = false;
      final healthPlanSetting = await LandingService.getHidePlan();
      if(healthPlanSetting!=null){
        if(healthPlanSetting.isSuccess!){
          PreferenceUtil.setAddPlanButton(healthPlanSetting.result!.qurBook!.addPlanBtn!);
          PreferenceUtil.setCartEnable(healthPlanSetting.result!.qurBook!.cart!);
          PreferenceUtil.setUnSubscribeValue(healthPlanSetting.result!.qurBook!.unSubscribeBtn!);
        }else{
          if(CommonUtil.REGION_CODE == 'IN'){
            PreferenceUtil.setAddPlanButton(true);
            PreferenceUtil.setCartEnable(true);
            PreferenceUtil.setUnSubscribeValue(true);
          }else{
            PreferenceUtil.setAddPlanButton(false);
            PreferenceUtil.setCartEnable(false);
            PreferenceUtil.setUnSubscribeValue(false);
          }

        }
      }else{
        if(CommonUtil.REGION_CODE == 'IN'){
          PreferenceUtil.setAddPlanButton(true);
          PreferenceUtil.setCartEnable(true);
          PreferenceUtil.setUnSubscribeValue(true);
        }else{
          PreferenceUtil.setAddPlanButton(false);
          PreferenceUtil.setCartEnable(false);
          PreferenceUtil.setUnSubscribeValue(false);
        }
      }
      final dashboardResponse = await LandingService.getQurPlanDashBoard();
      isLoadDone = true;
      if (dashboardResponse.isSuccess ?? false) {
        dashboardData = dashboardResponse.dashboardData;
      } else {
        dashboardData = dashboardResponse.dashboardData;
      }
      if (needNotify) {
        updateStatus(LandingScreenStatus.Loaded, needNotify: needNotify);
      }
      notifyListeners();
    }
  }

  Future<MemberShipDetailResponse> getMembershipDetails() async => await LandingService.getMemberShipDetails();

  Future<DashboardModel?> getQurPlanWidgetsData({
    bool needNotify = false,
    String includeText = qr_all,
  }) async {
    if (needNotify) {
      widgetScreenStatus = LandingScreenStatus.Loading;
    }
    final dashboardResponse = await LandingService.getQurPlanDashBoard(
      includeText: includeText,
    );
    if (dashboardResponse.isSuccess ?? false) {
      widgetsData = dashboardResponse.dashboardData;
    } else {
      widgetsData = dashboardResponse.dashboardData;
    }
    if (needNotify) {
      widgetScreenStatus = LandingScreenStatus.Loaded;
    }
    notifyListeners();
    return widgetsData;
  }
}
