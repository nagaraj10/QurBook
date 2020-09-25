import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/bot/widgets/chatdata.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/model/bot/ConversationModel.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  List<Conversation> conversation;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;
  MyProfileModel myProfile =
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
    getMyViewModel()
      ..clearMyConversation()
      ..startMayaAutomatically();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backToPrevious();
    super.dispose();
  }

  stopTTSEngine() async {
    await variable.tts_platform.invokeMethod(variable.strtts,
        {parameters.strMessage: "", parameters.strIsClose: true});
  }

  dynamic getMyViewModel() {
    return Provider.of<ChatScreenViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<ChatScreenViewModel>(
        builder: (contxt, model, child) {
          return ChatData(conversations: model.getMyConversations);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (getMyViewModel().isLoading) {
            //do nothing
          } else if (getMyViewModel().getisMayaSpeaks <= 0) {
            stopTTSEngine();
            getMyViewModel().gettingReposnseFromNative();
          } else {
            getMyViewModel().gettingReposnseFromNative();
          }
        },
        child: Icon(
          Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _backToPrevious() async {
    stopTTSEngine();
    Navigator.pop(context);
  }
}
