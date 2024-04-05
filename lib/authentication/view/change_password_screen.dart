import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../../common/CommonUtil.dart';
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../constants/constants.dart';
import '../model/change_password_model.dart';
import '../view_model/patientauth_view_model.dart';
import 'authentication_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final OldPasswordController = TextEditingController();
  final NewPasswordController = TextEditingController();
  final NewPasswordAgainController = TextEditingController();
  FlutterToast toast = FlutterToast();
  var isLoading = false;
  final _ChangePasswordKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  late AuthViewModel authViewModel;
  @override
  void initState() {
    super.initState();
    authViewModel = AuthViewModel();
  }

  @override
  Widget build(BuildContext context) {
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _ChangePasswordKey,
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: CommonUtil().isTablet! ? 50 : 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .1),
                      AssetImageWidget(
                        icon: myFHB_logo,
                        height: 120.0.h,
                        width: 120.0.h,
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Text(
                        strChangePasswordText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                        ),
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Column(
                        children: [
                          _changepasswordTextFields(
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: strOldPasswordHintTxt,
                                labelText: strOldPasswordHintTxt,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color:
                                        mAppThemeProvider.primaryColor,
                                  ),
                                ),
                              ),
                              controller: OldPasswordController,
                              autovalidateMode: _autoValidateBool
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              validator: (value) {
                                return AuthenticationValidator()
                                    .passwordValidation(
                                        value!,
                                        patternPassword as String,
                                        strPassCantEmpty);
                              },
                              onSaved: (value) {},
                            ),
                          ),
                          SizedBox(height: 10.0.h),
                          _changepasswordTextFields(
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                              ),
                              autovalidateMode: _autoValidateBool
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: strNewPasswordHintTxt,
                                labelText: strNewPasswordHintTxt,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color:
                                        mAppThemeProvider.primaryColor,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                return AuthenticationValidator()
                                    .passwordValidation(
                                        value!,
                                        patternPassword as String,
                                        strPassCantEmpty);
                              },
                              controller: NewPasswordController,
                              onSaved: (value) {},
                            ),
                          ),
                          SizedBox(height: 10.0.h),
                          _changepasswordTextFields(
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                              ),
                              autovalidateMode: _autoValidateBool
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: strNewPasswordAgainHintText,
                                labelText: strNewPasswordAgainHintText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color:
                                        mAppThemeProvider.primaryColor,
                                  ),
                                ),
                              ),
                              controller: NewPasswordAgainController,
                              validator: (value) {
                                return AuthenticationValidator()
                                    .confirmPasswordValidation(
                                        NewPasswordController.text,
                                        value,
                                        patternPassword as String,
                                        strPassCantEmpty);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0.h,
                      ),
                      _changePassword(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changePassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            _verifyDetails();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 15.0.sp,
              horizontal: 15.0.sp,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(end: Alignment.centerRight, colors: [
                  mAppThemeProvider.primaryColor,
                  mAppThemeProvider.primaryColor,
                ])),
            child: Text(
              strChangeButtonText,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _verifyDetails() async {
    FocusScope.of(context).unfocus();
    if (_ChangePasswordKey.currentState!.validate()) {
      _ChangePasswordKey.currentState!.save();
      var logInModel = ChangePasswordModel(
        newPassword: NewPasswordAgainController.text,
        oldPassword: OldPasswordController.text,
        source: strSource,
      );
      final map = logInModel.toJson();
      var response = await authViewModel.changePassword(map);
      print(response.toString());
      _checkResponse(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(ChangePasswordModel response) {
    if (response.isSuccess!) {
      toast.getToast(response.message!, Colors.lightBlue);
      Navigator.pop(context);
    } else {
      toast.getToast(response.message!, Colors.red);
    }
  }

  Widget _changepasswordTextFields(TextFormField textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }
}
