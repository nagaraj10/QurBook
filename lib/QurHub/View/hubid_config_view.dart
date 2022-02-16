import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/QurHub/Controller/add_network_controller.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

class HubIdConfigView extends StatefulWidget {
  const HubIdConfigView({Key key}) : super(key: key);

  @override
  _HubIdConfigViewState createState() => _HubIdConfigViewState();
}

class _HubIdConfigViewState extends State<HubIdConfigView> {
  final AddNetworkController controller = Get.find();
  final hubIdController = TextEditingController();
  FocusNode hubIdFocus = FocusNode();

  final nickNameController = TextEditingController();
  FocusNode nickNameFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    try {
      super.initState();
      init();
    } catch (e) {
      print(e);
    }
  }

  init() async {
    try {
      await 1.delay();
      showSetNickNameDialog(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
        body: Container(),
      );

  showSetNickNameDialog(BuildContext context) {
    hubIdController.text = controller.strHubId.value;
    nickNameController.text = '';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Container(
                width: 1.sw,
                height: 1.sh / 3.2,
                child: Form(
                  key: formKey,
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
                                  Obx(() => controller.isBtnLoading.isTrue
                                      ? CircularProgressIndicator()
                                      : _showSaveButton()),
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
                  ),
                )),
          );
        });
      },
    );
  }

  Widget _showHubIdTextField() {
    return Expanded(
        child: TextFormField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: hubIdController,
      keyboardType: TextInputType.text,
      focusNode: hubIdFocus,
      textInputAction: TextInputAction.done,
      enabled: false,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "Please enter HubId";
        }
        return null;
      },
      onFieldSubmitted: (term) {
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
        child: TextFormField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: nickNameController,
      keyboardType: TextInputType.text,
      focusNode: nickNameFocus,
      textInputAction: TextInputAction.done,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return "Please enter Nickname";
        }
        return null;
      },
      onFieldSubmitted: (term) {
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
      onTap: () {
        try {
          FocusScope.of(context).unfocus();
          if (formKey.currentState.validate()) {
            controller.callSaveHubIdConfig(
                hubIdController.text.toString().trim(),
                nickNameController.text.toString().trim());
          }
        } catch (e) {
          print(e);
        }
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
            CommonConstants.save,
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
