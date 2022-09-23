import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/my_reports/model/report_model.dart';
import 'package:myfhb/my_reports/view_model/report_view_model.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/TicketsListResponse.dart';
import 'package:myfhb/ticket_support/model/ticket_model.dart';
import 'package:myfhb/ticket_support/view/detail_ticket_view_screen.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import '../../common/errors_widget.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import '../../constants/fhb_constants.dart' as strConstants;

class TicketsList extends StatefulWidget {
  @override
  _TicketsList createState() => _TicketsList();
}

class _TicketsList extends State<TicketsList> {
  UserTicketModel userTicketModel;
  TicketViewModel ticketViewModel = TicketViewModel();
  bool _isTabVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: Column(
              children: [
                Expanded(
                  child: getTicketsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getTicketsList() {
    return FutureBuilder<TicketsListResponse>(
      future: ticketViewModel.getTicketsList(),
      builder: (context, snapshot) {
        print('=================');
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
        } else if (snapshot.connectionState == ConnectionState.done) {
          //return ticketListTest(context);
          if (snapshot?.hasData && snapshot?.data != null) {
            print(snapshot.data.tickets.length.toString());
            print('=================');
            return ticketList(snapshot.data.tickets);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 60.w,
                    ),
                    child: Center(
                      child: Text(
                        variable.strNoTicketsRaised,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            );
          }
        } else {
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
        }
      },
    );
  }

  Widget ticketList(List<Tickets> ticketList) {
    return (ticketList != null && ticketList.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: 8.0.h,
            ),
            itemBuilder: (ctx, i) {
              return myTicketListItem(ctx, i, ticketList);
            },
            itemCount: ticketList.length,
          )
        : SafeArea(
            child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                  child: Center(
                    child: Text(
                      variable.strNoTicketsRaised,
                    ),
                  ),
                )),
          );
  }

  Widget myTicketListItem(
      BuildContext context, int i, List<Tickets> ticketList) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedTicketView(
                    ticketList[i], false, ticketList[i].uid.toString())),
          );
        },
        child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 10, right: 10, top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFe3e2e2),
                  blurRadius: 16, // has the effect of softening the shadow
                  spreadRadius: 5, // has the effect of extending the shadow
                  offset: Offset(
                    0, // horizontal, move right 10
                    0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 8.0.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ticketList[i]
                                    .type
                                    .name
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
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                      ' #${ticketList[i].uid.toString()}',
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
                          SizedBox(height: 8.0.h),
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
                                ticketList[i].status == 0 ? 'Open' : 'Closed',
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orangeAccent[100]),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                          (ticketList[i].subject.toString() !=
                                  ticketList[i].type.name)
                              ? Text(
                                  ticketList[i]
                                      .subject
                                      .toString()
                                      .capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )
                              : SizedBox(),
                          ticketList[i].preferredDate != null
                              ? Text(
                                  constants.notificationDate(ticketList[i]
                                              .preferredDate !=
                                          null
                                      ? '${ticketList[i].preferredDate?.toString()}'
                                      : ''),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w100,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                )
                              : SizedBox(),
                          Row(
                            children: [
                              Spacer(
                                flex: 1,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedTicketView(
                                                ticketList[i],
                                                false,
                                                ticketList[i].uid.toString())),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0.sp, horizontal: 35.0.sp),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            offset: Offset(2, 4),
                                            blurRadius: 5,
                                            spreadRadius: 2)
                                      ],
                                      gradient: LinearGradient(
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(new CommonUtil()
                                                .getMyPrimaryColor()),
                                            Color(new CommonUtil()
                                                .getMyGredientColor())
                                            /*getColorFromHex('#5428ef'),
                                                getColorFromHex('#5428ef'),*/
                                          ])),
                                  child: Text(
                                    strConstants.strDetailsButton,
                                    style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
              ],
            )));
  }
}
