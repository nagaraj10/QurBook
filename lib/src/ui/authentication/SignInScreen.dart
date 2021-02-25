import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/src/ui/authentication/SignUpScreen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginBloc _loginBloc;
  var _selected = Country.IN;
  TextEditingController phoneTextController = new TextEditingController();
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffold_state,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  variable.strwelcome,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      //TODO chnage theme
                      color: Color(new CommonUtil().getMyPrimaryColor()),
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  variable.strgetStart,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ImageIcon(
                  AssetImage(variable.icon_otp),
                  size: 70,
                  color: Color(new CommonUtil().getMyPrimaryColor()),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.black54),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      CountryPicker(
                        nameTextStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        dialingCodeTextStyle: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w500),
                        dense: false,
                        showFlag: true, //displays flag, true by default
                        showDialingCode:
                            true, //displays dialing code, false by default
                        showName:
                            false, //displays country name, true by default
                        showCurrency: false, //eg. 'British pound'
                        showCurrencyISO: false, //eg. 'GBP'
                        onChanged: (Country country) {
                          setState(() {
                            _selected = country;
                          });
                        },
                        selectedCountry: _selected,
                      ),
                      Container(
                        width: 1.0.w,
                        height: 30.0.h,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                          child: mobileNumberField(
                              _loginBloc, phoneTextController)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0.h),
              SizedBox(height: 20.0.h),
              submitButton(
                  _loginBloc, _selected.dialingCode, phoneTextController),
              SizedBox(height: 20.0.h)
            ],
          ),
        ));
  }

  moveToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        PageNavigator.goTo(context, router.rt_HomeScreen);
      });
    });
  }

  Widget mobileNumberField(bloc, TextEditingController textController) {
    return StreamBuilder<String>(
      stream: bloc.mobileNumber,
      builder: (context, snapshot) {
        return TextField(
          style: TextStyle(fontSize: 14.0.sp),
          controller: textController,
          onChanged: bloc.mobileNumberChanged,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(12),
            WhitelistingTextInputFormatter.digitsOnly,
            BlacklistingTextInputFormatter.singleLineFormatter,
          ],
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              hintText: Constants.ENTER_MOB_NUM,
              hintStyle: TextStyle(fontSize: 14.0.sp)),
        );
      },
    );
  }

  Widget submitButton(LoginBloc bloc, String countryCode,
      TextEditingController phoneTextController) {
    return StreamBuilder(
      stream: bloc.submitCheck,
      builder: (context, snapshot) {
        return Container(
          //padding: EdgeInsets.all(20),
          constraints: BoxConstraints(maxWidth: 220),
          child: RaisedGradientButton(
              child: Text(
                variable.strNext,
                style: TextStyle(color: Colors.white, fontSize: 16.0.sp),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  //TODO chnage theme
                  Color(new CommonUtil().getMyPrimaryColor()),
                  Color(new CommonUtil().getMyGredientColor()),
                ],
              ),
              onPressed: () {
                new FHBUtils().check().then((intenet) {
                  if (intenet != null && intenet) {
                    bloc
                        .submit(phoneTextController.text, countryCode)
                        .then((signInResponse) {
                      if (signInResponse.message == Constants.STR_MSG_SIGNUP ||
                          signInResponse.message == Constants.STR_MSG_SIGNUP1 ||
                          signInResponse.message == Constants.STR_VERIFY_OTP ||
                          signInResponse.message == Constants.STR_VERIFY_USER)
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen(
                                enteredMobNumber: phoneTextController.text,
                                selectedCountryCode: countryCode,
                                selectedCountry: _selected.name,
                              );
                            },
                          ),
                        );
                      else {
                        PreferenceUtil.saveInt(CommonConstants.KEY_COUNTRYCODE,
                            int.parse(countryCode));
                        PreferenceUtil.saveString(
                                Constants.MOB_NUM, phoneTextController.text)
                            .then((onValue) {});
                        PreferenceUtil.saveString(
                            CommonConstants.KEY_COUNTRYNAME, _selected.name);
                        moveToNext(signInResponse, phoneTextController.text,
                            countryCode);
                      }
                    });
                  } else {
                    new FHBBasicWidget().showInSnackBar(
                        Constants.STR_NO_CONNECTIVITY, scaffold_state);
                  }
                  // No-Internet Case
                });
              }),
        );
      },
    );
  }

  void moveToNext(SignIn signIn, String phoneNumber, String countryCode) {
    if (signIn.success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return OtpVerifyScreen(
              enteredMobNumber: phoneNumber,
              selectedCountryCode: countryCode,
              fromSignIn: true,
              forEmailVerify: false,
            );
          },
        ),
      );
    } else {
      new FHBBasicWidget().getSnackBarWidget(context, signIn.message);
    }
  }
}
