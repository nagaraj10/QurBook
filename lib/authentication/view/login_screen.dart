import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../../common/CommonUtil.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../constants/constants.dart';
import '../model/Country.dart';
import '../model/patientlogin_model.dart';
import '../view_model/patientauth_view_model.dart';
import '../widgets/country_code_picker.dart';
import 'authentication_validator.dart';
import 'login_validation_screen.dart';
import 'signup_screen.dart';

class PatientSignInScreen extends StatefulWidget {
  @override
  _PatientSignInScreenState createState() => _PatientSignInScreenState();
}

class _PatientSignInScreenState extends State<PatientSignInScreen> {
  Country _selectedDialogCountry = Country.fromCode(CommonUtil.REGION_CODE);
  final numberController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();
  bool _autoValidateBool = false;
  late AuthViewModel authViewModel;
  FlutterToast toast = FlutterToast();

  bool isSignInScreen = true;
  SignInValidationModel? signInValidationModel;

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBALoginScreen);
    authViewModel = AuthViewModel();
  }

  @override
  Widget build(BuildContext context) {
    var height = 1.sh;
    return Scaffold(
      body: Form(
        key: _loginKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Color(
              CommonUtil().getMyPrimaryColor(),
            ),
          ),
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
                        SizedBox(height: 20.0.h),
                        Text(
                          ENTER_MOB_NUM,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                        ),
                        SizedBox(height: 20.0.h),
                        _loginTextFields(
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            readOnly: isSignInScreen ? false : true,
                            enableInteractiveSelection: false,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                            ),
                            autovalidateMode: _autoValidateBool
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            maxLength: 10,
                            decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 75.0.w,
                                  minWidth: 75.0.w,
                                ),
                                child: CountryCodePickerPage(
                                  selectedCountry: _selectedDialogCountry,
                                  isFromAuthenticationScreen: true,
                                  onValuePicked: (country) => setState(
                                    () => _selectedDialogCountry = country,
                                  ),
                                  isEnabled: isSignInScreen
                                      ? (BASE_URL != prodUSURL)
                                      : false,
                                ),
                              ),
                              hintText: strNewPhoneHint,
                              labelText: strNumberHint,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                  )),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                  )),
                            ),
                            validator: (value) {
                              return AuthenticationValidator().phoneValidation(
                                  value!,
                                  patternPhoneNew as String,
                                  strPhoneCantEmpty);
                            },
                            controller: numberController,
                            onSaved: (value) {},
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        if (isSignInScreen) ...{
                          SizedBox(height: 20.0.h),
                          _loginsavebutton(),
                          SizedBox(height: 20.0.h),
                        } else ...{
                          SizedBox(height: 10.0.h),
                          retryButton(),
                          SizedBox(height: 20.0.h),
                          createAccountButton(),
                        }
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginTextFields(Widget textFormField) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 2), child: textFormField);
  }

  Widget _loginsavebutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            AuthenticationValidator().checkNetwork().then((intenet) {
              if (intenet != null && intenet) {
                getPatientDetails();
              } else {
                toast.getToast(strNetworkIssue, Colors.red);
              }
            });
          },
          child: Container(
            width: 260.0.w,
            padding:
                EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
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
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              strNext,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  getPatientDetails() async {
    try {
      FocusScope.of(context).unfocus();
      if (_loginKey.currentState!.validate()) {
        _loginKey.currentState!.save();
        LoaderClass.showLoadingDialog(context);
        var logInModel = PatientLogIn(
          userName:
              '${_selectedDialogCountry.phoneCode}${numberController.text}',
          password: "",
          source: strSource,
        );
        signInValidationModel = await authViewModel
            .loginPatientWithMobNo((logInModel.userName ?? ""));
        LoaderClass.hideLoadingDialog(context);
        if ((signInValidationModel != null) &&
            (signInValidationModel?.isSuccess ?? false)) {
          if ((signInValidationModel?.result != null) &&
              (signInValidationModel?.result?.isRegistered ?? false)) {
            Get.to(PatientSignInValidationScreen(
              flag: 0,
              signInValidationModel: signInValidationModel,
              selDialogCountry: _selectedDialogCountry,
              mobNo: numberController.text.trim(),
            ));
          } else {
            Get.to(PatientSignUpScreen(
              flag: 1,
              signInValidationModel: signInValidationModel,
              selDialogCountry: _selectedDialogCountry,
              mobNo: numberController.text.trim(),
            ));
          }
        } else {
          CommonUtil.showCommonMsgDialog(msg: strCheckValidNumber);
          onChangeScreen(false);
        }
      } else {
        setState(() {
          _autoValidateBool = true;
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  onChangeScreen(bool signInScreen) {
    setState(() {
      isSignInScreen = signInScreen;
    });
  }

  Widget retryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            onChangeScreen(true);
          },
          child: Container(
            width: 260.0.w,
            padding:
                EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
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
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              strNext,
              style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget createAccountButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            SignInValidationModel signInValidationModel =
                SignInValidationModel();
            goToPatientSignUpScreen(0, signInValidationModel);
          },
          child: Container(
            width: 260.0.w,
            padding:
                EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border:
                    Border.all(color: Color(CommonUtil().getMyPrimaryColor()))),
            child: Text(
              strCreateAccount,
              style: TextStyle(
                  fontSize: 16.0.sp,
                  color: Color(CommonUtil().getMyPrimaryColor())),
            ),
          ),
        ),
      ],
    );
  }

  goToPatientSignUpScreen(int flag, SignInValidationModel response) async {
    try {
      Get.to(PatientSignUpScreen(
        flag: flag,
        signInValidationModel: response,
        selDialogCountry: _selectedDialogCountry,
        mobNo: numberController.text.trim(),
      ));
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}
