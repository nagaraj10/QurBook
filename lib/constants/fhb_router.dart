import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/my_family/screens/my_family.dart';
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/schedules/add_appointments.dart';
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/IntroSlider.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/src/ui/authentication/WebCognitoScreen.dart';
import 'package:myfhb/src/ui/camera/TakePictureScreen.dart';
import 'package:myfhb/src/ui/camera/take_picture_screen_for_devices.dart';
import 'package:myfhb/src/ui/dashboard.dart';
import 'package:myfhb/src/ui/settings/MySettings.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProvidersMain.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/video_call/pages/callmain.dart';
import 'package:provider/provider.dart';

import '../add_address/screens/add_address_screen.dart';
import '../add_family_otp/screens/add_family_otp_screen.dart';
import '../add_family_user_info/screens/add_family_user_info.dart';
import '../add_providers/screens/add_providers_screen.dart';
import '../confirm_location/screens/confirm_location_screen.dart';
import '../feedback/Feedbacks.dart';
import '../feedback/FeedbacksSucess.dart';
import '../my_family_detail/screens/my_family_detail_screen.dart';

setRouter(List<CameraDescription> listOfCameras) async {
  var firstCamera = listOfCameras[0];

  var fhb_router = <String, WidgetBuilder>{
    router.rt_Splash: (BuildContext context) => SplashScreen(),
    router.rt_SignIn: (BuildContext context) => SignInScreen(),
    router.rt_Dashboard: (BuildContext context) => DashboardScreen(),
    router.rt_HomeScreen: (BuildContext context) =>
        HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_UserAccounts: (BuildContext context) =>
        UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AppSettings: (BuildContext context) => ChangeNotifierProvider(
          create: (context) => DevicesViewModel(),
          child: MySettings(),
        ),
    router.rt_MyRecords: (BuildContext context) => MyRecords(),
    router.rt_MyFamily: (BuildContext context) => MyFamily(),
    router.rt_myprovider: (BuildContext context) => MyProvider(),
    router.rt_th_myprovider: (BuildContext context) => MyProvidersMain(),
    router.rt_AddProvider: (BuildContext context) =>
        AddProviders(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddAddress: (BuildContext context) =>
        AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
    router.rt_SearchProvider: (BuildContext context) => SearchSpecificList(
          arguments: ModalRoute.of(context).settings.arguments,
          toPreviousScreen: false,
        ),
    router.rt_TakePicture: (BuildContext context) =>
        TakePictureScreen(camera: firstCamera),
    router.rt_TakePictureForDevices: (BuildContext context) =>
        TakePictureScreenForDevices(cameras: listOfCameras),
    router.rt_ConfirmLocation: (BuildContext context) => ConfirmLocationScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AudioScreen: (BuildContext context) => AudioRecordScreen(),
    // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
    router.rt_AddFamilyOtp: (BuildContext context) => AddFamilyOTPScreen(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddFamilyUserInfo: (BuildContext context) =>
        AddFamilyUserInfoScreen(
            arguments: ModalRoute.of(context).settings.arguments),
    router.rt_FamilyDetailScreen: (BuildContext context) =>
        MyFamilyDetailScreen(
            arguments: ModalRoute.of(context).settings.arguments),
    router.rt_FamilyInsurance: (BuildContext context) => MyFamilyDetailView(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_AddReminders: (BuildContext context) => AddReminder(),
    router.rt_AddAppointments: (BuildContext context) => AddAppointments(),
    router.rt_IntroSlider: (BuildContext context) => IntroSliderPage(),
    router.rt_Feedbacks: (BuildContext context) => Feedbacks(),
    router.rt_FeedbackSucess: (BuildContext context) => FeedbackSuccess(),
    router.rt_WebCognito: (BuildContext context) => WebCognitoScreen(),
    router.rt_TelehealthProvider: (BuildContext context) => TelehealthProviders(
        arguments: ModalRoute.of(context).settings.arguments),
    router.rt_CallMain: (BuildContext context) =>
        CallMain(arguments: ModalRoute.of(context).settings.arguments)
  };

  return fhb_router;
}
