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
      hubIdController.text = controller.strHubId.value;
      nickNameController.text = '';
    } catch (e) {}
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
              try {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                              height: 120,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text("Do you want to close this?"),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: Card(
                                                  color: Colors.red,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0,
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: Card(
                                                  color: Colors.green,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0,
                                                            left: 16.0,
                                                            right: 16.0),
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            )
                                          ])
                                    ],
                                  ),
                                ),
                              )));
                    }).then((val) {
                  if (val != null && val) {
                    Get.back();
                  }
                });
              } catch (e) {}
            },
          ),
          title: Text(
            'Add Network',
          ),
        ),
        body: Form(
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
                    //width: 1.sw,
                    padding: EdgeInsets.all(15),
                    height: 1.sh / 2.65,
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
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      controller.isSaveBtnLoading.isTrue
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    "Saving the Hub",
                                                  ),
                                                )
                                              ],
                                            )
                                          : _showSaveButton(),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25.0.h,
                                ),
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Obx(() => controller
                                            .isSaveBtnLoading.isTrue
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  "Saving the Hub",
                                                ),
                                              )
                                            ],
                                          )
                                        : _showSaveButton()),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.0.h,
                                ),*/
                                // callAddFamilyStreamBuilder(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )),
      );

  /*showSetNickNameDialog(BuildContext context) {
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
                height: 1.sh / 2.7,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      */ /*Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 24.0.sp,
                              ),
                              onPressed: () {
                                try {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0)),
                                            child: Container(
                                                height: 120,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            "Do you want to close this?"),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      true);
                                                                },
                                                                child: Card(
                                                                    color: Colors
                                                                        .red,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0,
                                                                          bottom:
                                                                              8.0,
                                                                          left:
                                                                              16.0,
                                                                          right:
                                                                              16.0),
                                                                      child:
                                                                          Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                width: 20,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      false);
                                                                },
                                                                child: Card(
                                                                    color: Colors
                                                                        .green,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0,
                                                                          bottom:
                                                                              8.0,
                                                                          left:
                                                                              16.0,
                                                                          right:
                                                                              16.0),
                                                                      child:
                                                                          Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    )),
                                                              )
                                                            ])
                                                      ],
                                                    ),
                                                  ),
                                                )));
                                      }).then((val) {
                                    if (val != null && val) {
                                      Navigator.of(context).pop();
                                      Get.back();
                                    }
                                  });
                                } catch (e) {}
                              })
                        ],
                      ),*/ /*
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
                                  Obx(() => controller.isSaveBtnLoading.isTrue
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
  }*/

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
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: InkWell(
          onTap: () {
            try {
              FocusScope.of(context).unfocus();
              if (formKey.currentState.validate()) {
                controller.callSaveHubIdConfig(
                    hubIdController.text.toString().trim(),
                    nickNameController.text.toString().trim(),
                    context);
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
                CommonConstants.save,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ));
  }
}
