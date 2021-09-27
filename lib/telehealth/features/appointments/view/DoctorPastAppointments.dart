import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/utils/language/language_utils.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/appointments/viewModel/appointmentsListViewModel.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorPastAppointments extends StatefulWidget {
  Past doc;
  ValueChanged<String> onChanged;
  Function(String) closePage;

  DoctorPastAppointments({this.doc, this.onChanged, this.closePage});

  @override
  DoctorPastAppointmentState createState() => DoctorPastAppointmentState();
}

class DoctorPastAppointmentState extends State<DoctorPastAppointments> {
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  CommonWidgets providerCommonWidget = CommonWidgets();
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = new List();
  AppointmentsListViewModel appointmentsViewModel;
  SharedPreferences prefs;
  ChatViewModel chatViewModel = ChatViewModel();
  List<CategoryResult> filteredCategoryData = new List();
  CategoryListBlock _categoryListBlock = new CategoryListBlock();

  @override
  void initState() {
    // TODO: implement initState
    appointmentsViewModel =
        Provider.of<AppointmentsListViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return doctorsHistoryListCard(widget.doc);
  }

  Widget doctorsHistoryListCard(Past doc) {
    List<String> recordIds = new List();
    if (doc.healthRecord.prescription != null &&
        doc.healthRecord.prescription.length > 0) {
      for (int i = 0; i < doc.healthRecord.prescription.length; i++) {
        if (!recordIds.contains(doc.healthRecord.prescription[i])) {
          recordIds.add(doc.healthRecord.prescription[i]);
        }
      }
    }
    int healthRecord = (recordIds.length > 0) ? recordIds.length : 0;
    return Card(
        color: Colors.white,
        elevation: 0.5,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonWidget.docPhotoView(doc),
                        SizedBoxWidget(
                          width: 10.0.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            commonWidget.docName(
                                context,
                                widget?.doc?.doctor?.user?.firstName
                                        ?.capitalizeFirstofEach +
                                    ' ' +
                                    widget?.doc?.doctor?.user?.lastName
                                        ?.capitalizeFirstofEach),
                            SizedBoxWidget(height: 3.0.h, width: 0.0.h),
                            widget.doc?.doctor?.specialization == null
                                ? Container()
                                : Container(
                                    width: 1.sw / 2,
                                    child: Text(
                                      toBeginningOfSentenceCase((widget
                                                      .doc
                                                      .doctor
                                                      .doctorProfessionalDetailCollection !=
                                                  null &&
                                              widget
                                                      .doc
                                                      .doctor
                                                      .doctorProfessionalDetailCollection
                                                      .length >
                                                  0)
                                          ? widget
                                                      .doc
                                                      .doctor
                                                      .doctorProfessionalDetailCollection[
                                                          0]
                                                      .specialty !=
                                                  null
                                              ? widget
                                                          .doc
                                                          .doctor
                                                          .doctorProfessionalDetailCollection[
                                                              0]
                                                          .specialty
                                                          .name !=
                                                      null
                                                  ? widget
                                                      .doc
                                                      .doctor
                                                      .doctorProfessionalDetailCollection[
                                                          0]
                                                      .specialty
                                                      .name
                                                  : ''
                                              : ''
                                          : ''),
                                      style: TextStyle(
                                          fontSize:
                                              fhbStyles.fnt_doc_specialist),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                            widget.doc.doctor.specialization == null
                                ? Container()
                                : SizedBox(height: 3.0.h),
                            commonWidget.docLoc(
                                context,
                                widget
                                        .doc
                                        ?.doctor
                                        ?.user
                                        ?.userAddressCollection3[0]
                                        ?.city
                                        ?.name ??
                                    ''),
                            SizedBoxWidget(height: 5.0.h),
                            SizedBoxWidget(height: 15.0.h),
                            commonWidget.docIcons(false, doc, context, () {})
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          //joinCallIcon(doc),
                          SizedBoxWidget(
                            height: widget.doc?.doctor?.specialization == null
                                ? 30.0.h
                                : 40.0.h,
                          ),
                          commonWidget.count(doc.slotNumber),
                          doc.plannedFollowupDate == null
                              ? TextWidget(
                                  fontsize: 12.0.sp,
                                  text: doc.plannedStartDateTime == null
                                      ? ''
                                      : DateFormat(Constants
                                                  .Appointments_time_format)
                                              .format(DateTime.parse(
                                                  doc.plannedStartDateTime))
                                              .toString() ??
                                          '',
                                  fontWeight: FontWeight.w600,
                                  colors: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                )
                              : TextWidget(
                                  fontsize: 11.0.sp,
                                  text: TranslationConstants.nextFollowUpOn.t(),
                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w400,
                                  colors: Colors.black38,
                                ),
                          TextWidget(
                            fontsize: 12.0.sp,
                            text: doc.plannedFollowupDate == null
                                ? doc.plannedStartDateTime == null
                                    ? ""
                                    : DateFormat.yMMMEd()
                                            .format(DateTime.parse(
                                                doc.plannedStartDateTime))
                                            .toString() ??
                                        ''
                                : DateFormat.yMMMEd()
                                        .format(DateTime.parse(
                                            doc.plannedFollowupDate))
                                        .toString() ??
                                    '',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.visible,
                            colors: Colors.black,
                          ),
                          TextWidget(
                            fontsize: 15.0.sp,
                            text: doc.plannedFollowupDate == null
                                ? ''
                                : '${CommonUtil.CURRENCY}' +
                                        providerCommonWidget.getMoneyWithForamt(
                                            doc.doctorFollowUpFee) ??
                                    '',
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.visible,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBoxWidget(height: 5.0.h),
            Container(height: 1.0.h, color: Colors.black26),
//            SizedBoxWidget(height: 10.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 60, top: 10, bottom: 10),
              child: Row(
                children: [
                  commonWidget.iconWithText(Constants.Appointments_chatImage,
                      Colors.black38, TranslationConstants.chats.t(), () {
                    FocusManager.instance.primaryFocus.unfocus();
                    goToChatIntegration(doc);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  /*commonWidget.iconWithText(
                      Constants.Appointments_prescriptionImage,
                      Colors.black38,
                      AppConstants.prescription,
                      () {},
                      null),*/
                  commonWidget.iconWithText(
                      Constants.Appointments_prescriptionImage,
                      Colors.black38,
                      AppConstants.prescription, () async {
                    FocusManager.instance.primaryFocus.unfocus();
                    if (healthRecord > 0) {
                      int position =
                          getCategoryPosition(AppConstants.prescription);

                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyRecords(
                            argument: MyRecordsArgument(
                                categoryPosition: position,
                                allowSelect: false,
                                isAudioSelect: false,
                                isNotesSelect: true,
                                selectedMedias: recordIds,
                                isFromChat: false,
                                showDetails: true,
                                isAssociateOrChat: false,
                                fromClass: 'appointments')),
                      ));
                    }
                  }, healthRecord.toString()),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, TranslationConstants.receipt.t(), () {
                    FocusManager.instance.primaryFocus.unfocus();
                    moveToBilsPage(doc.healthRecord);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus.unfocus();
                      navigateToProviderScreen(doc, false);
                    },
                    child: commonWidget.svgWithText(
                        Constants.Appointments_newAppoinmentImage,
                        Colors.black38,
                        TranslationConstants.newAppointment.t()),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void navigateToProviderScreen(doc, isReshedule) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResheduleMain(
                isFromNotification: false,
                doc: doc,
                isReshedule: isReshedule,
                isFromFollowUpApp: getFollowup(doc),
                closePage: (value) {
                  widget.closePage(value);
                },
              )),
    );
  }

  bool getFollowup(Past doc) {
    bool status = false;

    if (doc != null && doc != '') {
      if (doc?.plannedFollowupDate != null && doc?.plannedFollowupDate != '') {
        status = true;
      } else {
        status = false;
      }
    } else {
      status = false;
    }

    return status;
  }

  void goToChatIntegration(Past doc) {
    //chat integration start
    String doctorId = doc.doctor.id;
    String doctorName = doc.doctor.user.name;
    String doctorPic = doc.doctor.user.profilePicThumbnailUrl;
    chatViewModel.storePatientDetailsToFCM(
        doctorId, doctorName, doctorPic, '', '', '', context, false);
  }

  void moveToBilsPage(HealthRecord healthRecord) async {
    List<String> paymentID = new List();
    if (healthRecord != null &&
        healthRecord.bills != null &&
        healthRecord.bills.length > 0) {
      for (int i = 0; i < healthRecord.bills.length; i++) {
        paymentID.add(healthRecord.bills[i]);
      }
    }
    int position = getCategoryPosition(AppConstants.bills);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MyRecords(
          argument: MyRecordsArgument(
              categoryPosition: position,
              allowSelect: true,
              isAudioSelect: false,
              isNotesSelect: false,
              selectedMedias: paymentID,
              isFromChat: false,
              showDetails: true,
              isAssociateOrChat: false,
              fromClass: 'appointments')),
    ));
  }

  getCategoryPosition(String categoryName) {
    int categoryPosition;
    switch (categoryName) {
      case AppConstants.notes:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case AppConstants.prescription:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case AppConstants.voiceRecords:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;
      case AppConstants.bills:
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
    if (categoryName == AppConstants.prescription) {
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
        return filteredCategoryData;
      });
    } else {
      return filteredCategoryData;
    }
  }
}
