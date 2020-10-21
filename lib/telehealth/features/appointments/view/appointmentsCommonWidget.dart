import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class AppointmentsCommonWidget {
  List<CategoryResult> filteredCategoryData = new List();
  List<CategoryResult> categoryDataList = new List();
  CategoryResult categoryDataObjClone = new CategoryResult();
  CategoryListBlock _categoryListBlock = new CategoryListBlock();

  Widget docName(BuildContext context, doc) {
    return Row(
      children: [
        Container(
//          constraints:
//              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.5),
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

  Widget docIcons(Past doc, BuildContext context, Function refresh) {
    List<String> recordIds = new List();
    List<String> notesId = new List();
    List<String> voiceIds = new List();

    FlutterToast toast = new FlutterToast();

    String notesCount =
        doc.healthRecord.notes == null || doc.healthRecord.notes == ''
            ? 0.toString()
            : 1.toString();
    String voiceNotesCount =
        doc.healthRecord.voice == null || doc.healthRecord.voice == ''
            ? 0.toString()
            : 1.toString();
    int healthRecord = doc.healthRecord.prescription == null
        ? 0
        : doc.healthRecord.prescription.length;
    int otherRecords =
        doc.healthRecord.others == null ? 0 : doc.healthRecord.others.length;
    String rxCount = (healthRecord + otherRecords).toString();

    if (int.parse(notesCount) > 0 && doc.healthRecord.notes != null) {
      notesId.add(doc.healthRecord.notes);
    }
    if (int.parse(voiceNotesCount) > 0 && doc.healthRecord.voice != null) {
      voiceIds.add(doc.healthRecord.voice);
    }
    if (int.parse(rxCount) > 0) {
      if (otherRecords > 0) {
        recordIds.addAll(doc.healthRecord.others);
      }
      if (doc.healthRecord.prescription != null &&
          doc.healthRecord.prescription.length > 0) {
        for (int i = 0; i < doc.healthRecord.prescription.length; i++) {
          if (!recordIds.contains(doc.healthRecord.prescription[i])) {
            recordIds.add(doc.healthRecord.prescription[i]);
          }
        }
      }
    }

    notesCount = notesCount == Constants.ZERO ? '' : notesCount;
    voiceNotesCount = voiceNotesCount == Constants.ZERO ? '' : voiceNotesCount;
    rxCount = rxCount == Constants.ZERO ? '' : rxCount;

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
                  isAssociateOrChat: true),
            ));
          }
        }, voiceNotesCount),
        SizedBoxWidget(width: 15.0),
        iconWithText(
            Constants.Appointments_recordsImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_records, () async {
          if (rxCount != null) {
            await Navigator.of(context)
                .push(MaterialPageRoute(
              builder: (context) => MyRecords(
                  categoryPosition:
                      getCategoryPosition(Constants.STR_PRESCRIPTION),
                  allowSelect: true,
                  isAudioSelect: false,
                  isNotesSelect: false,
                  selectedMedias: recordIds,
                  isFromChat: false,
                  showDetails: false,
                  isAssociateOrChat: true),
            ))
                .then((results) {
              try {
                if (results.containsKey('metaId')) {
                  var metaIds = results['metaId'];
                  print(metaIds.toString());

                  recordIds = results['metaId'].cast<String>();

                  associateRecords(
                          doc.doctor.user.id, doc.bookedBy.id, recordIds)
                      .then((value) {
                    if (value != null && value.isSuccess) {
                      toast.getToast('Sucess', Colors.green);
                      refresh();
                    } else {
                      //pr.hide();
                      toast.getToast(
                          parameters.errAssociateRecords, Colors.red);
                    }
                  });
                }
              } catch (e) {}
            });
          }
        }, rxCount),
      ],
    );
  }

  Future<AssociateSuccessResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    MyProviderViewModel providerViewModel = new MyProviderViewModel();
    AssociateSuccessResponse associateResponseList = await providerViewModel
        .associateRecords(doctorId, userId, healthRecords);

    return associateResponseList;
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

  getCategoryPosition(String categoryName) {
    int categoryPosition = 0;
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
    List<CategoryResult> categoryDataList = getCategoryList();
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

  List<CategoryResult> getCategoryList() {
    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock.getCategoryLists().then((value) {
        filteredCategoryData = new CommonUtil().fliterCategories(value.result);

        //filteredCategoryData.add(categoryDataObjClone);
      });
      return filteredCategoryData;
    } else {
      return filteredCategoryData;
    }
  }

  Widget docPhotoView(Past doc) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFe3e2e2),
                blurRadius: 16,
                // has the effect of softening the shadow
                spreadRadius: 5.0,
                // has the effect of extending the shadow
                offset: Offset(
                  0.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ]),
        child: ClipOval(
          child: Container(
            child: //Container(color: Color(fhbColors.bgColorContainer)),
                doc?.doctor?.user?.profilePicThumbnailUrl == null
                    ? Container(color: Color(fhbColors.bgColorContainer))
                    : Image.network(
                        doc.doctor.user.profilePicThumbnailUrl,
                        fit: BoxFit.cover,
                        height: 40,
                        width: 40,
                      ),
            color: Color(fhbColors.bgColorContainer),
            height: 50,
            width: 50,
          ),
        ));
  }
}
