import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/divider_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/telehealth/features/appointments/controller/AppointmentDetailsController.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class AppointmentDetailScreen extends StatefulWidget {
  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final appointmentDetailsController = CommonUtil().onInitAppointmentDetailsController();
  double imgContainerSize = 70.0;
  double imgSize = 30.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Color(
          CommonUtil().getMyPrimaryColor(),
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          appointmentDetails,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      floatingActionButton: addOkBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() => appointmentDetailsController.loadingData.isTrue
          ? Center(
              child: CircularProgressIndicator(),
            )
          : getAppointmentDetailWidget()),
    );
  }

  Widget addOkBtn() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Obx(
        () {
          if (appointmentDetailsController.loadingData.isTrue) {
            return Container();
          }

          return appointmentDetailsController.appointmentDetailsModel != null &&
                  appointmentDetailsController.appointmentDetailsModel.result !=
                      null
              ? InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    color: Color(
                      CommonUtil().getMyPrimaryColor(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        left: 50.0,
                        right: 50.0,
                      ),
                      child: Text(
                        strOK,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }

  Widget getAppointmentDetailWidget() {
    if (appointmentDetailsController.appointmentDetailsModel != null &&
        appointmentDetailsController.appointmentDetailsModel.result != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              appointmentTypeItem(),
              appointmentInformationItem(),
            ],
          ),
        ),
      );
    } else {
      return Center(child: Text('No Data Found'));
    }
  }

  Widget appointmentTypeItem() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 10, right: 10, top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe3e2e2),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: imgContainerSize,
                  width: imgContainerSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(
                        CommonUtil().getMyPrimaryColor(),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Color(
                          CommonUtil().getMyPrimaryColor(),
                        ),
                      )),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: appointmentDetailsController
                                  .appointmentIconUrl.value !=
                              null
                          ? CachedNetworkImage(
                              imageUrl: appointmentDetailsController
                                      .appointmentIconUrl.value ??
                                  "",
                              height: imgSize,
                              width: imgSize,
                              fit: BoxFit.fill,
                              color: Colors.white,
                              placeholder: (context, url) =>
                                  CommonCircularIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/icons/10.png',
                                height: imgSize,
                                width: imgSize,
                                color: Colors.white,
                              ),
                            )
                          : Image.asset(
                              'assets/icons/10.png',
                              width: imgSize,
                              height: imgSize,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
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
                            appointmentDetailsController.appointmentType.value,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          appointmentDetailsController
                                  .appointmentModeOfService.value
                                  .trim()
                                  .isNotEmpty
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
                                  ),
                                  color: Color(
                                    CommonUtil().getMyPrimaryColor(),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                      left: 8.0,
                                      right: 8.0,
                                    ),
                                    child: Text(
                                      appointmentDetailsController
                                          .appointmentModeOfService.value,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(height: 8.0.h),
                      appointmentDetailsController.providerName.value.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DividerWidget(
                                    ht: 1.0.h, colors: Colors.grey[500]),
                                SizedBox(height: 8.0.h),
                                Text(
                                  appointmentDetailsController
                                      .providerName.value,
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
          ],
        ));
  }

  Widget appointmentInformationItem() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe3e2e2),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10.h),
            Text(
              appointmentSchedule,
              style: TextStyle(
                fontSize: 17.0.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 10.h),
            commonWidgetForTitleValue(parameters.dateAndTime,
                appointmentDetailsController.scheduleDateTime.value),
            appointmentDetailsController.appointmentType.value.toLowerCase() ==
                    "doctor appointment"
                ? Column(
                    children: [
                      SizedBox(height: 5.h),
                      commonWidgetForTitleValue(appointmentSlot,
                          appointmentDetailsController.slotNumber.value),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(height: 10.h),
            Text(
              appointmentInformation,
              style: TextStyle(
                fontSize: 17.0.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 10.h),
            showWidget(),
            SizedBox(height: 20.h),
          ],
        ));
  }

  showWidget() {
    switch (appointmentDetailsController.appointmentType.value.toLowerCase()) {
      case "lab appointment":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonWidgetForTitleValue(appointmentTestName,
                appointmentDetailsController.testName.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentLabAddress,
                appointmentDetailsController.providerAddress.value),
          ],
        );
        break;
      case "homecare service":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonWidgetForTitleValue(
                strTitle, appointmentDetailsController.testName.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentDescription,
                appointmentDetailsController.description.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentAddress,
                appointmentDetailsController.providerAddress.value),
          ],
        );
        break;
      case "transportation":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonWidgetForTitleValue(
                strTitle, appointmentDetailsController.testName.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentDescription,
                appointmentDetailsController.description.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentPickupaddress,
                appointmentDetailsController.pickUpAddress.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentDropAddress,
                appointmentDetailsController.dropAddress.value),
          ],
        );
        break;
      case "doctor appointment":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonWidgetForTitleValue(appointmentHospitalName,
                appointmentDetailsController.hospitalName.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentHospitalAddress,
                appointmentDetailsController.providerAddress.value),
          ],
        );
        break;
      default:
        return Column(
          children: [
            Container(),
          ],
        );
        break;
    }
  }

  commonWidgetForTitleValue(String header, String value) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 1,
            child: Text(
              header,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.5),
              ),
            )),
        Text(
          " : ",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 13.0.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            appointmentDetailsController.checkIfEmptyString(value),
            textAlign: TextAlign.start,
            overflow: TextOverflow.visible,
            softWrap: true,
            //maxLines: 3,
            style: TextStyle(
              fontSize: 13.0.sp,
              fontWeight: FontWeight.w600,
              color:
                  appointmentDetailsController.checkIfEmptyString(value) == "--"
                      ? Colors.grey
                      : Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}
