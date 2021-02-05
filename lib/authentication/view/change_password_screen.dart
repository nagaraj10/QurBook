import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/model/change_password_model.dart';
import 'package:myfhb/authentication/view/authentication_validator.dart';
import 'package:myfhb/authentication/model/change_password_model.dart'
    as changePasswordModel;
import 'package:myfhb/authentication/view_model/patientauth_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final OldPasswordController = TextEditingController();
  final NewPasswordController = TextEditingController();
  final NewPasswordAgainController = TextEditingController();
  FlutterToast toast = new FlutterToast();
  var isLoading = false;
  var _ChangePasswordKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  AuthViewModel authViewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authViewModel = new AuthViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Form(
        key: _ChangePasswordKey,
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .1),
                      AssetImageWidget(
                        icon: myFHB_logo,
                        height: 120,
                        width: 120,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(strChangePasswordText),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          _changepasswordTextFields(
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: strOldPasswordHintTxt,
                                labelText: strOldPasswordHintTxt,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(CommonUtil().getMyPrimaryColor()),
                                  ),
                                ),
                              ),
                              controller: OldPasswordController,
                              autovalidate: _autoValidateBool,
                              validator: (value) {
                                return AuthenticationValidator()
                                    .passwordValidation(value, patternPassword,
                                        strPassCantEmpty);
                              },
                              onSaved: (value) {},
                            ),
                          ),
                          SizedBox(height: 10),
                          _changepasswordTextFields(
                            TextFormField(
                              autovalidate: _autoValidateBool,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: strNewPasswordHintTxt,
                                labelText: strNewPasswordHintTxt,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(CommonUtil().getMyPrimaryColor()),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                return AuthenticationValidator()
                                    .passwordValidation(value, patternPassword,
                                        strPassCantEmpty);
                              },
                              controller: NewPasswordController,
                              onSaved: (value) {},
                            ),
                          ),
                          SizedBox(height: 10),
                          _changepasswordTextFields(
                            TextFormField(
                              autovalidate: _autoValidateBool,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: strNewPasswordAgainHintText,
                                labelText: strNewPasswordAgainHintText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(CommonUtil().getMyPrimaryColor()),
                                  ),
                                ),
                              ),
                              controller: NewPasswordAgainController,
                              validator: (value) {
                                return AuthenticationValidator()
                                    .confirmPasswordValidation(
                                        NewPasswordController.text,
                                        value,
                                        patternPassword,
                                        strPassCantEmpty);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
    return InkWell(
      onTap: () {
        _verifyDetails();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
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
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyPrimaryColor()),
                ])),
        child: Text(
          strChangeButtonText,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  _verifyDetails() async {
    FocusScope.of(context).unfocus();
    if (_ChangePasswordKey.currentState.validate()) {
      _ChangePasswordKey.currentState.save();
      ChangePasswordModel logInModel = new ChangePasswordModel(
        newPassword: NewPasswordAgainController.text,
        oldPassword: OldPasswordController.text,
        source: strSource,
      );
      Map<String, dynamic> map = logInModel.toJson();
      changePasswordModel.ChangePasswordModel response =
          await authViewModel.changePassword(map);
      print(response.toString());
      _checkResponse(response);
    } else {
      setState(() {
        _autoValidateBool = true;
      });
    }
  }

  _checkResponse(ChangePasswordModel response) {
    if (response.isSuccess) {
      toast.getToast(response.message, Colors.lightBlue);
      Navigator.pop(context);
    } else {
      toast.getToast(response.message, Colors.red);
    }
  }

  Widget _changepasswordTextFields(TextFormField textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }
}
