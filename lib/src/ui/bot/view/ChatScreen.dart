import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/bot/common/botutils.dart';
import 'package:myfhb/src/ui/bot/view/sheela_arguments.dart';
import 'package:myfhb/src/ui/bot/widgets/chatdata.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/model/bot/ConversationModel.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  //List<Conversation> conversation;
  final SheelaArgument arguments;

  ChatScreen({this.arguments});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;

  Animation<double> _animation;
  MyProfileModel myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);
  ScrollController controller = new ScrollController();
  bool isFromQurhome = PreferenceUtil.getIfQurhomeisAcive();
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
    Provider.of<ChatScreenViewModel>(context, listen: false)?.isMicListening =
        false;
    Provider.of<ChatScreenViewModel>(context, listen: false)
        ?.getDeviceSelectionValues();
    PreferenceUtil.init();
    animationController = AnimationController(
        duration: const Duration(
          milliseconds: 600,
        ),
        vsync: this,
        value: 0.0);
    _animation =
        Tween<double>(begin: 0.0, end: 15.0).animate(animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animationController.forward();
            }
          });
    getMyViewModel().uuid = Uuid().v1();

    getMyViewModel().clearMyConversation();
    if (widget?.arguments?.takeActiveDeviceReadings &&
        PreferenceUtil.getIfQurhomeisAcive()) {
      getMyViewModel().addToSheelaConversation(
        text: "Your SPO2 device is connected & reading values. Please wait",
      );
      getMyViewModel().setupListenerForReadings();
    } else if (widget?.arguments?.isFromBpReading &&
        PreferenceUtil.getIfQurhomeisAcive()) {
      getMyViewModel().addToSheelaConversation(
        text: "Your BP device is connected & reading values. Please wait..",
      );
      getMyViewModel().updateBPUserData();
    } else if ((widget?.arguments?.eId ?? '').isNotEmpty) {
      getMyViewModel().eId = widget?.arguments?.eId;
      getMyViewModel().sendToMaya(constants.KIOSK_SHEELA);
      getMyViewModel().uuid = Uuid().v1();
    } else if (widget?.arguments?.scheduleAppointment ?? false) {
      getMyViewModel().scheduleAppointment = true;
      getMyViewModel().sendToMaya(constants.KIOSK_SHEELA);
      getMyViewModel().uuid = Uuid().v1();
    }else {
    } else {
      if ((widget?.arguments?.sheelaInputs ?? '').isNotEmpty) {
        getMyViewModel(
          sheelaInputs: widget?.arguments?.sheelaInputs,
        );
      } else {
        widget?.arguments?.isSheelaAskForLang
            ? getMyViewModel().askUserForLanguage(
                message: widget?.arguments?.rawMessage,
              )
            : getMyViewModel().startMayaAutomatically(
                message: widget?.arguments?.rawMessage,
              );
      }
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
  void deactivate() {
    Provider.of<ChatScreenViewModel>(context, listen: false)
        ?.conversations
        ?.clear();
    super.deactivate();
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
    animationController?.dispose();
    Provider.of<ChatScreenViewModel>(context, listen: false)?.disposeTimer();
    super.dispose();
  }

  List<PopupMenuItem<String>> getSupportedLanguages() {
    stopTTSEngine();
    Provider.of<ChatScreenViewModel>(context, listen: false)?.isMicListening =
        false;
    List<PopupMenuItem<String>> languagesMenuList = [];
    String currentLanguage = '';
    final lan = Utils.getCurrentLanCode();
    if (lan != "undef") {
      final langCode = lan.split("-").first;
      currentLanguage = langCode;
    }
    CommonUtil.supportedLanguages.forEach((
      language,
      languageCode,
    ) {
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
                      CommonUtil.langaugeCodes[value ?? 'undef']);
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

  AppBar getQurhomeAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: CommonUtil().isTablet ? 110.00 : null,
      centerTitle: true,
      elevation: 0,
      title: CommonUtil().isTablet
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon_mayaMain,
                  height: 32.h,
                  width: 32.h,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  variable.strMaya,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset(
                  icon_mayaMain,
                  height: 30.h,
                  width: 30.h,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  variable.strMaya,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
      leading: Container(
        margin: EdgeInsets.only(
          left: 8.h,
        ),
        child: InkWell(
          onTap: () {
            _backToPrevious();
          },
          child: CommonUtil().isTablet
              ? AssetImageWidget(
                  icon: icon_qurhome,
                  height: 48.h,
                  width: 48.h,
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.h,
                    vertical: 4.h,
                  ),
                  child: AssetImageWidget(
                    icon: icon_qurhome,
                    height: 30.h,
                    width: 30.h,
                  ),
                ),
        ),
      ),
      bottom: PreferredSize(
        child: Container(
          color: Color(
            CommonUtil().getQurhomeGredientColor(),
          ),
          height: 1.0,
        ),
        preferredSize: Size.fromHeight(
          1.0,
        ),
      ),
    );
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
        appBar: isFromQurhome
            ? getQurhomeAppbar()
            : AppBar(
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
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: 10.0.w,
                        ),
                        child: Image.asset(
                          variable.icon_language,
                          width: 35.0.sp,
                          height: 35.0.sp,
                        ),
                      ),
                      onSelected: (languageCode) {
                        PreferenceUtil.saveString(constants.SHEELA_LANG,
                            CommonUtil.langaugeCodes[languageCode ?? 'undef']);
                        Provider.of<ChatScreenViewModel>(context, listen: false)
                            .updateDeviceSelectionModel(
                          preferredLanguage: languageCode,
                        );
                      },
                      itemBuilder: (BuildContext context) =>
                          getSupportedLanguages(),
                    ),
                  ),
                ],
              ),
        body: Consumer<ChatScreenViewModel>(
          builder: (contxt, model, child) {
            if (model?.isMicListening ?? false) {
              animationController?.reset();
              animationController?.forward();
            } else {
              animationController?.stop();
            }
            isLoading = model.isLoading;
            closeIfByeSaid(model.conversations);
            return ChatData(conversations: model.getMyConversations);
          },
        ),
        bottomNavigationBar: Container(
          height: 0,
        ),
        floatingActionButton: Visibility(
          visible:
              !Provider.of<ChatScreenViewModel>(context).getIsButtonResponse,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all((_animation?.value ?? 0)),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Provider.of<ChatScreenViewModel>(context).isMicListening
                            ? Colors.redAccent.shade100
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all((15.0 - (_animation?.value ?? 0))),
                  child: child,
                ),
              );
            },
            child: FloatingActionButton(
              onPressed: Provider.of<ChatScreenViewModel>(context).isLoading
                  ? null
                  : () {
                      if (getMyViewModel().isLoading ||
                          (getMyViewModel().isMicListening ?? false)) {
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
              elevation: 10,
              child: Icon(
                Provider.of<ChatScreenViewModel>(context).isSheelaSpeaking
                    ? Icons.pause
                    : Provider.of<ChatScreenViewModel>(context).isLoading
                        ? Icons.mic_off
                        : Icons.mic,
                color: Colors.white,
              ),
              backgroundColor:
                  Provider.of<ChatScreenViewModel>(context).isMicListening
                      ? Colors.red
                      : Provider.of<ChatScreenViewModel>(context).isLoading
                          ? Colors.black45
                          : isFromQurhome
                              ? Color(CommonUtil().getQurhomeGredientColor())
                              : Color(CommonUtil().getMyPrimaryColor()),
            ),
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
    Provider.of<ChatScreenViewModel>(context, listen: false).movedToBackScreen =
        true;
    Provider.of<ChatScreenViewModel>(context, listen: false).disposeTimer();
    Navigator.pop(context);
  }
}
