import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/add_address/models/AddAddressArguments.dart';
import 'package:myfhb/add_family_otp/models/add_family_otp_arguments.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeDashboardController.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/View/QurhomeDashboard.dart';
import 'package:myfhb/add_provider_plan/view/AddProviderPlan.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/claim/screen/ClaimList.dart';
import 'package:myfhb/claim/screen/ClaimRecordCreate.dart';
import 'package:myfhb/confirm_location/models/confirm_location_arguments.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/devices/device_dashboard_arguments.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/more_menu/screens/more_menu_screen.dart';
import 'package:myfhb/more_menu/screens/terms_and_conditon.dart';
import 'package:myfhb/more_menu/screens/voice_clone_status_screen.dart';
import 'package:myfhb/more_menu/screens/voicecloning_introduction.dart';
import 'package:myfhb/my_family_detail/models/my_family_detail_arguments.dart';
import 'package:myfhb/my_family_detail_view/models/my_family_detail_view_arguments.dart';
import 'package:myfhb/plan_wizard/view/plan_wizard_screen.dart';
import 'package:myfhb/regiment/models/regiment_arguments.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/SheelaAIMainScreen.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/unit/choose_unit.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_status_arguments.dart';
import 'package:myfhb/voice_cloning/model/voice_cloning_choose_member_arguments.dart';
import 'package:myfhb/voice_cloning/view/screens/voice_clone_choose_members.dart';
import 'package:path/path.dart';
import '../add_family_user_info/screens/add_family_user_info_clone.dart';
import '../claim/model/members/MembershipBenefitListModel.dart';
import '../telehealth/features/Notifications/view/notification_main.dart';
import '../ticket_support/view/membership_benefits_list_screen.dart';
import '../voice_cloning/view/screens/voice_recording_screen.dart';
import 'router_variable.dart' as router;
import '../device_integration/viewModel/Device_model.dart';
import '../devices/device_dashboard.dart';
import '../landing/view/landing_screen.dart';
import '../regiment/view/manage_activities/manage_activities_screen.dart';
import '../myPlan/view/my_plans_screen.dart';
import '../my_family/screens/MyFamily.dart';
import '../my_family_detail_view/screens/my_family_detail_view.dart';
import '../my_providers/screens/my_provider.dart';
import '../plan_dashboard/view/diseasesHome.dart';
import '../plan_dashboard/view/plans_screen.dart';
import '../regiment/view/regiment_screen.dart';
import '../schedules/add_appointments.dart';
import '../schedules/add_reminders.dart';
import '../search_providers/screens/search_specific_list.dart';
import '../src/ui/HomeScreen.dart';
import '../src/ui/MyRecord.dart';
import '../src/ui/SplashScreen.dart';
import '../src/ui/authentication/SignInScreen.dart';
import '../src/ui/camera/TakePictureScreen.dart';
import '../src/ui/camera/take_picture_screen_for_devices.dart';
import '../src/ui/devices_screen.dart';
import '../src/ui/settings/MySettings.dart';
import '../src/ui/user/UserAccounts.dart';
import '../telehealth/features/MyProvider/view/MyProvidersMain.dart';
import '../telehealth/features/MyProvider/view/TelehealthProviders.dart';
import '../video_call/pages/callmain.dart';
import 'package:provider/provider.dart';
import '../add_address/screens/add_address_screen.dart';
import '../add_family_otp/screens/add_family_otp_screen.dart';
import '../add_providers/screens/add_providers_screen.dart';
import '../confirm_location/screens/confirm_location_screen.dart';
import '../feedback/Feedbacks.dart';
import '../feedback/FeedbacksSucess.dart';
import '../my_family_detail/screens/my_family_detail_screen.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';

setRouter(List<CameraDescription> listOfCameras) async {
  final firstCamera = listOfCameras[0];

  final fhbRouter = <String, WidgetBuilder>{
    router.rt_Sheela: (context) => SheelaAIMainScreen(
          arguments:
              ModalRoute.of(context)!.settings.arguments as SheelaArgument?,
        ),
    router.rt_Splash: (context) => SplashScreen(),
    router.rt_SignIn: (context) => SignInScreen(),
    router.rt_Dashboard: (context) => DevicesScreen(),
    router.rt_Regimen: (context) => RegimentScreen(
        aruguments:
            ModalRoute.of(context)!.settings.arguments as RegimentArguments?),
    router.rt_Landing: (context) {
      if (CommonUtil.REGION_CODE == "US") {
        // US
        Get.lazyPut(() => QurhomeDashboardController());
        return QurhomeDashboard();
      } else {
        // IN
        return LandingScreen(
          landingArguments:
              ModalRoute.of(context)!.settings.arguments as LandingArguments?,
        );
      }
    },
    router.rt_ManageActivitiesScreen: (context) => ManageActivitiesScreen(),
    router.rt_MyPlans: (context) => MyPlansScreen(),
    router.rt_Plans: (context) => PlansScreen(),
    router.rt_Diseases: (context) => DiseasesScreen(),
    router.rt_Devices: (context) => DevicesScreen(),
    router.rt_HomeScreen: (context) => HomeScreen(
        arguments:
            ModalRoute.of(context)!.settings.arguments as HomeScreenArguments?),
    router.rt_deviceDashboard: (context) => Devicedashboard(
        arguments: ModalRoute.of(context)!.settings.arguments
            as DeviceDashboardArguments?),
    router.rt_UserAccounts: (context) => UserAccounts(
        arguments: ModalRoute.of(context)!.settings.arguments
            as UserAccountsArguments?),
    router.rt_AppSettings: (context) => ChangeNotifierProvider(
          create: (context) => DevicesViewModel(),
          child: MySettings(),
        ),
    router.rt_MyRecords: (context) => MyRecords(
          argument:
              ModalRoute.of(context)!.settings.arguments as MyRecordsArgument?,
        ),
    router.rt_MyFamily: (context) => MyFamily(),
    router.rt_myprovider: (context) => MyProvider(),
    router.rt_th_myprovider: (context) => MyProvidersMain(),
    router.rt_AddProvider: (context) => AddProviders(
        arguments: ModalRoute.of(context)!.settings.arguments
            as AddProvidersArguments?),
    router.rt_AddAddress: (context) => AddAddressScreen(
        arguments:
            ModalRoute.of(context)!.settings.arguments as AddAddressArguments?),
    router.rt_SearchProvider: (context) => SearchSpecificList(
        arguments:
            ModalRoute.of(context)!.settings.arguments as SearchArguments?,
        toPreviousScreen: false,
        isSkipUnknown: true),
    router.rt_TakePicture: (context) => TakePictureScreen(camera: firstCamera),
    router.rt_TakePictureForDevices: (context) =>
        TakePictureScreenForDevices(cameras: listOfCameras),
    router.rt_ConfirmLocation: (context) => ConfirmLocationScreen(
        arguments: ModalRoute.of(context)!.settings.arguments
            as ConfirmLocationArguments?),
    router.rt_AudioScreen: (context) => AudioRecorder(),
    // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
    router.rt_AddFamilyOtp: (context) => AddFamilyOTPScreen(
        arguments: ModalRoute.of(context)!.settings.arguments
            as AddFamilyOTPArguments?),
    router.rt_AddFamilyUserInfo: (context) => AddFamilyUserInfoScreen(
        arguments: ModalRoute.of(context)!.settings.arguments
            as AddFamilyUserInfoArguments?),
    router.rt_FamilyDetailScreen: (context) => MyFamilyDetailScreen(
        arguments: ModalRoute.of(context)!.settings.arguments
            as MyFamilyDetailArguments?),
    router.rt_FamilyInsurance: (context) => MyFamilyDetailView(
        arguments: ModalRoute.of(context)!.settings.arguments
            as MyFamilyDetailViewArguments?),
    router.rt_AddReminders: (context) => AddReminder(),
    router.rt_AddAppointments: (context) => AddAppointments(),
    router.rt_Feedbacks: (context) => Feedbacks(),
    router.rt_FeedbackSucess: (context) => FeedbackSuccess(),
    router.rt_TelehealthProvider: (context) => TelehealthProviders(
        arguments:
            ModalRoute.of(context)!.settings.arguments as HomeScreenArguments?),
    router.rt_CallMain: (context) => CallMain(
        arguments:
            ModalRoute.of(context)!.settings.arguments as CallArguments?),
    router.rt_AudioScreen: (BuildContext context) => AudioRecorder(
        arguments: ModalRoute.of(context)!.settings.arguments
            as AudioScreenArguments?),
    router.rt_PlanWizard: (BuildContext context) => PlanWizardScreen(),
    router.rt_AddProviderPlan: (BuildContext context) => AddProviderPlan(""),
    router.rt_ClaimResult: (BuildContext context) => ClaimList(),
    router.rt_ClaimCreate: (BuildContext context) => ClaimRecordCreate(),
    router.rt_chooseUnit: (BuildContext context) => ChooseUnit(),
    router.rt_VoiceCloneTerms: (context) => TermsAndConditonWebView(
          isLocalAsset: false,
          selectedUrl: CommonUtil.PORTAL_URL + voice_cloning_html,
          title: strVoiceCloning,
        ), //initialize router for terms and condition of voice cloning
    router.rt_VoiceCloningIntro: (context) =>
        VoiceCloningIntroducuton(), //initialize router for introduction page of voice cloning
    router.rt_VoiceCloningStatus: (context) => VoiceCloningStatus(
        arguments: ModalRoute.of(context)!.settings.arguments
            as VoiceCloneStatusArguments?), //initialize router for introduction page of voice cloning
    router.rt_record_submission: (BuildContext context) =>
        VoiceRecordingScreen(),
    router.rt_VoiceCloningChooseMemberSubmit: (context) => VoiceCloningChooseMember(
        arguments: ModalRoute.of(context)!.settings.arguments
            as VoiceCloningChooseMemberArguments?), //initialize router for Choose and Submit Caregiver Voice Assignment of voice cloning
    router.rt_more_menu: (context) => MoreMenuScreen(
          refresh:
              ModalRoute.of(context)!.settings.arguments as Function(bool)?,
        ),
    router.rt_notification_main: (BuildContext context) => NotificationMain(),
    router.rt_membership_benefits_screen: (BuildContext context) =>
        MembershipBenefitListScreen(
            membershipBenefitListModel: ModalRoute.of(context)!
                .settings
                .arguments as MembershipBenefitListModel?),
  };

  return fhbRouter;
}
