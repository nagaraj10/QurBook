import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/DateSlots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/Slots.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Languages.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/ProfilePic.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/GridViewNew.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/SessionList.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class CommonWidgets {
  CommonUtil commonUtil = new CommonUtil();
  int rowPosition;
  int itemPosition;

  Widget getTextForDoctors(String docName) {
    return Text(
      docName != null ? toBeginningOfSentenceCase(docName) : '',
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: fhbStyles.fnt_doc_name),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getMCVerified(bool condition, String value) {
    return Text(
      value != null ? value.toUpperCase() : "''",
      style: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: fhbStyles.fnt_sessionTime,
          color: condition ? Colors.green : Colors.red),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getSizedBox(double height) {
    return SizedBox(height: height);
  }

  Widget getDoctoSpecialist(String phoneNumber) {
    print('specialization' + phoneNumber);
    return Text(
      (phoneNumber != null && phoneNumber != 'null')
          ? toBeginningOfSentenceCase(phoneNumber)
          : '',
      style: TextStyle(
          color: Color(0xFF8C8C8C), fontSize: fhbStyles.fnt_doc_specialist),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getDoctorsAddress(String address) {
    return Text(
      address != null ? toBeginningOfSentenceCase(address) : '',
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
          fontWeight: FontWeight.w200,
          color: Colors.grey[600],
          fontSize: fhbStyles.fnt_city),
    );
  }

  Widget getHospitalDetails(String address) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      child: Text(
        toBeginningOfSentenceCase(address),
        style: TextStyle(
            color: Color(0xFF8C8C8C), fontSize: fhbStyles.fnt_abt_doc),
        softWrap: true,
      ),
    );
  }

  Widget getDownArrowWidget() {
    return Container(
      color: Colors.white,
      width: 15,
      height: 30,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.blue,
      ),
    );
  }

  Widget getBookMarkedIcon(DoctorIds docs, Function onClick) {
    return GestureDetector(
        onTap: () {
          onClick();
        },
        child: docs.isDefault
            ? ImageIcon(
                AssetImage('assets/icons/record_fav_active.png'),
                color: Color(new CommonUtil().getMyPrimaryColor()),
                size: fhbStyles.imageWidth,
              )
            : ImageIcon(
                AssetImage('assets/icons/record_fav.png'),
                color: Colors.black,
                size: fhbStyles.imageWidth,
              ));
  }

  Widget getGridView() {
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 8.0,
      children: <Widget>[
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
        Image.network("https://placeimg.com/500/500/any"),
      ],
    );
  }

  Widget getIcon(
      {double width,
      double height,
      IconData icon,
      Colors colors,
      Function onTap}) {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        child: Icon(
          icon,
          color: Color(new CommonUtil().getMyPrimaryColor()),
          size: width,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget getSizeBoxWidth(double width) {
    return SizedBox(width: width);
  }

  Widget getClipOvalImage(String profileImage, double imageSize) {
    return ClipOval(
        child: Image.network(
      'https://heyr2.com/r2/admin/images/profile/${profileImage != null ? profileImage : 'Patient0.jpg'}',
      fit: BoxFit.cover,
      height: imageSize,
      width: imageSize,
    ));
  }

  Widget getClipOvalImageNew(String profilePicThumbnailURL, double imageSize) {
    return ClipOval(child: getProfilePicWidget(profilePicThumbnailURL));
  }

  Widget getProfilePicWidget(String profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.network(
            profilePicThumbnail,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 40,
            width: 40,
          );
  }

  Widget showDoctorDetailView(DoctorIds docs, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              width: MediaQuery.of(context).size.width - 20,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    top: -1.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: getClipOvalImageNew(
                                docs.profilePicThumbnailURL,
                                fhbStyles.detailClipImage),
                          ),
                          getSizeBoxWidth(10.0),
                          Expanded(
                            // flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                getTextForDoctors('${docs.name}'),
                                docs.specialization != null
                                    ? getDoctoSpecialist(
                                        '${docs.specialization}')
                                    : SizedBox(),
                                getDoctorsAddress('${docs.city}'),
                                (docs.languages != null &&
                                        docs.languages.length > 0)
                                    ? getTextForDoctors('Can Speak')
                                    : SizedBox(),
                                (docs.languages != null &&
                                        docs.languages.length > 0)
                                    ? Row(children: getLanguages(docs))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      getSizedBox(20),
                      getTextForDoctors('About'),
                      getHospitalDetails(docs.professionalDetails != null
                          ? docs.professionalDetails[0].aboutMe
                          : ''),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getTimeSlotText(String textSlotTime) {
    return Text(
      textSlotTime,
      style: TextStyle(
          color: Colors.blueGrey, fontSize: fhbStyles.fnt_sessionTime),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
          width: 0.8, //
          color: Colors.green),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

  getSpecificTimeSlots(List<Slots> dateTimingsSlots) {
    List<Widget> rowSpecificTimeSlots = new List();
    String timeSlots = '';

    for (Slots dateTiming in dateTimingsSlots) {
      timeSlots = commonUtil.removeLastThreeDigits(dateTiming.startTime);

      rowSpecificTimeSlots.add(getSpecificSlots(timeSlots));
    }

    return rowSpecificTimeSlots;
  }

  getSpecificTimeSlotsNew(List<DateTiming> dateTimingsSlots) {
    List<Widget> rowSpecificTimeSlots = new List();

    for (int i = 0; i < dateTimingsSlots.length; i++) {
      if (i > 0 && i % 5 == 0) {
        rowSpecificTimeSlots
            .add(getSpecificSlots(dateTimingsSlots[i].timeslots));
      } else {
        rowSpecificTimeSlots.add(Row(
          children: [],
        ));
      }
    }

    return rowSpecificTimeSlots;
  }

  Widget getSpecificSlots(String time) {
    return Container(
      width: 35,
      decoration: myBoxDecoration(),
      child: Center(
        child: Text(
          time,
          style:
              TextStyle(fontSize: fhbStyles.fnt_date_slot, color: Colors.green),
        ),
      ),
    );
  }

  Widget getDoctorStatusWidget(DoctorIds docs, int position) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getDoctorStatus('${docs.isActive}', position)
            //color: getDoctorStatus('5'),
            ),
      ),
    );
  }

  BoxDecoration getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color(fhbColors.cardShadowColor),
          blurRadius: 16, // has the effect of softening the shadow
          spreadRadius: 0, // has the effect of extending the shadow
        )
      ],
    );
  }

  Color getDoctorStatus(String s, int position) {
    print('getDoctorStatus $s');
    switch (s) {
      case 'true':
        return Colors.green;
      case 'false':
        return Colors.red;
      default:
        return null;
    }
  }

  removeLastThreeDigits(String string) {
    String removedString = '';
    removedString = string.substring(0, string.length - 3);

    return removedString;
  }

  getLanguages(DoctorIds docs) {
    List<Widget> languageWidget = new List();
    if (docs.languages != null && docs.languages.length > 0) {
      for (Languages lang in docs.languages) {
        languageWidget.add(getDoctorsAddress(lang.name + ','));
      }
    } else {
      languageWidget.add(SizedBox());
    }

    return languageWidget;
  }
}
