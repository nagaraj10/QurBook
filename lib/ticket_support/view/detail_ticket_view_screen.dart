import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFModel.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFView.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:myfhb/ticket_support/model/ticket_details_model.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/TicketsListResponse.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import 'package:path/path.dart' as p;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as strConstants;
import 'package:myfhb/colors/fhb_colors.dart' as colors;
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import 'package:myfhb/common/CommonUtil.dart' as commonUtils;
import '../../constants/variable_constant.dart' as variable;

var fullName, date, isUser;

class DetailedTicketView extends StatefulWidget {
  DetailedTicketView(this.ticket);

  final Tickets ticket;
  @override
  State createState() {
    return _DetailedTicketViewState();
  }
}

class _DetailedTicketViewState extends State<DetailedTicketView>
    with SingleTickerProviderStateMixin {
  TicketViewModel ticketViewModel = TicketViewModel();
  final FocusNode focusNode = FocusNode();
  final ItemScrollController listScrollController = ItemScrollController();
  final addCommentController = TextEditingController();

  final List<Events> listOfEvents = [
    Events(
        time: constants.notificationDate('${DateTime.now().toString()}'),
        eventName: "Ticket Raised",
        description: "Ticket Raised"),
    Events(
        time: constants.notificationDate('${DateTime.now().toString()}'),
        eventName: "Ticket has assigned to",
        description: "Ticket has assigned to"),
    Events(
        time: constants.notificationDate('${DateTime.now().toString()}'),
        eventName: "Chat",
        description: "Chat"),
  ];

  Future<TicketDetailResponseModel> future;
  TabController _controller;
  int selectedTab = 0;
  String authToken = '';
  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    _controller.addListener(_handleTabSelection);
    callTicketDetailsApi();

    // _getHistoryData(widget.ticketUid);
  }

  callTicketDetailsApi() async {
    var token = await PreferenceUtil.getStringValue(KEY_AUTHTOKEN);
    setState(() {
      authToken = token;
      future = ticketViewModel.getTicketDetail(widget.ticket.uid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(strConstants.strMyTickets),
      ),
      body: getData(),
    );
  }

  Widget getData() {
    return FutureBuilder<TicketDetailResponseModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
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
          return SingleChildScrollView(
              child: detailView(snapshot.data.result.ticket));
        }
      },
    );
  }

  Widget detailView(Ticket ticket) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Status : ',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            widget.ticket.status == 0 ? 'Open' : 'Closed',
                            style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.orangeAccent[100]),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Spacer(flex: 1),
                          Flexible(
                            child: Row(
                              children: [
                                Text(
                                  'Ticket ID :',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w100,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  ' #${widget.ticket.uid.toString()}',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w100,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        ticket?.subject?.toString().capitalizeFirstofEach,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      ticket.preferredDate != null
                          ? Text(
                              constants.notificationDate(
                                  '${ticket.preferredDate.toString()}'),
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w100,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          : SizedBox(),
                      CommonUtil()
                              .validString(ticket?.preferredLabName ?? '')
                              .trim()
                              .isNotEmpty
                          ? commonWidgetForDropDownValue(
                              "Preferred Lab Name",
                              CommonUtil().parseHtmlString(
                                  ticket.preferredLabName ?? ''))
                          : SizedBox.shrink(),
                      (ticket?.additionalInfo?.chooseCategory != null &&
                              ticket?.additionalInfo?.chooseCategory != "")
                          ? commonWidgetForDropDownValue("Category Name",
                              ticket?.additionalInfo?.chooseCategory ?? '')
                          : SizedBox.shrink(),
                      (ticket?.additionalInfo?.packageName != null &&
                              ticket?.additionalInfo?.packageName != "")
                          ? commonWidgetForDropDownValue("Package Name",
                              ticket?.additionalInfo?.packageName ?? '')
                          : SizedBox.shrink(),
                      (ticket?.additionalInfo?.chooseDoctor != null &&
                              ticket?.additionalInfo?.chooseDoctor != "")
                          ? commonWidgetForDropDownValue(
                              "Preferred Doctor Name",
                              ticket?.additionalInfo?.chooseDoctor ?? '')
                          : SizedBox.shrink(),
                      (ticket?.additionalInfo?.chooseHospital != null &&
                              ticket?.additionalInfo?.chooseHospital != "")
                          ? commonWidgetForDropDownValue(
                              "Preferred Hospital Name",
                              ticket?.additionalInfo?.chooseHospital)
                          : SizedBox.shrink(),
                      Row(
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      _tabWidget(context, ticket),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _tabWidget(BuildContext context, Ticket ticketList) {
    for (var historyData in ticketList.history) {
      fullName = ticketList.assignee?.fullname ?? "N/A";
      date = historyData.date.toString();
      print('History fullname : $fullName & $date');
    }
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
          Widget>[
        SizedBox(height: 20.0),
        DefaultTabController(
            length: 3, // length of tabs
            initialIndex: selectedTab,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: TabBar(
                  onTap: (value) {
                    selectedTab = value;
                  },
                  labelStyle: TextStyle(fontSize: 14),
                  isScrollable: false,
                  labelColor: Color(CommonUtil().getMyPrimaryColor()),
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.transparent,
                  tabs: [
                    Tab(
                      icon: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(new CommonUtil().getMyPrimaryColor()),
                                Color(new CommonUtil().getMyGredientColor())
                              ]).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Image.asset('assets/icons/08.png',
                            height: 30, width: 30),
                      ),
                      text: 'History',
                    ),
                    Tab(
                        icon: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(new CommonUtil().getMyPrimaryColor()),
                                  Color(new CommonUtil().getMyGredientColor())
                                ]).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Image.asset(
                            'assets/icons/07.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        text: 'Comments'),
                    Tab(
                        icon: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(new CommonUtil().getMyPrimaryColor()),
                                  Color(new CommonUtil().getMyGredientColor())
                                ]).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Image.asset('assets/icons/06.png',
                              height: 30, width: 30),
                        ),
                        text: 'Attachment'),
                  ],
                ),
              ),
              SizedBox(height: 70.h),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity, //height of TabBarView
                    child: TabBarView(children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 80.w, right: 70.w),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return new Stack(
                                children: <Widget>[
                                  new Positioned(
                                    top: 10.0,
                                    bottom: 0.0,
                                    left: 20.0,
                                    child: new Container(
                                      height: 20,
                                      width: 1.0,
                                      color: Color(
                                          CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                  new Positioned(
                                    top: 0.0,
                                    left: 10.0,
                                    child: new Container(
                                      margin: new EdgeInsets.all(5.0),
                                      height: 10.0,
                                      width: 10.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(CommonUtil()
                                              .getMyPrimaryColor())),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Container(
                                          height: 100.h,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                      child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: listOfEvents[
                                                                  index]
                                                              .description,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[400]),
                                                        ),
                                                        listOfEvents[index]
                                                                    .description
                                                                    .contains(
                                                                        'assigned') &&
                                                                fullName != null
                                                            ? TextSpan(
                                                                text:
                                                                    '\t$fullName',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : TextSpan(text: '')
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    constants.changeDateFormat(
                                                        '$date'),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.grey[400]),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: listOfEvents.length,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                child: //_getChatWidget(context, ticketList),
                                    ticketList.comments != null &&
                                            ticketList.comments.isNotEmpty
                                        ? _getChatWidget(context, ticketList)
                                        : Container(
                                            alignment: Alignment.center,
                                            child: Center(
                                              child:
                                                  Text('No Comments Found !'),
                                            ),
                                          ),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    height: 58.0.h,
                                    child: TextField(
                                      controller: addCommentController,
                                      style: TextStyle(fontSize: 16.0.sp),
                                      focusNode: focusNode,
                                      //controller: textEditingController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(
                                            "\[[ A-Za-z0-9#+-.@&?!{}():'%/=-]\]*")),
                                      ],
                                      decoration: InputDecoration(
                                        suffixIcon: SizedBoxWithChild(
                                          width: 50.0.h,
                                          height: 50.0.h,
                                          child: FlatButton(
                                              onPressed: () async {
                                                FilePickerResult result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'jpg',
                                                    'pdf'
                                                  ],
                                                );
                                                if (result != null) {
                                                  File file = File(
                                                      result.files.single.path);
                                                  uploadFile(
                                                      widget.ticket.sId, file);
                                                }
                                              },
                                              child: new Icon(
                                                Icons.attach_file,
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor()),
                                                size: 24,
                                              )),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                            bottom: -10.0, left: 8),
                                        hintText: "Type your message here",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0.sp,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white70,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                      ),
                                      /*onChanged: (text){
                    final val = TextSelection.collapsed(offset: textEditingController.text.length);
                    textEditingController.selection = val;
                    */ /*textEditingController.text = '~$text~';*/ /*
                  },*/
                                      /*onSubmitted: (value) =>*/
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: new Container(
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        onSendMessage(addCommentController.text,
                                            widget.ticket);
                                      },
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: Icon(Icons.send,
                                          size: 25.0,
                                          color: Color(CommonUtil()
                                              .getMyPrimaryColor())),
                                      padding: EdgeInsets.all(12.0),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ),
                                // Flexible(
                                //   flex: 1,
                                //   child: new Container(
                                //     child: RawMaterialButton(
                                //       onPressed: () {
                                //         Navigator.of(context)
                                //             .push(
                                //           MaterialPageRoute(
                                //             builder: (context) => AudioRecorder(
                                //               arguments: AudioScreenArguments(
                                //                 fromVoice: false,
                                //               ),
                                //             ),
                                //           ),
                                //         )
                                //             .then((results) {
                                //           /*String audioPath = results[Constants.keyAudioFile];
                                //         if (audioPath != null && audioPath != '') {
                                //           setState(() {
                                //             isLoading = true;
                                //           });
                                //           uploadFile(audioPath);
                                //         }*/
                                //         });
                                //       },
                                //       elevation: 2.0,
                                //       fillColor: Colors.white,
                                //       child: Icon(Icons.mic,
                                //           size: 25.0,
                                //           color: Color(CommonUtil()
                                //               .getMyPrimaryColor())),
                                //       padding: EdgeInsets.all(12.0),
                                //       shape: CircleBorder(),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                            alignment: Alignment.center,
                            child: ticketList.attachments != null &&
                                    ticketList.attachments.isNotEmpty
                                ? Container(
                                    alignment: Alignment.topCenter,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Wrap(
                                            spacing: 5.0,
                                            runSpacing: 5.0,
                                            children: List<Widget>.generate(
                                              ticketList.attachments.length,
                                              (int index) {
                                                return InkWell(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5.0) //                 <--- border radius here
                                                                  ),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                          ticketList
                                                                      .attachments[
                                                                          index]
                                                                      .path
                                                                      .toString()
                                                                      .split(
                                                                          '.')
                                                                      .last ==
                                                                  'pdf'
                                                              ? 'assets/icons/file_placeholder.png'
                                                              : 'assets/icons/image_placeholder.png',
                                                          color: Colors.grey,
                                                          height: 50.h,
                                                          width: 50.w,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      openIntent(
                                                          ticketList
                                                                  .attachments[
                                                              index],
                                                          widget.ticket.uid
                                                              .toString());
                                                    });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      child:
                                          Text('No attachments available !!'),
                                    ),
                                  )),
                      ),
                    ])),
              )
            ])),
      ]),
    );
  }

  void _getHistoryData(var ticketList) {
    if (ticketList != null) {
      for (var historyData in ticketList.history) {
        setState(() {
          fullName = historyData.owner.fullname;
          date = historyData.date.toString();
          print('History fullname : $fullName & $date');
        });
      }
      for (int i = 0; i < ticketList.comments.length; i++) {
        setState(() {
          // Looping iSAgent value for checking patient or agent in comments
          isUser = ticketList.comments[i].owner.role.isAgent;
          print('Is agent length : $isUser');
        });
      }
    } else {
      print('History array is empty !!');
    }
  }

  Widget _getChatWidget(BuildContext context, Ticket ticketList) {
    print('comments length=======');
    print(ticketList.comments.length);
    return ScrollablePositionedList.builder(
      physics: BouncingScrollPhysics(),
      itemCount: ticketList.comments.length,
      reverse: true,
      itemScrollController: listScrollController,
      itemBuilder: (context, i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ticketList.comments[ticketList.comments.length - 1 - i].owner.role
                            .isAgent !=
                        null &&
                    ticketList.comments[ticketList.comments.length - 1 - i]
                            .owner.role.isAgent ==
                        false
                ? Container(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16))),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 1.sw * .6,
                              ),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              /*child: Text(
                                document[STR_CONTENT],
                                style: TextStyle(
                                    color: Color(CommonUtil().getMyPrimaryColor())),
                              ),*/
                              child: ticketList
                                          .comments[ticketList.comments.length -
                                              1 -
                                              i]
                                          .comment !=
                                      null
                                  ? Text(
                                      '${_parseHtmlString(ticketList.comments[ticketList.comments.length - 1 - i].comment)}',
                                      style: TextStyle(color: Colors.white))
                                  : Text('Hi I have a query !!',
                                      style: TextStyle(color: Colors.white)),
                            )),
                        Flexible(
                          flex: 1,
                          child: new Container(
                            child: RawMaterialButton(
                              onPressed: () {
                                // onSendMessage(textEditingController.text?.replaceAll("#", ""), 0);
                              },
                              elevation: 2.0,
                              fillColor:
                                  Color(CommonUtil().getMyPrimaryColor()),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CommonCircularIndicator(),
                                  width: 30.w,
                                  height: 30.h,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'assets/maya/maya_india_main.png',
                                    width: 30.w,
                                    height: 30.h,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: '',
                                width: 30.w,
                                height: 30.h,
                                fit: BoxFit.cover,
                              ),
                              padding: EdgeInsets.all(12.0),
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 15.h),
            ticketList.comments[ticketList.comments.length - 1 - i].owner.role
                            .isAgent !=
                        null &&
                    ticketList.comments[ticketList.comments.length - 1 - i]
                        .owner.role.isAgent
                ? Container(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: new Container(
                            child: RawMaterialButton(
                              onPressed: () {
                                // onSendMessage(textEditingController.text?.replaceAll("#", ""), 0);
                              },
                              elevation: 2.0,
                              fillColor:
                                  Color(CommonUtil().getMyPrimaryColor()),
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CommonCircularIndicator(),
                                  width: 30.w,
                                  height: 30.h,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color:
                                        Color(CommonUtil().getMyPrimaryColor()),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'assets/user/profile_pic_ph.png',
                                    width: 30.w,
                                    height: 30.h,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: '',
                                width: 30.w,
                                height: 30.h,
                                fit: BoxFit.cover,
                              ),
                              padding: EdgeInsets.all(12.0),
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                        Card(
                            color: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16))),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 1.sw * .6,
                              ),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              /*child: Text(
                                document[STR_CONTENT],
                                style: TextStyle(
                                    color: Color(CommonUtil().getMyPrimaryColor())),
                              ),*/
                              child: ticketList
                                          .comments[ticketList.comments.length -
                                              1 -
                                              i]
                                          .comment !=
                                      null
                                  ? Text(
                                      '${_parseHtmlString(ticketList.comments[ticketList.comments.length - 1 - i].comment)}',
                                      style: TextStyle(color: Colors.black))
                                  : Text('Hi !!',
                                      style: TextStyle(color: Colors.black)),
                            )),
                      ],
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  String _parseHtmlString(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlString.replaceAll(exp, '');
  }

  void onSendMessage(var comment, var ticketList) {
    try {
      strConstants.tckComment = comment;
      strConstants.tckID = ticketList.sId; //1038
      print(
          'Values for comment : ${strConstants.tckComment}\n${strConstants.tckID}');
      ticketViewModel.userTicketService.commentTicket().then((value) {
        if (value != null) {
          addCommentController.clear();
          callTicketDetailsApi();
          print('Hitting Send Comments API .. : ${value.toJson()}');
        } else {
          print('Failed Sending Comments ..');
          return null;
        }
      }).catchError((e) {
        print('Comment ticket exception in catch error: ${e.toString()}');
        return null;
      });
    } catch (e) {
      print('Comment ticket exception : ${e.toString()}');
      return null;
    }
  }

  void uploadFile(String ticketId, file) {
    try {
      FlutterToast().getToast('Uploading Please Wait..', Colors.grey);
      ticketViewModel.userTicketService
          .uploadAttachment(ticketId, file)
          .then((value) {
        if (value) {
          FlutterToast().getToast('Uploaded Successfully', Colors.grey);
          callTicketDetailsApi();
        } else {
          FlutterToast().getToast('Uploaded Failed', Colors.red);
          return null;
        }
      }).catchError((e) {
        FlutterToast().getToast('Uploaded Failed', Colors.red);
        print('Attachment ticket exception in catch error: ${e.toString()}');
        return null;
      });
    } catch (e) {
      print('Attachment ticket exception : ${e.toString()}');
      return null;
    }
  }

  void _handleTabSelection() {
    selectedTab = _controller.index;
  }

  Future<void> openIntent(Attachments attachments, String ticketUid) async {
    FlutterToast().getToast('Please wait', Colors.grey);
    String path = await downloadFileOpen(attachments, ticketUid);
    if (attachments.path.split('.').last == 'pdf') {
      final controller = Get.find<PDFViewController>();
      final data = OpenPDF(
          type: PDFLocation.Path,
          path: path,
          title: attachments.path.split('/').last);
      controller.data = data;
      Get.to(() => PDFView());
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullPhoto(
            url: "",
            filePath: path,
          ),
        ),
      );
    }
  }

  Future<String> downloadFile(String fileUrl) async {
    String filePath = await FHBUtils.createFolderInAppDocDirClone(
        "doc", fileUrl.split('/').last);
    var file = File('$filePath' /*+ fileType*/);
    final request = await ApiServices.post(
      BASE_URL + 'trudesk/tickets/getAttachment',
      body: {"fileUrl": fileUrl},
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + authToken,
        KEY_OffSet: CommonUtil().setTimeZone()
      },
    );
    final bytes = request.bodyBytes; //close();
    await file.writeAsBytes(bytes);
    return file.path.toString();
  }

  Future<String> downloadFileOpen(
      Attachments attachments, String ticketUId) async {
    String nameWithoutExtension = p.basenameWithoutExtension(attachments.path);
    String filePath = await FHBUtils.createFolderInAppDocDirClone(
        variable.stAudioPath, attachments.name);
    var file = File('$filePath' /*+ fileType*/);
    final request = await ApiServices.post(
      CommonUtil.TRUE_DESK_URL + 'tickets/${ticketUId}/attachments/open',
      body: {
        "fileKey": attachments.fileKey,
        "fileName": attachments.name,
        "fileType": attachments.type
      },
      headers: {
        HttpHeaders.authorizationHeader: authToken,
        KEY_OffSet: CommonUtil().setTimeZone()
      },
    );
    final bytes = request.bodyBytes; //close();
    await file.writeAsBytes(bytes);
    return file.path.toString();
  }

  commonWidgetForDropDownValue(String header, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: Text(
              header,
              style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.start,
            )),
        Expanded(
          flex: 1,
          child: Text(
            CommonUtil().capitalizeFirstofEach(value),
            style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class Events {
  final String time;
  final String eventName;
  final String description;

  Events({this.time, this.eventName, this.description});
}
