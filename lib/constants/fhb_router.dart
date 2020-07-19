import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/my_family_detail_view/screens/my_family_detail_view.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/schedules/add_appointments.dart';
import 'package:myfhb/schedules/add_reminders.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/IntroSlider.dart';
import 'package:myfhb/src/ui/MyRecordClone.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/src/ui/camera/TakePictureScreen.dart';
import 'package:myfhb/src/ui/camera/take_picture_screen_for_devices.dart';
import 'package:myfhb/src/ui/connectivity_bloc.dart';
import 'package:myfhb/src/ui/dashboard.dart';
import 'package:myfhb/src/ui/settings/MySettings.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';

import '../add_address/screens/add_address_screen.dart';
import '../add_family_otp/screens/add_family_otp_screen.dart';
import '../add_family_user_info/screens/add_family_user_info.dart';
import '../add_providers/screens/add_providers_screen.dart';
import '../confirm_location/screens/confirm_location_screen.dart';
import '../feedback/Feedbacks.dart';
import '../feedback/FeedbacksSucess.dart';
import '../my_family/screens/MyFamily.dart';
import '../my_family_detail/screens/my_family_detail_screen.dart';
import '../telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/constants/router_variable.dart' as router;


//List<CameraDescription> listOfCameras= availableCameras();
//var firstCamera=availableCameras()[0];


/*var fhb_router= <String, WidgetBuilder>{
  "/splashscreen": (BuildContext context) => SplashScreen(),
  "/sign-in-screen": (BuildContext context) => SignInScreen(),
  "/dashboard-screen": (BuildContext context) => DashboardScreen(),
  "/home-screen": (BuildContext context) =>
      HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/user-accounts": (BuildContext context) =>
      UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
  "/app-settings": (BuildContext context) => MySettings(),
  "/my-records": (BuildContext context) => MyRecordsClone(),
  "/my-family": (BuildContext context) => MyFamily(),
  "/my-providers": (BuildContext context) => MyProvider(),
  "/add-providers": (BuildContext context) =>
      AddProviders(arguments: ModalRoute.of(context).settings.arguments),
  "/add-address": (BuildContext context) =>
      AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/search-providers": (BuildContext context) => SearchSpecificList(
        arguments: ModalRoute.of(context).settings.arguments,
        toPreviousScreen: false,
      ),
  "/take-picture-screen": (BuildContext context) => TakePictureScreen(
        camera: firstCamera,
      ),
  "/take-picture-screen-for-devices": (BuildContext context) =>
      TakePictureScreenForDevices(cameras: listOfCameras),
  "/confirm-location": (BuildContext context) => ConfirmLocationScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/audio-record-screen": (BuildContext context) => AudioRecordScreen(),
  // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
  "/add-family-otp-screen": (BuildContext context) =>
      AddFamilyOTPScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/add-family-user-info": (BuildContext context) => AddFamilyUserInfoScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my-family-detail-screen": (BuildContext context) => MyFamilyDetailScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my-family-detail-view-insurance": (BuildContext context) =>
      MyFamilyDetailView(arguments: ModalRoute.of(context).settings.arguments),
  "/add-reminders": (BuildContext context) => AddReminder(),
  "/add-appointments": (BuildContext context) => AddAppointments(),
  "/intro-slider": (BuildContext context) => IntroSliderPage(),
  "/feedbacks": (BuildContext context) => Feedbacks(),
  "/feedbacks-success": (BuildContext context) => FeedbackSuccess(),

    "/telehealth-providers": (BuildContext context) =>
      TelehealthProviders(arguments: ModalRoute.of(context).settings.arguments),
};*/

setRouter(List<CameraDescription> listOfCameras)async{

  var firstCamera=listOfCameras[0];

  var fhb_router= <String, WidgetBuilder>{
  "/splashscreen": (BuildContext context) => SplashScreen(),
  "/sign-in-screen": (BuildContext context) => SignInScreen(),
  "/dashboard-screen": (BuildContext context) => DashboardScreen(),
  "/home-screen": (BuildContext context) =>
      HomeScreen(arguments: ModalRoute.of(context).settings.arguments),
  router.rt_UserAccounts: (BuildContext context) =>
      UserAccounts(arguments: ModalRoute.of(context).settings.arguments),
  "/app-settings": (BuildContext context) => MySettings(),
  "/my-records": (BuildContext context) => MyRecordsClone(),
  "/my-family": (BuildContext context) => MyFamily(),
  "/my-providers": (BuildContext context) => MyProvider(),
  "/add-providers": (BuildContext context) =>
      AddProviders(arguments: ModalRoute.of(context).settings.arguments),
  router.rt_AddAddress: (BuildContext context) =>
      AddAddressScreen(arguments: ModalRoute.of(context).settings.arguments),
  "/search-providers": (BuildContext context) => SearchSpecificList(
        arguments: ModalRoute.of(context).settings.arguments,
        toPreviousScreen: false,
      ),
  "/take-picture-screen": (BuildContext context) => TakePictureScreen(
        camera: firstCamera,
      ),
  "/take-picture-screen-for-devices": (BuildContext context) =>
      TakePictureScreenForDevices(cameras: listOfCameras),
  "/confirm-location": (BuildContext context) => ConfirmLocationScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/audio-record-screen": (BuildContext context) => AudioRecordScreen(),
  // "/sign_up_screen": (BuildContext context) => SignUpScreen(),
  router.rt_AddFamilyOtp: (BuildContext context) =>
      AddFamilyOTPScreen(arguments: ModalRoute.of(context).settings.arguments),
  router.rt_AddFamilyUserInfo: (BuildContext context) => AddFamilyUserInfoScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my-family-detail-screen": (BuildContext context) => MyFamilyDetailScreen(
      arguments: ModalRoute.of(context).settings.arguments),
  "/my-family-detail-view-insurance": (BuildContext context) =>
      MyFamilyDetailView(arguments: ModalRoute.of(context).settings.arguments),
  "/add-reminders": (BuildContext context) => AddReminder(),
  "/add-appointments": (BuildContext context) => AddAppointments(),
  "/intro-slider": (BuildContext context) => IntroSliderPage(),
  "/feedbacks": (BuildContext context) => Feedbacks(),
  "/feedbacks-success": (BuildContext context) => FeedbackSuccess(),

    "/telehealth-providers": (BuildContext context) =>
      TelehealthProviders(arguments: ModalRoute.of(context).settings.arguments),
};
return fhb_router;

}

