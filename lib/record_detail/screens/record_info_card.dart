import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/CommonUtil.dart';
import '../../common/PreferenceUtil.dart';
import '../../src/blocs/health/HealthReportListForUserBlock.dart';
import '../../src/model/Health/MetaInfo.dart';
import '../../src/model/Health/UserHealthResponseList.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../src/model/Health/asgard/health_record_list.dart';
import 'package:shimmer/shimmer.dart';
import '../../src/utils/FHBUtils.dart';
import '../../src/utils/DashSeparator.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../src/model/Health/CompleteData.dart';
import '../../src/model/Health/MediaMetaInfo.dart';
import '../../constants/variable_constant.dart' as variable;
import '../../constants/fhb_parameters.dart' as parameters;
import '../../src/utils/screenutils/size_extensions.dart';

import '../../common/CommonConstants.dart';
import '../../constants/fhb_parameters.dart';

class RecordInfoCard {
  Widget getCardForPrescription(Metadata metaInfo, String createdDate) {
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
                    child: metaInfo.doctor != null
                        ? CommonUtil().getDoctorProfileImageWidget(
                            metaInfo.doctor.profilePicThumbnailUrl,
                            metaInfo
                                .doctor) //getDoctorProfileImageWidget(metaInfo)
                        : Container(
                            width: 50.0.h,
                            height: 50.0.h,
                            color: Color(fhbColors.bgColorContainer))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.doctor != null)
                          Text(
                            /* toBeginningOfSentenceCase(
                                    metaInfo.doctor != null
                                        ? (metaInfo.doctor.name != null &&
                                                metaInfo.doctor.name != '')
                                            ? metaInfo.doctor.name
                                            : metaInfo.doctor.firstName +
                                                ' ' +
                                                metaInfo.doctor.lastName
                                        : ''), */
                            metaInfo.doctor != null
                                ? (metaInfo.doctor.name != null &&
                                        metaInfo.doctor.name != '')
                                    ? metaInfo
                                        .doctor.name?.capitalizeFirstofEach
                                    : metaInfo.doctor.firstName
                                            ?.capitalizeFirstofEach +
                                        ' ' +
                                        metaInfo.doctor.lastName
                                            ?.capitalizeFirstofEach
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0.sp,
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
                            metaInfo?.hospital?.healthOrganizationName
                                    ?.capitalizeFirstofEach ??
                                "",
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        Text(
                          metaInfo.dateOfVisit != null
                              ? variable.strDateOfVisit + metaInfo.dateOfVisit
                              : '',
                          style: TextStyle(
                            fontSize: 13.0.sp,
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
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0.sp,
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

  Widget getCardForMedicalRecord(Metadata metaInfo, String createdDate) {
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
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.hospital != null)
                          metaInfo.hospital.healthOrganizationName != null
                              ? Text(
                                  /* toBeginningOfSentenceCase(metaInfo
                                        .hospital.healthOrganizationName), */
                                  metaInfo?.hospital?.healthOrganizationName
                                      ?.capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0.sp,
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
                                ? (metaInfo.doctor.name != null &&
                                        metaInfo.doctor.name != '')
                                    ? metaInfo
                                        ?.doctor?.name?.capitalizeFirstofEach
                                    : metaInfo?.doctor?.firstName
                                            ?.capitalizeFirstofEach +
                                        ' ' +
                                        metaInfo?.doctor?.lastName
                                            ?.capitalizeFirstofEach
                                : '',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        Text(
                          variable.strDateOfVisit + metaInfo.dateOfVisit,
                          style: TextStyle(
                            fontSize: 13.0.sp,
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
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0.sp,
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

  Widget getCardForLab(Metadata metaInfo, String createdDate) {
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
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.laboratory != null)
                          metaInfo.laboratory.healthOrganizationName != null
                              ? Text(
                                  // toBeginningOfSentenceCase(metaInfo
                                  //     .laboratory.healthOrganizationName),
                                  metaInfo?.laboratory?.healthOrganizationName
                                      ?.capitalizeFirstofEach,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0.sp,
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
                                ? (metaInfo.doctor.name != null &&
                                        metaInfo.doctor.name != '')
                                    ? metaInfo
                                        ?.doctor?.name?.capitalizeFirstofEach
                                    : metaInfo?.doctor?.firstName
                                            ?.capitalizeFirstofEach +
                                        ' ' +
                                        metaInfo?.doctor?.lastName
                                            ?.capitalizeFirstofEach
                                : '',
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          )
                        else
                          SizedBox(
                            height: 0.0.h,
                          ),
                        Text(
                          variable.strDateOfVisit + metaInfo.dateOfVisit,
                          style: TextStyle(
                            fontSize: 13.0.sp,
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
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0.sp,
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

  Widget getCardForDevices(Metadata metaInfo, String createdOn) {
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
                  FHBUtils().getMonthDateYear(createdOn),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Text(
              metaInfo.healthRecordType.name,
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
              getDeviceReadings(metaInfo.deviceReadings)
            else
              Container(
                height: 0.0.h,
              ),
            Text(
              metaInfo.memoText ?? '',
              style: TextStyle(
                fontSize: 15.0.sp,
              ),
            ),
            SizedBox(
              height: 60.0.h,
            ),
          ],
        ));
  }

  getCardForBillsAndOthers(Metadata metaInfo, String createdDate) {
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
                    ? FHBUtils().getMonthDateYear(createdDate)
                    : '',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Text(
            metaInfo.fileName ?? '',
            style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
          ),
          /*metaInfo.memoText != null
              ? Text(toBeginningOfSentenceCase(metaInfo.memoText))
              : Text(''),*/
          SizedBox(
            height: 10.0.h,
          ),
          if (metaInfo.doctor != null)
            Text(
              metaInfo?.doctor?.name?.capitalizeFirstofEach,
              style: TextStyle(
                fontSize: 15.0.sp,
              ),
            )
          else
            SizedBox(height: 0.0.h),
          if (metaInfo.memoText != null)
            Text(
              metaInfo.memoText,
              style: TextStyle(
                fontSize: 15.0.sp,
              ),
            )
          else
            SizedBox(height: 0.0.h),
        ],
      ),
    );
  }

  getCardForNotes(Metadata metaInfo, String createdDate) {
    PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME,
            metaInfo.healthRecordCategory.categoryName)
        .then((value) {
      PreferenceUtil.saveString(
              Constants.KEY_CATEGORYID, metaInfo.healthRecordCategory.id)
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
                    ? FHBUtils().getMonthDateYear(createdDate)
                    : '',
                textAlign: TextAlign.end,
                style:
                    TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Text(
            metaInfo.fileName ?? '',
            style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
          ),
          /*metaInfo.memoText != null
              ? Text(toBeginningOfSentenceCase(metaInfo.memoText))
              : Text(''),*/
          SizedBox(
            height: 10.0.h,
          ),
          if (metaInfo.doctor != null)
            Text(
              metaInfo?.doctor?.name,
              style: TextStyle(fontSize: 15.0.sp),
            )
          else
            SizedBox(height: 0.0.h),
          if (metaInfo.memoText != null)
            Text(
              metaInfo.memoText,
              style: TextStyle(fontSize: 15.0.sp),
            )
          else
            SizedBox(height: 0.0.h),
        ],
      ),
    );
  }

  getCardForIDDocs(Metadata metaInfo, String createdDate) {
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
                  FHBUtils().getMonthDateYear(createdDate),
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Text(
              metaInfo.fileName,
              style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
            ),
            if (metaInfo.dateOfVisit != null)
              Text(
                variable.strValidThru + metaInfo.dateOfVisit,
                style: TextStyle(fontSize: 15.0.sp),
              )
            else
              SizedBox(height: 0.0.h),
            if (metaInfo.memoText != null)
              Text(metaInfo.memoText)
            else
              SizedBox(height: 0.0.h),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }

  Widget getCardForHospitalDocument(Metadata metaInfo, String createdDate) {
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
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (metaInfo.hospital != null)
                          metaInfo.hospital.healthOrganizationName != null
                              ? Text(
                                  /* toBeginningOfSentenceCase(metaInfo
                                        .hospital.healthOrganizationName) */
                                  metaInfo?.hospital?.healthOrganizationName
                                      ?.capitalizeFirstofEach,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0.sp),
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
                            metaInfo?.doctor?.name?.capitalizeFirstofEach,
                            style: TextStyle(fontSize: 15.0.sp),
                          )
                        else
                          SizedBox(height: 0.0.h),
                        Text(
                          FHBUtils().getFormattedDateString(createdDate),
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w200,
                              fontSize: 14.0.sp),
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
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14.0.sp),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20.0.h,
            ),
          ],
        ));
  }
}

Widget getDeviceReadings(List<DeviceReadings> deviceReadings) {
  final list = List<Widget>();
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
                    ? toBeginningOfSentenceCase(
                        deviceReadings[i].parameter.toLowerCase() ==
                                CommonConstants.strOxygenParams.toLowerCase()
                            ? CommonConstants.strOxygenParamsName.toLowerCase()
                            : deviceReadings[i].parameter.toLowerCase())
                    : ''),
              ),
              Expanded(
                flex: 2,
                child: FittedBox(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      deviceReadings[i].value.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0.sp),
                    ),
                    Text(
                        deviceReadings[i].unit.toLowerCase() ==
                                CommonConstants.strOxygenUnits.toLowerCase()
                            ? CommonConstants.strOxygenUnitsName
                            : getUnitForTemperature(
                                " " + deviceReadings[i].unit),
                        style: TextStyle(
                            color: Colors.black54, fontSize: 14.0.sp)),
                  ],
                )),
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
  //return new Row(children: list);
}

getDoctorProfileImageWidget(MetaInfo data) {
  var _healthReportListForUserBlock = HealthReportListForUserBlock();
  return FutureBuilder(
    future: _healthReportListForUserBlock.getProfilePic(data.doctor.id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Image.memory(
          snapshot.data,
          height: 50.0.h,
          width: 50.0.h,
          fit: BoxFit.cover,
        );
      } else {
        return SizedBox(
          width: 50.0.h,
          height: 50.0.h,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[550],
              child: Container(
                  width: 50.0.h, height: 50.0.h, color: Colors.grey[200])),
        );
      }

      ///load until snapshot.hasData resolves to true
    },
  );
}

getCardForBillsAndOthers(MetaInfo metaInfo, String createdDate) {
  return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            metaInfo.fileName,
            style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (metaInfo.doctor != null)
                Text(
                  metaInfo.doctor.name,
                )
              else
                SizedBox(height: 0.0.h),
              Text(FHBUtils().getFormattedDateString(createdDate))
            ],
          ),
          Text(metaInfo.memoText),
          SizedBox(
            height: 60.0.h,
          ),
        ],
      ));
}

getCardForIDDocs(MetaInfo metaInfo, String createdDate) {
  return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            metaInfo.fileName,
            style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (metaInfo.doctor != null)
                Text(
                  metaInfo.doctor.name,
                )
              else
                SizedBox(height: 0.0.h),
              Text(FHBUtils().getFormattedDateString(createdDate))
            ],
          ),
          Text(metaInfo.memoText),
          SizedBox(
            height: 60.0.h,
          ),
        ],
      ));
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
