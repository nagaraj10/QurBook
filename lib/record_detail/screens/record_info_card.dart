import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/ClipImage/ClipOvalImage.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_parameters.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../main.dart';
import '../../src/blocs/health/HealthReportListForUserBlock.dart';
import '../../src/model/Health/MetaInfo.dart';
import '../../src/model/Health/asgard/health_record_list.dart';
import '../../src/utils/DashSeparator.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class RecordInfoCard {
  Widget getCardForPrescription(
      Metadata metaInfo, String? createdDate, String? authToken) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  variable.strCreatedDate +
                      FHBUtils().getMonthDateYear(createdDate),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: <Widget>[
                ClipOval(
                    child: metaInfo?.doctor != null
                        ? getProfilePicWidget(
                            metaInfo?.doctor?.profilePicThumbnailUrl ?? "",
                            metaInfo?.doctor?.firstName ?? "",
                            metaInfo?.doctor?.lastName ?? "",
                            mAppThemeProvider.primaryColor,
                            CommonUtil().isTablet!
                                ? imageTabHeader
                                : Constants.imageMobileHeader,
                            CommonUtil().isTablet!
                                ? tabHeader1
                                : Constants.mobileHeader1,
                            authtoken: authToken ?? "")
                        : Container(
                            child: Center(
                                child: Image.network(
                                    metaInfo?.healthRecordCategory?.logo ?? '',
                                    height: 30,
                                    width: 30,
                                    color: mAppThemeProvider.primaryColor)),
                            width: CommonUtil().isTablet!
                                ? imageTabHeader
                                : Constants.imageMobileHeader,
                            height: CommonUtil().isTablet!
                                ? imageTabHeader
                                : Constants.imageMobileHeader,
                            color: const Color(fhbColors.bgColorContainer))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.doctor != null)
                          Text(
                            metaInfo.doctor != null
                                ? ((metaInfo.doctor!.name != null &&
                                        metaInfo.doctor!.name != '')
                                    ? metaInfo
                                        .doctor!.name?.capitalizeFirstofEach
                                    : metaInfo.doctor!.firstName!
                                            .capitalizeFirstofEach +
                                        ' ' +
                                        metaInfo.doctor!.lastName!
                                            .capitalizeFirstofEach)!
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader1
                                  : mobileHeader1,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        if (metaInfo.hospital != null)
                          Text(
                            /* toBeginningOfSentenceCase(
                                    metaInfo.hospital.healthOrganizationName) */
                            metaInfo.hospital?.healthOrganizationName
                                    ?.capitalizeFirstofEach ??
                                "",
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2,
                            ),
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        Text(
                          metaInfo.dateOfVisit != null
                              ? variable.strDateOfVisit + metaInfo.dateOfVisit!
                              : '',
                          style: TextStyle(
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader3
                                : mobileHeader3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText)!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:
                            CommonUtil().isTablet! ? tabHeader3 : mobileHeader3,
                      ),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }

  Widget getCardForMedicalRecord(Metadata metaInfo, String? createdDate) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  variable.strCreatedDate +
                      FHBUtils().getMonthDateYear(createdDate),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: <Widget>[
                getCardImage(metaInfo),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.hospital != null)
                          metaInfo.hospital!.healthOrganizationName != null
                              ? Text(
                                  /* toBeginningOfSentenceCase(metaInfo
                                        .hospital.healthOrganizationName), */
                                  metaInfo.hospital!.healthOrganizationName!
                                      .capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader1
                                        : mobileHeader1,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox(
                                  height: 0.0.h,
                                )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        if (metaInfo.doctor != null)
                          Text(
                            /* toBeginningOfSentenceCase(
                                    toBeginningOfSentenceCase(
                                        metaInfo.doctor != null
                                            ? (metaInfo.doctor.name != null &&
                                                    metaInfo.doctor.name != '')
                                                ? metaInfo.doctor.name
                                                : metaInfo.doctor.firstName +
                                                    ' ' +
                                                    metaInfo.doctor.lastName
                                            : '')), */
                            metaInfo.doctor != null
                                ? ((metaInfo.doctor!.name != null &&
                                        metaInfo.doctor!.name != '')
                                    ? metaInfo
                                        .doctor?.name?.capitalizeFirstofEach
                                    : metaInfo.doctor!.firstName!
                                            .capitalizeFirstofEach +
                                        ' ' +
                                        metaInfo.doctor!.lastName!
                                            .capitalizeFirstofEach)!
                                : '',
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2,
                            ),
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        Text(
                          variable.strDateOfVisit + metaInfo.dateOfVisit!,
                          style: TextStyle(
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader3
                                : mobileHeader3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText)!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:
                            CommonUtil().isTablet! ? tabHeader3 : mobileHeader3,
                      ),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }

  Widget getCardForLab(Metadata metaInfo, String? createdDate) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  variable.strCreatedDate +
                      FHBUtils().getMonthDateYear(createdDate),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: <Widget>[
                getCardImage(metaInfo),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.laboratory != null)
                          metaInfo.laboratory!.healthOrganizationName != null
                              ? Text(
                                  // toBeginningOfSentenceCase(metaInfo
                                  //     .laboratory.healthOrganizationName),
                                  metaInfo.laboratory!.healthOrganizationName!
                                      .capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader1
                                        : mobileHeader1,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox(
                                  height: 0.0.h,
                                )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        if (metaInfo.doctor != null)
                          Text(
                            /* toBeginningOfSentenceCase(
                                    toBeginningOfSentenceCase(
                                        metaInfo.doctor != null
                                            ? (metaInfo.doctor.name != null &&
                                                    metaInfo.doctor.name != '')
                                                ? metaInfo.doctor.name
                                                : metaInfo.doctor.firstName +
                                                    ' ' +
                                                    metaInfo.doctor.lastName
                                            : '')), */
                            metaInfo.doctor != null
                                ? ((metaInfo.doctor!.name != null &&
                                        metaInfo.doctor!.name != '')
                                    ? metaInfo
                                        .doctor?.name?.capitalizeFirstofEach
                                    : metaInfo.doctor!.firstName!
                                            .capitalizeFirstofEach +
                                        ' ' +
                                        metaInfo.doctor!.lastName!
                                            .capitalizeFirstofEach)!
                                : '',
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2,
                            ),
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        Text(
                          variable.strDateOfVisit + metaInfo.dateOfVisit!,
                          style: TextStyle(
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader3
                                : mobileHeader3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText)!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize:
                            CommonUtil().isTablet! ? tabHeader3 : mobileHeader3,
                      ),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }

  Widget getCardForDevices(Metadata metaInfo, String? createdOn) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  variable.strCreatedDate +
                      FHBUtils().getMonthDateYear(createdOn),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Text(
              metaInfo.healthRecordType!.name!,
              style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
            ),
            /* metaInfo.memoText != null
                ? Text(
                    toBeginningOfSentenceCase(metaInfo.memoText),
                    style: TextStyle(fontSize: 14.0.sp),
                  )
                : Text(''),*/
            SizedBox(
              height: 10.0.h,
            ),
            if (metaInfo.deviceReadings != null)
              getDeviceReadings(metaInfo.deviceReadings!)
            else
              Container(
                height: 0.0.h,
              ),
            Text(
              metaInfo.memoText ?? '',
              style: TextStyle(
                fontSize: CommonUtil().isTablet! ? tabHeader3 : mobileHeader3,
              ),
            ),
            SizedBox(
              height: 60.0.h,
            ),
          ],
        ));
  }

  getCardForBillsAndOthers(Metadata metaInfo, String? createdDate) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Text(
                createdDate != null
                    ? variable.strCreatedDate +
                        FHBUtils().getMonthDateYear(createdDate)
                    : '',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Text(
            metaInfo.fileName ?? '',
            style: TextStyle(
                fontSize: CommonUtil().isTablet! ? tabHeader1 : mobileHeader1,
                fontWeight: FontWeight.w500),
          ),
          /*metaInfo.memoText != null
              ? Text(toBeginningOfSentenceCase(metaInfo.memoText))
              : Text(''),*/
          SizedBox(
            height: 10.0.h,
          ),
          if (metaInfo.doctor != null)
            Text(
              metaInfo.doctor!.name!.capitalizeFirstofEach,
              style: TextStyle(
                fontSize: CommonUtil().isTablet! ? tabHeader2 : mobileHeader2,
              ),
            )
          else
            SizedBox(height: 0.0.h),
          if (metaInfo.memoText != null)
            Text(
              metaInfo.memoText!,
              style: TextStyle(
                fontSize: CommonUtil().isTablet! ? tabHeader3 : mobileHeader3,
              ),
            )
          else
            SizedBox(height: 0.0.h),
        ],
      ),
    );
  }

  getCardForNotes(Metadata metaInfo, String? createdDate) {
    PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME,
            metaInfo.healthRecordCategory!.categoryName!)
        .then((value) {
      PreferenceUtil.saveString(
              Constants.KEY_CATEGORYID, metaInfo.healthRecordCategory!.id!)
          .then((value) {});
    });

    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Text(
                createdDate != null
                    ? variable.strCreatedDate +
                        FHBUtils().getMonthDateYear(createdDate)
                    : '',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              getCardImage(metaInfo),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    metaInfo.fileName ?? '',
                    style: TextStyle(
                        fontSize:
                            CommonUtil().isTablet! ? tabHeader1 : mobileHeader1,
                        fontWeight: FontWeight.w500),
                  ),
                  if (metaInfo.doctor != null)
                    Text(
                      metaInfo.doctor!.name!,
                      style: TextStyle(
                        fontSize:
                            CommonUtil().isTablet! ? tabHeader2 : mobileHeader2,
                      ),
                    )
                  else
                    SizedBox(height: 0.0.h),
                  if (metaInfo.memoText != null)
                    Text(
                      metaInfo.memoText!,
                      style: TextStyle(
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader3
                              : mobileHeader3),
                    )
                  else
                    SizedBox(height: 0.0.h),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  getCardForIDDocs(Metadata metaInfo, String? createdDate) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  variable.strCreatedDate +
                      FHBUtils().getMonthDateYear(createdDate),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                getCardImage(metaInfo),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      metaInfo.fileName!,
                      style: TextStyle(
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader1
                              : mobileHeader1,
                          fontWeight: FontWeight.w500),
                    ),
                    if (metaInfo.dateOfVisit != null &&
                        metaInfo!.dateOfVisit != "")
                      Text(
                        variable.strValidThru + metaInfo.dateOfVisit!,
                        style: TextStyle(
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader2
                              : mobileHeader2,
                        ),
                      )
                    else
                      SizedBox(height: 0.0.h),
                    if (metaInfo.memoText != null)
                      Text(
                        metaInfo.memoText!,
                        style: TextStyle(
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader3
                                : mobileHeader3),
                      )
                    else
                      SizedBox(height: 0.0.h),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }

  Widget getCardForHospitalDocument(Metadata metaInfo, String? createdDate) {
    return Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Text(
                  variable.strCreatedDate +
                      FHBUtils().getMonthDateYear(createdDate),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                    child: Image.network(
                      metaInfo.healthRecordCategory!.logo!,
                      height: 25.0.h,
                      width: 25.0.h,
                      color: mAppThemeProvider.primaryColor,
                      errorBuilder: (context, error, stackTrace) => SizedBox(),
                    )),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.hospital != null)
                          metaInfo.hospital!.healthOrganizationName != null
                              ? Text(
                                  /* toBeginningOfSentenceCase(metaInfo
                                        .hospital.healthOrganizationName) */
                                  metaInfo.hospital!.healthOrganizationName!
                                      .capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: CommonUtil().isTablet!
                                        ? tabHeader1
                                        : mobileHeader1,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : SizedBox(
                                  height: 0.0.h,
                                )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        if (metaInfo.doctor != null)
                          Text(
                            //toBeginningOfSentenceCase(metaInfo.doctor.name),
                            metaInfo.doctor!.name!.capitalizeFirstofEach,
                            style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabHeader2
                                  : mobileHeader2,
                            ),
                          )
                        else
                          SizedBox(height: 0.0.h),
                        Text(
                          FHBUtils().getFormattedDateString(createdDate),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w200,
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader3
                                : mobileHeader3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText)!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader3
                              : mobileHeader3),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }

  /// Returns an Image widget to display for the given Metadata.
  ///
  /// This handles finding the appropriate image based on the metadata,
  /// loading it, and constructing the Image widget to display.
  getCardImage(Metadata metaInfo) {
    return ClipOval(
        child: CircleAvatar(
      radius: CommonUtil().isTablet! ? 35 : 25,
      backgroundColor: const Color(fhbColors.bgColorContainer),
      child: Image.network(
        metaInfo?.healthRecordCategory?.logo ?? '',
        height: 30.0.h,
        width: 30.0.h,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
        color: mAppThemeProvider.primaryColor,
      ),
    ));
  }

  Widget getDeviceReadings(List<DeviceReadings> deviceReadings) {
    final list = <Widget>[];
    for (var i = 0; i < deviceReadings.length; i++) {
      list.add(
        Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Text(deviceReadings[i].parameter != null
                      ? toBeginningOfSentenceCase(deviceReadings[i]
                                  .parameter!
                                  .toLowerCase() ==
                              CommonConstants.strOxygenParams.toLowerCase()
                          ? CommonConstants.strOxygenParamsName.toLowerCase()
                          : deviceReadings[i].parameter!.toLowerCase())!
                      : ''),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        deviceReadings[i].value.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: CommonUtil().isTablet!
                              ? tabHeader1
                              : mobileHeader1,
                        ),
                      ),
                      Text(
                          deviceReadings[i].unit.toLowerCase() ==
                                  CommonConstants.strOxygenUnits.toLowerCase()
                              ? CommonConstants.strOxygenUnitsName
                              : getUnitForTemperature(
                                  " " + deviceReadings[i].unit),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: CommonUtil().isTablet!
                                ? tabHeader2
                                : mobileHeader2,
                          )),
                    ],
                  ),
                )
              ],
            )),
      );
    }

    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: DashSeparator(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      Column(
        children: list,
      ),
      Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: DashSeparator(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    ]);
    //return Row(children: list);
  }

  getDoctorProfileImageWidget(MetaInfo data) {
    var _healthReportListForUserBlock = HealthReportListForUserBlock();
    return FutureBuilder(
      future: _healthReportListForUserBlock.getProfilePic(data.doctor!.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data as Uint8List,
            height: 50.0.h,
            width: 50.0.h,
            fit: BoxFit.cover,
          );
        } else {
          return SizedBox(
            width: 50.0.h,
            height: 50.0.h,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[550]!,
                child: Container(
                    width: 50.0.h, height: 50.0.h, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }

  getUnitForTemperature(String unit) {
    if (unit.toLowerCase() == strParamUnitFarenheit.toLowerCase()) {
      return strParamUnitFarenheit;
    } else if (unit.toLowerCase() ==
        CommonConstants.strTemperatureValue.toLowerCase()) {
      return strParamUnitFarenheit;
    } else if (unit.toLowerCase() == "c".toLowerCase()) {
      return strParamUnitCelsius;
    } else {
      return unit;
    }
  }
}
