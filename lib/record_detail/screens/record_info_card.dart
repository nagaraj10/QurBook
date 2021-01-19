import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/MetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/DashSeparator.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/src/model/Health/CompleteData.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                    child: metaInfo.doctor != null
                        ? new CommonUtil().getDoctorProfileImageWidget(metaInfo
                            .doctor
                            .profilePicThumbnailUrl) //getDoctorProfileImageWidget(metaInfo)
                        : Container(
                            width: 50,
                            height: 50,
                            color: Color(fhbColors.bgColorContainer))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        metaInfo.doctor != null
                            ? Text(
                                toBeginningOfSentenceCase(
                                    metaInfo.doctor != null
                                        ? (metaInfo.doctor.name != null &&
                                                metaInfo.doctor.name != '')
                                            ? metaInfo.doctor.name
                                            : metaInfo.doctor.firstName +
                                                ' ' +
                                                metaInfo.doctor.lastName
                                        : ''),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        metaInfo.hospital != null
                            ? Text(
                                toBeginningOfSentenceCase(
                                    metaInfo.hospital.healthOrganizationName),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13),
                              )
                            //Text('')
                            : SizedBox(height: 0),
                        Text(
                          metaInfo.dateOfVisit != null
                              ? variable.strDateOfVisit + metaInfo.dateOfVisit
                              : '',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20,
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
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      /*metaInfo.hospital != null
                      ? metaInfo.hospital.logoThumbnail != null
                          ? NetworkImage(Constants.BASE_URL +
                              metaInfo.hospital.logoThumbnail)
                          : null
                      :*/
                      null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        metaInfo.hospital != null
                            ? metaInfo.hospital.healthOrganizationName != null
                                ? Text(
                                    toBeginningOfSentenceCase(metaInfo
                                        .hospital.healthOrganizationName),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox(
                                    height: 0,
                                  )
                            : SizedBox(
                                height: 0,
                              ),
                        metaInfo.doctor != null
                            ? Text(
                                toBeginningOfSentenceCase(
                                    toBeginningOfSentenceCase(
                                        metaInfo.doctor != null
                                            ? (metaInfo.doctor.name != null &&
                                                    metaInfo.doctor.name != '')
                                                ? metaInfo.doctor.name
                                                : metaInfo.doctor.firstName +
                                                    ' ' +
                                                    metaInfo.doctor.lastName
                                            : '')),
                                style: TextStyle(fontSize: 13),
                              )
                            : SizedBox(height: 0),
                        Text(
                          variable.strDateOfVisit + metaInfo.dateOfVisit,
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20,
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
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      /*metaInfo.laboratory != null
                      ? metaInfo.laboratory.logoThumbnail != null
                          ? NetworkImage(Constants.BASE_URL +
                              metaInfo.laboratory.logoThumbnail)
                          : null
                      : null
                      :*/
                      null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        metaInfo.laboratory != null
                            ? metaInfo.laboratory.healthOrganizationName != null
                                ? Text(
                                    toBeginningOfSentenceCase(metaInfo
                                        .laboratory.healthOrganizationName),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox(
                                    height: 0,
                                  )
                            : SizedBox(
                                height: 0,
                              ),
                        metaInfo.doctor != null
                            ? Text(
                                toBeginningOfSentenceCase(
                                    toBeginningOfSentenceCase(
                                        metaInfo.doctor != null
                                            ? (metaInfo.doctor.name != null &&
                                                    metaInfo.doctor.name != '')
                                                ? metaInfo.doctor.name
                                                : metaInfo.doctor.firstName +
                                                    ' ' +
                                                    metaInfo.doctor.lastName
                                            : '')),
                                style: TextStyle(fontSize: 13),
                              )
                            : SizedBox(height: 0),
                        Text(
                          variable.strDateOfVisit + metaInfo.dateOfVisit,
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20,
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
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Text(
              metaInfo.healthRecordType.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            /* metaInfo.memoText != null
                ? Text(
                    toBeginningOfSentenceCase(metaInfo.memoText),
                    style: TextStyle(fontSize: 12),
                  )
                : Text(''),*/
            SizedBox(
              height: 10,
            ),
            metaInfo.deviceReadings != null
                ? getDeviceReadings(metaInfo.deviceReadings)
                : Container(
                    height: 0,
                  ),
            Text(
              metaInfo.memoText != null ? metaInfo.memoText : '',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(
              height: 60,
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Text(
            metaInfo.fileName != null ? metaInfo.fileName : '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          /*metaInfo.memoText != null
              ? Text(toBeginningOfSentenceCase(metaInfo.memoText))
              : Text(''),*/
          SizedBox(
            height: 10,
          ),
          metaInfo.doctor != null
              ? Text(
                  metaInfo.doctor.name,
                  style: TextStyle(fontSize: 13),
                )
              : SizedBox(height: 0),
          metaInfo.memoText != null
              ? Text(
                  metaInfo.memoText,
                  style: TextStyle(fontSize: 13),
                )
              : SizedBox(height: 0),
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
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              )
            ],
          ),
          Text(
            metaInfo.fileName != null ? metaInfo.fileName : '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          /*metaInfo.memoText != null
              ? Text(toBeginningOfSentenceCase(metaInfo.memoText))
              : Text(''),*/
          SizedBox(
            height: 10,
          ),
          metaInfo.doctor != null
              ? Text(
                  metaInfo.doctor.name,
                  style: TextStyle(fontSize: 13),
                )
              : SizedBox(height: 0),
          metaInfo.memoText != null
              ? Text(
                  metaInfo.memoText,
                  style: TextStyle(fontSize: 13),
                )
              : SizedBox(height: 0),
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
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Text(
              metaInfo.fileName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            metaInfo.dateOfVisit != null
                ? Text(
                    variable.strValidThru + metaInfo.dateOfVisit,
                    style: TextStyle(fontSize: 13),
                  )
                : SizedBox(height: 0),
            metaInfo.memoText != null
                ? Text(metaInfo.memoText)
                : SizedBox(height: 0),
            SizedBox(
              height: 20,
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
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      /*metaInfo.hospital != null
                      ? metaInfo.hospital.logoThumbnail != null
                          ? NetworkImage(Constants.BASE_URL +
                              metaInfo.hospital.logoThumbnail)
                          : null
                      :*/
                      null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        metaInfo.hospital != null
                            ? metaInfo.hospital.healthOrganizationName != null
                                ? Text(
                                    toBeginningOfSentenceCase(metaInfo
                                        .hospital.healthOrganizationName),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : SizedBox(
                                    height: 0,
                                  )
                            : SizedBox(
                                height: 0,
                              ),
                        metaInfo.doctor != null
                            ? Text(
                                toBeginningOfSentenceCase(metaInfo.doctor.name),
                                style: TextStyle(fontSize: 13),
                              )
                            : SizedBox(height: 0),
                        Text(
                          new FHBUtils().getFormattedDateString(createdDate),
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w200,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: metaInfo.memoText != null
                  ? Text(
                      toBeginningOfSentenceCase(metaInfo.memoText),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 12),
                    )
                  : Text(''),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}

Widget getDeviceReadings(List<DeviceReadings> deviceReadings) {
  List<Widget> list = new List<Widget>();
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
                        deviceReadings[i].parameter.toLowerCase())
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
                          fontSize: 16),
                    ),
                    Text(deviceReadings[i].unit.toString(),
                        style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              )
            ],
          )),
    );
  }

  return new Column(children: <Widget>[
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
  HealthReportListForUserBlock _healthReportListForUserBlock =
      new HealthReportListForUserBlock();
  return FutureBuilder(
    future: _healthReportListForUserBlock.getProfilePic(data.doctor.id),
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        return Image.memory(
          snapshot.data,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        );
      } else {
        return new SizedBox(
          width: 50.0,
          height: 50.0,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[200],
              highlightColor: Colors.grey[550],
              child: Container(width: 50, height: 50, color: Colors.grey[200])),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              metaInfo.doctor != null
                  ? Text(
                      metaInfo.doctor.name,
                    )
                  : SizedBox(height: 0),
              Text(FHBUtils().getFormattedDateString(createdDate))
            ],
          ),
          Text(metaInfo.memoText),
          SizedBox(
            height: 60,
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              metaInfo.doctor != null
                  ? Text(
                      metaInfo.doctor.name,
                    )
                  : SizedBox(height: 0),
              Text(FHBUtils().getFormattedDateString(createdDate))
            ],
          ),
          Text(metaInfo.memoText),
          SizedBox(
            height: 60,
          ),
        ],
      ));
}
