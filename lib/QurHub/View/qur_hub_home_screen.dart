import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/QurHub/Controller/hub_list_controller.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../../constants/variable_constant.dart' as variable;

class QurHubHomeScreen extends StatefulWidget {
  const QurHubHomeScreen({Key key}) : super(key: key);

  @override
  _QurHubHomeScreenState createState() => _QurHubHomeScreenState();
}

class _QurHubHomeScreenState extends State<QurHubHomeScreen> {
  final controller = Get.put(HubListController());

  @override
  void initState() {
    try {
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(/*'Connected Hub'*/variable.strConnectedDevices),
        centerTitle: false,
        elevation: 0,
      ),
      body: Obx(
        () => controller.loadingData.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    qurHomeBtn(),
                    /*SizedBox(
                      height: 30,
                    ),
                    qurHubIoTBtn(),*/
                  ],
                ),
              ),
      ));

  Widget qurHomeBtn() {
    final qurHomeWithGesture = InkWell(
      onTap: () async {
        try {
          bool serviceEnabled = await CommonUtil().checkGPSIsOn();
          if (!serviceEnabled) {
            FlutterToast().getToast(
                'Please turn on your GPS location services and try again',
                Colors.red);
            return;
          } else {
            FocusScope.of(context).unfocus();
            controller.navigateToHubListScreen(true);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 250.0.w,
        //height: 45.0.h,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.strQurHomeinQurBook,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return Center(
      child: qurHomeWithGesture,
    );
  }

  Widget qurHubIoTBtn() {
    final qurHubIoTWithGesture = InkWell(
      onTap: () async {
        try {
          bool serviceEnabled = await CommonUtil().checkGPSIsOn();
          if (!serviceEnabled) {
            FlutterToast().getToast(
                'Please turn on your GPS location services and try again',
                Colors.red);
            return;
          } else {
            FocusScope.of(context).unfocus();
            controller.navigateToHubListScreen(false);
          }
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        width: 250.0.w,
        //height: 45.0.h,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.strQurHubIoTdevice,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
    return Center(
      child: qurHubIoTWithGesture,
    );
  }
}
