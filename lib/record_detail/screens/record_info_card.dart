import 'package:flutter/material.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:shimmer/shimmer.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/DashSeparator.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class RecordInfoCard {
  Widget getCardForPrescription(MetaInfo metaInfo, String createdDate) {
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
                        ? getDoctorProfileImageWidget(metaInfo)
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
                        metaInfo.doctor.name != null
                            ? Text(
                                metaInfo.doctor.name,
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
                                metaInfo.hospital.name,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13),
                              )
                            //Text('')
                            : SizedBox(height: 0),
                        Text(
                          'Date of visit: ' + metaInfo.dateOfVisit,
                          style: TextStyle(fontSize: 11),
                        ),
                        /* Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Date of visit: ' + metaInfo.dateOfVisit),
                            Text(metaInfo.dateOfVisit)
                          ],
                        ), */
                      ],
                    ),
                  ),
                )
              ],
            ),
            /*  SizedBox(
              height: 20,
            ), */
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget getCardForMedicalRecord(MetaInfo metaInfo, String createdDate) {
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
                  backgroundImage: metaInfo.hospital.logoThumbnail != null
                      ? NetworkImage(
                          Constants.BASERURL + metaInfo.hospital.logoThumbnail)
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        metaInfo.hospital.name != null
                            ? Text(
                                metaInfo.hospital.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        metaInfo.doctor != null
                            ? Text(
                                metaInfo.doctor.name,
                                style: TextStyle(fontSize: 13),
                              )
                            : SizedBox(height: 0),
                        Text(
                          'Date of visit: ' + metaInfo.dateOfVisit,
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget getCardForLab(MetaInfo metaInfo, String createdDate) {
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
                  backgroundImage: metaInfo.laboratory.logoThumbnail != null
                      ? NetworkImage(Constants.BASERURL +
                          metaInfo.laboratory.logoThumbnail)
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        metaInfo.laboratory.name != null
                            ? Text(
                                metaInfo.laboratory.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              )
                            : SizedBox(
                                height: 0,
                              ),
                        metaInfo.doctor != null
                            ? Text(
                                metaInfo.doctor.name,
                                style: TextStyle(fontSize: 13),
                              )
                            : SizedBox(height: 0),
                        /* metaInfo.memoText != null
                            ? Text(
                                metaInfo.memoText,
                                style: TextStyle(fontSize: 13),
                              )
                            : SizedBox(height: 0), */
                        Text(
                          'Date of visit: ' + metaInfo.dateOfVisit,
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Widget getCardForDevices(MetaInfo metaInfo, String createdOn) {
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
              metaInfo.mediaTypeInfo.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            metaInfo.deviceReadings != null
                ? getDeviceReadings(metaInfo.deviceReadings)
                : Container(
                    height: 0,
                  ),
            Text(
              metaInfo.memoText,
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ));
  }

  getCardForBillsAndOthers(MetaInfo metaInfo, String createdDate) {
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

  getCardForIDDocs(MetaInfo metaInfo, String createdDate) {
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
            metaInfo.dateOfExpiry != null
                ? Text(
                    'Valid thru - ' + metaInfo.dateOfExpiry,
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
                child: Text(deviceReadings[i].parameter),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      deviceReadings[i].value,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    Text(deviceReadings[i].unit,
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
  print('docotor id : ${data.doctor.id}');
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
