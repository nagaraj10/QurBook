import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/chat_socket/constants/const_socket.dart';
import 'package:myfhb/chat_socket/model/ChatHistoryModel.dart';
import 'package:myfhb/chat_socket/model/EmitAckResponse.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/ui/bot/widgets/youtube_player.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/telehealth/features/chat/model/AppointmentDetailModel.dart';
import 'package:myfhb/telehealth/features/chat/view/ChooseDateSlot.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFModel.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFView.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChatDetail extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String patientPicture;

  final String peerId;
  final String peerName;
  final String peerAvatar;

  final String carecoordinatorId;

  final bool isFromVideoCall;
  final String message;
  final bool isCareGiver;
  final bool isForGetUserId;
  final bool isFromFamilyListChat;
  final bool isFromCareCoordinator;

  final String lastDate;

  final String groupId;
  final String familyUserId;

  const ChatDetail(
      {Key key,
      @required this.peerId,
      @required this.peerName,
      @required this.peerAvatar,
      @required this.patientId,
      @required this.patientName,
      @required this.patientPicture,
      @required this.isFromVideoCall,
      @required this.groupId,
      this.message,
      this.isCareGiver,
      this.carecoordinatorId,
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
  var token = '';
  var userId = '';

  //IO.Socket socket;

  Future<ChatHistoryModel> chatHistoryModel;

  ChatViewModel chatViewModel = new ChatViewModel();
  AppointmentResult appointmentResult;

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
  List<String> recordIds = new List();
  FlutterToast toast = new FlutterToast();

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

  String peerId = '';
  String chatPeerId = '';
  String peerName = '';
  String peerAvatar = '';

  String patientId = '';
  String patientName = '';
  String patientPicUrl = '';

  String bookingId = '-';
  String lastAppointmentDate = '';
  String nextAppointmentDate = '';
  String doctorDeviceToken = '';
  String patientDeviceToken = '';
  String currentPlayedVoiceURL = '';

  String carecoordinatorId = '';

  String textValue = '';

  String groupId = '';

  String familyUserId = '';

  String careCoordinatorName = '';

  bool isLoading = false;

  bool isFromVideoCall = false;

  //bool firstTime = true;

  bool isFistClicked = false;

  var listMessage;

  bool isCareGiver = false;

  bool isForGetUserId = false;

  var isSearchVisible = false;

  bool isCareGiverApi = true;

  bool isFamilyPatientApi = true;

  bool isChatDisable = true;

  bool isCallBackDisable = false;

  bool isFromFamilyListChat = false;

  bool isFromCareCoordinator = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();

  String audioPath;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatSocketViewModel>(
        Get.context,
        listen: false,
      )?.updateChatHistoryList([], shouldUpdate: false);
    });

    peerId = widget.peerId;
    peerName = widget.peerName;
    peerAvatar = widget.peerAvatar;

    isCareGiver = widget.isCareGiver;
    isForGetUserId = widget.isForGetUserId;
    carecoordinatorId = widget.carecoordinatorId;
    isFromFamilyListChat = widget.isFromFamilyListChat;
    isFromCareCoordinator = widget.isFromCareCoordinator;
    isFromVideoCall = widget.isFromVideoCall;

    groupId = widget.groupId;

    familyUserId = widget.familyUserId;

    token = PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    userId = PreferenceUtil.getStringValue(KEY_USERID);

    initSocket();

    initLoader();

    getPatientDetails();
    set_up_audios();

    if (isForGetUserId) {
      Provider.of<ChatSocketViewModel>(context, listen: false)
          .getUserIdFromDocId(peerId)
          .then((value) {
        if (value != null) {
          if (value?.result != null) {
            if (value?.result?.user != null) {
              if (value?.result?.user?.id != null &&
                  value?.result?.user?.id != '') {
                chatPeerId = value?.result?.user?.id;
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

    textEditingController.text = widget?.message;
  }

  void scrollToPosiiton(int commonIndex) async {
    await listScrollController.scrollTo(
        index: listIndex[commonIndex], duration: Duration(milliseconds: 100));

    //Scrollable.ensureVisible(context);
  }

  void getChatHistory() {
    chatHistoryModel = Provider.of<ChatSocketViewModel>(context, listen: false)
        .getChatHistory(chatPeerId, familyUserId, isFromCareCoordinator,
            carecoordinatorId, isFromFamilyListChat);
  }

  void getGroupId() {
    if (groupId == '' || groupId == null) {
      if (isFromFamilyListChat) {
        Provider.of<ChatSocketViewModel>(context, listen: false)
            .initNewFamilyChat(
                chatPeerId, peerName, isFromCareCoordinator, carecoordinatorId)
            .then((value) {
          if (value != null) {
            if (value?.result != null) {
              if (value?.result?.chatListId != null &&
                  value?.result?.chatListId != '') {
                groupId = value.result.chatListId;
                updateReadCount();
              }
            }
          }
        });
      } else {
        Provider.of<ChatSocketViewModel>(context, listen: false)
            .initNewChat(chatPeerId)
            .then((value) {
          if (value != null) {
            if (value?.result != null) {
              if (value?.result?.chatListId != null &&
                  value?.result?.chatListId != '') {
                groupId = value.result.chatListId;
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
      MyProfileModel myProfile = PreferenceUtil.getProfileData(KEY_PROFILE);
      patientName = myProfile.result != null
          ? myProfile.result.firstName + ' ' + myProfile.result.lastName
          : '';
    }

    if (patientPicUrl == null || patientPicUrl == '') {
      patientPicUrl = getProfileURL();
    }

    parseData();
  }

  String getProfileURL() {
    MyProfileModel myProfile = PreferenceUtil.getProfileData(KEY_PROFILE);
    String patientPicURL = myProfile.result.profilePicThumbnailUrl;

    return patientPicURL;
  }

  void initSocket() {
    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .off(message);

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .on(message, (data) {
      if (data != null) {
        //print('OnMessageack$data');
        ChatHistoryResult emitAckResponse = ChatHistoryResult.fromJson(data);
        if (emitAckResponse != null) {
          if (isFromCareCoordinator) {
            if (carecoordinatorId == emitAckResponse.messages.idFrom) {
              Provider.of<ChatSocketViewModel>(Get.context, listen: false)
                  ?.onReceiveMessage(emitAckResponse);
              updateReadCount();
            }
          } else {
            if (chatPeerId == emitAckResponse.messages.idFrom) {
              Provider.of<ChatSocketViewModel>(Get.context, listen: false)
                  ?.onReceiveMessage(emitAckResponse);
              updateReadCount();
            }
          }
        }
      }
    });
  }

  updateReadCount() {
    var data = {"chatListId": groupId, "userId": userId};

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .emitWithAck(unreadNotification, data, ack: (res) {
      //print('emitWithackCount$res');
    });
  }

  parseData() async {
    await chatViewModel
        .fetchAppointmentDetail(widget.peerId, userId, carecoordinatorId)
        .then((value) {
      appointmentResult = value;
      if (appointmentResult != null) {
        setState(() {
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
                  ? appointmentResult?.deviceToken?.doctor?.payload?.isNotEmpty
                      ? appointmentResult
                          .deviceToken?.doctor?.payload[0]?.deviceTokenId
                      : ''
                  : ''
              : '';
          patientDeviceToken = '';
          if (appointmentResult?.deviceToken != null) {
            if (appointmentResult?.deviceToken?.patient?.isSuccess &&
                appointmentResult?.deviceToken?.patient?.payload?.isNotEmpty &&
                appointmentResult
                        ?.deviceToken?.patient?.payload[0]?.deviceTokenId !=
                    null) {
              patientDeviceToken = appointmentResult
                  ?.deviceToken?.patient?.payload[0]?.deviceTokenId;
            } else if (appointmentResult
                    ?.deviceToken?.parentMember?.isSuccess &&
                appointmentResult
                    ?.deviceToken?.parentMember?.payload?.isNotEmpty &&
                appointmentResult?.deviceToken?.parentMember?.payload[0]
                        ?.deviceTokenId !=
                    null) {
              patientDeviceToken = appointmentResult
                  ?.deviceToken?.parentMember?.payload[0]?.deviceTokenId;
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
                      ?.doctorOrCarecoordinatorInfo?.carecoordinatorfirstName ??
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
                  appointmentResult
                      ?.doctorOrCarecoordinatorInfo?.carecoordinatorLastName;
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
    return new FutureBuilder<ChatHistoryModel>(
      future: chatHistoryModel,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 1.4,
              child: new Center(
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
          Provider.of<ChatSocketViewModel>(Get.context, listen: false)
              ?.updateChatHistoryList(snapshot?.data?.result,
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
    super.dispose();
  }

  void onSendMessage(
      String content, int type, String chatMessageId, bool isNotUpload) async {
    if (content != null) {
      if (content.trim() != '') {
        textValue = textEditingController.text;
        textEditingController.clear();

        var data = {
          "id": groupId,
          'idFrom': userId,
          'idTo': isFromCareCoordinator ? carecoordinatorId : chatPeerId,
          "type": type,
          "isread": false,
          'content': content,
          'chatMessageId': chatMessageId,
          'isUpload': isNotUpload,
          'isPatient': isFamilyPatientApi
        };

        try {
          Provider.of<ChatSocketViewModel>(Get.context, listen: false)
              ?.socket
              .emitWithAck(message, data, ack: (res) {
            //print('emitWithack$res');
            if (res != null) {
              EmitAckResponse emitAckResponse = EmitAckResponse.fromJson(res);
              if (emitAckResponse != null) {
                if (emitAckResponse?.lastSentMessageInfo != null) {
                  Provider.of<ChatSocketViewModel>(Get.context, listen: false)
                      ?.messageEmit(emitAckResponse?.lastSentMessageInfo);
                  /*listScrollController.scrollTo(
                    index: Provider.of<ChatSocketViewModel>(Get.context,listen: false)?.chatHistoryList.length,
                    duration: Duration(milliseconds: 100));*/
                }
              }
            }
          });
        } catch (e) {
          //print('execption$e');
        }

        textValue = '';
      } else {
        Fluttertoast.showToast(msg: NOTHING_SEND, backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(1.sh * 0.15),
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
                    new Theme(
                      data: new ThemeData(
                        accentColor: Colors.transparent,
                      ),
                      child: Container(
                        height: 1.sw * 0.1,
                        width: 1.sw * 0.1,
                        child: new FloatingActionButton(
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
                    new Theme(
                      data: new ThemeData(
                        accentColor: Colors.transparent,
                      ),
                      child: Container(
                        height: 1.sw * 0.1,
                        width: 1.sw * 0.1,
                        child: new FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            //firstTime = false;
                            if (!isFistClicked) {
                              isFistClicked = true;
                              if (textFieldValue != null &&
                                  textFieldValue != '' &&
                                  textFieldValue.length > 2) {
                                getListIndexMapFilter();
                                commonIndex = listIndex?.length ?? 0;
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
              Color(new CommonUtil().getMyPrimaryColor()),
              Color(new CommonUtil().getMyGredientColor())
            ],
                stops: [
              0.3,
              1.0
            ])),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(
                      width: 1.sw * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isCallBackDisable && isCareGiver
                            ? SizedBoxWithChild(
                                height: 24.0.h,
                                width: 24.0.w,
                                child: IconButton(
                                  padding: new EdgeInsets.all(0.0),
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
                                                  chatPeerId,
                                                  familyUserId,
                                                  isFromCareCoordinator,
                                                  carecoordinatorId,
                                                  isFromFamilyListChat);
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
                        SizedBox(width: 1.sw * 0.04),
                        SizedBoxWithChild(
                          height: 24.0.h,
                          width: 24.0.w,
                          child: moreOptionsPopup(),
                        )
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
      onSelected: (newValue) {
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
                  fontSize: 16.0.sp,
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
            (listIndex?.length > 1
                ? listIndex?.length - 1
                : listIndex?.length ?? 0)) {
          commonIndex = commonIndex;
          scrollToPosiiton(commonIndex);
        }
        /*else {
          toast.getToast('No data', Colors.red);
        }*/
      }
    }
  }

  Widget _patientDetailOrSearch() {
    var resultWidget = null;
    setState(() {
      if (isSearchVisible) {
        resultWidget = AnimatedSwitcher(
          duration: Duration(milliseconds: 10),
          child: Container(
            height: 45.0.h,
            child: TextField(
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
                    icon: Icon(Icons.clear, size: 20),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16.0.sp,
                  ),
                  fillColor: Colors.white70),
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
                    widget?.peerAvatar != null ? widget?.peerAvatar ?? '' : '',
                    height: 40.0.h,
                    width: 40.0.h,
                    fit: BoxFit.cover, errorBuilder: (BuildContext context,
                        Object exception, StackTrace stackTrace) {
                  return Container(
                    height: 50.0.h,
                    width: 50.0.h,
                    color: Colors.grey[200],
                    child: Center(
                        child: Text(
                      widget.peerName != null && widget.peerName != ''
                          ? widget.peerName[0].toString().toUpperCase()
                          : '',
                      style: TextStyle(
                        color: Color(new CommonUtil().getMyPrimaryColor()),
                        fontSize: 16.0.sp,
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
                            ? isFromCareCoordinator
                                ? widget.peerName?.capitalizeFirstofEach +
                                    ' (CC)'
                                : widget.peerName?.capitalizeFirstofEach
                            : '',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: font_poppins,
                            fontSize: 16.0.sp,
                            color: Colors.white)),
                    getTopBookingDetail(),
                    widget.lastDate != null
                        ? Text(
                            LAST_RECEIVED + widget.lastDate,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: font_poppins,
                                fontSize: 12.0.sp,
                                color: Colors.white),
                          )
                        : SizedBox.shrink()
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
    if (isFromCareCoordinator) {
      return Text('CC: ' + careCoordinatorName,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontFamily: font_poppins,
              fontSize: 12.0.sp,
              color: Colors.white));
    } else {
      if (!isCareGiverApi) {
        if (!isFromFamilyListChat) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Id: ' + bookingId,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: font_poppins,
                        fontSize: 12.0.sp,
                        color: Colors.white)),
                Text(
                    'Next Appointment: ' +
                        getFormattedDateTimeAppbar(nextAppointmentDate),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: font_poppins,
                        fontSize: 12.0.sp,
                        color: Colors.white)),
                Text(
                    toBeginningOfSentenceCase('Last Appointment: ' +
                        getFormattedDateTimeAppbar(lastAppointmentDate)),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: font_poppins,
                        fontSize: 12.0.sp,
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
      padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) {
        var chatList = Provider.of<ChatSocketViewModel>(Get.context)
            ?.chatHistoryList
            .reversed
            .toList();

        searchIndexListAll = [];
        searchIndexListAll.clear();
        /*listIndex = [];
        listIndex.clear();*/
        for (int i = 0; i < chatList.length; i++) {
          String content = chatList[i]?.messages?.content;

          searchIndexListAll.add(content);
        }

        bool isIconNeed = false;

        if (chatList[index]?.messages?.idFrom == patientId) {
          isIconNeed = isLastMessageRight(index, chatList);
        } else if (chatList[index]?.messages?.idFrom != patientId) {
          isIconNeed = isLastMessageLeft(index, chatList);
        } else {
          isIconNeed = false;
        }

        return buildItem(chatList[index], index, isIconNeed);
      },
      itemCount: Provider.of<ChatSocketViewModel>(Get.context)
              ?.chatHistoryList
              ?.reversed
              ?.toList()
              ?.length ??
          0,
      reverse: true,
      itemScrollController: listScrollController,
    ));
  }

  Widget buildInput() {
    return IconTheme(
      data: IconThemeData(color: Color(new CommonUtil().getMyPrimaryColor())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                height: 58.0.h,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
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
                              FlatButton(
                                  onPressed: () {
                                    recordIds.clear();
                                    FetchRecords(
                                        0, true, true, false, recordIds);
                                  },
                                  child: new Icon(
                                    Icons.attach_file,
                                    color:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                    size: 22,
                                  ))
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
              child: new Container(
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
                    child: new Container(
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
                                  audioPath, userId, chatPeerId, groupId);
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
                : Container()
          ],
        ),
      ),
    );
  }

  Widget buildItem(ChatHistoryResult chatList, int index, bool isIconNeed) {
    List<TextSpan> textSpanList = [];

    if (chatList?.messages?.type == 0) {
      String tempData = chatList?.messages?.content;

      textSpanList = [
        buildTextWithLinks(
            tempData, index, chatList?.messages?.idFrom == patientId)
      ];
      //firstTime = false;
      //commonIndex=indexList.length-1;
    }

    if (chatList?.messages?.idFrom == patientId) {
      return Row(
        children: <Widget>[
          chatList?.messages?.type == 0
              // Text
              ? Card(
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
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    /*child: Text(
                      document[STR_CONTENT],
                      style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor())),
                    ),*/
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            fontSize: 16.0.sp,
                          ),
                          children: textSpanList),
                    ),
                  ),
                )
              : chatList?.messages?.type == 1
                  // Image
                  ? Container(
                      child: FlatButton(
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
                            imageUrl: chatList?.messages?.content ?? '',
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
                                      url: chatList?.messages?.content)));
                        },
                        onLongPress: () {
                          openDownloadAlert(chatList?.messages?.content,
                              context, false, '.jpg');
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isIconNeed ? 20.0 : 10.0, right: 10.0),
                    )
                  // Pdf
                  : chatList?.messages?.type == 2
                      ? Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                          child: InkWell(
                            onTap: () {
                              goToPDFViewBasedonURL(
                                  chatList?.messages?.content);
                            },
                            onLongPress: () {
                              openDownloadAlert(chatList?.messages?.content,
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
                      : chatList?.messages?.type == 3
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
                                          chatList?.messages?.content)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Image.asset(
                                'images/${chatList?.messages?.content}.gif',
                                width: 100.0.h,
                                height: 100.0.h,
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom: isIconNeed ? 20.0 : 10.0,
                                  right: 10.0),
                            ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
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
                            imageUrl:
                                peerAvatar != null ? peerAvatar ?? '' : '',
                            width: 35.0.h,
                            height: 35.0.h,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                                  height: 35.0.h,
                                  width: 35.0.h,
                                  color: Colors.grey[200],
                                  child: Center(
                                      child: Text(
                                    peerName != null && peerName != ''
                                        ? peerName[0].toString().toUpperCase()
                                        : '',
                                    style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                                )),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 38.0.w),
                chatList?.messages?.type == 0
                    ? Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 1.sw * .6,
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
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: textSpanList),
                          ),
                        ),
                      )
                    : chatList?.messages?.type == 1
                        ? Container(
                            child: FlatButton(
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
                                  imageUrl: chatList?.messages?.content ?? '',
                                  width: 200.0.h,
                                  height: 200.0.h,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: chatList?.messages?.content)));
                              },
                              onLongPress: () {
                                openDownloadAlert(chatList?.messages?.content,
                                    context, false, '.jpg');
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : chatList?.messages?.type == 2
                            ? Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25))),
                                child: InkWell(
                                  onTap: () {
                                    goToPDFViewBasedonURL(
                                        chatList?.messages?.content);
                                  },
                                  onLongPress: () {
                                    openDownloadAlert(
                                        chatList?.messages?.content,
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
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : chatList?.messages?.type == 3
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
                                            fhbBasicWidget
                                                .getAudioWidgetForChat(
                                                    chatList?.messages?.content)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Image.asset(
                                      'images/${chatList?.messages?.content}.gif',
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
            // Time
            isIconNeed
                ? Container(
                    child: Text(
                      getFormattedDateTime(DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                  chatList?.messages?.timestamp?.sSeconds))
                          .toString()),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 14.0.sp,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
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
                fontSize: 16.0.sp,
              ),
            ),
          ),
          onTap: () {
            openYoutubeDialog(text);
          },
        ),
      );

  WidgetSpan buildDateComponent(
          String text, String linkToOpen, int index, bool isPatient) =>
      WidgetSpan(
        child: !isPatient
            ? InkWell(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: RichText(
                      text: TextSpan(
                        children: getSplittedTextWidget(chooseYourDate, index),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  FocusManager.instance.primaryFocus.unfocus();
                  //tapDatePicker();
                  //Get.to(ChooseDateSlot());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseDateSlot()),
                  ).then((value) {
                    if (value != null) {
                      List<String> result = [];
                      result.add(value);
                      try {
                        if (result?.length > 0) {
                          final removedBrackets = result
                              .toString()
                              .substring(2, result.toString().length - 2);
                          if (removedBrackets.length > 0) {
                            onSendMessage(
                                removedBrackets.toString(), 0, null, true);
                          }
                        }
                      } catch (e) {
                        //print(e);
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
    final RegExp dateRegExp = RegExp('($datePattern)', caseSensitive: false);
    final RegExp linkRegExp = RegExp('($urlPattern)', caseSensitive: false);

    final List<InlineSpan> list = <InlineSpan>[];
    final RegExpMatch dateMatch = dateRegExp.firstMatch(text);
    final RegExpMatch match = linkRegExp.firstMatch(text);

    if (match == null && dateMatch == null) {
      list.add(TextSpan(children: getSplittedTextWidget(text, index)));
      return list;
    }

    if ((match?.start ?? 0) > 0) {
      list.add(TextSpan(
          children:
              getSplittedTextWidget(text.substring(0, match.start), index)));
    }

    if ((dateMatch?.start ?? 0) > 0) {
      list.add(TextSpan(
          children: getSplittedTextWidget(
              text.substring(0, dateMatch.start), index)));
    }

    final String linkText = match?.group(0) ?? '';
    final String dateText = dateMatch?.group(0) ?? '';
    if (linkText.contains(RegExp(urlPattern, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, linkText, index, isPatient));
    }

    if (dateText.contains(RegExp(datePattern, caseSensitive: false))) {
      list.add(buildDateComponent(dateText, dateText, index, isPatient));
    }

    list.addAll(linkify(
        text.substring(match != null
            ? match?.start + linkText?.length
            : (dateMatch != null ? dateMatch?.start + dateText?.length : 0)),
        index,
        isPatient));

    return list;
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

  String getFormattedDateTimeAppbar(String datetime) {
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
    if (document?.messages?.timestamp?.sSeconds != null &&
        document?.messages?.timestamp?.sSeconds != '') {
      DateTime dateTimeFromServerTimeStamp =
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(document?.messages?.timestamp?.sSeconds));
      return Text(
        'File ' + dateTimeFromServerTimeStamp.millisecondsSinceEpoch.toString(),
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
        ),
      );
    } else {
      return Text(
        'Click to View Pdf',
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
        ),
      );
    }
  }

  openDownloadAlert(
      String fileUrl, BuildContext contxt, bool isPdf, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure want to download?',
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                saveImageToGallery(fileUrl, contxt, isPdf, type);
                Navigator.pop(context);
              },
              child: Text(
                'Download',
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  goToPDFViewBasedonURL(String url) {
    final controller = Get.find<PDFViewController>();
    final data = OpenPDF(type: PDFLocation.URL, path: url);
    controller.data = data;
    Get.to(() => PDFView());
  }

  bool isLastMessageRight(int index, List<ChatHistoryResult> list) {
    if (index == 0 ||
        (index > 0 &&
            list != null &&
            list[index - 1]?.messages?.idFrom != patientId)) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageLeft(int index, List<ChatHistoryResult> list) {
    if (index == 0 ||
        (index > 0 &&
            list != null &&
            list[index - 1]?.messages?.idFrom == patientId)) {
      return true;
    } else {
      return false;
    }
  }

  void saveImageToGallery(String fileUrl, BuildContext contxt,
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

    String _currentImage;

    final snackBar = SnackBar(
      content: Text(
        strDownloadStart,
        style: TextStyle(
          fontSize: 16.0.sp,
        ),
      ),
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
    );

    //Scaffold.of(contxt).showSnackBar();

    _scaffoldKey.currentState.showSnackBar(snackBar);

    if (isPdfPresent) {
      if (Platform.isIOS) {
        final file = await CommonUtil.downloadFile(fileUrl, fileType);
        /*Scaffold.of(contxt).showSnackBar(
          ,
        );*/

        final snackBar = SnackBar(
          content: Text(
            strFileDownloaded,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () async {
              await OpenFile.open(
                file.path,
              );
              // final controller = Get.find<PDFViewController>();
              // final data = OpenPDF(type: PDFLocation.Path, path: file.path);
              // controller.data = data;
              // Get.to(() => PDFView());
            },
          ),
        );

        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        await ImageGallerySaver.saveFile(fileUrl).then((res) {
          setState(() {
            downloadStatus = true;
          });
        });
      }
    } else {
      _currentImage = fileUrl;
      try {
        CommonUtil.downloadFile(_currentImage, fileType).then((filePath) async {
          if (Platform.isAndroid) {
            //Scaffold.of(contxt).showSnackBar();

            final snackBar = SnackBar(
              content: Text(
                strFileDownloaded,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
              backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () async {
                  await OpenFile.open(
                    filePath.path,
                  );

                  // final controller = Get.find<PDFViewController>();
                  // final data =
                  //     OpenPDF(type: PDFLocation.Path, path: filePath.path);
                  // controller.data = data;
                  // Get.to(() => PDFView());
                },
              ),
            );

            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        });
      } catch (e) {}
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
          if (value?.isSuccess) {
            if (value?.result != null) {
              onSendMessage(value?.result?.fileUrl, 3,
                  value?.result?.chatMessageId, true);
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
    } catch (e) {
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
          healthRecordList = results[STR_META_ID] as List;
          if (healthRecordList != null && healthRecordList?.length > 0 ?? 0) {
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
          'Send to Dr. ' + peerName != null && peerName != '' ? peerName : '',
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => closeDialog(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              closeDialog();
              getMediaURL(healthRecordList);
            },
            child: Text(
              'Send',
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  getMediaURL(List<HealthRecordCollection> healthRecordCollection) {
    for (int i = 0; i < healthRecordCollection.length; i++) {
      String fileType = healthRecordCollection[i].fileType;
      String fileURL = healthRecordCollection[i].healthRecordUrl;
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
        if (value?.toLowerCase().contains('$textFieldValue'.toLowerCase())) {
          listIndex.add(index);
        }
      }
    });
  }
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
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText?.length ?? 0),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext context, TextStyle style, bool withComposing}) {
    final List<InlineSpan> children = [];
    String patternMatched;
    String formatText;
    TextStyle myStyle;
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        myStyle = map[match[0]] ??
            map[map.keys.firstWhere(
              (e) {
                bool ret = false;
                RegExp(e).allMatches(text)
                  ..forEach((element) {
                    if (element.group(0) == match[0]) {
                      patternMatched = e;
                      ret = true;
                      return true;
                    }
                  });
                return ret;
              },
            )];

        if (patternMatched == "#(.*?)#") {
          formatText = match[0].replaceAll("#", " ");
        } else {
          formatText = match[0];
        }
        children.add(TextSpan(
          text: formatText,
          style: style.merge(myStyle),
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
