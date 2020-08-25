import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/bot/ConversationModel.dart';
import 'package:myfhb/src/model/bot/SpeechModelResponse.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  List<Conversation> conversation;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  static var uuid = Uuid().v1();
  bool _isSpeaks = false;

  var user_id = PreferenceUtil.getStringValue(constants.KEY_USERID_MAIN);
  var auth_token = PreferenceUtil.getStringValue(constants.KEY_AUTHTOKEN);
  static MyProfile prof =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  var user_name = prof.response.data.generalInfo.name;
  List<Conversation> conversations = new List();
  var isMayaSpeaks = -1;
  var isEndOfConv = false;
  var stopTTSNow = false;
  var isLoading = false;
  var isListening = false;

  AnimationController _controller;

  Animation<double> _animation;
  MyProfile myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  ScrollController controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    startMayaAutomatically();
  }

  startMayaAutomatically() {
    Future.delayed(Duration(seconds: 1), () {
      sendToMaya(variable.strhiMaya);
    });

    var date = new FHBUtils().getFormattedDateString(DateTime.now().toString());
    Conversation model = new Conversation(
      isMayaSaid: false,
      text: variable.strhiMaya,
      name: prof.response.data.generalInfo.name,
      timeStamp: date,
    );
    conversations.add(model);
    setState(() {});
    chatData(conversations);
  }

  @override
  void dispose() {
    _controller.dispose();
    stopTTSNow = true;
    stopTTSEngine();
    super.dispose();
  }

  stopTTSEngine() async {
    await variable.tts_platform.invokeMethod(variable.strtts,
        {parameters.strMessage: "", parameters.strIsClose: true});
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 1000),
        () => controller.jumpTo(controller.position.maxScrollExtent));
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: Text(variable.strMaya),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: _backToPrevious),
      ),
      body: chatData(conversations),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isLoading) {
            //gettingReposnseFromNative();
          } else if (isMayaSpeaks <= 0) {
            stopTTSEngine();
            gettingReposnseFromNative();
          } else {
            gettingReposnseFromNative();
          }
        },
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

  _backToPrevious() async {
    stopTTSNow = true;
    stopTTSEngine();
    Navigator.pop(context);
  }

  Widget _pleaseWait() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              variable.strtapToSpeak,
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
    isListening = true;
    try {
      await variable.voice_platform
          .invokeMethod(variable.strspeakAssistant)
          .then((response) {
        isListening = false;
        sendToMaya(response);
        var date =
            new FHBUtils().getFormattedDateString(DateTime.now().toString());
        Conversation model = new Conversation(
          isMayaSaid: false,
          text: response,
          name: prof.response.data.generalInfo.name,
          timeStamp: date,
        );
        conversations.add(model);
        setState(() {
          chatData(conversations);
        });
      });
    } on PlatformException catch (e) {}
  }

  sendToMaya(String msg) async {
    String mayaUrl = CommonUtil.MAYA_URL;
    String uuidString = uuid;

    var reqJson = {};
    reqJson[parameters.strSender] = user_id;
    reqJson[parameters.strSenderName] = user_name;
    reqJson[parameters.strMessage] = msg;
    reqJson[parameters.strSource] = variable.strdevice;
    reqJson[parameters.strSessionId] = uuidString;
    reqJson[parameters.strAuthtoken] = auth_token;

    String jsonString = convert.jsonEncode(reqJson);

    HeaderRequest headerRequest = new HeaderRequest();

    var response = await http.post(
      mayaUrl,
      body: jsonString,
      headers: await headerRequest.getRequesHeaderWithoutToken(),
    );

    if (response.statusCode == 200) {
      if (response.body != null) {
        var jsonResponse = convert.jsonDecode(response.body);

        List<dynamic> list = jsonResponse;
        if (list.length > 0) {
          SpeechModelResponse res = SpeechModelResponse.fromJson(list[0]);

          setState(() {
            isEndOfConv = res.endOfConv;
          });
          var date =
              new FHBUtils().getFormattedDateString(DateTime.now().toString());
          Conversation model = new Conversation(
            isMayaSaid: true,
            text: res.text,
            name: prof.response.data.generalInfo.name,
            imageUrl: res.imageURL,
            timeStamp: date,
          );
          conversations.add(model);
          isLoading = true;
          chatData(conversations);
          Future.delayed(Duration(seconds: 4), () {
            isLoading = false;
            isMayaSpeaks = 0;
            if (!stopTTSNow) {
              variable.tts_platform.invokeMethod(variable.strtts, {
                parameters.strMessage: res.text,
                parameters.strIsClose: false
              }).then((res) {
                if (res == 1) {
                  isMayaSpeaks = 1;
                }
                if (!isEndOfConv && !isListening) {
                  gettingReposnseFromNative();
                } else {
                  refreshData();
                }
              });
            }
          });
          return jsonResponse;
        }
      }
    }
  }

  Widget chatData(List<Conversation> con) {
    if (con.length == 0) {
      return _pleaseWait();
    } else {
      return Container(
          padding: EdgeInsets.only(bottom: 50),
          color: Colors.white70,
          child: ListView.builder(
              controller: controller,
              reverse: false,
              itemCount: con.length,
              itemBuilder: (BuildContext ctxt, int index) => Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: con[index].isMayaSaid
                      ? receiverLayout(con[index], ctxt)
                      : senderLayout(con[index], ctxt))));
    }
  }

  Widget senderLayout(Conversation c, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              c.name.toUpperCase(),
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
                  c.text,
                  style: Theme.of(context).textTheme.body1.apply(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            Text(
              "${c.timeStamp}",
              style:
                  Theme.of(context).textTheme.body1.apply(color: Colors.grey),
            ),
          ],
        ),
        ClipOval(
            child: Container(
          height: 40,
          width: 40,
          child: FHBBasicWidget().getProfilePicWidgeUsingUrl(
              myProfile.response.data.generalInfo.profilePicThumbnailURL),
        )),
        SizedBox(width: 20),
      ],
    );
  }

  Widget receiverLayout(Conversation c, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Image.asset(
            PreferenceUtil.getStringValue(constants.keyMayaAsset) != null
                ? PreferenceUtil.getStringValue(constants.keyMayaAsset) + '.png'
                : variable.icon_maya,
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
              variable.strMAYA,
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
                child: FutureBuilder(
                  future: mayaData(c, context),
                  builder: (BuildContext context, snapshot) {
                    return snapshot.hasData
                        ? snapshot.data
                        : Loading(
                            indicator: BallPulseIndicator(),
                            size: 20.0,
                            color: Colors.white);
                  },
                ),
              ),
            ),
            Text(
              "${c.timeStamp}",
              style:
                  Theme.of(context).textTheme.body1.apply(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 20),
      ],
    );
  }

  Future<Widget> mayaData(Conversation c, BuildContext context) {
    return Future.delayed(
      Duration(seconds: 3),
      () => Column(
        children: <Widget>[
          Text(
            c.text,
            style: Theme.of(context).textTheme.body1.apply(
                  color: Colors.white,
                ),
          ),
          c.imageUrl != null
              ? Padding(
                  child: Image.network(
                    c.imageUrl,
                    height: (MediaQuery.of(context).size.width * .6) - 5,
                    width: (MediaQuery.of(context).size.width * .6) - 5,
                    fit: BoxFit.cover,
                  ),
                  padding: EdgeInsets.all(10),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }

  void refreshData() {
    var _healthReportListForUserBlock = new HealthReportListForUserBlock();
    _healthReportListForUserBlock.getHelthReportList().then((value) {
      PreferenceUtil.saveCompleteData(
          constants.KEY_COMPLETE_DATA, value.response.data);
    });
  }
}
