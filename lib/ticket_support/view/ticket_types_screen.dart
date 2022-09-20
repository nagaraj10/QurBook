import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/landing/view/widgets/landing_card.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view/create_ticket_scree_new.dart';
import 'package:myfhb/ticket_support/view/tickets_list_view.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as constants;
import 'package:myfhb/colors/fhb_colors.dart' as colors;
import '../../constants/variable_constant.dart' as variable;
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import '../../common/errors_widget.dart';
import '../../src/utils/FHBUtils.dart';

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
        title: Text(constants.strMyTickets),
      ),
      body: Container(
        child: getTicketTypes(),
      ),
    );
  }

  Widget getTicketTypes() {
    return FutureBuilder<TicketTypesModel>(
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
          if (snapshot?.hasData &&
              snapshot?.data?.ticketTypeResults != null &&
              snapshot?.data?.ticketTypeResults.isNotEmpty) {
            return Container(
                child: ticketTypesList(snapshot.data.ticketTypeResults));
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

  Widget ticketTypesList(List<TicketTypesResult> ticketTypesList) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;
    return (ticketTypesList != null && ticketTypesList.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
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
                createTicketController.isCTLoading?.value = false;

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

                try {
                  final index = ticketList[i].additionalInfo.field.indexWhere(
                      (element) => element.name == "mode_of_service");
                  if (index >= 0) {
                    List<FieldData> fieldData =
                        ticketList[i].additionalInfo.field[index].fieldData;
                    if (fieldData != null && fieldData.length > 0) {
                      createTicketController.modeOfServiceList =
                          ticketList[i].additionalInfo.field[index].fieldData;
                    }
                  }
                } catch (e) {
                  //print(e);
                }

                ticketList[i].additionalInfo != null
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateTicketScreen(ticketList[i])),
                      )
                    : null;
              } catch (e) {
                print(e);
              }
            },
            child: Container(
              height: 150.h,
              width: MediaQuery.of(context).size.width / 2.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                        12.0) //                 <--- border radius here
                    ),
                border: Border.all(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                ),
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(
                15.0.sp,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShaderMask(
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
                    child: getTicketTypeImages(context, ticketList[i]),
                  ),
                  Text(
                    ticketList[i].name,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(CommonUtil().getMyPrimaryColor()),

                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget getTicketTypeImages(BuildContext context, var ticketListData) {
    if (ticketListData.iconUrl != null) {
      return CachedNetworkImage(
        imageUrl: ticketListData.iconUrl,
        placeholder: (context, url) => CommonCircularIndicator(),
        errorWidget: (context, url, error) => Image.asset(
          'assets/icons/10.png',
          height: 60,
          width: 60,
          color: Color(CommonUtil().getMyPrimaryColor()),
        ),
        imageBuilder: (context, imageProvider) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
          ),
        ),
      );
    } else {
      return Image.asset(
        'assets/icons/10.png',
        width: 60,
        height: 60,
        color: Color(CommonUtil().getMyPrimaryColor()),
      );
    }
  }
}
