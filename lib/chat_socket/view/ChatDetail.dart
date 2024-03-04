import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;


import '../../add_family_user_info/services/add_family_user_info_repository.dart';
import '../../authentication/constants/constants.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/errors_widget.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart';
import '../../src/model/Health/asgard/health_record_collection.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/ui/MyRecordsArguments.dart';
import '../../src/ui/SheelaAI/Views/youtube_player.dart';
import '../../src/ui/audio/AudioRecorder.dart';
import '../../src/ui/audio/AudioScreenArguments.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../telehealth/features/chat/constants/const.dart';
import '../../telehealth/features/chat/model/AppointmentDetailModel.dart';
import '../../telehealth/features/chat/view/ChooseDateSlot.dart';
import '../../telehealth/features/chat/view/PDFModel.dart';
import '../../telehealth/features/chat/view/PDFView.dart';
import '../../telehealth/features/chat/view/full_photo.dart';
import '../../telehealth/features/chat/viewModel/ChatViewModel.dart';
import '../constants/const_socket.dart';
import '../model/CaregiverPatientChatModel.dart';
import '../model/ChatHistoryModel.dart';
import '../model/EmitAckResponse.dart';
import '../viewModel/chat_socket_view_model.dart';
import '../viewModel/getx_chat_view_model.dart';

class ChatDetail extends StatefulWidget {
  final String? patientId;
  final String? patientName;
  final String? patientPicture;

  final String? peerId;
  final String? peerName;
  final String? peerAvatar;

  final String? carecoordinatorId;

  final bool isFromVideoCall;
  final String? message;
  final bool? isCareGiver;
  final bool isForGetUserId;
  final bool isFromFamilyListChat;
  final bool? isFromCareCoordinator;

  final String? lastDate;

  final String? groupId;
  final String? familyUserId;
  final String isNormalChatUserList;

  const ChatDetail(
      {Key? key,
      required this.peerId,
      required this.peerName,
      required this.peerAvatar,
      required this.patientId,
      required this.patientName,
      required this.patientPicture,
      required this.isFromVideoCall,
      this.groupId,
      this.message,
      this.isCareGiver,
      this.carecoordinatorId,
      this.isNormalChatUserList = 'false',
      this.familyUserId,
      this.isForGetUserId = false,
      this.isFromFamilyListChat = false,
      this.isFromCareCoordinator = false,
      this.lastDate})
      : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<ChatDetail> {
  String? token = '';
  String? userId = '';

  //IO.Socket socket;

  Future<ChatHistoryModel?>? chatHistoryModel;

  ChatViewModel chatViewModel = ChatViewModel();
  AppointmentResult? appointmentResult;

  final AddFamilyUserInfoRepository _addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  //final TextEditingController textEditingController = TextEditingController();

  final TextFieldColorizer textEditingController = TextFieldColorizer(
    {
      '#(.*?)#': TextStyle(color: Colors.orange),
    },
  );

  var chatEnterMessageController = TextEditingController();

  /*final ScrollController listScrollController = ScrollController();*/
  ItemScrollController listScrollController = ItemScrollController();
  final FocusNode focusNode = FocusNode();
  var healthRecordList;
  List<String> recordIds = [];
  FlutterToast toast = FlutterToast();

  //List<String> wordsList = [];
  //List<String> filteredWordsList = [];

  List<String> searchIndexListAll = [];
  List<int> listIndex = [];

  String textFieldValue = '';
  String textFieldValueClone = '';

  int commonIndex = 0;

  //List<int> indexList = [];
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();

  bool isPlaying = false;

  String? peerId = '';
  String? chatPeerId = '';
  String? peerName = '';
  String? peerAvatar = '';

  String? patientId = '';
  String patientName = '';
  String? patientPicUrl = '';

  String? bookingId = '-';
  String? lastAppointmentDate = '';
  String? nextAppointmentDate = '';
  String? doctorDeviceToken = '';
  String? patientDeviceToken = '';
  String currentPlayedVoiceURL = '';

  String? carecoordinatorId = '';

  String textValue = '';

  String? groupId = '';

  String? familyUserId = '';

  String? chatById = '';

  String careCoordinatorName = '';

  bool isLoading = false;

  bool isFromVideoCall = false;

  //bool firstTime = true;

  bool isFistClicked = false;

  var listMessage;

  bool? isCareGiver = false;

  bool isForGetUserId = false;

  var isSearchVisible = false;

  bool isCareGiverApi = true;

  bool isFamilyPatientApi = true;

  bool isChatDisable = true;

  bool isCallBackDisable = false;

  bool isFromFamilyListChat = false;

  bool? isFromCareCoordinator = false;

  String isNormalChatUserList = 'false';

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();

  String? audioPath;
  final controller = Get.put(ChatUserListController());
  CaregiverPatientChatModel? familyListModel;

  String? lastReceived = '';
  String lastReceivedFuture = '';

  String parsedReferenceText = '';

  var pdfViewController;

  double? fontSizeOne = (CommonUtil().isTablet ?? false) ? 20.0.sp : 16.0.sp;
  double? fontSizeTwo = (CommonUtil().isTablet ?? false) ? 16.0.sp : 12.0.sp;
  double? fontSizeThree = (CommonUtil().isTablet ?? false) ? 18.0.sp : 14.0.sp;
  double? fontSizeFour = (CommonUtil().isTablet ?? false) ? 16.0.sp : 14.0.sp;

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBAChatDetailsScreen);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ChatSocketViewModel>(
        Get.context!,
        listen: false,
      ).updateChatHistoryList([], shouldUpdate: false);
    });

    pdfViewController = CommonUtil().onInitPDFViewController();

    peerId = widget.peerId;
    peerName = widget.peerName;
    peerAvatar = widget.peerAvatar;

    isCareGiver = widget.isCareGiver;
    isForGetUserId = widget.isForGetUserId;
    carecoordinatorId = widget.carecoordinatorId;
    isFromFamilyListChat = widget.isFromFamilyListChat;
    isFromCareCoordinator = widget.isFromCareCoordinator;
    isFromVideoCall = widget.isFromVideoCall;
    isNormalChatUserList = widget.isNormalChatUserList;

    groupId = widget.groupId;

    familyUserId = widget.familyUserId;

    chatById = widget.carecoordinatorId;

    if (isFromCareCoordinator! && isNormalChatUserList == "true") {
      chatById = familyUserId;
    }

    token = PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    userId = PreferenceUtil.getStringValue(KEY_USERID);

    initSocket();

    initLoader();

    getPatientDetails();
    lastReceived = widget.lastDate;
    getLastReceivedDate();
    set_up_audios();

    if (isForGetUserId) {
      Provider.of<ChatSocketViewModel>(context, listen: false)
          .getUserIdFromDocId(peerId!)
          .then((value) {
        if (value != null) {
          if (value.result != null) {
            if (value.result?.user != null) {
              if (value.result?.user?.id != null &&
                  value.result?.user?.id != '') {
                chatPeerId = value.result?.user?.id;
                getGroupId();
                getChatHistory();
              }
            }
          } else {
            chatPeerId = peerId;
            getGroupId();
            getChatHistory();
          }
        }
      });
    } else {
      chatPeerId = peerId;
      getGroupId();
      getChatHistory();
    }

    textEditingController.text = widget.message;
  }

  void scrollToPosiiton(int commonIndex) async {
    await listScrollController.scrollTo(
        index: listIndex[commonIndex],
        duration: Duration(milliseconds: 100)); //FU2.5

    //Scrollable.ensureVisible(context);
  }

  void getChatHistory() {
    chatHistoryModel = Provider.of<ChatSocketViewModel>(context, listen: false)
        .getChatHistory(
            chatPeerId!,
            familyUserId,
            isFromCareCoordinator!,
            carecoordinatorId ?? '',
            isFromFamilyListChat) as Future<ChatHistoryModel?>;
  }

  void getGroupId() {
    if (groupId == '' || groupId == null) {
      if (isFromFamilyListChat) {
        Provider.of<ChatSocketViewModel>(context, listen: false)
            .initNewFamilyChat(
                chatPeerId ?? '',
                peerName ?? '',
                isFromCareCoordinator ?? false,
                carecoordinatorId ?? '',
                familyUserId ?? '')
            .then((value) {
          if (value != null) {
            if (value.result != null) {
              if (value.result?.chatListId != null &&
                  value.result?.chatListId != '') {
                groupId = value.result!.chatListId;
                updateReadCount();
              }
            }
          }
        });
      } else {
        Provider.of<ChatSocketViewModel>(context, listen: false)
            .initNewChat(chatPeerId!)
            .then((value) {
          if (value != null) {
            if (value.result != null) {
              if (value.result?.chatListId != null &&
                  value.result?.chatListId != '') {
                groupId = value.result!.chatListId;
                updateReadCount();
              }
            }
          }
        });
      }
    } else {
      updateReadCount();
    }
  }

  initLoader() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  set_up_audios() async {
    _mPlayer.openAudioSession().then(
      (value) {
        _mPlayer.setSubscriptionDuration(
          Duration(
            seconds: 1,
          ),
        );
      },
    );
  }

  getPatientDetails() async {
    if (patientId == null || patientId == '') {
      patientId = PreferenceUtil.getStringValue(KEY_USERID);
    }

    if (patientName == null || patientName == '') {
      MyProfileModel myProfile = PreferenceUtil.getProfileData(KEY_PROFILE)!;
      patientName = myProfile.result != null
          ? myProfile.result!.firstName! + ' ' + myProfile.result!.lastName!
          : '';
    }

    if (patientPicUrl == null || patientPicUrl == '') {
      patientPicUrl = getProfileURL();
    }

    parseData();
  }

  String? getProfileURL() {
    MyProfileModel myProfile = PreferenceUtil.getProfileData(KEY_PROFILE)!;
    String? patientPicURL = myProfile.result!.profilePicThumbnailUrl;

    return patientPicURL;
  }

  void initSocket() {
    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket
        ?.off(message);

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket
        ?.on(message, (data) {
      if (data != null) {
        //print('OnMessageack$data');
        ChatHistoryResult emitAckResponse = ChatHistoryResult.fromJson(data);
        if (emitAckResponse != null) {
          if (isFromCareCoordinator ?? false) {
            if (carecoordinatorId == emitAckResponse.messages!.idFrom) {
              Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
                  .onReceiveMessage(emitAckResponse);
              updateReadCount();
            }
          } else {
            if (chatPeerId == emitAckResponse.messages!.idFrom) {
              Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
                  .onReceiveMessage(emitAckResponse);
              updateReadCount();
            }
          }
        }
      }
    });
  }

  updateReadCount() {
    var data = {"chatListId": groupId, "userId": userId};

    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket
        ?.emitWithAck(unreadNotification, data, ack: (res) {
      //print('emitWithackCount$res');
    });
  }

  parseData() async {
    await chatViewModel
        .fetchAppointmentDetail(
            widget.peerId!, userId!, chatById, isNormalChatUserList)
        .then((value) {
      appointmentResult = value;
      if (appointmentResult != null) {
        if (mounted)
          setState(() {
            // FUcrash add mounted
            isCareGiverApi = appointmentResult?.isCaregiver ?? false;
            isFamilyPatientApi = appointmentResult?.isPatient ?? false;
            isChatDisable = appointmentResult?.chatList?.isDisable ?? false;
            isCallBackDisable = isChatDisable;

            if (appointmentResult?.upcoming != null) {
              bookingId = appointmentResult?.upcoming?.bookingId;
            } else {
              if (appointmentResult?.past != null) {
                bookingId = appointmentResult?.past?.bookingId;
              } else {
                bookingId = '-';
              }
            }

            lastAppointmentDate = appointmentResult?.past != null
                ? appointmentResult?.past?.plannedStartDateTime
                : '';
            nextAppointmentDate = appointmentResult?.upcoming != null
                ? appointmentResult?.upcoming?.plannedStartDateTime
                : '';
            doctorDeviceToken = appointmentResult?.deviceToken != null
                ? appointmentResult?.deviceToken?.doctor != null
                    ? appointmentResult!
                            .deviceToken!.doctor!.payload!.isNotEmpty
                        ? appointmentResult!
                            .deviceToken!.doctor!.payload![0].deviceTokenId
                        : ''
                    : ''
                : '';
            patientDeviceToken = '';
            if (appointmentResult!.deviceToken != null) {
              if (appointmentResult!.deviceToken!.patient!.isSuccess! &&
                  appointmentResult!
                      .deviceToken!.patient!.payload!.isNotEmpty &&
                  appointmentResult
                          ?.deviceToken?.patient?.payload![0].deviceTokenId !=
                      null) {
                patientDeviceToken = appointmentResult
                    ?.deviceToken?.patient?.payload![0].deviceTokenId;
              } else if ((appointmentResult
                          ?.deviceToken!.parentMember!.isSuccess! ??
                      false) &&
                  appointmentResult!
                      .deviceToken!.parentMember!.payload!.isNotEmpty &&
                  appointmentResult?.deviceToken?.parentMember?.payload![0]
                          .deviceTokenId !=
                      null) {
                patientDeviceToken = appointmentResult
                    ?.deviceToken?.parentMember?.payload![0].deviceTokenId;
              }
            }

            if (appointmentResult?.doctorOrCarecoordinatorInfo != null) {
              if (appointmentResult?.doctorOrCarecoordinatorInfo
                          ?.carecoordinatorfirstName !=
                      null &&
                  appointmentResult?.doctorOrCarecoordinatorInfo
                          ?.carecoordinatorfirstName !=
                      '') {
                careCoordinatorName = appointmentResult
                        ?.doctorOrCarecoordinatorInfo
                        ?.carecoordinatorfirstName ??
                    '';
              }

              if (appointmentResult?.doctorOrCarecoordinatorInfo
                          ?.carecoordinatorLastName !=
                      null &&
                  appointmentResult?.doctorOrCarecoordinatorInfo
                          ?.carecoordinatorLastName !=
                      '') {
                careCoordinatorName = careCoordinatorName +
                    ' ' +
                    appointmentResult!
                        .doctorOrCarecoordinatorInfo!.carecoordinatorLastName!;
                isFromCareCoordinator = appointmentResult
                    ?.doctorOrCarecoordinatorInfo?.isCareCoordinator;
              }
            }
          });
      } else {
        setState(() {
          isChatDisable = false;
          isCallBackDisable = false;
          isCareGiverApi = false;
        });
      }
    });
  }

  Widget getChatHistoryList() {
    return FutureBuilder<ChatHistoryModel?>(
      future: chatHistoryModel,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 1.4,
              child: Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          /* if (snapshot?.hasData &&
              snapshot?.data?.result != null &&
              snapshot?.data?.result?.length > 0) {*/
          Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
              .updateChatHistoryList(snapshot.data?.result,
                  shouldUpdate: false);

          return buildListMessage();
          /*} else {
            return Flexible(
              child: SafeArea(
                child: SizedBox(
                  height: 1.sh / 1.4,
                  child: Flexible(
                    child: Container(
                        child: Center(
                      child: Text(strNoMessage,
                          style: TextStyle(color: Colors.grey)),
                    )),
                  ),
                ),
              ),
            );
          }*/
        }
      },
    );
  }

  @override
  void dispose() {
    //socket.disconnect();
    //socket.disconnect();
    Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
        .socket
        ?.off(message);
    super.dispose();
  }

  void onSendMessage(String? content, int type, String? chatMessageId,
      bool isNotUpload) async {
    if (content != null) {
      if (content.trim() != '') {
        textValue = textEditingController.text;
        textEditingController.clear();

        var data = {
          "id": groupId,
          'idFrom': userId,
          'idTo': /*isFromCareCoordinator! ? carecoordinatorId : */ chatPeerId,
          "type": type,
          "isread": false,
          'content': content,
          'chatMessageId': chatMessageId,
          'isUpload': isNotUpload,
          'isPatient': isFamilyPatientApi
        };

        try {
          Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
              .socket
              ?.emitWithAck(message, data, ack: (res) {
            //print('emitWithack$res');
            if (res != null) {
              EmitAckResponse emitAckResponse = EmitAckResponse.fromJson(res);
              if (emitAckResponse != null) {
                if (emitAckResponse.lastSentMessageInfo != null) {
                  Provider.of<ChatSocketViewModel>(Get.context!, listen: false)
                      .messageEmit(emitAckResponse.lastSentMessageInfo);
                  /*listScrollController.scrollTo(
                    index: Provider.of<ChatSocketViewModel>(Get.context,listen: false)?.chatHistoryList.length,
                    duration: Duration(milliseconds: 100));*/
                }
              }
            }
          });
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);
        }

        textValue = '';
      } else {
        Fluttertoast.showToast(msg: NOTHING_SEND, backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: CommonUtil().isTablet!
              ? isPortrait
                  ? Size.fromHeight(1.sh * 0.1)
                  : Size.fromHeight(1.sh * 0.2)
              : Size.fromHeight(1.sh * 0.15),
          child: _patientChatBar()),
      floatingActionButton: isSearchVisible
          ? Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(
                bottom: 180.0,
              ),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    // SpeedDial
                    Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.transparent),
                      ),
                      child: Container(
                        height: 1.sw * 0.1,
                        width: 1.sw * 0.1,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            //firstTime = false;
                            if (!isFistClicked) {
                              isFistClicked = true;
                              if (textFieldValue != null &&
                                  textFieldValue != '' &&
                                  textFieldValue.length > 1) {
                                getListIndexMapFilter();
                              }
                            }

                            if (listIndex != null) {
                              if (commonIndex < listIndex.length - 1) {
                                commonIndex = commonIndex + 1;
                                scrollToPosiiton(commonIndex);
                              } else {
                                toast.getToast('No more data', Colors.red);
                              }
                            }
                          },
                          child: Icon(Icons.arrow_upward),
                        ),
                      ),
                    ),
                    SizedBoxWidget(
                      height: 5.0.h,
                    ),
                    Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.transparent),
                      ),
                      child: Container(
                        height: 1.sw * 0.1,
                        width: 1.sw * 0.1,
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            //firstTime = false;
                            if (!isFistClicked) {
                              isFistClicked = true;
                              if (textFieldValue != null &&
                                  textFieldValue != '' &&
                                  textFieldValue.length > 2) {
                                getListIndexMapFilter();
                                commonIndex = listIndex.length;
                              }
                            }

                            if (listIndex != null) {
                              if (commonIndex > 0) {
                                commonIndex = commonIndex - 1;
                                scrollToPosiiton(commonIndex);
                              } else {
                                toast.getToast('No more data', Colors.red);
                              }
                            }
                          },
                          child: Icon(Icons.arrow_downward),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Color(CommonUtil().getMyPrimaryColor()),
            ))
          : WillPopScope(
              onWillPop: onBackPress,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.grey[300],
                    child: Column(
                      children: <Widget>[
                        // List of messages
                        getChatHistoryList(),

                        // Sticker
                        //(isShowSticker ? buildSticker() : Container()),

                        // Input content
                        !isChatDisable ? buildInput() : SizedBox.shrink(),
                        SizedBox(
                          height: 20.0.h,
                        ),
                      ],
                    ),
                  ),

                  // Loading
                  //buildLoading()
                ],
              ),
            ),
    );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context, isCareGiver);
    return Future.value(false);
  }

  Widget _patientChatBar() {
    return AppBar(
      flexibleSpace: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
              Color(CommonUtil().getMyPrimaryColor()),
              Color(CommonUtil().getMyGredientColor())
            ],
                stops: [
              0.3,
              1.0
            ])),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24.0.sp,
                        ),
                        onTap: () {
                          //Add code for tapping back
                          Navigator.pop(context, isCareGiver);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 10),
                      child: Container(
                        width: 1.sw * 0.66,
                        child: _patientDetailOrSearch(),
                      ),
                    ),
                    Expanded(flex: 1, child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        !isCallBackDisable && isCareGiver!
                            ? SizedBoxWithChild(
                                height: 24.0.h,
                                width: 24.0.w,
                                child: IconButton(
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () {
                                    CommonUtil()
                                        .CallbackAPIFromChat(
                                            patientId,
                                            peerId,
                                            (widget.peerName ?? "").length > 0
                                                ? widget.peerName
                                                    ?.capitalizeFirstofEach
                                                : '')
                                        .then((value) {
                                      chatHistoryModel =
                                          Provider.of<ChatSocketViewModel>(
                                                      context,
                                                      listen: false)
                                                  .getChatHistory(
                                                      chatPeerId!,
                                                      familyUserId!,
                                                      isFromCareCoordinator!,
                                                      carecoordinatorId!,
                                                      isFromFamilyListChat)
                                              as Future<ChatHistoryModel?>;
                                      setState(() {});
                                    });
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 24.0.sp,
                                  ),
                                ),
                              )
                            : SizedBoxWithChild(
                                height: 24.0.h,
                                width: 24.0.w,
                                child:
                                    CommonUtil().getNotificationIcon(context),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBoxWithChild(
                          height: 24.0.h,
                          width: 24.0.w,
                          child: moreOptionsPopup(),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget moreOptionsPopup() => PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      color: Colors.white,
      padding: EdgeInsets.only(left: 1, right: 2),
      onSelected: (dynamic newValue) {
        if (newValue == 0) {
          isSearchVisible = true;
          showSearch();
        }
      },
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text(
                '$popUpChoiceOne',
                style: TextStyle(
                  fontSize: fontSizeOne,
                ),
              ),
            ),
            /* PopupMenuItem(
            child: GestureDetector(child: Text('$popUpChoiceTwo'))),
        PopupMenuItem(
            child: GestureDetector(child: Text('$popUpCHoiceThree')))*/
          ]);

  void showSearch() {
    setState(() {
      if (isSearchVisible) {
        _patientDetailOrSearch();
      }
    });
  }

  void _onSearch(value) {
    /*if (indexList.length > 0 &&
        value.length > 0 &&
        textFieldValueClone != value) {
      //indexList.clear();
      //indexList = [];
      commonIndex = 0;
      //wordsList.clear();
      //wordsList = [];
    }*/
    if (value != null && value.length > 0) {
      commonIndex = 0;
      clearSearchData();
    }

    //scrollToPosiiton(0);
    setState(() {
      //firstTime = true;
      /*filteredWordsList =
          wordsList.where((item) => item.contains('$value')).toList();*/
      textFieldValue = value;
    });

    if (value != null && value != '' && value.length > 2) {
      if (!isFistClicked) {
        isFistClicked = true;
        if (textFieldValue != null &&
            textFieldValue != '' &&
            textFieldValue.length > 1) {
          if (searchIndexListAll != null) {
            getListIndexMapFilter();
          }
        }
      }

      if (listIndex != null) {
        if (commonIndex <
            (listIndex.length > 1 ? listIndex.length - 1 : listIndex.length)) {
          commonIndex = commonIndex;
          scrollToPosiiton(commonIndex);
        }
        /*else {
          toast.getToast('No data', Colors.red);
        }*/
      }
    }
  }

  Widget? _patientDetailOrSearch() {
    dynamic resultWidget = null;
    setState(() {
      if (isSearchVisible) {
        resultWidget = AnimatedSwitcher(
          duration: Duration(milliseconds: 10),
          child: Container(
            height: 45.0.h,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 16.0.sp),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      //filteredWordsList = [];
                      //wordsList = [];
                      textFieldValue = '';
                      isSearchVisible = false;
                      //firstTime = true;
                      //indexList.clear();
                      //indexList = [];
                      commonIndex = 0;
                      clearSearchData();
                      showSearch();
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16.0.sp,
                  ),
                  fillColor: Colors.white),
              onChanged: _onSearch,
            ),
          ),
        );
      } else {
        resultWidget = AnimatedSwitcher(
          duration: Duration(milliseconds: 10),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Image.network(
                    widget.peerAvatar != null ? widget.peerAvatar ?? '' : '',
                    height: 40.0.h,
                    width: 40.0.h,
                    fit: BoxFit.cover, errorBuilder: (BuildContext context,
                        Object exception, StackTrace? stackTrace) {
                  return Container(
                    height: 50.0.h,
                    width: 50.0.h,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                      widget.peerName != null && widget.peerName != ''
                          ? widget.peerName![0].toString().toUpperCase()
                          : '',
                      style: TextStyle(
                        color: Color(new CommonUtil().getMyPrimaryColor()),
                        fontSize: fontSizeOne,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  );
                }),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              Container(
                  child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        widget.peerName != null && widget.peerName != ''
                            ? isFromCareCoordinator! &&
                                    (familyUserId != null && familyUserId != '')
                                ? widget.peerName!.capitalizeFirstofEach +
                                    CARE_COORDINATOR_STRING
                                : widget.peerName!.capitalizeFirstofEach
                            : '',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: font_poppins,
                            fontSize: fontSizeOne,
                            color: Colors.white)),
                    getTopBookingDetail(),
                    lastReceived != null &&
                            lastReceived != 'null' &&
                            lastReceived != ""
                        ? getWidgetTextForLastReceivedDate(
                            LAST_RECEIVED + lastReceived!)
                        : getLastReceivedDateWidget()
                  ],
                ),
              ))
            ],
          ),
        );
      }
    });
    return resultWidget;
  }

  Widget getTopBookingDetail() {
    if (isFromCareCoordinator! &&
        (familyUserId != null && familyUserId != '')) {
      return Text('Name: ' + careCoordinatorName,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontFamily: font_poppins,
              fontSize: fontSizeTwo,
              color: Colors.white));
    } else {
      if (!isCareGiverApi) {
        if (!isFamilyPatientApi &&
            (familyUserId != null && familyUserId != '')) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Id: ' + bookingId!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: font_poppins,
                        fontSize: fontSizeTwo,
                        color: Colors.white)),
                Text(
                    'Next Appointment: ' +
                        getFormattedDateTimeAppbar(nextAppointmentDate),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: font_poppins,
                        fontSize: fontSizeTwo,
                        color: Colors.white)),
                Text(
                    toBeginningOfSentenceCase('Last Appointment: ' +
                        getFormattedDateTimeAppbar(lastAppointmentDate))!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: font_poppins,
                        fontSize: fontSizeTwo,
                        color: Colors.white)),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      } else {
        return SizedBox.shrink();
      }
    }
  }

  Widget buildListMessage() {
    return Flexible(
        child: ScrollablePositionedList.builder(
      padding: EdgeInsets.all((CommonUtil().isTablet ?? false) ? 20.00 : 10.0),
      itemBuilder: (context, index) {
        var chatList = Provider.of<ChatSocketViewModel>(Get.context!)
            .chatHistoryList!
            .reversed
            .toList();
        searchIndexListAll = [];
        searchIndexListAll.clear();
        /*listIndex = [];
         listIndex.clear();*/
        for (int i = 0; i < chatList.length; i++) {
          String? content = chatList[i]?.messages?.content;

          searchIndexListAll.add(content ?? '');
        }

        bool isIconNeed = false;

        if (chatList[index]?.messages?.idFrom == patientId) {
          isIconNeed = isLastMessageRight(index, chatList);
        } else if (chatList[index]?.messages?.idFrom != patientId) {
          isIconNeed = isLastMessageLeft(index, chatList);
        } else {
          isIconNeed = false;
        }

        return buildItem(chatList[index]!, index, isIconNeed);
      },
      itemCount: Provider.of<ChatSocketViewModel>(Get.context!)
              .chatHistoryList
              ?.reversed
              .toList()
              .length ??
          0,
      reverse: true,
      itemScrollController: listScrollController,
    ));
  }

  Widget buildInput() {
    //Check if the tablet is in landscape of portrait mode
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return IconTheme(
      data: IconThemeData(color: Color(CommonUtil().getMyPrimaryColor())),
      child: Container(
        width: (CommonUtil().isTablet ?? false)
            ? MediaQuery.of(context).size.width
            : null,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            (CommonUtil().isTablet ?? false)
                ? SizedBox(width: 10)
                : Container(),
            Flexible(
              //set the flex value based on the orientation of tablet
              flex: (CommonUtil().isTablet ?? false)
                  ? isPortrait
                      ? 8
                      : 15
                  : 4,
              child: Container(
                height: 58.0.h,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 16.0.sp),
                      focusNode: focusNode,
                      onTap: () {
                        //isSearchVisible = false;
                        //_patientDetailOrSearch();
                      },
                      controller: textEditingController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("\[[ A-Za-z0-9#+-.@&?!{}():'%/=-]\]*")),
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.fromLTRB(13, 13, 46, 13),
                        hintText: "$chatTextFieldHintText",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0.sp,
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*onChanged: (text){
                      final val = TextSelection.collapsed(offset: textEditingController.text.length);
                      textEditingController.selection = val;
                      */ /*textEditingController.text = '~$text~';*/ /*
                    },*/
                      /*onSubmitted: (value) =>*/
                    ),
                    Container(
                      child: SizedBoxWithChild(
                        width: 46.0.h,
                        height: 46.0.h,
                        child:
                            /*!isDateIconShown
                            ?*/
                            TextButton(
                          onPressed: () {
                            recordIds.clear();
                            FetchRecords(0, true, true, false, recordIds);
                          },
                          child: Icon(
                            Icons.attach_file,
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            size: 22,
                          ),
                        ),
                        /*: FlatButton(
                                onPressed: () {
                                  tapDatePicker();
                                },
                                child: new Icon(
                                  Icons.calendar_today,
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  size: 22,
                                )),*/
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: RawMaterialButton(
                  onPressed: () {
                    onSendMessage(textEditingController.text, 0, null, true);
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(Icons.send,
                      size: 25.0,
                      color: Color(CommonUtil().getMyPrimaryColor())),
                  padding: EdgeInsets.all(12.0),
                  shape: CircleBorder(),
                ),
              ),
            ),
            !isFromVideoCall
                ? Flexible(
                    flex: 1,
                    child: Container(
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => AudioRecorder(
                                arguments: AudioScreenArguments(
                                  fromVoice: false,
                                ),
                              ),
                            ),
                          )
                              .then((results) {
                            audioPath = results[keyAudioFile];
                            if (audioPath != null && audioPath != '') {
                              setState(() {
                                isLoading = true;
                              });
                              //uploadFile(audioPath);
                              uploadDocument(
                                  audioPath!, userId!, chatPeerId!, groupId!);
                            }
                          });
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: Icon(Icons.mic,
                            size: 25.0,
                            color: Color(CommonUtil().getMyPrimaryColor())),
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget buildItem(ChatHistoryResult chatList, int index, bool isIconNeed) {
    List<TextSpan> textSpanList = [];

    if (chatList.messages?.type == 0) {
      String tempData = chatList.messages!.content!;

      textSpanList = [
        buildTextWithLinks(
            tempData, index, chatList.messages!.idFrom == patientId)
      ];
      //firstTime = false;
      //commonIndex=indexList.length-1;
    }

    if (chatList.messages?.idFrom == patientId) {
      return Row(
        children: <Widget>[
          chatList.messages?.type == 0
              // Text
              ? chatList.isCommonContent!
                  ? Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 0.6.sw,
                        ),
                        padding: EdgeInsets.all(10.0.sp),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: fontSizeOne,
                              ),
                              children: textSpanList),
                        ),
                      ),
                    )
                  : Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 1.sw * .6,
                        ),
                        padding: const EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                    color: Color(CommonUtil().getMyPrimaryColor()),
                                    fontSize: fontSizeOne,
                                  ),
                                  children: textSpanList),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5,),
                              child: Text(
                                getFormattedDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(int.parse(
                                        chatList
                                            .messages!.timestamp!.sSeconds!))
                                        .toString()),
                                style: TextStyle(
                                  color: greyColor,
                                  fontSize: fontSizeThree,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),

                          ],
                        ),
                        /*child: Text(
                      document[STR_CONTENT],
                      style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor())),
                    ),*/
                      ),
                    )
              : chatList.messages?.type == 1
                  // Image
                  ? Container(
                      child: TextButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CommonCircularIndicator(),
                              width: 200.0.h,
                              height: 200.0.h,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0.h,
                                height: 200.0.h,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: chatList.messages?.content ?? '',
                            width: 200.0.h,
                            height: 200.0.h,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                      url: chatList.messages?.content)));
                        },
                        onLongPress: () {
                          openDownloadAlert(chatList.messages?.content, context,
                              false, '.jpg');
                        },
                      ),
                      margin: EdgeInsets.only(
                          bottom: isIconNeed ? 20.0 : 10.0, right: 10.0),
                    )
                  // Pdf
                  : chatList.messages?.type == 2
                      ? Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                          child: InkWell(
                            onTap: () {
                              goToPDFViewBasedonURL(chatList.messages?.content);
                            },
                            onLongPress: () {
                              openDownloadAlert(chatList.messages?.content,
                                  context, false, '.pdf');
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 1.sw * .6,
                              ),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                  SizedBoxWidget(
                                    width: 5.0.w,
                                  ),
                                  getPdfViewLabel(chatList),
                                ],
                              ),
                            ),
                          ),
                        )
                      // voice card
                      : chatList.messages?.type == 3
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 2.0,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  width: 1.sw / 1.5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      fhbBasicWidget.getAudioWidgetForChat(
                                          chatList.messages?.content)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Image.asset(
                                'images/${chatList.messages?.content}.gif',
                                width: 100.0.h,
                                height: 100.0.h,
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isIconNeed ? 20.0 : 10.0,
                                  right: 10.0),
                            ),
        ],
        mainAxisAlignment: chatList.isCommonContent!
            ? MainAxisAlignment.center
            : MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return chatList.isCommonContent!
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 0.6.sw,
                      ),
                      padding: EdgeInsets.all(10.0.sp),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: fontSizeOne,
                            ),
                            children: textSpanList),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      isIconNeed
                          ? Material(
                              child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: CommonCircularIndicator(),
                                        width: 35.0.h,
                                        height: 35.0.h,
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                  imageUrl: peerAvatar != null
                                      ? peerAvatar ?? ''
                                      : '',
                                  width: 35.0.h,
                                  height: 35.0.h,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height: 35.0.h,
                                        width: 35.0.h,
                                        color: Colors.grey[200],
                                        child: Center(
                                            child: Text(
                                          peerName != null && peerName != ''
                                              ? peerName![0]
                                                  .toString()
                                                  .toUpperCase()
                                              : '',
                                          style: TextStyle(
                                            color: Color(CommonUtil()
                                                .getMyPrimaryColor()),
                                            fontSize: fontSizeOne,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                      )),
                              borderRadius: BorderRadius.all(
                                Radius.circular((CommonUtil().isTablet ?? false)
                                    ? 35.0
                                    : 20.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            )
                          : Container(width: 38.0.w),
                      chatList.messages?.type == 0
                          ?
                      Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 1.sw * .6,
                          ),
                          padding: const EdgeInsets.only(left: 15, right: 15,top: 10,bottom: 10),
                          decoration: BoxDecoration(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSizeOne,
                                  ),
                                  children: textSpanList,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5,bottom: 5),
                                child: Text(
                                  getFormattedDateTime(
                                      DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          chatList
                                              .messages!.timestamp!.sSeconds!))
                                          .toString()),
                                  // getFormattedDateTime(chatList.messages!.timestamp!.sSeconds.toString()),
                                  style: TextStyle(
                                    color: greyColor,
                                    fontSize: fontSizeThree,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              isSentViaSheelaTextWidget(chatList, Colors.white),
                            ],
                          ),
                        ),
                      )

                          : chatList.messages?.type == 1
                              ? Container(
                                  child: TextButton(
                                    child: Material(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Container(
                                          child: CommonCircularIndicator(),
                                          width: 200.0.h,
                                          height: 200.0.h,
                                          padding: EdgeInsets.all(70.0),
                                          decoration: BoxDecoration(
                                            color: greyColor2,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Material(
                                          child: Image.asset(
                                            'images/img_not_available.jpeg',
                                            width: 200.0.h,
                                            height: 200.0.h,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        imageUrl:
                                            chatList.messages?.content ?? '',
                                        width: 200.0.h,
                                        height: 200.0.h,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullPhoto(
                                                  url: chatList
                                                      .messages?.content)));
                                    },
                                    onLongPress: () {
                                      openDownloadAlert(
                                          chatList.messages?.content,
                                          context,
                                          false,
                                          '.jpg');
                                    },
                                  ),
                                  margin: EdgeInsets.only(left: 10.0),
                                )
                              : chatList.messages?.type == 2
                                  ? Card(
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              bottomRight:
                                                  Radius.circular(25))),
                                      child: InkWell(
                                        onTap: () {
                                          goToPDFViewBasedonURL(
                                              chatList.messages?.content);
                                        },
                                        onLongPress: () {
                                          openDownloadAlert(
                                              chatList.messages?.content,
                                              context,
                                              false,
                                              '.pdf');
                                        },
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 1.sw * .6,
                                          ),
                                          padding: const EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                            color: Color(CommonUtil()
                                                .getMyPrimaryColor()),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.picture_as_pdf,
                                                size: 14,
                                                color: Colors.black54,
                                              ),
                                              SizedBoxWidget(
                                                width: 5.0.w,
                                              ),
                                              Text(
                                                'Click to view PDF',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fontSizeOne,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : chatList.messages?.type == 3
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            elevation: 2.0,
                                            child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              width: 1.sw / 1.5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: fhbBasicWidget
                                                            .getAudioWidgetForChat(
                                                                chatList
                                                                    .messages
                                                                    ?.content),
                                                      )
                                                    ],
                                                  ),
                                                  isSentViaSheelaTextWidget(
                                                      chatList, Colors.black),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Image.asset(
                                            'images/${chatList.messages?.content}.gif',
                                            width: 100.0.h,
                                            height: 100.0.h,
                                            fit: BoxFit.cover,
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: isIconNeed ? 20.0 : 10.0,
                                              right: 10.0),
                                        ),
                    ],
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            );
    }
  }
  String formatDateTime(String timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return timeago.format(dateTime); // Show relative time for today
    } else {
      // Show date and time for other days in 12-hour format
      return DateFormat('MMM d, hh:mm a').format(dateTime);
    }
  }


  TextSpan buildTextWithLinks(String textToLink, int index, bool isPatient) =>
      TextSpan(
        children: linkify(
          textToLink,
          index,
          isPatient,
        ),
      );

  WidgetSpan buildLinkComponent(
          String text, String linkToOpen, int index, bool isPatient) =>
      WidgetSpan(
        child: InkWell(
          child: RichText(
            text: TextSpan(
              children: getSplittedTextWidget(text, index),
              style: TextStyle(
                color: isPatient ? Colors.blueAccent : Colors.white,
                // background: Paint()
                //   ..color =
                //       Colors.white,
                decoration: TextDecoration.underline,
                fontSize: fontSizeOne,
              ),
            ),
          ),
          onTap: () {
            openYoutubeDialog(text);
          },
        ),
      );

  WidgetSpan buildDateComponent(String text, String linkToOpen, int index,
          bool isPatient, String fullContent,
          {bool isFromBtnDirection = false}) =>
      WidgetSpan(
        child: !isPatient
            ? InkWell(
                child: Container(
                  margin: (CommonUtil().isTablet ?? false
                      ? EdgeInsets.only(top: 8)
                      : EdgeInsets.only(top: 2, bottom: 2)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: RichText(
                      text: TextSpan(
                        children: getSplittedTextWidget(
                            isFromBtnDirection
                                ? chooseDirection
                                : chooseYourDate,
                            index),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeOne,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: isFromBtnDirection
                    ? null
                    : () async {
                        FocusManager.instance.primaryFocus!.unfocus();
                        parsedReferenceText = '';
                        //tapDatePicker();
                        //Get.to(ChooseDateSlot());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseDateSlot(
                                    messageContent: fullContent,
                                    getRefNumber: (message) {
                                      if (message != null && message != '') {
                                        if (message.toString().contains(')')) {
                                          parsedReferenceText =
                                              getSubstringByString(
                                                  message.toString());
                                        }
                                      }
                                    }))).then((value) {
                          if (value != null) {
                            List<String> result = [];
                            result.add(value);
                            try {
                              if (result.length > 0) {
                                final removedBrackets = result
                                    .toString()
                                    .substring(2, result.toString().length - 2);
                                if (removedBrackets.length > 0) {
                                  Provider.of<ChatSocketViewModel>(
                                    Get.context!,
                                    listen: false,
                                  ).initRRTNotificaiton(
                                    peerId: peerId,
                                    selectedDate: removedBrackets.toString() +
                                        getRefText(),
                                  );
                                  onSendMessage(
                                      removedBrackets.toString() + getRefText(),
                                      0,
                                      null,
                                      true);
                                }
                              }
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);
                            }
                          }
                        });
                      },
              )
            : SizedBox.shrink(),
      );

  List<InlineSpan> linkify(String text, int index, bool isPatient) {
    const String urlPattern = 'https?:/\/\\S+';
    const String datePattern = '{date}';
    const String directionPattern = '{map}';
    final RegExp dateRegExp = RegExp('($datePattern)', caseSensitive: false);
    final RegExp btnDirectionExp =
        RegExp('($directionPattern)', caseSensitive: false);
    final RegExp linkRegExp = RegExp('($urlPattern)', caseSensitive: false);

    final List<InlineSpan> list = <InlineSpan>[];
    final RegExpMatch? dateMatch = dateRegExp.firstMatch(text);
    final RegExpMatch? directionMap = btnDirectionExp.firstMatch(text);
    final RegExpMatch? match = linkRegExp.firstMatch(text);

    if (match == null && dateMatch == null && directionMap == null) {
      list.add(TextSpan(children: getSplittedTextWidget(text, index)));
      return list;
    }

    if ((match?.start ?? 0) > 0) {
      list.add(TextSpan(
          children:
              getSplittedTextWidget(text.substring(0, match!.start), index)));
    }

    if ((dateMatch?.start ?? 0) > 0) {
      list.add(TextSpan(
          children: getSplittedTextWidget(
              text.substring(0, dateMatch!.start), index)));
    }

    if ((directionMap?.start ?? 0) > 0) {
      list.add(TextSpan(
          children: getSplittedTextWidget(
              text.substring(0, directionMap!.start), index)));
    }

    final String linkText = match?.group(0) ?? '';
    final String dateText = dateMatch?.group(0) ?? '';
    final String directionText = directionMap?.group(0) ?? '';
    if (linkText.contains(RegExp(urlPattern, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, linkText, index, isPatient));
    }

    if (dateText.contains(RegExp(datePattern, caseSensitive: false))) {
      list.add(buildDateComponent(dateText, dateText, index, isPatient, text,
          isFromBtnDirection: false));
    }

    if (directionText
        .contains(RegExp(directionPattern, caseSensitive: false))) {
      list.add(buildDateComponent(
          directionText, directionText, index, isPatient, text,
          isFromBtnDirection: true));
    }

    list.addAll(linkify(
        text.substring(getMatchLinkText(
            match, dateMatch, directionMap, linkText, dateText, directionText)),
        index,
        isPatient));

    return list;
  }

  getMatchLinkText(
      RegExpMatch? match,
      RegExpMatch? dateMatch,
      RegExpMatch? directionMap,
      String? linkText,
      String? dateText,
      String? directionText) {
    int value = 0;

    try {
      if (match != null) {
        value = match.start + linkText!.length;
      } else {
        if (dateMatch != null) {
          value = dateMatch.start + dateText!.length;
        } else if (directionMap != null) {
          value = directionMap.start + directionText!.length;
        } else {
          value = 0;
        }
      }

      return value;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return value;
    }
  }

  String getSubstringByString(String content) {
    String value = '';
    try {
      int start = content.indexOf("(") + 1;
      int end = content.indexOf(")", start);
      value = content.substring(start, end);
      return value;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      return value;
    }
  }

  String getRefText() {
    if (parsedReferenceText != null && parsedReferenceText != '') {
      return '  (' + parsedReferenceText + ')'.toString();
    } else {
      return '';
    }
  }

  List<TextSpan> getSplittedTextWidget(String tempData, int index) {
    List<TextSpan> textSpanList = [];
    //setState((
    //wordsList = tempData.split(',');
    //filteredWordsList = wordsList;
    //});

    String word = tempData;
    /*final RegExp REGEX_EMOJI = RegExp(
          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
      if (word.contains(REGEX_EMOJI)) {
        word = word.replaceAll(REGEX_EMOJI, '');
      }*/
    List<String> tempList =
        word.length > 1 && word.indexOf(textFieldValue) != -1
            ? word.split(textFieldValue)
            : [word, ''];
    int i = 0;

    tempList.forEach((item) {
      if (word.indexOf(textFieldValue) != -1 && i < tempList.length - 1) {
        /*if (textFieldValue != '' && textFieldValue != null && firstTime) {
          textFieldValueClone = textFieldValue;
          indexList.add(index);
        }*/
        textSpanList = [
          ...textSpanList,
          TextSpan(text: '${item}'),
          TextSpan(
            text: '${textFieldValue}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                background: Paint()..color = Colors.yellow),
          ),
        ];
      } else {
        //
        textSpanList = [...textSpanList, TextSpan(text: '${item}')];
      }
      i++;
    });
    return textSpanList;
  }

  openYoutubeDialog(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyYoutubePlayer(
            videoId: videoId,
          ),
        ),
      );
    } else {
      CommonUtil().openWebViewNew(
        url,
        url,
        false,
      );
    }
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('MMM d, hh:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  String getFormattedDateTimeAppbar(String? datetime) {
    String formattedDate = '-';
    if (datetime != null && datetime != '') {
      DateTime dateTimeStamp = DateTime.parse(datetime);
      formattedDate = DateFormat('MMM d, hh:mm a').format(dateTimeStamp);
    }

    return formattedDate;
  }

  Future<dynamic> flutterStopPlayer(url) async {
    setState(() {
      isPlaying = false;
    });
    currentPlayedVoiceURL = '';
    await _mPlayer.stopPlayer().then((value) {
      //flutterPlaySound(url);
    });
  }

  flutterPlaySound(url) async {
    currentPlayedVoiceURL = url;
    setState(() {
      isPlaying = true;
    });
    // final file = await CommonUtil.downloadFile(url, 'mp3');
    await _mPlayer.startPlayer(fromURI: url).whenComplete(
      () {
        setState(() {
          isPlaying = false;
        });
      },
    );

    //TODO: Check for audio
  }

  Widget getPdfViewLabel(ChatHistoryResult document) {
    if (document.messages?.timestamp?.sSeconds != null &&
        document.messages?.timestamp?.sSeconds != '') {
      DateTime dateTimeFromServerTimeStamp =
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(document.messages!.timestamp!.sSeconds!));
      return Text(
        'File ' + dateTimeFromServerTimeStamp.millisecondsSinceEpoch.toString(),
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: fontSizeOne,
        ),
      );
    } else {
      return Text(
        'Click to View Pdf',
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: fontSizeOne,
        ),
      );
    }
  }

  openDownloadAlert(
      String? fileUrl, BuildContext contxt, bool isPdf, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure want to download?',
            style: TextStyle(
              fontSize: fontSizeOne,
            ),
          ),
          actions: <Widget>[
            FlatButtonWidget(
              bgColor: Colors.transparent,
              isSelected: true,
              onPress: () {
                saveImageToGallery(fileUrl, contxt, isPdf, type);
                Navigator.pop(context);
              },
              title: 'Download',
              fontSize: fontSizeOne,
              /*child: Text(
                'Download',
                style: TextStyle(
                  fontSize: fontSizeOne,
                ),
              ),*/
            ),
          ],
        );
      },
    );
  }

  goToPDFViewBasedonURL(String? url) {
    final data = OpenPDF(type: PDFLocation.URL, path: url);
    pdfViewController.data = data;
    Get.to(() => PDFView());
  }

  bool isLastMessageRight(int index, List<ChatHistoryResult?> list) {
    if (index == 0 ||
        (index > 0 &&
            list != null &&
            list[index - 1]?.messages?.idFrom != patientId)) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageLeft(int index, List<ChatHistoryResult?> list) {
    if (index == 0 ||
        (index > 0 &&
            list != null &&
            list[index - 1]?.messages?.idFrom == patientId)) {
      return true;
    } else {
      return false;
    }
  }

  void saveImageToGallery(String? fileUrl, BuildContext contxt,
      bool isPdfPresent, String fileType) async {
    //check the storage permission for both android and ios!
    //request gallery permission
    String albumName = 'myfhb';
    bool downloadStatus = false;
    PermissionStatus storagePermission = Platform.isAndroid
        ? await Permission.storage.status
        : await Permission.photos.status;
    if (storagePermission.isDenied || storagePermission.isRestricted) {
      Platform.isAndroid
          ? await Permission.storage.request()
          : await Permission.photos.request();
    }

    String? _currentImage;

    final snackBar = SnackBar(
      content: Text(
        strDownloadStart,
        style: TextStyle(
          fontSize: fontSizeOne,
        ),
      ),
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
    );

    //ScaffoldMessenger.of(contxt).showSnackBar();

    _scaffoldKey.currentState!.showSnackBar(snackBar);

    if (isPdfPresent) {
      if (Platform.isIOS) {
        final file = await CommonUtil.downloadFile(fileUrl!, fileType);
        /*ScaffoldMessenger.of(contxt).showSnackBar(
          ,
        );*/

        final snackBar = SnackBar(
          content: Text(
            strFileDownloaded,
            style: TextStyle(
              fontSize: fontSizeOne,
            ),
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              await OpenFilex.open(
                file?.path,
              ); //FU2.5
              final data = OpenPDF(type: PDFLocation.Path, path: file?.path);
              var pdfController = CommonUtil().onInitPDFViewController();
              pdfController.data = data;
              Get.to(() => PDFView());
            },
          ),
        );

        _scaffoldKey.currentState!.showSnackBar(snackBar);
      } else {
        await ImageGallerySaver.saveFile(fileUrl!).then((res) {
          setState(() {
            downloadStatus = true;
          });
        });
      }
    } else {
      _currentImage = fileUrl;
      try {
        CommonUtil.downloadFile(_currentImage!, fileType)
            .then((filePath) async {
          if (Platform.isAndroid) {
            //ScaffoldMessenger.of(contxt).showSnackBar();

            final snackBar = SnackBar(
              content: Text(
                strFileDownloaded,
                style: TextStyle(
                  fontSize: fontSizeOne,
                ),
              ),
              backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () async {
                  await OpenFilex.open(
                    filePath?.path,
                  ); //FU2.5

                  final data =
                      OpenPDF(type: PDFLocation.Path, path: filePath?.path);
                  var pdfController = CommonUtil().onInitPDFViewController();
                  pdfController.data = data;
                  Get.to(() => PDFView());
                },
              ),
            );

            _scaffoldKey.currentState!.showSnackBar(snackBar);
          }
        });
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
  }

  Future<void> uploadDocument(
      String image, String userId, String peerId, String groupId) async {
    try {
      _addFamilyUserInfoRepository
          .uploadChatDocument(image, userId, peerId, groupId)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        if (value != null) {
          if (value.isSuccess!) {
            if (value.result != null) {
              onSendMessage(
                  value.result?.fileUrl, 3, value.result?.chatMessageId, true);
            } else {
              FlutterToast().getToast(upload_failed, Colors.red);
            }
          } else {
            FlutterToast().getToast(upload_failed, Colors.red);
          }
        } else {
          FlutterToast().getToast(upload_failed, Colors.red);
        }
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      setState(() {
        isLoading = false;
      });
    }
  }

  void FetchRecords(int position, bool allowSelect, bool isAudioSelect,
      bool isNotesSelect, List<String> mediaIds) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
          argument: MyRecordsArgument(
              categoryPosition: position,
              allowSelect: allowSelect,
              isAudioSelect: isAudioSelect,
              isNotesSelect: isNotesSelect,
              selectedMedias: mediaIds,
              showDetails: false,
              isFromChat: true,
              isAssociateOrChat: true,
              fromClass: 'chats')),
    ))
        .then((results) {
      if (results != null) {
        if (results.containsKey(STR_META_ID)) {
          healthRecordList = results[STR_META_ID] as List?;
          if (healthRecordList != null && healthRecordList?.length > 0) {
            getAlertForFileSend(healthRecordList);
          }
          setState(() {});
        }
      }
    });
  }

  getAlertForFileSend(var healthRecordList) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Send to Dr. ' + peerName! != null && peerName != '' ? peerName! : '',
          style: TextStyle(
            fontSize: fontSizeOne,
          ),
        ),
        actions: <Widget>[
          FlatButtonWidget(
            onPress: () => closeDialog(),
            title: 'Cancel',
            fontSize: fontSizeOne,
            bgColor: Colors.transparent,
            isSelected: true,
            /*child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: fontSizeOne,
              ),
            ),*/
          ),
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            title: 'Send',
            fontSize: fontSizeOne,
            onPress: () {
              closeDialog();
              getMediaURL(healthRecordList);
            },
            /*child: Text(
              'Send',
              style: TextStyle(
                fontSize: fontSizeOne,
              ),
            ),*/
          ),
        ],
      ),
    );
  }

  getMediaURL(List<HealthRecordCollection> healthRecordCollection) {
    for (int i = 0; i < healthRecordCollection.length; i++) {
      String? fileType = healthRecordCollection[i].fileType;
      String? fileURL = healthRecordCollection[i].healthRecordUrl;
      if ((fileType == STR_JPG) ||
          (fileType == STR_PNG) ||
          (fileType == STR_JPEG)) {
        //getAlertForFileSend(fileURL, 1);
        onSendMessage(fileURL, 1, null, false);
      } else if ((fileType == STR_PDF)) {
        //getAlertForFileSend(fileURL, 2);
        onSendMessage(fileURL, 2, null, false);
      } else if ((fileType == STR_AAC)) {
        //getAlertForFileSend(fileURL, 3);
        onSendMessage(fileURL, 3, null, false);
      }
    }
  }

  closeDialog() {
    Navigator.of(context).pop();
  }

  void clearSearchData() {
    listIndex = [];
    listIndex.clear();
    isFistClicked = false;
  }

  void getListIndexMapFilter() {
    searchIndexListAll.asMap().forEach((index, value) {
      if (value != null) {
        if (value.toLowerCase().contains('$textFieldValue'.toLowerCase())) {
          listIndex.add(index);
        }
      }
    });
  }

  Future<String> getLastReceivedDate() async {
    lastReceived = '';
    var familyListModel = await controller.getFamilyMappingList();
    if (familyListModel != null) {
      if (familyListModel?.result != null) {
        if (familyListModel?.result?.isNotEmpty) {
          if (familyListModel?.result?.length > 0) {
            for (Result data in familyListModel.result) {
              if (widget.peerName!.contains(data.firstName!)) {
                lastReceived = data.chatListItem?.deliveredOn != null &&
                        data.chatListItem?.deliveredOn != ''
                    ? CommonUtil()
                        .getFormattedDateTime(data.chatListItem!.deliveredOn!)
                    : '';
              }
            }
          }
        }
      }
    }
    return lastReceived ?? "";
  }

  Widget getLastReceivedDateWidget() {
    return FutureBuilder<String>(
      future: getLastReceivedDate(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return getWidgetTextForLastReceivedDate('Loading');
        } else if (snapshot.hasError) {
          return SizedBox.shrink();
        } else if (snapshot.hasData &&
            snapshot.data != '' &&
            snapshot.data != null) {
          return getWidgetTextForLastReceivedDate(
              LAST_RECEIVED + lastReceived!);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget getWidgetTextForLastReceivedDate(String value) {
    return Text(
      value,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
          fontFamily: font_poppins, fontSize: fontSizeTwo, color: Colors.white),
    );
  }

  Widget isSentViaSheelaTextWidget(ChatHistoryResult chatList, Color color) =>
      (chatList?.messages?.isSentViaSheela ?? false)
          ? Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(
                strSentViaSheela,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: color,
                    fontSize: fontSizeFour,
                    fontStyle: FontStyle.italic),
              ),
            )
          : SizedBox.shrink();
}

class TextFieldColorizer extends TextEditingController {
  final Map<String, TextStyle> map;
  final Pattern pattern;

  TextFieldColorizer(this.map)
      : pattern = RegExp(
            map.keys.map((key) {
              return key;
            }).join('|'),
            multiLine: true);

  @override
  set text(String? newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText?.length ?? 0),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    final List<InlineSpan> children = [];
    String? patternMatched;
    String? formatText;
    TextStyle? myStyle;
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        myStyle = map[match[0]!] ??
            map[map.keys.firstWhere(
              (e) {
                bool ret = false;
                RegExp(e).allMatches(text)
                  ..forEach((element) {
                    if (element.group(0) == match[0]) {
                      patternMatched = e;
                      ret = true;
                      return;
                    }
                  });
                return ret;
              },
            )];

        if (patternMatched == "#(.*?)#") {
          formatText = match[0]!.replaceAll("#", " ");
        } else {
          formatText = match[0];
        }
        children.add(TextSpan(
          text: formatText,
          style: style!.merge(myStyle),
        ));
        return "";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "";
      },
    );

    return TextSpan(style: style, children: children);
  }
}
