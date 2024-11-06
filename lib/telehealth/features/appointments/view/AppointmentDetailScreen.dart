import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/divider_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Qurhome/Common/GradientAppBarQurhome.dart';
import '../../../../common/CommonCircularQurHome.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_parameters.dart' as parameters;
import '../../../../constants/variable_constant.dart';
import '../../../../constants/variable_constant.dart' as variableConstant;
import '../../../../main.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../widgets/GradientAppBar.dart';

class AppointmentDetailScreen extends StatefulWidget {
  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final appointmentDetailsController =
      CommonUtil().onInitAppointmentDetailsController();
  double imgContainerSize = 70.0;
  double imgSize = 30.0;

  @override
  void initState() {
    FABService.trackCurrentScreen(FBAAppointmentsDetailsScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          flexibleSpace: (PreferenceUtil.getIfQurhomeisAcive())
              ? GradientAppBarQurhome()
              : GradientAppBar(),
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
          title: const Text(
            appointmentDetails,
          ),
          centerTitle: false,
          elevation: 0,
        ),
        floatingActionButton: addOkBtn(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Obx(() => appointmentDetailsController.loadingData.isTrue
            ? Center(
                child: (PreferenceUtil.getIfQurhomeisAcive())
                    ? CommonCircularQurHome()
                    : const CircularProgressIndicator(),
              )
            : getAppointmentDetailWidget()),
      );

  Widget addOkBtn() => Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Obx(
          () {
            if (appointmentDetailsController.loadingData.isTrue) {
              return Container();
            }

            return appointmentDetailsController.appointmentDetailsModel !=
                        null &&
                    appointmentDetailsController
                            .appointmentDetailsModel!.result !=
                        null
                ? appointmentDetailsController.appointmentDetailsModel?.result
                            ?.additionalInfo?.pickupRequestInfo !=
                        null
                    ? checkAcceptOrRejectButton()
                    : OkButton()
                : Container();
          },
        ),
      );

  Widget checkAcceptOrRejectButton() {
    appointmentDetailsController
        .appointmentDetailsModel?.result?.additionalInfo?.pickupRequestInfo
        ?.sort((a, b) => (DateTime.parse(b?.requestTime ?? ''))
            .compareTo(DateTime.parse(a?.requestTime ?? '')));

    if (appointmentDetailsController.appointmentDetailsModel?.result
            ?.additionalInfo?.pickupRequestInfo?[0] !=
        null) {
      final userId = PreferenceUtil.getStringValue(KEY_USERID);
      if ((appointmentDetailsController.appointmentDetailsModel?.result
                  ?.additionalInfo?.pickupRequestInfo?[0].requestFrom ??
              '')
          .contains(userId ?? 'none')) {
        return OkButton();
      } else {
        var temp = DateTime.now();
        var d1 = DateTime.utc(temp.year, temp.month, temp.day, temp.hour,
            temp.minute, temp.second);

        if (d1.isAfter(
            appointmentDetailsController.endTimeForTransportation?.toUtc() ??
                DateTime.now())) {
          return OkButton();
        } else {
          if (appointmentDetailsController.appointmentDetailsModel?.result
                  ?.additionalInfo?.pickupRequestInfo?[0].isAccepted ==
              null) {
            return AcceptReject(appointmentDetailsController
                .appointmentDetailsModel
                ?.result
                ?.additionalInfo
                ?.pickupRequestInfo?[0]
                .requestFrom);
          } else if (appointmentDetailsController.appointmentDetailsModel
                  ?.result?.additionalInfo?.pickupRequestInfo?[0].isAccepted ??
              false) {
            return RejectButton(appointmentDetailsController
                    .appointmentDetailsModel
                    ?.result
                    ?.additionalInfo
                    ?.pickupRequestInfo?[0]
                    .requestFrom ??
                '');
          } else {
            return OkButton();
          }
        }
      }
    } else {
      return OkButton();
    }
  }

  Widget OkButton() => InkWell(
        onTap: () {
          Get.back();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          color: mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
          child: const Padding(
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
      );

  Widget AcceptButton(String s) => InkWell(
        onTap: () {
          appointmentDetailsController.acceptCareGiverTransportRequestReminder(
              appointmentDetailsController.appointmentId, s, true);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          color: mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 50.0,
              right: 50.0,
            ),
            child: Text(
              straccept.capitalizeFirstofEach,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

  Widget RejectButton(String s) => InkWell(
        onTap: () {
          appointmentDetailsController.acceptCareGiverTransportRequestReminder(
              appointmentDetailsController.appointmentId, s, false);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          color: mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
          child: const Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 50.0,
              right: 50.0,
            ),
            child: Text(
              strDecline,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

  Widget AcceptReject(String? requestFrom) => Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AcceptButton(requestFrom ?? ''),
          const SizedBox(
            width: 5,
          ),
          RejectButton(requestFrom ?? ''),
        ],
      ));

  Widget getAppointmentDetailWidget() {
    if (appointmentDetailsController.appointmentDetailsModel != null &&
        appointmentDetailsController.appointmentDetailsModel!.result != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 100),
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
      return const Center(child: Text('No Data Found'));
    }
  }

  Widget appointmentTypeItem() => Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
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
                    color:mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
                    border: Border.all(
                      width: 1,
                      color: mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
                    )),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: appointmentDetailsController
                                .appointmentIconUrl.value !=
                            null
                        ? CachedNetworkImage(
                            imageUrl: appointmentDetailsController
                                .appointmentIconUrl.value,
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
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.0.h),
                    Text(
                      appointmentDetailsController.appointmentType.value,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
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
                                appointmentDetailsController.providerName.value,
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
        ],
      ));

  Widget appointmentInformationItem() => Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appointmentSchedule,
                style: TextStyle(
                  fontSize: 17.0.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                color: mAppThemeProvider.getCommonPrimaryColorQurHomeBook(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Text(
                    appointmentDetailsController.appointmentModeOfService.value,
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          commonWidgetForTitleValue(parameters.dateAndTime,
              appointmentDetailsController.scheduleDateTime.value),
          appointmentDetailsController.appointmentType.value.toLowerCase() ==
                  strDoctorAppointment
              ? Column(
                  children: [
                    SizedBox(height: 5.h),
                    commonWidgetForTitleValue(appointmentSlot,
                        appointmentDetailsController.slotNumber.value),
                  ],
                )
              : const SizedBox.shrink(),
          SizedBox(height: 10.h),
          Text(
            appointmentInformation,
            style: TextStyle(
              fontSize: 17.0.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.h),
          showWidget(),
          if ((appointmentDetailsController.notes.value != null) &&
              (appointmentDetailsController.notes.value != ''))
            Container(
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  commonWidgetForTitleValue(parameters.strNotes,
                      appointmentDetailsController.notes.value),
                ],
              ),
            ),
          showLocationField(),
          SizedBox(height: 20.h),
        ],
      ));

  showLocationField() {
    if (CommonUtil.isUSRegion()) {
      var modeOfServiceType =
          appointmentDetailsController.appointmentModeOfService.value.trim();
      var locationUrl = appointmentDetailsController.locationUrl;
      if (modeOfServiceType.isNotEmpty &&
          locationUrl.isNotEmpty &&
          ((modeOfServiceType.toLowerCase() == strCentreVisit.toLowerCase()) ||
              (modeOfServiceType.toLowerCase() == strOnsite.toLowerCase()))) {
        return Column(
          children: [
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(strLocationLink, locationUrl,
                isLocationLink: true),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  showWidget() {
    var isCustomAppointment = appointmentDetailsController.appointmentType.value
                    .toLowerCase() !=
                strLabAppointment.toLowerCase() &&
            appointmentDetailsController.appointmentType.value.toLowerCase() !=
                strDoctorAppointment.toLowerCase() &&
            appointmentDetailsController.appointmentType.value.toLowerCase() !=
                strTransportation.toLowerCase() &&
            appointmentDetailsController.appointmentType.value.toLowerCase() !=
                strHomecareService.toLowerCase() &&
            appointmentDetailsController.appointmentType.value.toLowerCase() !=
                variableConstant.strOthers.toLowerCase()
        ? true
        : false;

    switch (appointmentDetailsController.appointmentType.value.toLowerCase()) {
      case strLabAppointment:
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
      case strHomecareService:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonWidgetForTitleValue(
                strPurpose, appointmentDetailsController.testName.value),
            getDescriptionWidget(),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentAddress,
                appointmentDetailsController.providerAddress.value),
          ],
        );
        break;
      case strTransportation:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonWidgetForTitleValue(
                strPurpose, appointmentDetailsController.testName.value),
            getDescriptionWidget(),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentPickupaddress,
                appointmentDetailsController.pickUpAddress.value),
            SizedBox(height: 5.h),
            commonWidgetForTitleValue(appointmentDropAddress,
                appointmentDetailsController.dropAddress.value),
          ],
        );
        break;
      case strDoctorAppointment:
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
      case strHomeHealthVisit:
        return Column(
          children: [
            if (appointmentDetailsController.testName.value.isNotEmpty)
              commonWidgetForTitleValue(
                  strPurpose, appointmentDetailsController.testName.value)
            else
              const SizedBox.shrink(),
            SizedBox(height: 5.h),
            if (appointmentDetailsController
                .visitingCareCoordinator.value.isNotEmpty)
              commonWidgetForTitleValue(parameters.strVisitingCareCoordinator,
                  appointmentDetailsController.visitingCareCoordinator.value)
            else
              const SizedBox.shrink(),
            SizedBox(height: 5.h),
            if (appointmentDetailsController.providerAddress.value.isNotEmpty)
              commonWidgetForTitleValue(appointmentAddress,
                  appointmentDetailsController.providerAddress.value)
            else
              const SizedBox.shrink(),
          ],
        );
      default:
        if (isCustomAppointment)
          return Column(
            children: [
              commonWidgetForTitleValue(
                  strPurpose, appointmentDetailsController.testName.value),
              SizedBox(height: 5.h),
              commonWidgetForTitleValue(appointmentAddress,
                  appointmentDetailsController.providerAddress.value),
            ],
          );
        return Column(children: [Container()]);
        break;
    }
  }

  commonWidgetForTitleValue(String header, String value,
      {bool isLocationLink = false}) {
    String strValue = appointmentDetailsController.checkIfEmptyString(value);
    bool isShow = strValue == "--" ? false : true;
    return isShow
        ? Row(
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
              const SizedBox(
                width: 25,
              ),
              isLocationLink
                  ? Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () async {
                          try {
                            if (await canLaunch(value)) {
                              await launch(value);
                            }
                          } catch (e, stackTrace) {
                            print(e);
                            CommonUtil()
                                .appLogs(message: e, stackTrace: stackTrace);
                          }
                        },
                        child: Text(
                          strValue,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ),
                      ))
                  : Expanded(
                      flex: 2,
                      child: Text(
                        strValue,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        //maxLines: 3,
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          fontWeight: FontWeight.w600,
                          color: strValue == "--"
                              ? Colors.grey
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
            ],
          )
        : const SizedBox.shrink();
  }

  getDescriptionWidget() =>
      (appointmentDetailsController.description.value != null) &&
              (appointmentDetailsController.description.value.trim().isNotEmpty)
          ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  commonWidgetForTitleValue(appointmentDescription,
                      appointmentDetailsController.description.value),
                ],
              ),
            )
          : const SizedBox.shrink();
}
