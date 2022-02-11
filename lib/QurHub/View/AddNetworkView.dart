import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/Orders/Controller/OrderController.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:myfhb/Orders/View/AppointmentOrderTile.dart';
import 'package:myfhb/Orders/View/OrderTile.dart';
import 'package:myfhb/QurHub/Controller/QurHubController.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class AddNetWorkView extends StatefulWidget {
  @override
  _AddNetWorkViewState createState() => _AddNetWorkViewState();
}

class _AddNetWorkViewState extends State<AddNetWorkView> {
  final controller = Get.put(
    QurHubController(),
  );
  final wifiNameController = TextEditingController();
  FocusNode wifiNameFocus = FocusNode();

  final passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();

  final hubIdController = TextEditingController();
  FocusNode hubIdFocus = FocusNode();

  final nickNameController = TextEditingController();
  FocusNode nickNameFocus = FocusNode();

  @override
  void initState() {
    try {
      super.initState();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    try {
      FocusManager.instance.primaryFocus.unfocus();
      fbaLog(eveName: 'qurbook_screen_event', eveParams: {
        'eventTime': '${DateTime.now()}',
        'pageName': 'AddNetWorkView Screen',
        'screenSessionTime':
            '${DateTime.now().difference(mInitialTime).inSeconds} secs'
      });
      super.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Get.back();
          },
        ),
        title: const Text(
          'Add Network',
        ),
      ),
      body: Obx(
        () {
          return controller.isLoading.value
              ? CommonCircularIndicator()
              : Center(child: _showPairNewHubBtn());
        },
      ),
    );
  }

  Widget _showPairNewHubBtn() {
    final addButtonWithGesture = GestureDetector(
      onTap: () {
        showSetNickNameDialog(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            width: 200.0.w,
            height: 47.0.h,
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
                "Pair New Hub",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  showConnectWifiDialog(BuildContext context) {
    wifiNameController.text = '';
    passwordController.text = '';

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
                width: 1.sw,
                height: 1.sh / 3.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showWifiNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showPasswordTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 15.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showConnectButton(),
                              ],
                            ),
                            SizedBox(
                              height: 25.0.h,
                            ),
                            // callAddFamilyStreamBuilder(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  Widget _showWifiNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: wifiNameController,
      keyboardType: TextInputType.text,
      focusNode: wifiNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.wifiName,
        hintText: CommonConstants.wifiName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showPasswordTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: passwordController,
      keyboardType: TextInputType.text,
      focusNode: passwordFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        //FocusScope.of(context).requestFocus(passwordFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.password,
        hintText: CommonConstants.password,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showConnectButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: () {},
      child: Container(
        width: 140.0.w,
        height: 45.0.h,
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
            CommonConstants.connect,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  showSetNickNameDialog(BuildContext context) {
    hubIdController.text = '';
    nickNameController.text = '';

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
                width: 1.sw,
                height: 1.sh / 3.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showHubIdTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              children: <Widget>[
                                _showNickNameTextField(),
                              ],
                            ),
                            SizedBox(
                              height: 15.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showSaveButton(),
                              ],
                            ),
                            SizedBox(
                              height: 25.0.h,
                            ),
                            // callAddFamilyStreamBuilder(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  Widget _showHubIdTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: hubIdController,
      keyboardType: TextInputType.text,
      focusNode: hubIdFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        FocusScope.of(context).requestFocus(nickNameFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.hubId,
        hintText: CommonConstants.hubId,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showNickNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: nickNameController,
      keyboardType: TextInputType.text,
      focusNode: nickNameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        //FocusScope.of(context).requestFocus(passwordFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.nickName,
        hintText: CommonConstants.nickName,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }

  Widget _showSaveButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: () {},
      child: Container(
        width: 140.0.w,
        height: 45.0.h,
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
            CommonConstants.save,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }
}
