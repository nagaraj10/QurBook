import 'dart:convert';
import 'dart:io';

import 'package:device_id/device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/model/Authentication/DeviceInfoSucess.dart';
import 'package:myfhb/src/model/Authentication/UserModel.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebCognitoScreen extends StatefulWidget {
  @override
  createState() => _WebCognitoScreenState();
}

class _WebCognitoScreenState extends State<WebCognitoScreen> {
  // var _url ='https://myfhb-dev-v3.auth.us-east-2.amazoncognito.com/login?client_id=6llcfsioe822tngnnvdndtv7ti&response_type=code&scope=aws.cognito.signin.user.admin+email+openid+phone+profile&redirect_uri=http://localhost:4200/callback';
  ApiBaseHelper apiBaseHelper = new ApiBaseHelper();

  var _url = '';
  final _key = UniqueKey();
  bool _loading = true;
  var _isPageCompleted = false;
  bool showSpinner = true;

  _WebCognitoScreenState();

  UserModel saveuser = UserModel();
  String authcode = '';
  String last_name;
  String first_name;
  String special;
  String AuthToken;
  Image doctor_image;
  String decodesstring;
  String id_token_string;
  String family_name;
  String username;
  String doctor_id;
  String user_mobile_no;
  var token1;
  String token2;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferenceUtil.init();
    getAuthCode();
  }

  @override
  Widget build(BuildContext context) {
    return (authcode != null && authcode != '')
        ? getWeBViewWidget()
        : _url != '' ? getWeBViewWidget() : getLoginURL();
    // }
  }

  getLoginURL() {
    return new FutureBuilder<String>(
      future: attemptLogIn(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            body: Center(child: new CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          return getWeBViewWidget();
        }
      },
    );
  }

  Widget getWeBViewWidget() {
    return Scaffold(
        key: _globalKey,
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: _url,
              debuggingEnabled: true,
              navigationDelegate: (NavigationRequest req) {
                if (req.url.startsWith(redirecturl)) {
                  print('blocking navigation to ${req.url}');
                  getCode(req.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
                showSpinner = false;
              },
              onPageFinished: (url) {
                setState(() {
                  showSpinner = false;
                });
              },
            )),
            showSpinner
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                    ),
                  )
                : Container(color: Colors.transparent),
            //Expanded(child: Text('$mycode')),
          ],
        ));
  }

  Future<String> attemptLogIn() async {
    Map<String, dynamic> postImage = new Map();
    postImage['source'] = source;
    var params = json.encode(postImage);
    print(params.toString());
    var res = await http.post(CommonUtil.COGNITO_AUTH_CODE,
        headers: {'Content-Type': 'application/json'}, body: params.toString());
    String jsonsDataString = res.body.toString();
    var _data = jsonDecode(jsonsDataString);
    print(_data);
    if (res.statusCode == 200) {
      String jsonsDataString = res.body.toString();
      var _data = jsonDecode(jsonsDataString);
      print(_data);
      String url = _data['loginUrl'];
      _url = _data["result"]['loginUrl'];
      print(_url);
      //return res.body;
    }
  }

// added cognito login and signup
  void getCode(String url) {
    var mURL = url;
    List slicedURL = mURL.split('=');
    mURL = slicedURL[1];
    print('onPageFinished URL: ${mURL}');
    getAuthToken('${mURL}');
    //save('authcode', '${mURL}');
  }

  save(String key, dynamic value) async {
    PreferenceUtil.saveString(key, value);
  }

  Future<String> getAuthToken(String code) async {
    Map<String, dynamic> postImage = new Map();
    postImage['authorizationCode'] = code;
    postImage['source'] = source;
    postImage['sourceCode'] = sourceCode;
    postImage['entityCode'] = entityCode;
    postImage['roleCode'] = roleCode;
    var params = json.encode(postImage);
    print(params);
    var res = await http.post(CommonUtil.COGNITO_AUTH_TOKEN,
        headers: {'Content-Type': 'application/json'}, body: params.toString());
    if (res.statusCode == 200) {
      String jsonsDataString = res.body.toString();
      var _data = jsonDecode(jsonsDataString);
      decodesstring = _data["result"];
      print(decodesstring);
      saveuser.auth_token = _data["result"];
      String userId = parseJwtPayLoad(decodesstring)['token']['userId'];
      print(userId);
      saveuser.userId = userId;
      print(userId);
      id_token_string = parseJwtPayLoad(decodesstring)['token']
          ['ProviderPayload']['id_token'];
      print(id_token_string);

      token1 = parseJwtPayLoad(decodesstring)['token']['ProviderPayload'];
      print(token1);
      String countrycode =
          parseJwtPayLoad(decodesstring)['token']['countryCode'];
      print(countrycode);
      var id_tokens = parseJwtPayLoad(id_token_string);
      print(id_tokens);
      user_mobile_no = id_tokens['phone_number'];
      print(id_tokens['phone_number']);
      saveuser.family_name = id_tokens['family_name'];
      print(id_tokens['family_name']);
      saveuser.phone_number = id_tokens['phone_number'];
      String ph = id_tokens['phone_number'];
      print(id_tokens['phone_number']);
      saveuser.birthdate = id_tokens['birthdate'];
      print(id_tokens['birthdate']);
      saveuser.given_name = id_tokens['given_name'];
      print(id_tokens['given_name']);
      saveuser.email = id_tokens['email'];
      print(id_tokens['email']);

      /* PreferenceUtil.saveInt(CommonConstants.KEY_COUNTRYCODE,
          int.parse(parseJwtPayLoad(decodesstring)['token']['countryCode']));*/
      PreferenceUtil.saveString(Constants.MOB_NUM, ph).then((onValue) {});

      PreferenceUtil.saveString(Constants.KEY_AUTHTOKEN, decodesstring)
          .then((onValue) {});
      print(decodesstring);
      PreferenceUtil.saveString(Constants.KEY_USERID_MAIN, userId)
          .then((onValue) {});
      PreferenceUtil.saveString(Constants.KEY_USERID, userId)
          .then((onValue) {});
      PreferenceUtil.save("user_details", saveuser);

      authToken = decodesstring;
      String deviceId = await DeviceId.getID;

      sendDeviceToken(userId, saveuser.email, user_mobile_no, deviceId)
          .then((value) {
        if (value != null) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DashboardScreen()));
            //Navigator.pop(context, 'code:${mURL}');
          });
        } else {
          new FHBBasicWidget().showDialogWithTwoButtons(context, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DashboardScreen()));
          }, value.message, 'Confirmation Dialog');
        }
      });
      // redirecting to dashboard screen using userid

    } else {
      print(res.body.toString());
      _globalKey.currentState.showSnackBar(SnackBar(
        content: new Text(res.body.toString()),
      ));
    }
  }

  getAuthCode() async {
    try {
      authcode = await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    } catch (e) {}
    //getAuthToken(authcode);
    //TODO: More restoring of settings would go here...
  }

  Future<DeviceInfoSucess> sendDeviceToken(String userId, String email,
      String user_mobile_no, String deviceId) async {
    var jsonParam;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    final token = await _firebaseMessaging.getToken();
    print('Firebase Token from Login Page $token');

    Map<String, dynamic> deviceInfo = new Map();
    Map<String, dynamic> user = new Map();
    Map<String, dynamic> jsonData = new Map();

    user['id'] = userId;
    deviceInfo['user'] = user;
    deviceInfo['phoneNumber'] = user_mobile_no;
    deviceInfo['email'] = email;
    deviceInfo['isActive'] = true;
    deviceInfo['deviceTokenId'] = token;

    jsonData['deviceInfo'] = deviceInfo;
    if (Platform.isIOS) {
      jsonData['platformCode'] = 'IOSPLT';
    } else {
      jsonData['platformCode'] = 'ANDPLT';
    }

    print(jsonData.toString());

    var params = json.encode(jsonData);

    print(params.toString());

    final response = await apiBaseHelper.postDeviceId('device-info', params);
    return DeviceInfoSucess.fromJson(response);
  }
}
