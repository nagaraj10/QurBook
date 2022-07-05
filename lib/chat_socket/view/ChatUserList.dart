import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/chat_socket/constants/const_socket.dart';
import 'package:myfhb/chat_socket/model/CaregiverPatientChatModel.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/chat_socket/viewModel/chat_socket_view_model.dart';
import 'package:myfhb/chat_socket/viewModel/getx_chat_view_model.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/landing/model/qur_plan_dashboard_model.dart';
import 'package:myfhb/landing/view/landing_arguments.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/services/FamilyMemberListRepository.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../model/UserChatListModel.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import '../../colors/fhb_colors.dart' as fhbColors;

import 'ChatDetail.dart';

class ChatUserList extends StatefulWidget {
  const ChatUserList({
    Key key,
    this.isHome = false,
    this.onBackPressed,
    this.careGiversList,
    this.isDynamicLink = false,
  }) : super(key: key);

  final bool isHome;
  final Function onBackPressed;
  final List<CareGiverInfo> careGiversList;
  final bool isDynamicLink;

  @override
  _ChatUserListState createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {
  var token = '';
  var userId = '';

  bool isLoading = false;

  String patientId = '';
  String patientName = '';

  ChatSocketService chocketService = new ChatSocketService();

  FamilyMembers familyMembersModel = new FamilyMembers();
  List<SharedByUsers> sharedbyme = new List();

  FamilyMembers familyData = new FamilyMembers();

  CaregiverPatientChatModel familyListModel;

  FlutterToast toast = FlutterToast();

  bool isShowNewChat = false;

  final controller = Get.put(ChatUserListController());

  @override
  Future<void> initState() {
    super.initState();

    token = PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    userId = PreferenceUtil.getStringValue(KEY_USERID);

    initSocket(true);

    mInitialTime = DateTime.now();

    getFamilyListMap();
  }

  void getFamilyListMap() async {
    familyListModel = await controller.getFamilyMappingList();
    if (familyListModel != null) {
      if (familyListModel?.result != null) {
        if (familyListModel?.result?.isNotEmpty) {
          if (familyListModel?.result?.length > 0) {
            controller.updateNewChatFloatShown(true);
          } else {
            controller.updateNewChatFloatShown(false);
          }
        } else {
          controller.updateNewChatFloatShown(false);
        }
      } else {
        controller.updateNewChatFloatShown(false);
      }
    }
  }

  void initSocket(bool isLoad) {
    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .off(message);

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .off(notifyChatList);

    if (isLoad) {
      setState(() {
        isLoading = true;
      });
    }

    var careGiverIds = [];

    if ((widget?.careGiversList?.length ?? 0) > 0) {
      widget?.careGiversList?.forEach((careGiver) {
        careGiverIds.add(careGiver.doctorId);
      });
    }

    emitGetUserList(careGiverIds, isLoad);

    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .on(notifyChatList, (data) {
      if (data != null) {
        emitGetUserList(careGiverIds, isLoad);
      }
    });
  }

  void emitGetUserList(var careGiverIds, bool isLoad) {
    Provider.of<ChatSocketViewModel>(Get.context, listen: false)
        ?.socket
        .emitWithAck(getChatsList, {
      'userId': userId,
      'isCaregiverFilter': (careGiverIds?.length ?? 0) > 0 ? true : false,
      'careGiverList': careGiverIds ?? [],
      'limit': 'all'
    }, ack: (userList) {
      if (userList != null) {
        UserChatListModel userChatList = UserChatListModel.fromJson(userList);
        if (userChatList != null) {
          Provider.of<ChatSocketViewModel>(Get.context, listen: false)
              ?.updateChatUserList(userChatList);
        }
      }
      if (mounted) {
        if (isLoad) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isHome
            ? null
            : AppBar(
                flexibleSpace: GradientAppBar(),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 24.0.sp,
                    ),
                    onPressed: () {
                      onBackPress();
                    }),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: Text(
                  ((widget?.careGiversList?.length ?? 0) > 0 ||
                          widget.isDynamicLink)
                      ? CAREPROVIDERS
                      : CHAT,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0.sp,
                  ),
                ),
                actions: [
                  Center(child: new CommonUtil().getNotificationIcon(context)),
                  SizedBoxWidget(
                    width: 10,
                  ),
                ],
              ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Color(CommonUtil().getMyPrimaryColor()),
              ))
            : WillPopScope(
                child: checkIfDoctorIdExist(),
                onWillPop: onBackPress,
              ),
        floatingActionButton: (widget?.careGiversList?.length ?? 0) > 0
            ? null
            : Obx(() => controller.shownNewChatFloat.isTrue &&
                    controller.isSelfUser()
                ? FloatingActionButton(
                    backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if ((familyListModel?.result?.length ?? 0) > 0) {
                        showDialogForFamilyMembers();
                      }
                    },
                  )
                : SizedBox.shrink()));
  }

  showDialogForFamilyMembers() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              child: Column(children: <Widget>[
                getFamilyListWidget(),
              ]),
            ),
          );
        });
  }

  Widget getFamilyListWidget() {
    if (familyListModel != null) {
      if (familyListModel?.result != null) {
        if (familyListModel?.result?.length > 0) {
          return Container(
            decoration: BoxDecoration(
                color: const Color(fhbColors.bgColorContainer),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        strNewChatLabel,
                        style: TextStyle(
                            fontSize: 18.0.sp, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black54,
                          size: 24.0.sp,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 440.0.h,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (c, i) =>
                        getCardWidgetForFamilyList(familyListModel?.result[i]),
                    itemCount: familyListModel?.result?.length ?? 0,
                  ),
                ),
              ],
            ),
          );
        } else {
          controller.updateNewChatFloatShown(false);
          getNofamilyWidget();
        }
      }
    } else {
      controller.updateNewChatFloatShown(false);
      getNofamilyWidget();
    }
  }

  Widget getNofamilyWidget() {
    return SafeArea(
      child: SizedBox(
        height: 1.sh / 1.3,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(strLabelNoFamily),
            )),
      ),
    );
  }

  Widget getCardWidgetForFamilyList(Result data) {
    var fulName = '';
    var ccName = '';
    try {
      if (data?.firstName != null && data?.firstName != '') {
        fulName = data?.firstName;
      }
      if (data?.lastName != null && data?.lastName != '') {
        fulName = fulName + ' ' + data?.lastName;
      }
    } catch (e) {}

    if (data?.isCarecoordinator) {
      try {
        if (data?.carecoordinatorfirstName != null &&
            data?.carecoordinatorfirstName != '') {
          ccName = data?.carecoordinatorfirstName;
        }
        if (data?.carecoordinatorLastName != null &&
            data?.carecoordinatorLastName != '') {
          ccName = ccName + ' ' + data?.carecoordinatorLastName;
        }
      } catch (e) {}
    }

    return Card(
      child: InkWell(
          onTap: () {
            Get.back();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetail(
                        peerId: data?.id,
                        peerAvatar: data?.profilePicThumbnailUrl,
                        peerName: getFamilyName(data),
                        patientId: '',
                        patientName: '',
                        patientPicture: '',
                        isFromVideoCall: false,
                        isFromFamilyListChat: true,
                        isFromCareCoordinator: data?.isCarecoordinator,
                        carecoordinatorId: data?.carecoordinatorId,
                        isCareGiver: (widget?.careGiversList?.length ?? 0) > 0
                            ? true
                            : false,
                        groupId: data?.chatListItem?.id ?? '',
                        lastDate: data?.chatListItem?.lastModifiedOn))).then(
                (value) {
              if (value) {
                initSocket(true);
              } else {
                initSocket(false);
              }
            });
          },
          child: Container(
              margin: EdgeInsets.only(bottom: 6),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  ClipOval(
                      child: data?.profilePicThumbnailUrl == null
                          ? Container(
                              width: 45.0.h,
                              height: 45.0.h,
                              color: Color(fhbColors.bgColorContainer),
                              child: Center(
                                child: Text(
                                  data != null
                                      ? data.firstName[0].toUpperCase()
                                      : '',
                                  style: TextStyle(
                                      fontSize: 22.0.sp,
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor())),
                                ),
                              ),
                            )
                          : Image.network(
                              data?.profilePicThumbnailUrl,
                              fit: BoxFit.cover,
                              width: 45.0.h,
                              height: 45.0.h,
                              headers: {
                                HttpHeaders.authorizationHeader:
                                    PreferenceUtil.getStringValue(
                                        KEY_AUTHTOKEN),
                              },
                              errorBuilder: (context, exception, stackTrace) {
                                return Container(
                                  height: 45.0.h,
                                  width: 45.0.h,
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  child: Center(
                                      child: Text(
                                    data?.firstName != null &&
                                            data?.lastName != null
                                        ? data?.firstName[0].toUpperCase() +
                                            (data?.lastName.length > 0
                                                ? data?.lastName[0]
                                                    .toUpperCase()
                                                : '')
                                        : data?.firstName != null
                                            ? data?.firstName[0].toUpperCase()
                                            : '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                                );
                              },
                            )),
                  SizedBox(
                    width: 20.0.w,
                  ),
                  Expanded(
                    // flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              fulName != null
                                  ? CommonUtil()
                                      .titleCase(fulName.toLowerCase())
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0.sp,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                            data?.isCarecoordinator
                                ? Text(
                                    ' (CC)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0.sp,
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        data?.isCarecoordinator
                            ? Text(
                                ccName != null
                                    ? 'CC: ' +
                                        CommonUtil()
                                            .titleCase(ccName.toLowerCase())
                                    : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0.sp,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                (data?.relationshipName != null &&
                                        data?.relationshipName != '')
                                    ? data?.relationshipName ?? ''
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              )
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  Widget checkIfDoctorIdExist() {
    return new FutureBuilder<String>(
      future: getPatientDetails(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            body: CommonCircularIndicator(),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          return getChatList();
        }
      },
    );
  }

  Widget getChatList() {
    return Stack(
      children: <Widget>[
        // List
        Container(
            child: (Provider.of<ChatSocketViewModel>(Get.context)
                            ?.userChatList
                            ?.length ??
                        0) >
                    0
                ? ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(
                        context,
                        Provider.of<ChatSocketViewModel>(Get.context)
                            ?.userChatList[index]),
                    itemCount: Provider.of<ChatSocketViewModel>(Get.context)
                        ?.userChatList
                        .length,
                  )
                : Container(
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          strNoMessage,
                          style: TextStyle(
                              fontSize: 16.0.sp, color: Colors.grey[800]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                  )),

        // Loading
        /*Positioned(
          child: isLoading ? CommonCircularIndicator() : Container(),
        )*/
      ],
    );
  }

  Widget buildItem(BuildContext context, PayloadChat userChatList) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDetail(
                        peerId: userChatList?.peerId,
                        peerAvatar: userChatList?.profilePicThumbnailURL,
                        peerName: getDocName(userChatList),
                        patientId: '',
                        patientName: '',
                        patientPicture: '',
                        isFromVideoCall: false,
                        isCareGiver: (widget?.careGiversList?.length ?? 0) > 0
                            ? true
                            : false,
                        groupId: userChatList?.id,
                        lastDate: userChatList?.deliveredTimeStamp != null &&
                                userChatList?.deliveredTimeStamp != ''
                            ? getFormattedDateTime(
                                DateTime.fromMillisecondsSinceEpoch(int.parse(
                                        userChatList?.deliveredTimeStamp))
                                    .toString())
                            : ''))).then((value) {
              if (value) {
                initSocket(true);
              } else {
                initSocket(false);
              }
            });
          },
          child: Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 1.sw * 0.025),
                Container(
                  width: 1.sw * 0.12,
                  height: 1.sw * 0.12,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipOval(
                          child: userChatList?.profilePicThumbnailURL != null
                              ? CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: CommonCircularIndicator(),
                                        width: 50.0,
                                        height: 50.0,
                                        padding: EdgeInsets.all(15.0),
                                      ),
                                  imageUrl:
                                      userChatList?.profilePicThumbnailURL,
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height: 50.0.h,
                                        width: 50.0.h,
                                        color: Colors.grey[200],
                                        child: Center(
                                            child: Text(
                                          userChatList?.firstName != null
                                              ? userChatList?.firstName[0]
                                                  .toString()
                                                  .toUpperCase()
                                              : '',
                                          style: TextStyle(
                                            color: Color(new CommonUtil()
                                                .getMyPrimaryColor()),
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                      ))
                              : Icon(
                                  Icons.account_circle,
                                  size: 50.0,
                                  color: greyColor,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 1.sw * 0.055,
                ),
                Container(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            CommonUtil().capitalizeFirstofEach(
                                getDocName(userChatList)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0.sp,
                                fontFamily: variable.font_poppins),
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                            constraints: BoxConstraints(maxWidth: 1.sw * 0.5),
                            padding: const EdgeInsets.only(bottom: 4),
                            child: userChatList?.messages != null
                                ? userChatList?.messages?.content != null
                                    ? userChatList?.messages?.content
                                            .contains(STR_HTTPS)
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.photo,
                                                size: 16.0.sp,
                                                color: Colors.black54,
                                              ),
                                              SizedBoxWidget(
                                                width: 3,
                                              ),
                                              Text(
                                                STR_FILE,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14.0.sp,
                                                    fontFamily:
                                                        variable.font_poppins),
                                              )
                                            ],
                                          )
                                        : Text(
                                            userChatList?.messages?.content ??
                                                '',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                                fontSize: 14.0.sp,
                                                fontFamily:
                                                    variable.font_poppins),
                                          )
                                    : SizedBox.shrink()
                                : SizedBox.shrink()),
                        SizedBox(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            userChatList?.deliveredTimeStamp != null &&
                                    userChatList?.deliveredTimeStamp != ''
                                ? LAST_RECEIVED +
                                    getFormattedDateTime(
                                        (DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(userChatList
                                                    ?.deliveredTimeStamp))
                                            .toString()))
                                : '',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey[600],
                                fontSize: 12.0.sp,
                                fontFamily: variable.font_poppins),
                          ),
                        ),
                        if ((widget?.careGiversList?.length ?? 0) > 0 &&
                            userChatList?.isDisable != null &&
                            userChatList?.isDisable == true)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              STR_NOT_AVAILABLE,
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 14.0.sp,
                                  fontFamily: variable.font_poppins),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 1.sw * 0.035,
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 4, 4),
                          child: (userChatList?.unReadCount != null &&
                                  userChatList?.unReadCount != '' &&
                                  !userChatList?.unReadCount?.contains('0'))
                              ? Container(
                                  width: 60,
                                  height: 50,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 5, 0, 0),
                                          child: CircleAvatar(
                                            radius: 10,
                                            child: Text(
                                              userChatList?.unReadCount ?? '',
                                              style: TextStyle(
                                                fontSize: 12.0.sp,
                                              ),
                                            ),
                                            backgroundColor: Color(CommonUtil()
                                                .getMyPrimaryColor()),
                                            foregroundColor: Colors.white,
                                          )),
                                    ],
                                  ),
                                )
                              : Text(''))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey,
          height: 0.5,
          margin: EdgeInsets.only(bottom: 6),
        )
      ],
    );
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('MMM d, hh:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  Future<String> getPatientDetails() async {
    patientId = PreferenceUtil.getStringValue(KEY_USERID);

    MyProfileModel myProfile = PreferenceUtil.getProfileData(KEY_PROFILE);
    patientName = myProfile.result != null
        ? myProfile.result.firstName + myProfile.result.firstName
        : '';
    return patientId;
  }

  Future<bool> onBackPress() {
    //socket.disconnect();
    if (!widget.isHome) {
      if (Navigator.canPop(context)) {
        Get.back();
      } else {
        Get.offAllNamed(
          rt_Landing,
          arguments: const LandingArguments(
            needFreshLoad: false,
          ),
        );
      }
    } else {
      widget.onBackPressed();
    }
    return Future.value(false);
  }

  String getDocName(PayloadChat userChatList) {
    String name = '';
    if (userChatList != null) {
      if (userChatList?.firstName != null && userChatList?.firstName != '') {
        if (userChatList?.lastName != null && userChatList?.lastName != '') {
          name = userChatList.firstName + ' ' + userChatList.lastName ?? '';
        } else {
          name = (userChatList?.firstName ?? '').toString();
        }
      } else {
        name = '';
      }
    } else {
      name = '';
    }

    return name;
  }

  String getFamilyName(Result users) {
    String name = '';
    if (users != null) {
      if (users?.firstName != null && users?.firstName != '') {
        if (users?.lastName != null && users?.lastName != '') {
          name = users?.firstName + ' ' + users?.lastName ?? '';
        } else {
          name = (users?.firstName ?? '').toString();
        }
      } else {
        name = '';
      }
    } else {
      name = '';
    }

    return name;
  }

  @override
  void dispose() {
    super.dispose();
    //socket.disconnect();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Chat Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }
}
