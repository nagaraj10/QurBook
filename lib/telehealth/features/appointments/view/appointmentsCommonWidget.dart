import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';

class AppointmentsCommonWidget {
  List<CategoryData> filteredCategoryData = new List();
  List<CategoryData> categoryDataList = new List();
  CategoryData categoryDataObjClone = new CategoryData();

  Widget docName(BuildContext context, doc) {
    return Row(
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
          child: Row(
            children: [
              TextWidget(
                text: toBeginningOfSentenceCase(doc == null ? '' : doc),
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
    return TextWidget(
      text: doc == null ? '' : doc,
      colors: Colors.black26,
      fontsize: 10.5,
      //fhbStyles.fnt_doc_specialist,
      softwrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget docLoc(BuildContext context, doc) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
      child: TextWidget(
        text: doc == null ? '' : doc,
        overflow: TextOverflow.ellipsis,
        softwrap: false,
        fontWeight: FontWeight.w200,
        colors: Colors.black87,
        fontsize: fhbStyles.fnt_city,
      ),
    );
  }

  Widget docTimeSlot(BuildContext context, History doc, hour, minute, daysNum) {
    return daysNum != '0' && daysNum != null
        ? TextWidget(
            fontsize: 10,
            text: daysNum + ' days',
            fontWeight: FontWeight.w500,
            colors: Colors.black,
          )
        : ((hour == '00' && minute == '00') || hour == null || minute == null)
//        ||
//                hour.length == 0 ||
//                minute.length == 0)
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

  Widget docIcons(History doc, BuildContext context) {
    List<String> recordIds = new List();
    List<String> notesId = new List();
    List<String> voiceIds = new List();
//    print(doc.healthRecord);

    print(doc.bookingId);
    String notesCount =
        doc.healthRecord.notes == null ? 0.toString() : 1.toString();
    String voiceNotesCount =
        doc.healthRecord.voice == null ? 0.toString() : 1.toString();
    int healthRecord = doc.healthRecord.prescription == null
        ? 0
        : doc.healthRecord.prescription.length;
    int otherRecords =
        doc.healthRecord.others == null ? 0 : doc.healthRecord.others.length;
    String rxCount = (healthRecord + otherRecords).toString();

    if (int.parse(notesCount) > 0 && doc.healthRecord.notes != null) {
      notesId.add(doc.healthRecord.notes.mediaMetaId);
      print('notesId' + doc.healthRecord.notes.mediaMetaId);
    }
    if (int.parse(voiceNotesCount) > 0 && doc.healthRecord.voice != null) {
      voiceIds.add(doc.healthRecord.voice.mediaMetaId);
      print('voiceIds' + doc.healthRecord.voice.mediaMetaId);
    }
    if (int.parse(rxCount) > 0) {
      if (otherRecords > 0) {
        recordIds.addAll(doc.healthRecord.others);
        print('others******' + doc.healthRecord.others.toString());
      }
      if (doc.healthRecord.prescription != null &&
          doc.healthRecord.prescription.length > 0) {
        for (int i = 0; i < doc.healthRecord.prescription.length; i++) {
          if (!recordIds
              .contains(doc.healthRecord.prescription[i].mediaMetaId)) {
            recordIds.add(doc.healthRecord.prescription[i].mediaMetaId);

            print('RECORDID' + doc.healthRecord.prescription[i].mediaMetaId);
          }
        }
      }
    }

    notesCount = notesCount == '0' ? '' : notesCount;
    voiceNotesCount = voiceNotesCount == '0' ? '' : voiceNotesCount;
    rxCount = rxCount == '0' ? '' : rxCount;

//    print(notesCount + '****** ' + voiceNotesCount + '****' + rxCount);
    return Row(
      children: [
        iconWithText(
            Constants.Appointments_notesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_notes, () async {
          if (notesCount != '') {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyRecords(
                categoryPosition: getCategoryPosition(Constants.STR_NOTES),
                allowSelect: false,
                isAudioSelect: false,
                isNotesSelect: true,
                selectedMedias: notesId,
                isFromChat: false,
                showDetails: true,
              ),
            ));
          }
        }, notesCount),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_voiceNotesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.STR_VOICE_NOTES, () async {
          if (voiceNotesCount != '') {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyRecords(
                categoryPosition:
                    getCategoryPosition(Constants.STR_VOICERECORDS),
                allowSelect: false,
                isAudioSelect: true,
                isNotesSelect: true,
                selectedMedias: voiceIds,
                isFromChat: false,
                showDetails: true,
              ),
            ));
          }
        }, voiceNotesCount),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_recordsImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_records, () async {
          if (rxCount != null) {
            print(recordIds.toString() + '***********************');
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyRecords(
                categoryPosition:
                    getCategoryPosition(Constants.STR_PRESCRIPTION),
                allowSelect: true,
                isAudioSelect: false,
                isNotesSelect: false,
                selectedMedias: recordIds,
                isFromChat: false,
                showDetails: true,
              ),
            ));
          }
        }, rxCount),
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
              (count == null || count == 0 || count == '')
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

  Widget floatingButton(BuildContext context) {
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
        onTap: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            '/telehealth-providers',
            arguments: HomeScreenArguments(selectedIndex: 1),
          ).then((value) {});
        },
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

  List<CategoryData> getCategoryList() {
    CategoryListBlock _categoryListBlock = new CategoryListBlock();

    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock.getCategoryList().then((value) {
        categoryDataList = value.response.data;

        filteredCategoryData =
            new CommonUtil().fliterCategories(categoryDataList);

        filteredCategoryData.add(categoryDataObjClone);
      });
      return filteredCategoryData;
    } else {
      return filteredCategoryData;
    }
  }

  getCategoryPosition(String categoryName) {
    int categoryPosition;
    switch (categoryName) {
      case Constants.STR_NOTES:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case Constants.STR_PRESCRIPTION:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case Constants.STR_VOICERECORDS:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case Constants.STR_BILLS:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;
      default:
        categoryPosition = 0;
        return categoryPosition;

        break;
    }
  }

  int pickPosition(String categoryName) {
    int position = 0;
    List<CategoryData> categoryDataList = getCategoryList();
    for (int i = 0; i < categoryDataList.length; i++) {
      if (categoryName == categoryDataList[i].categoryName) {
        print(categoryName + ' ****' + categoryDataList[i].categoryName);
        position = i;
      }
    }
    if (categoryName == Constants.STR_PRESCRIPTION) {
      return position;
    } else {
      return position;
    }
  }
}
