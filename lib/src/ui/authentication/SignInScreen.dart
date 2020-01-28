import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/model/Authentication/SignIn.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/authentication/OtpVerifyScreen.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LoginBloc _loginBloc;
  var _selected = Country.IN;
  TextEditingController phoneTextController = new TextEditingController();

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
        resizeToAvoidBottomInset: false,
        body: Stack(
          //alignment: Alignment.center,
          children: <Widget>[
            Container(child: Image.asset('assets/bg/login-bg.png')),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CountryPicker(
                        nameTextStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        dialingCodeTextStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        dense: false,
                        showFlag: true, //displays flag, true by default
                        showDialingCode:
                            true, //displays dialing code, false by default
                        showName: true, //displays country name, true by default
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
                        margin: EdgeInsets.only(left: 30, right: 30),
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      SizedBox(height: 20),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          width: double.infinity,
                          child: mobileNumberField(
                              _loginBloc, phoneTextController)),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        Constants.SignInOtpText,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      submitButton(_loginBloc, _selected.dialingCode,
                          phoneTextController)
                    ],
                  ),
                ),
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
                margin: EdgeInsets.only(left: 40, right: 40, top: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right 10  horizontally
                        5.0, // Move to bottom 5 Vertically
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Image.asset('assets/login_icon.png')],
              ),
            )
          ],
        )

        /*Center(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Constants.ENTER_MOB_NUM,
              textAlign: TextAlign.start,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CountryPicker(
                  dense: false,
                  showFlag: true, //displays flag, true by default
                  showDialingCode:
                      true, //displays dialing code, false by default
                  showName: false, //displays country name, true by default
                  showCurrency: false, //eg. 'British pound'
                  showCurrencyISO: false, //eg. 'GBP'
                  onChanged: (Country country) {
                    setState(() {
                      _selected = country;
                      print('selected country code : ${country.dialingCode}');
                    });
                  },
                  selectedCountry: _selected,
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: mobileNumberField(_loginBloc)),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 1,
              color: Colors.blueGrey.withOpacity(0.5),
            ),
            SizedBox(height: 20),
            submitButton(_loginBloc, _selected.dialingCode),
            StreamBuilder<ApiResponse<SignIn>>(
              stream: _loginBloc.signInStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return CircularProgressIndicator();
                      break;

                    case Status.ERROR:
                      return Text('Oops, something went wrong',
                          style: TextStyle(color: Colors.red));
                      break;

                    case Status.COMPLETED:
                      print(snapshot.data.message);
                      moveToNextScreen();
                      return Container();
                      break;
                  }
                } else {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                }
              },
            ),
          ],
        ),
      )),*/
        );
  }

  moveToNextScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        // PageNavigator.goTo(context, '/otp_verification_screen');
        PageNavigator.goTo(context, '/home_screen');
      });
    });
  }
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
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(minWidth: 220, maxWidth: double.infinity),
        child: RaisedGradientButton(
            child: Text(
              'NEXT',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            gradient: LinearGradient(
              colors: <Color>[Colors.deepPurple[300], Colors.deepPurple],
            ),
            onPressed: //snapshot.hasData ? bloc.submit : null,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpVerifyScreen(
                          enteredMobNumber: phoneTextController.text,
                          selectedCountryCode: countryCode,
                        )),
              );
            }),
      );
    },
  );
}
