import 'dart:convert';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
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
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_update_success_response.dart';
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
import 'package:myfhb/constants/fhb_constants.dart' as ConstantKey;

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
//              BoxConstraints(maxWidth: 1.sw / 2.5),
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
                  size: 12.0.sp,
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
      fontsize: 10.5.sp,
      //fhbStyles.fnt_doc_specialist,
      softwrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget docLoc(BuildContext context, doc) {
    return Container(
      constraints: BoxConstraints(maxWidth: 1.sw / 2.5),
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

  Widget docIcons(
      bool isUpcoming, Past doc, BuildContext context, Function refresh) {
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
    int healthRecord = doc.healthRecord.associatedRecords == null
        ? 0
        : doc.healthRecord.associatedRecords.length;
    //int otherRecords =  doc.healthRecord.others == null ? 0 : doc.healthRecord.others.length;
    //String rxCount = (healthRecord + otherRecords).toString();
    String rxCount = healthRecord.toString();

    if (int.parse(notesCount) > 0 && doc.healthRecord.notes != null) {
      notesId.add(doc.healthRecord.notes);
    }
    if (int.parse(voiceNotesCount) > 0 && doc.healthRecord.voice != null) {
      voiceIds.add(doc.healthRecord.voice);
    }
    if (int.parse(rxCount) > 0) {
      /* if (otherRecords > 0) {
        recordIds.addAll(doc.healthRecord.others);
      }*/
      if (doc.healthRecord.associatedRecords != null &&
          doc.healthRecord.associatedRecords.length > 0) {
        for (int i = 0; i < doc.healthRecord.associatedRecords.length; i++) {
          if (!recordIds.contains(doc.healthRecord.associatedRecords[i])) {
            recordIds.add(doc.healthRecord.associatedRecords[i]);
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
          int position = await getCategoryPosition(Constants.STR_NOTES);

          await Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => MyRecords(
                argument: MyRecordsArgument(
                    categoryPosition: position,
                    allowSelect: false,
                    isAudioSelect: false,
                    isNotesSelect: isUpcoming ? true : false,
                    selectedMedias: notesId,
                    isFromChat: false,
                    showDetails: false,
                    isAssociateOrChat: isUpcoming ? true : false,
                    fromAppointments: true,
                    fromClass: 'appointments')),
          ))
              .then((results) {
            try {
              if (results.containsKey('selectedResult')) {
                HealthResult metaIds = results['selectedResult'];

                print(metaIds.toString());

                print('*****************88 inside notesId Selected');
                //metaIds = json.decode(results['selectedResult'].cast<HealthResult>());
                //metaIds = json.decode(results['selectedResult']);

                associateUpdateRecords(doc.id, metaIds).then((value) {
                  if (value != null && value.isSuccess) {
                    toast.getToast('Success', Colors.green);
                    refresh();
                  } else {
                    //pr.hide();
                    toast.getToast(parameters.errAssociateRecords, Colors.red);
                  }
                });
              }
            } catch (e) {}
          });
        }, notesCount),
        SizedBoxWidget(width: 15.0.w),
        iconWithText(
            Constants.Appointments_voiceNotesImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.STR_VOICE_NOTES, () async {
          int position = await getCategoryPosition(Constants.STR_VOICERECORDS);

          await Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => MyRecords(
                argument: MyRecordsArgument(
                    categoryPosition: position,
                    allowSelect: false,
                    isAudioSelect: isUpcoming ? true : false,
                    isNotesSelect: false,
                    selectedMedias: voiceIds,
                    isFromChat: false,
                    showDetails: false,
                    isAssociateOrChat: isUpcoming ? true : false,
                    fromAppointments: true,
                    fromClass: 'appointments')),
          ))
              .then((results) {
            try {
              if (results.containsKey('selectedResult')) {
                HealthResult metaIds = results['selectedResult'];

                print(metaIds.toString());

                print('*****************88 inside notesId Selected');
                //metaIds = json.decode(results['selectedResult'].cast<HealthResult>());
                //metaIds = json.decode(results['selectedResult']);

                associateUpdateRecords(doc.id, metaIds).then((value) {
                  if (value != null && value.isSuccess) {
                    toast.getToast('Success', Colors.green);
                    refresh();
                  } else {
                    //pr.hide();
                    toast.getToast(parameters.errAssociateRecords, Colors.red);
                  }
                });
              }
            } catch (e) {}
          });
        }, voiceNotesCount),
        SizedBoxWidget(width: 15.0.w),
        iconWithText(
            Constants.Appointments_recordsImage,
            Color(new CommonUtil().getMyPrimaryColor()),
            Constants.Appointments_records, () async {
          if (rxCount != null /*&& isUpcoming*/) {
            int position =
                await getCategoryPosition(Constants.STR_PRESCRIPTION);

            await Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => MyRecords(
                          argument: MyRecordsArgument(
                              categoryPosition: position,
                              allowSelect: isUpcoming ? true : false,
                              isAudioSelect: false,
                              isNotesSelect: false,
                              selectedMedias: recordIds,
                              isFromChat: false,
                              showDetails: false,
                              isAssociateOrChat: isUpcoming ? true : false,
                              fromClass: 'appointments'),
                        )))
                .then((results) {
              try {
                if (results.containsKey('metaId')) {
                  var metaIds = results['metaId'];
                  print(metaIds.toString());

                  recordIds = results['metaId'].cast<String>();

                  associateRecords(
                          doc.doctor.user.id, doc.bookedFor.id, recordIds)
                      .then((value) {
                    if (value != null && value.isSuccess) {
                      toast.getToast('Success', Colors.green);
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
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 20.0.h,
                width: 20.0.h,
                child: Image.asset(
                  imageText,
                  color: color,
                ),
              ),
              (count == null || count == 0 || count == '' || count == '0')
                  ? Container()
                  : BadgesBlue(
                      backColor: Color(new CommonUtil().getMyPrimaryColor()),
                      badgeValue: count,
                    )
            ],
          ),
          SizedBoxWidget(
            height: 5.0.h,
          ),
          TextWidget(
            fontsize: 10.0.sp,
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
            height: 20.0.h,
            width: 20.0.h,
            child: SvgPicture.asset(
              imageText,
              color: color,
            )),
        SizedBoxWidget(
          height: 5.0.h,
        ),
        TextWidget(
          fontsize: 10.0.sp,
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
        height: 20.0.h,
        width: 70.0.h,
        child: OutlineButton(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          borderSide:
              BorderSide(color: Color(new CommonUtil().getMyPrimaryColor())),
          onPressed: () {},
          child: TextWidget(
            text: Constants.Appointments_joinCall,
            colors: Color(new CommonUtil().getMyPrimaryColor()),
            fontsize: 10.0.sp,
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
              color: Color(new CommonUtil().getMyPrimaryColor()),
              width: 3.0.w,
            ),
            borderRadius: BorderRadius.circular(50.0),
            gradient: LinearGradient(
              colors: <Color>[
                Color(new CommonUtil().getMyPrimaryColor()),
                Color(new CommonUtil().getMyGredientColor())
              ],
            )),
        height: 40.0.h,
        width: 40.0.h,
        alignment: Alignment.center,
        child: TextWidget(
          fontsize: 20.0.sp,
          text: doc.toString(),
          fontWeight: FontWeight.w600,
          colors: Colors.white,
        ),
      ),
    );
  }

  Widget floatingButton(BuildContext context,{bool isHome=false,}) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
            width: 2.0.w, color: Color(new CommonUtil().getMyPrimaryColor())),
      ),
      elevation: 0.0,
      onPressed: () {},
      child: IconWidget(
        icon: Icons.add,
        colors: Color(new CommonUtil().getMyPrimaryColor()),
        size: 24.0.sp,
        onTap: () {
          if(!isHome) {
            Navigator.of(context).pop();
          }
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
          fontsize: 16.0.sp,
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
    List<CategoryResult> categoryDataList = List();
    categoryDataList = getCategoryList();
    for (int i = 0;
        i < (categoryDataList == null ? 0 : categoryDataList.length);
        i++) {
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
    try {
      filteredCategoryData = PreferenceUtil.getCategoryTypeDisplay(
          ConstantKey.KEY_CATEGORYLIST_VISIBLE);
    } catch (e) {}
    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock.getCategoryLists().then((value) {
        filteredCategoryData = new CommonUtil().fliterCategories(value.result);

        //filteredCategoryData.add(categoryDataObjClone);
        return filteredCategoryData;
      });
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
                    : Image.network(doc.doctor.user.profilePicThumbnailUrl,
                        fit: BoxFit.cover,
                        height: 40.0.h,
                        width: 40.0.h, errorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                        return Container(
                          height: 50.0.h,
                          width: 50.0.h,
                          color: Colors.grey[200],
                          child: Center(
                            child: getFirstLastNameText(doc),
                          ),
                        );
                      }),
            color: Color(fhbColors.bgColorContainer),
            height: 50.0.h,
            width: 50.0.h,
          ),
        ));
  }

  Widget getFirstLastNameText(Past doc) {
    if (doc != null &&
        doc.doctor.user.firstName != null &&
        doc.doctor.user.lastName != null) {
      return Text(
        doc.doctor.user.firstName[0].toUpperCase() +
            doc.doctor.user.lastName[0].toUpperCase(),
        style: TextStyle(
          color: Color(new CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (doc != null && doc.doctor.user.firstName != null) {
      return Text(
        doc.doctor.user.firstName[0].toUpperCase(),
        style: TextStyle(
          color: Color(new CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: Color(new CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w200,
        ),
      );
    }
  }

  Future<AssociateUpdateSuccessResponse> associateUpdateRecords(
      String bookingID, HealthResult healthResult) async {
    MyProviderViewModel providerViewModel = new MyProviderViewModel();
    AssociateUpdateSuccessResponse associateResponseList =
        await providerViewModel.associateUpdateRecords(bookingID, healthResult);

    return associateResponseList;
  }
}
