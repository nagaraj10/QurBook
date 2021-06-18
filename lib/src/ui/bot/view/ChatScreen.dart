import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/bot/common/botutils.dart';
import 'package:myfhb/src/ui/bot/widgets/chatdata.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/model/bot/ConversationModel.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  //List<Conversation> conversation;
  final bool isSheelaAskForLang;
  final String langCode;
  final String sheelaInputs;
  final String rawMessage;
  ChatScreen(
      {@required this.isSheelaAskForLang,
      this.langCode,
      this.sheelaInputs,
      this.rawMessage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _controller;

  Animation<double> _animation;
  MyProfileModel myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  ScrollController controller = new ScrollController();

  bool isLoading = false;

  @override
  void initState() {
    constants.mInitialTime = DateTime.now();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<ChatScreenViewModel>(context, listen: false)?.updateAppState(
      true,
      isInitial: true,
    );
    Provider.of<ChatScreenViewModel>(context, listen: false)
        ?.getDeviceSelectionValues();
    PreferenceUtil.init();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    getMyViewModel().clearMyConversation();
    if (widget.sheelaInputs != null && widget.sheelaInputs != '') {
      getMyViewModel(sheelaInputs: widget.sheelaInputs);
    } else {
      widget.isSheelaAskForLang
          ? (widget?.rawMessage != null && widget?.rawMessage?.isNotEmpty)
              ? getMyViewModel().askUserForLanguage(message: widget?.rawMessage)
              : getMyViewModel().askUserForLanguage()
          : (widget?.rawMessage != null && widget?.rawMessage?.isNotEmpty)
              ? getMyViewModel()
                  .startMayaAutomatically(message: widget?.rawMessage)
              : getMyViewModel().startMayaAutomatically();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      Provider.of<ChatScreenViewModel>(context, listen: false)
          ?.updateAppState(false);
      stopTTSEngine();
    } else if (state == AppLifecycleState.resumed) {
      Provider.of<ChatScreenViewModel>(context, listen: false)
          .updateAppState(true);
    }
  }

  @override
  void dispose() {
    constants.fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Sheela Chat Screen',
      'screenSessionTime':
          '${DateTime.now().difference(constants.mInitialTime).inSeconds} secs'
    });
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  List<PopupMenuItem<String>> getSupportedLanguages() {
    stopTTSEngine();
    List<PopupMenuItem<String>> languagesMenuList = [];
    String currentLanguage = '';
    final lan = Utils.getCurrentLanCode();
    if (lan != "undef") {
      final langCode = lan.split("-").first;
      currentLanguage = langCode;
    }
    Utils.supportedLanguages.forEach((language, languageCode) {
      languagesMenuList.add(
        PopupMenuItem<String>(
          value: languageCode,
          child: Row(
            children: [
              Radio(
                value: languageCode,
                groupValue: currentLanguage,
                activeColor: Color(CommonUtil().getMyPrimaryColor()),
                onChanged: (value) {
                  Navigator.pop(context);
                  PreferenceUtil.saveString(constants.SHEELA_LANG,
                      Utils.langaugeCodes[value ?? 'undef']);
                  Provider.of<ChatScreenViewModel>(context, listen: false)
                      .updateDeviceSelectionModel(
                    preferredLanguage: value,
                  );
                },
              ),
              Text(
                toBeginningOfSentenceCase(language),
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ],
          ),
        ),
      );
    });
    return languagesMenuList;
  }

  stopTTSEngine() async {
    ChatScreenViewModel model = getMyViewModel();
    model.audioPlayerForTTS.stop();
    Provider.of<ChatScreenViewModel>(context, listen: false).stopTTSEngine();
  }

  // dynamic getMyViewModel() {
  //   return Provider.of<ChatScreenViewModel>(context, listen: false);
  // }

  dynamic getMyViewModel({String sheelaInputs}) {
    ChatScreenViewModel.prof =
        PreferenceUtil.getProfileData(constants.KEY_PROFILE);
    if (sheelaInputs != null && sheelaInputs != '') {
      return Provider.of<ChatScreenViewModel>(context, listen: false)
          ?.startSheelaFromDashboard(sheelaInputs);
    } else {
      return Provider.of<ChatScreenViewModel>(context, listen: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!isLoading) {
          _backToPrevious();
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: Text(variable.strMaya),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
              color: Colors.white,
            ),
            onPressed: () {
              if (!isLoading) {
                _backToPrevious();
              }
            },
          ),
          actions: [
            Visibility(
              visible: !Platform.isIOS,
              child: PopupMenuButton<String>(
                onSelected: (languageCode) {
                  PreferenceUtil.saveString(constants.SHEELA_LANG,
                      Utils.langaugeCodes[languageCode ?? 'undef']);
                  Provider.of<ChatScreenViewModel>(context, listen: false)
                      .updateDeviceSelectionModel(
                    preferredLanguage: languageCode,
                  );
                },
                itemBuilder: (BuildContext context) => getSupportedLanguages(),
              ),
            ),
          ],
        ),
        body: Consumer<ChatScreenViewModel>(
          builder: (contxt, model, child) {
            isLoading = model.isLoading;
            closeIfByeSaid(model.conversations);
            return ChatData(conversations: model.getMyConversations);
          },
        ),
        floatingActionButton: Visibility(
          visible:
              !Provider.of<ChatScreenViewModel>(context).getIsButtonResponse,
          child: FloatingActionButton(
            onPressed: Provider.of<ChatScreenViewModel>(context).isLoading
                ? null
                : () {
                    if (getMyViewModel().isLoading) {
                      //do nothing
                    } else if (getMyViewModel().isSheelaSpeaking) {
                      stopTTSEngine();
                    } else if (getMyViewModel().getisMayaSpeaks <= 0) {
                      stopTTSEngine();
                      getMyViewModel().gettingReposnseFromNative();
                    } else {
                      getMyViewModel().gettingReposnseFromNative();
                    }
                  },
            child: Icon(
              Provider.of<ChatScreenViewModel>(context).isSheelaSpeaking
                  ? Icons.pause
                  : Icons.mic,
              color: Colors.white,
            ),
            backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void closeIfByeSaid(conversations) async {
    if (conversations.length > 0) {
      Conversation conversation = conversations[conversations.length - 1];
      if (conversation?.redirect != null &&
          conversation?.screen != null &&
          !conversation.isSpeaking &&
          !conversation.loadingDots) {
        if (conversation?.screen == parameters.strDashboard &&
            conversation?.redirect) {
          Future.delayed(Duration(seconds: 1), () => _backToPrevious());
        }
      }
    }
  }

  _backToPrevious() async {
    Provider.of<ChatScreenViewModel>(context, listen: false)
        .updateAppState(false);
    stopTTSEngine();
    Navigator.pop(context);
  }
}
