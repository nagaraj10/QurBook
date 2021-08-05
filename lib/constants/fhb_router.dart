import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/add_provider_plan/view/AddProviderPlan.dart';
import 'package:myfhb/plan_wizard/view/plan_wizard_screen.dart';
import '../add_family_user_info/screens/add_family_user_info_clone.dart';
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
import '../src/ui/audio/audio_record_screen.dart';
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
import '../src/ui/bot/view/ChatScreen.dart';
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

//TODO : to confirm
  /*
  var fhb_router = <String, WidgetBuilder>{
    router.rt_Sheela: (BuildContext context) => ChatScreen(
          arguments: ModalRoute.of(context).settings.arguments,
        ),
    router.rt_Splash: (BuildContext context) => SplashScreen(),
    router.rt_SignIn: (BuildContext context) => SignInScreen(),
    router.rt_Dashboard: (BuildContext context) => DevicesScreen(),
    router.rt_Regimen: (BuildContext context) =>
  */

  final fhbRouter = <String, WidgetBuilder>{
    router.rt_Sheela: (context) => ChatScreen(
          arguments: ModalRoute.of(context).settings.arguments,
        ),
    router.rt_Splash: (context) => SplashScreen(),
    router.rt_SignIn: (context) => SignInScreen(),
    router.rt_Dashboard: (context) => DevicesScreen(),
    router.rt_Regimen: (context) =>
        RegimentScreen(aruguments: ModalRoute.of(context).settings.arguments),
    router.rt_Landing: (context) => LandingScreen(
          landingArguments: ModalRoute.of(context).settings.arguments,
        ),
    router.rt_ManageActivitiesScreen: (context) => ManageActivitiesScreen(),
    router.rt_MyPlans: (context) => MyPlansScreen(),
    router.rt_Plans: (context) => PlansScreen(),
    router.rt_Diseases: (context) => DiseasesScreen(),
    router.rt_Devices: (context) => DevicesScreen(),
    router.rt_HomeScreen: (context) =>
        HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_deviceDashboard: (context) =>
        Devicedashboard(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_UserAccounts: (context) =>
        UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AppSettings: (context) => ChangeNotifierProvider(
          create: (context) => DevicesViewModel(),
          child: MySettings(),
        ),
    router.rt_MyRecords: (context) => MyRecords(
          argument: ModalRoute.of(context).settings.arguments,
        ),
    router.rt_MyFamily: (context) => MyFamily(),
    router.rt_myprovider: (context) => MyProvider(),
    router.rt_th_myprovider: (context) => MyProvidersMain(),
    router.rt_AddProvider: (context) =>
        AddProviders(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddAddress: (context) =>
        AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_SearchProvider: (context) => SearchSpecificList(
        arguments: ModalRoute.of(context).settings.arguments,
        toPreviousScreen: false,
        isSkipUnknown: true),
    router.rt_TakePicture: (context) => TakePictureScreen(camera: firstCamera),
    router.rt_TakePictureForDevices: (context) =>
        TakePictureScreenForDevices(cameras: listOfCameras),
    router.rt_ConfirmLocation: (context) => ConfirmLocationScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AudioScreen: (context) => AudioRecorder(),
    // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
    router.rt_AddFamilyOtp: (context) => AddFamilyOTPScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddFamilyUserInfo: (context) => AddFamilyUserInfoScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_FamilyDetailScreen: (context) => MyFamilyDetailScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_FamilyInsurance: (context) => MyFamilyDetailView(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddReminders: (context) => AddReminder(),
    router.rt_AddAppointments: (context) => AddAppointments(),
    router.rt_Feedbacks: (context) => Feedbacks(),
    router.rt_FeedbackSucess: (context) => FeedbackSuccess(),
    router.rt_TelehealthProvider: (context) => TelehealthProviders(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_CallMain: (context) =>
        CallMain(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AudioScreen: (BuildContext context) =>
        AudioRecorder(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_PlanWizard: (BuildContext context) => PlanWizardScreen(),
    router.rt_AddProviderPlan: (BuildContext context) => AddProviderPlan(),
  };

  return fhbRouter;
}
