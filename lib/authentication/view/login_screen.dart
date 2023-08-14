import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/model/Country.dart';
import '../model/patientlogin_model.dart';
import '../constants/constants.dart';
import 'authentication_validator.dart';
import 'login_validation_screen.dart';
import '../view_model/patientauth_view_model.dart';
import '../../constants/fhb_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../widgets/country_code_picker.dart';
import '../../common/CommonUtil.dart';
import '../../src/ui/loader_class.dart';

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

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    authViewModel = AuthViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Login Screen',
      'screenSessionTime':
      '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
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
                          strPhoneandPass,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                        ),
                        SizedBox(height: 20.0.h),
                        Column(
                          children: [
                            _loginTextFields(
                              TextFormField(
                                textCapitalization:
                                TextCapitalization.sentences,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                ),
                                autovalidate: _autoValidateBool,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  counterText: "",
                                  prefixIcon: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 75.0.w,
                                      minWidth: 75.0.w,
                                    ),
                                    child: CountryCodePickerPage(
                                      isFromAuthenticationScreen: true,
                                      selectedCountry: _selectedDialogCountry,
                                      onValuePicked: (country) => setState(
                                            () => _selectedDialogCountry = country,
                                      ),
                                    ),
                                  ),
                                  hintText: strNewPhoneHint,
                                  labelText: strNumberHint,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                      )),
                                ),
                                validator: (value) {
                                  return AuthenticationValidator()
                                      .phoneValidation(value!, patternPhoneNew as String,
                                      strPhoneCantEmpty);
                                },
                                controller: numberController,
                                onSaved: (value) {},
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0.h),
                        _loginsavebutton(),
                        SizedBox(height: 20.0.h),
                      ],
                    ),
                  ),
                ),
                /* Positioned(
                top: 40,
                left: 0,
              ),*/
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
              //strSignInText,
              strProceed,
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
        SignInValidationModel response = await authViewModel
            .loginPatientWithMobNo((logInModel.userName ?? ""));
        LoaderClass.hideLoadingDialog(context);
        if ((response != null) && (response?.isSuccess ?? false)) {
          if ((response.result != null) &&
              (response.result?.isRegistered ?? false)) {
            goToPatientSignInValidationScreen(0, response);
          } else {
            //TODO SignUp
          }
        } else {
          goToPatientSignInValidationScreen(1, response);
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

  goToPatientSignInValidationScreen(
      int flag, SignInValidationModel response) async {
    try {
      Get.to(PatientSignInValidationScreen(
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
