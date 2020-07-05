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
    //getDeviceLocale();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.white,
        //NOTE commented app bar
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
                  'Welcome',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      //TODO chnage theme
                      color: Color(new CommonUtil().getMyPrimaryColor()),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Get started with myFHB',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),

              /*    Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Enter your mobile number',
                      style: TextStyle(
                          color: Colors.black38, fontWeight: FontWeight.w500),
                    ),
                  ), */
              Padding(
                padding: EdgeInsets.all(20),
                child: ImageIcon(
                  AssetImage('assets/icons/otp_icon.png'),
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
                    //crossAxisAlignment: CrossAxisAlignment.baseline,
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
                        //margin: EdgeInsets.only(left: 30, right: 30),
                        width: 1,
                        height: 30,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      Expanded(
                          child: mobileNumberField(
                              _loginBloc, phoneTextController)),
                      /* Container(
                            //margin: EdgeInsets.only(left: 30, right: 30),
                            width: 1,
                            height: 20,
                            color: Colors.grey.withOpacity(0.5),
                          ), */
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              /*  InkWell(
                    child: Container(
                      child: Text('New Member? Sign Up'),
                      padding: EdgeInsets.all(10),
                    ),
                    onTap: () {
                      PageNavigator.goTo(context, '/sign_up_screen');
                    },
                  ), */
              SizedBox(height: 20),
              submitButton(
                  _loginBloc, _selected.dialingCode, phoneTextController),
              SizedBox(height: 20)
            ],
          ),
        ));
  }

  moveToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        PageNavigator.goTo(context, '/home-screen');
      });
    });
  }

  Widget mobileNumberField(bloc, TextEditingController textController) {
    return StreamBuilder<String>(
      stream: bloc.mobileNumber,
      builder: (context, snapshot) {
        return TextField(
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
              hintStyle: TextStyle(fontSize: 12)),
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
                'NEXT',
                style: TextStyle(color: Colors.white, fontSize: 16),
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
                        //PageNavigator.goTo(context, '/sign_up_screen');
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

  /*  void getDeviceLocale() async {
    String locale = await Devicelocale.currentLocale;
    List localeList = locale.split('_');
    _selected = Country.localeList[1];
  
  } */
}
