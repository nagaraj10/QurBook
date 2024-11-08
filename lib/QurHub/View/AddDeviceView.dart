import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../main.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../Controller/AddDeviceViewController.dart';

class AddDeviceView extends GetView<AddDeviceViewController> {
  @override
  Widget build(BuildContext context) {
    FABService.trackCurrentScreen(FBAAddNewDeviceScreen);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mAppThemeProvider.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add Device',
        ),
        elevation: 0,
      ),
      body: Obx(
        () {
          return controller.loadingData.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      getFormField(
                        controller.deviceTypeNameController,
                        'Device Type',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      getFormField(
                        controller.deviceIdController,
                        'Device ID',
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // getFormField(
                      //   controller.nickNameController,
                      //   'Nick Name',
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      getButton(),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget getButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: mAppThemeProvider.primaryColor,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        // if ((controller.nickNameController.text ?? "").isEmpty) {
        //   FlutterToast().getToast(
        //     'Please Enter Nick Name',
        //     Colors.red,
        //   );
        //   return;
        // }
        controller.saveDevice();
      },
      child: Padding(
        padding: EdgeInsets.all(
          8.0,
        ),
        child: Text(
          'Add New Device',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: CommonUtil().isTablet! ? tabHeader1 : mobileHeader1,
          ),
        ),
      ),
    );
  }

  TextFormField getFormField(
    TextEditingController control,
    String hint,
  ) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      cursorColor: mAppThemeProvider.primaryColor,
      controller: control,
      enabled: control == controller.nickNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0.sp,
        color: ColorUtils.blackcolor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: hint,
        labelStyle: TextStyle(
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w400,
          color: ColorUtils.myFamilyGreyColor,
        ),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorUtils.myFamilyGreyColor,
          ),
        ),
      ),
    );
  }
}
