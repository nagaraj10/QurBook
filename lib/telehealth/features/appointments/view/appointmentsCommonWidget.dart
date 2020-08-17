import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:path/path.dart';

class AppointmentsCommonWidget {
  Widget docName(BuildContext context, doc) {
    return Row(
      children: [
        Container(
          constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
          child: Row(
            children: [
              TextWidget(
                text: doc,
                fontWeight: FontWeight.w500,
                fontsize: fhbStyles.fnt_doc_name,
                softwrap: false,
                overflow: TextOverflow.ellipsis,
                colors: Colors.black,
              ),
              IconWidget(
                  colors: Color(new CommonUtil().getMyPrimaryColor()),
                  icon: Icons.info,
                  size: 10,
                  onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget docStatus(BuildContext context, doc) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width >=400
              ? MediaQuery.of(context).size.width / 1.5
              : MediaQuery.of(context).size.width / 2.1),
      child: TextWidget(
        text: doc == null ? '' : doc,
        colors: Colors.black26,
        fontsize: 10.5,//fhbStyles.fnt_doc_specialist,
        softwrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget docLoc(BuildContext context, doc) {
    return Container(
      constraints:
      BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
      child: TextWidget(
        text: doc,
        overflow: TextOverflow.ellipsis,
        softwrap: false,
        fontWeight: FontWeight.w200,
        colors: Colors.black87,
        fontsize: fhbStyles.fnt_city,
      ),
    );
  }

  Widget docTimeSlot(BuildContext context, History doc, hour, minute) {
    return ((hour == '00' && minute == '00') ||
        hour.length == 0 ||
        minute.length == 0)
        ? Container()
        : Row(
      children: [
        ClipRect(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color(new CommonUtil().getMyPrimaryColor())),
            ),
            height: 29,
            width: 25,
            alignment: Alignment.center,
            padding: EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextWidget(
                  fontsize: 10,
                  text: hour,
                  fontWeight: FontWeight.w500,
                  colors: Colors.grey,
                ),
                TextWidget(
                  fontsize: 5,
                  text: Constants.Appointments_hours,
                  fontWeight: FontWeight.w500,
                  colors: Color(new CommonUtil().getMyPrimaryColor()),
                ),
              ],
            ),
          ),
        ),
        SizedBoxWidget(width: 2.0),
        ClipRect(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color(new CommonUtil().getMyPrimaryColor())),
            ),
            height: 29,
            width: 25,
            alignment: Alignment.center,
            padding: EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextWidget(
                  fontsize: 10,
                  text: minute,
                  fontWeight: FontWeight.w500,
                  colors: Colors.grey,
                ),
                TextWidget(
                  fontsize: 5,
                  text: Constants.Appointments_minutes,
                  fontWeight: FontWeight.w500,
                  colors: Color(new CommonUtil().getMyPrimaryColor()),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget docIcons(History doc) {
    String notesCount=doc.healthRecord.notes==null?null:1.toString();
    String voiceNotesCount=doc.healthRecord.voice==null?null:1.toString();
    String rxCount=doc.healthRecord.rx==null?null:1.toString();
    return Row(
      children: [
        iconWithText(
            Constants.Appointments_notesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_notes,
                () {},notesCount),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_voiceNotesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.STR_VOICE_NOTES,
                () {},voiceNotesCount),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_recordsImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_records,
                () {},rxCount),
      ],
    );
  }

  Widget iconWithText(
      String imageText, Color color, String text, onTap, count) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                child: Image.asset(
                  imageText,
                  color: color,
                ),
              ),
              (count == null || count == 0)
                  ? Container()
                  : BadgesBlue(
                backColor: Colors.blue,
                badgeValue: count,
              )
            ],
          ),
          SizedBoxWidget(
            height: 5.0,
          ),
          TextWidget(
            fontsize: 8,
            text: text,
            fontWeight: FontWeight.w400,
            colors: color,
          ),
        ],
      ),
    );
  }

  Widget svgWithText(String imageText, Color color, String text) {
    return Column(
      children: [
        Container(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              imageText,
              color: color,
            )),
        SizedBoxWidget(
          height: 5.0,
        ),
        TextWidget(
          fontsize: 8,
          text: text,
          fontWeight: FontWeight.w400,
          colors: color,
        ),
      ],
    );
  }

  Widget joinCallIcon(doc) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 20,
        width: 70,
        child: OutlineButton(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          borderSide:
          BorderSide(color: Color(new CommonUtil().getMyPrimaryColor())),
          onPressed: () {},
          child: TextWidget(
            text: Constants.Appointments_joinCall,
            colors: Color(new CommonUtil().getMyPrimaryColor()),
            fontsize: 8,
          ),
          color: Color(new CommonUtil().getMyPrimaryColor()),
        ),
      ),
    );
  }

  Widget count(doc) {
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue[200],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(50.0),
            gradient: LinearGradient(
              colors: <Color>[
                Color(new CommonUtil().getMyPrimaryColor()),
                Color(new CommonUtil().getMyGredientColor())
              ],
            )),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        child: TextWidget(
          fontsize: 20,
          text: doc.toString(),
          fontWeight: FontWeight.w600,
          colors: Colors.white,
        ),
      ),
    );
  }

  Widget floatingButton() {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
            width: 2, color: Color(new CommonUtil().getMyPrimaryColor())),
      ),
      elevation: 0.0,
      onPressed: () {},
      child: IconWidget(
        icon: Icons.add,
        colors: Color(new CommonUtil().getMyPrimaryColor()),
        size: 24,
        onTap: () {},
      ),
    );
  }

  Widget title(String text) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: TextWidget(
          text: text,
          colors: Color(CommonUtil().getMyPrimaryColor()),
          overflow: TextOverflow.visible,
          fontWeight: FontWeight.w500,
          fontsize: 14,
          softwrap: true,
        ));
  }
}
