import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/model/bot/ConversationModel.dart';
import 'package:myfhb/src/model/bot/SpeechModelResponse.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:uuid/uuid.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  List<Conversation> conversation;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  static const voice_platform =
      const MethodChannel('flutter.native/voiceIntent');
  static const version_platform =
      const MethodChannel('flutter.native/versioncode');
  static const tts_platform =
      const MethodChannel('flutter.native/textToSpeech');
  static var uuid = Uuid().v1();
  bool _isSpeaks = false;
  String _wordsFromMaya = 'waiting for maya to speak';

  var user_id = PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);
  var auth_token = PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
  static MyProfile prof = PreferenceUtil.getProfileData(constants.KEY_PROFILE);
  var user_name = prof.response.data.generalInfo.name;
  List<Conversation> conversations = new List();

  AnimationController _controller;

  Animation<double> _animation;
  MyProfile myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferenceUtil.init();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    //myUUID=uuid.v1();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000),
        () => controller.jumpTo(controller.position.maxScrollExtent));
    return Scaffold(
      appBar: AppBar(
        title: Text('Maya'),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: _backToPrevious),
      ),
      body: chatData(conversations),
      floatingActionButton: FloatingActionButton(
        onPressed: gettingReposnseFromNative,
        //onPressed: dummyConversation,
        child: Icon(
          Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _backToPrevious() {
    Navigator.pop(context);
  }

  Widget _pleaseWait() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Tap to Speak",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Color(new CommonUtil().getMyPrimaryColor())),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gettingReposnseFromNative() async {
    //String res='';
    try {
      await voice_platform
          .invokeMethod('speakWithVoiceAssistant')
          .then((response) {
        sendToMaya(response);
        Conversation model = new Conversation(
            isMayaSaid: false,
            text: response,
            imageUrl: 'http://placehold.it/120x120&text=image1',
            name: prof.response.data.generalInfo.name);
        conversations.add(model);
        setState(() {});
        chatData(conversations);
      });
    } on PlatformException catch (e) {
      //res = 'failed to get the voice data due to${e.message}';
    }
  }

  sendToMaya(String msg) async {
    //String mayaUrl = 'https://ai.dev.vsolgmi.com/ai/api/rasa/';
    String mayaUrl = 'https://ai.vsolgmi.com/ai/api/rasa/';
    String uuidString = uuid;

    print(uuidString);

    var reqJson = {};
    reqJson["sender"] = user_id;
    reqJson["Name"] = user_name;
    reqJson["message"] = msg;
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
      List<dynamic> list = jsonResponse;
      SpeechModelResponse res = SpeechModelResponse.fromJson(list[0]);
      print(res.text);
      Conversation model = new Conversation(
          isMayaSaid: true,
          text: res.text,
          imageUrl: 'http://placehold.it/120x120&text=image1',
          name: prof.response.data.generalInfo.name);
      conversations.add(model);
      setState(() {});
      chatData(conversations);
      print('current length of ${conversations.length}');
      await tts_platform
          .invokeMethod('textToSpeech', {"message": res.text}).then((res) {
        print('speech to text implement');
      });
      return jsonResponse;
    } else {
      print('server issue');
    }
  }

  Widget chatData(List<Conversation> con) {
    if (con.length == 0) {
      return _pleaseWait();
    } else {
      return Container(
          color: Colors.white70,
          child: ListView.builder(
              controller: controller,
              reverse: true,
              itemCount: con.length,
              itemBuilder: (BuildContext ctxt, int index) => Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: con[index].isMayaSaid
                      ? receiverLayout(con[index], ctxt)
                      : senderLayout(con[index], ctxt))));
    }
  }

  Widget senderLayout(Conversation c, BuildContext context) {
    var currentDate =
        new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
//          crossAxisAlignment: CrossAxisAlignment.end,
//          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "${c.name.toUpperCase()}",
              style: Theme.of(context).textTheme.body1,
              softWrap: true,
            ),
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .6,
                ),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Color(new CommonUtil().getMyPrimaryColor()),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  "${c.text}",
                  style: Theme.of(context).textTheme.body1.apply(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            //SizedBox(height: 15,),
            Text(
              "${currentDate}",
              style:
                  Theme.of(context).textTheme.body1.apply(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 20),
        ClipOval(
          child: FHBBasicWidget().getProfilePicWidget(
              myProfile.response.data.generalInfo.profilePicThumbnail),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Widget receiverLayout(Conversation c, BuildContext context) {
    var currentDate =
        new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Image.asset(
            PreferenceUtil.getStringValue('maya_asset') != null
                ? PreferenceUtil.getStringValue('maya_asset') + '.png'
                : 'assets/maya/maya_us.png',
            height: 32,
            width: 32,
          ),
          radius: 30,
          backgroundColor: Colors.white,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MAYA",
              style: Theme.of(context).textTheme.body1,
              softWrap: true,
            ),
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .6,
                ),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Color(new CommonUtil().getMyPrimaryColor()),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  "${c.text}",
                  style: Theme.of(context).textTheme.body1.apply(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            //SizedBox(height: 15,),
            Text(
              "${currentDate}",
              style:
                  Theme.of(context).textTheme.body1.apply(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
