import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/chat.dart';
import 'package:myfhb/ticket_support/model/ticket_model.dart';
import 'package:myfhb/ticket_support/view/tickets_list_view.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as strConstants;
import 'package:myfhb/colors/fhb_colors.dart' as colors;
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import 'package:myfhb/common/CommonUtil.dart' as commonUtils;

var fullName, date;

class DetailedTicketView extends StatefulWidget {
  DetailedTicketView(this.ticketList);

  final ticketList;

  @override
  State createState() {
    return _DetailedTicketViewState();
  }
}

class _DetailedTicketViewState extends State<DetailedTicketView> {
  TicketViewModel ticketViewModel = TicketViewModel();
  final FocusNode focusNode = FocusNode();
  final ItemScrollController listScrollController = ItemScrollController();

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

  @override
  void initState() {
    super.initState();
    _getHistoryData(widget.ticketList);
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
        body: Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.ticketList.history.length,
            itemBuilder: (ctx, i) {
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
                                      'Open',
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
                                            'Ticket ID\t:',
                                            style: TextStyle(
                                              fontSize: 16.0.sp,
                                              fontWeight: FontWeight.w100,
                                            ),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          Text(
                                            '\t#${widget.ticketList.uid.toString()}',
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
                                  widget.ticketList.subject
                                      .toString()
                                      .capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  constants.notificationDate(
                                      '${widget.ticketList.preferredDate.toString()}'),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w100,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Row(
                                  children: [
                                    Spacer(
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                _tabWidget(context),
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
            },
          ),
        ));
  }

  Widget _tabWidget(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
          Widget>[
        SizedBox(height: 20.0),
        DefaultTabController(
            length: 3, // length of tabs
            initialIndex: 0,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                child: TabBar(
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
                    height: 400,
                    width: double.infinity, //height of TabBarView
                    child: TabBarView(children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 80.w, right: 70.w),
                          child: ListView.builder(
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
                                                    constants.notificationDate(
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
                                child: _getChatWidget(context),
                                /*widget.ticketList.comments != null &&
                                      widget.ticketList.comments.isNotEmpty
                                  ? _getChatWidget(context)
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text('No Comments Found !'),
                                      ),
                                    ),*/
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    height: 58.0.h,
                                    child: TextField(
                                      style: TextStyle(fontSize: 16.0.sp),
                                      focusNode: focusNode,
                                      onTap: () {
                                        //isSearchVisible = false;
                                        //_patientDetailOrSearch();
                                      },
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
                                              onPressed: () {
                                                //recordIds.clear();
                                                //FetchRecords(0, true, true, false, recordIds);
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
                                        //onSendMessage(textEditingController.text?.replaceAll("#", ""), 0);
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
                                Flexible(
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
                                          /*String audioPath = results[Constants.keyAudioFile];
                                        if (audioPath != null && audioPath != '') {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          uploadFile(audioPath);
                                        }*/
                                        });
                                      },
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: Icon(Icons.mic,
                                          size: 25.0,
                                          color: Color(CommonUtil()
                                              .getMyPrimaryColor())),
                                      padding: EdgeInsets.all(12.0),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                            alignment: Alignment.center,
                            child:
                                /*widget.ticketList.attachments != null &&
                                    widget.ticketList.attachments.isNotEmpty
                                ? */
                                Container(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Wrap(
                                      spacing: 5.0,
                                      runSpacing: 5.0,
                                      children: List<Widget>.generate(
                                        5,
                                        //widget.ticketList.attachments,
                                        (int index) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Image.asset(
                                              'assets/icons/placeholder.jpg',
                                              height: 100.h,
                                              width: 100.w,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                            /*: Center(
                                    child: Container(
                                      child:
                                          Text('No attachments available !!'),
                                    ),
                                  )*/
                            ),
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
    } else {
      print('History array is empty !!');
    }
  }

  Widget _getChatWidget(BuildContext context) {
    return ScrollablePositionedList.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 5,
      reverse: true,
      itemScrollController: listScrollController,
      itemBuilder: (context, i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
                        child: Text('Hi !!',
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
                        fillColor: Color(CommonUtil().getMyPrimaryColor()),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CommonCircularIndicator(),
                            width: 30.w,
                            height: 30.h,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color(CommonUtil().getMyPrimaryColor()),
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
            ),
            SizedBox(height: 15.h),
            Container(
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
                        fillColor: Color(CommonUtil().getMyPrimaryColor()),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CommonCircularIndicator(),
                            width: 30.w,
                            height: 30.h,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color(CommonUtil().getMyPrimaryColor()),
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
                        child: Text('Hai I have a query !!',
                            style: TextStyle(color: Colors.black)),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class Events {
  final String time;
  final String eventName;
  final String description;

  Events({this.time, this.eventName, this.description});
}
