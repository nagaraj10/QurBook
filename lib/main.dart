import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/MyRecords.dart';
import 'package:myfhb/src/ui/authentication/SignInScreen.dart';
import 'package:myfhb/src/ui/SplashScreen.dart';
import 'package:myfhb/src/ui/camera/TakePictureScreen.dart';
import 'package:myfhb/src/ui/dashboard.dart';
import 'package:myfhb/src/ui/family/MyFamily.dart';
import 'package:myfhb/src/ui/providers/MyProvider.dart';

var firstCamera;
var routes = <String, WidgetBuilder>{
  "/splashscreen": (BuildContext context) => SplashScreen(),
  "/sign_in_screen": (BuildContext context) => SignInScreen(),
  "/dashboard_screen": (BuildContext context) => DashboardScreen(),
  "/home_screen": (BuildContext context) => HomeScreen(),
  "/my_records": (BuildContext context) => MyRecords(),
  "/my_family": (BuildContext context) => MyFamily(),
  "/my_providers": (BuildContext context) => MyProvider(),
  "/take_picture_screen": (BuildContext context) => TakePictureScreen(
        camera: firstCamera,
      )
};

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;

  runApp(
    MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.deepPurple,
      ),
      home: SignInScreen(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

/* class MyApp extends StatelessWidget {
  //This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
} */
