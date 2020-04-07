import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:uuid/uuid.dart';
/* import 'package:myfhb/src/model/SpeechModel.dart';
import 'package:myfhb/src/model/SpeechModelResponse.dart'; */
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'dart:convert' as convert;

class SuperMayaSample extends StatefulWidget {
  @override
  _SuperMayaSampleState createState() => _SuperMayaSampleState();
}

class _SuperMayaSampleState extends State<SuperMayaSample> {
  static const voice_platform =
      const MethodChannel('flutter.native/voiceIntent');
  static const version_platform =
      const MethodChannel('flutter.native/versioncode');
  var uuid = Uuid();
  bool _isSpeaks = false;
  String _wordsFromMaya = 'waiting for maya to speak';

  var user_id = PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);
  var auth_token = PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
  static MyProfile prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE);
  var user_name = prof.response.data.generalInfo.name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferenceUtil.init();

    //gettingReposnseFromNative();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: GradientAppBar(),
            backgroundColor: Colors.transparent,
            leading: Container(),
            elevation: 0,
            title: Text('Maya'),
            centerTitle: true,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                PreferenceUtil.getStringValue('maya_asset') != null
                    ? PreferenceUtil.getStringValue('maya_asset') + '_main.png'
                    : 'assets/maya/maya_us_main.png',
                height: 160,
                width: 160,
                //color: Colors.deepPurple,
              ),
              //Icon(Icons.people),
              Text(
                'Hi, Im super Maya your health assistance',
                softWrap: true,
              ),
              SizedBox(
                height: 30,
              ),
              /*  IconButton(
                  icon: Icon(Icons.mic),
                  iconSize: 50.0,
                  onPressed: startMayatoListen) */

              IconButton(
                  icon: Icon(Icons.mic),
                  iconSize: 50.0,
                  onPressed: () => sendToMaya())
            ],
          ),
        ));
  }

  /* void startMayatoListen() {
    if (!_isSpeaks) {
      gettingReposnseFromNative();
      setState(() {
        _isSpeaks = true;
      });

      //todo trigger the voice recogniser intent

    } else {
      setState(() {
        _isSpeaks = false;
      });
    }
  } */

/*   Future<String> gettingReposnseFromNative() async {
    //String res='';
    try {
      print('VOICE TEXT FROM NATIVE START');
      await voice_platform.invokeMethod('speakWithVoiceAssistant').then((res) {
        print('VOICE TEXT FROM NATIVE $res');

        var sModel = {
          'sender': user_id,
          'Name': user_name,
          'message': 'mohan',
          'source': 'device',
          'sessionId': 's_id',
          'authToken': auth_token,
        };

        // SpeechModel model = new SpeechModel(
        //     authToken: auth_token,
        //     name: user_name,
        //     message: message,
        //     sender: user_id,
        //     sessionId: s_id,
        //     source: 'device');
        sendToMaya(constants.MAYA_URL, body: sModel);
      });
      //TODO  call the AI api to get the result
      print('VOICE TEXT FROM NATIVE END');
    } on PlatformException catch (e) {
      //res = 'failed to get the voice data due to${e.message}';
    }

//    setState(() {
//      _wordsFromMaya=res;
//    });
  }
 */

  sendToMaya() async {
    String mayaUrl = 'https://ai.dev.vsolgmi.com/ai/api/rasa/';
    String uuidString = uuid.v1();

    print(uuidString);

    var reqJson = {};
    reqJson["sender"] = user_id;
    reqJson["Name"] = user_name;
    reqJson["message"] = "Hi";
    reqJson["source"] = "device";
    reqJson["sessionId"] = uuidString;
    reqJson["authToken"] = auth_token;

    String jsonString = convert.jsonEncode(reqJson);

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(
      mayaUrl,
      body: jsonString,
      headers: requestHeaders,
    );

    print(response.toString());
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      print('server issue');
    }
  }

  /*  Future<List<SpeechModelResponse>> sendToMaya(String url,
      {dynamic body}) async {
    final response = await http.post(url, body: {
      'sender': user_id,
      'Name': user_name,
      'message': 'Hey may!! how can u help me?',
      'source': 'device',
      'sessionId': uuid.v1(),
      'authToken': auth_token,
    });
    if (response.statusCode == 200) {
      return parseMayaSpeech(response.body);
    }

    // return await http.post(url,body: body)
    //     .then((http.Response res){
    //       final int statusCode = res.statusCode;
    //       if (statusCode < 200 || statusCode > 400 || json == null) {
    //           throw new Exception("Error while fetching data");
    //         }
    //       List response = json.decode(res.body);
    //       return  response.map((r)=>new SpeechModelResponse.fromJson(r)).toList();
    //     });
  }

  Future<List<SpeechModelResponse>> parseMayaSpeech(String body) {
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return parsed
        .map<SpeechModelResponse>((json) => SpeechModelResponse.fromJson(json))
        .toList();
  } */
}
