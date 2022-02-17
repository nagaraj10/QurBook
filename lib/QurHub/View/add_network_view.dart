import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/QurHub/Controller/add_network_controller.dart';
import 'package:myfhb/QurHub/View/wifi_list_view.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import '../../../constants/variable_constant.dart' as variable;

class AddNetWorkView extends StatefulWidget {
  @override
  _AddNetWorkViewState createState() => _AddNetWorkViewState();
}

class _AddNetWorkViewState extends State<AddNetWorkView> {
  final controller = Get.put(AddNetworkController());
  final wifiNameController = TextEditingController();
  FocusNode wifiNameFocus = FocusNode();

  final passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    try {
      controller.getWifiList();
      super.initState();
    } catch (e) {}
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
    } catch (e) {}
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
        title: Text(
          'Add Network',
        ),
      ),
      body: Obx(() => controller.isLoading.isTrue
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : controller.qurHubWifiRouter == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        controller.errorMessage.value,
                      ),
                    ),
                    SizedBox(
                      height: 20.00,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          controller.getWifiList();
                        } catch (e) {}
                      },
                      child: Container(
                        width: 145.0.w,
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
                            CommonConstants.retry,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: Card(
                      margin: EdgeInsets.only(top: 60, left: 25, right: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        /*side: BorderSide(width: 5, color: Colors.green)*/
                      ),
                      child: Container(
                          padding: EdgeInsets.only(
                              top: 15, left: 15, right: 15, bottom: 15),
                          //width: 1.sw,
                          height: 1.sh / 2.85,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Obx(() =>
                                              controller.isBtnLoading.isTrue
                                                  ? CircularProgressIndicator()
                                                  : _showConnectButton()),
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
                    ),
                  ))),
    );
  }

  Widget _showWifiNameTextField() {
    wifiNameController.text = controller.strSSID.value;
    return Expanded(
        child: TextFormField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: wifiNameController,
      keyboardType: TextInputType.text,
      enabled: true,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "Please enter wifi name";
        }
        return null;
      },
      focusNode: wifiNameFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: SvgPicture.asset(
            variable.icon_qurhub_wifi,
            //color: Colors.black54,
            //color: Colors.black,
            height: 22,
            width: 22,
            color: wifiNameFocus.hasFocus ? Colors.black : Colors.black54,
            fit: BoxFit.fill,
          ),
          onPressed: () {},
        ),
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            variable.icon_qurhub_switch,
            //color: Colors.black54,
            //color: Colors.black,
            height: 22,
            width: 22,
            color: wifiNameFocus.hasFocus ? Colors.black : Colors.black54,
            fit: BoxFit.fill,
          ),
          onPressed: () {
            try {
              Get.to(
                WifiListView(),
              );
            } catch (e) {}
          },
        ),
        labelText: CommonConstants.wifiName,
        hintText: CommonConstants.wifiName,
        /*suffix: InkWell(
          onTap: () {
            //TODO
          },
          child: SvgPicture.asset(
            variable.icon_qurhub_wifi,
            color: Colors.black54,
          ),
        ),*/
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
        child: TextFormField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: passwordController,
      keyboardType: TextInputType.text,
      focusNode: passwordFocus,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "Please enter password";
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (term) {
        //FocusScope.of(context).requestFocus(passwordFocus);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        prefixIcon: IconButton(
          icon: SvgPicture.asset(
            variable.icon_qurhub_lock,
            //color: Colors.black54,
            //color: Colors.black,
            height: 22,
            width: 22,
            color: passwordFocus.hasFocus ? Colors.black : Colors.black54,
            fit: BoxFit.fill,
          ),
          onPressed: () {},
        ),
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
    final addButtonWithGesture = InkWell(
      onTap: () {
        try {
          FocusScope.of(context).unfocus();
          if (formKey.currentState.validate()) {
            controller.getConnectWifi(wifiNameController.text.toString().trim(),
                passwordController.text.toString().trim());
          }
        } catch (e) {}
      },
      child: Container(
        width: 150.0.w,
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
              fontWeight: FontWeight.w600,
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
