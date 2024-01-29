import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import '../../claim/model/members/MembershipDetails.dart';
import '../../claim/model/members/MembershipResult.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as constants;
import '../../constants/variable_constant.dart' as variable;
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../common/errors_widget.dart';

import 'create_ticket_screen.dart';

class TicketTypesScreen extends StatefulWidget {
  @override
  State createState() {
    return _TicketTypesScreenState();
  }
}

class _TicketTypesScreenState extends State<TicketTypesScreen> {
  TicketViewModel ticketViewModel = TicketViewModel();
  TicketTypesModel ticketTypesModel = TicketTypesModel();

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
        title: Text(
          constants.strNewServiceRequests,
          style: TextStyle(
              fontSize: (CommonUtil().isTablet ?? false)
                  ? constants.tabFontTitle
                  : constants.mobileFontTitle),
        ),
      ),
      body: Container(
        child: getTicketTypes(),
      ),
    );
  }

  Widget getTicketTypes() {
    return FutureBuilder<TicketTypesModel?>(
      future: ticketViewModel.getTicketTypesList(),
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
          //return ticketTypeListTest(context);
          if (snapshot.hasData &&
              snapshot.data!.ticketTypeResults != null &&
              snapshot.data!.ticketTypeResults!.isNotEmpty) {
            return ListView(
              children: [
                getMembershipDataUI(),
                ticketTypesList(snapshot.data!.ticketTypeResults),
              ],
            );
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
                        variable.strNoTicketTypesAvaliable,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            );
          }
        }
      },
    );
  }

  Widget getMembershipDataUI() => FutureBuilder<MemberShipDetails?>(
        future: ticketViewModel.getMemberShip(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return ErrorsWidget();
          } else {
            //return ticketTypeListTest(context);
            if (snapshot.hasData &&
                snapshot.data!.result != null &&
                snapshot.data!.result!.isNotEmpty) {
              MemberShipResult? memberShipResult = snapshot.data?.result?.first;

              if (memberShipResult != null) {
                DateTime planEndDateTime = DateFormat("yyyy-MM-dd")
                    .parse(memberShipResult.planEndDate ?? '');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
                      height: 150.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(CommonUtil().getMyPrimaryColor()),
                            Color(CommonUtil().getMyGredientColor())
                          ],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        border: Border.all(
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memberShipResult.planName ?? '',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 21.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Validity info (Valid till ${DateFormat("dd-MM-yyyy").format(
                              planEndDateTime,
                            )} (${CommonUtil().calculateDifference(
                              planEndDateTime,
                            )} days remaining)',
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Show available benefits',
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 6, 15, 0),
                      child: Text(
                        'Available Services',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }
        },
      );

  Widget ticketTypesList(List<TicketTypesResult>? ticketTypesList) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;
    return (ticketTypesList != null && ticketTypesList.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: 8.0.h,
                ),
                itemBuilder: (ctx, i) {
                  return myTicketTypesListItem(ctx, i, ticketTypesList);
                },
                itemCount: ticketTypesList.length,
              ),
            ),
          )
        : SafeArea(
            child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                  child: Center(
                    child: Text(
                      variable.strNoTicketTypesAvaliable,
                    ),
                  ),
                )),
          );
  }

  Widget myTicketTypesListItem(
      BuildContext context, int i, List<TicketTypesResult> ticketList) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: InkWell(
            onTap: () {
              try {
                var createTicketController = Get.put(CreateTicketController());
                createTicketController.isCTLoading.value = false;

                if (CommonUtil()
                    .validString(ticketList[i].name)
                    .toLowerCase()
                    .contains("lab appointment")) {
                  createTicketController.labBookAppointment.value = true;
                  createTicketController.selPrefLab.value =
                      CommonUtil().validString("Select");
                  createTicketController.selPrefLabId.value =
                      CommonUtil().validString("");
                  createTicketController.getLabList();
                } else {
                  createTicketController.labBookAppointment.value = false;
                  createTicketController.labsList = [];
                }

                if (CommonUtil()
                    .validString(ticketList[i].name)
                    .toLowerCase()
                    .contains("doctor appointment")) {
                  createTicketController.doctorBookAppointment.value = true;
                  createTicketController.selPrefDoctor.value =
                      CommonUtil().validString("Select");
                  createTicketController.selPrefDoctorId.value =
                      CommonUtil().validString("");
                  createTicketController.getDoctorList();
                } else {
                  createTicketController.doctorBookAppointment.value = false;
                  createTicketController.doctorsList = [];
                }

                ticketList[i].additionalInfo != null
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateTicketScreen(ticketList[i])),
                      )
                    : null;
              } catch (e, stackTrace) {
                //print(e);
                CommonUtil().appLogs(message: e, stackTrace: stackTrace);
              }
            },
            child: Container(
              height: 150.h,
              width: MediaQuery.of(context).size.width / 2.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(CommonUtil().getMyPrimaryColor()),
                    Color(CommonUtil().getMyGredientColor())
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        12.0) //                 <--- border radius here
                    ),
                border: Border.all(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                ),
              ),
              padding: EdgeInsets.all(
                15.0.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        getTicketTypeImages(
                          context,
                          ticketList[i],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    ticketList[i].name!,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 21.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,

                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget getTicketTypeImages(
      BuildContext context, TicketTypesResult ticketListData) {
    if (ticketListData.iconUrl?.isNotEmpty ?? false) {
      return SvgPicture.network(
        ticketListData.iconUrl!,
        height: 60,
        width: 60,
        placeholderBuilder: (context) => CommonCircularIndicator(),
        color: Colors.white.withAlpha(200),
      );
    } else {
      return Image.asset(
        'assets/icons/10.png',
        width: 60,
        height: 60,
        color: Colors.white.withAlpha(200),
      );
    }
  }
}
