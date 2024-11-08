import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../chat_socket/view/ChatDetail.dart';
import '../../../../constants/fhb_parameters.dart' as parameters;
import '../../../../main.dart';
import '../../../../src/blocs/Category/CategoryListBlock.dart';
import '../../../../src/model/Category/catergory_result.dart';
import '../../../../src/ui/MyRecord.dart';
import '../../../../src/ui/MyRecordsArguments.dart';
import '../../../../src/utils/language/language_utils.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../../styles/styles.dart' as fhbStyles;
import '../../chat/viewModel/ChatViewModel.dart';
import '../constants/appointments_constants.dart' as Constants;
import '../constants/appointments_parameters.dart';
import '../controller/AppointmentDetailsController.dart';
import '../model/cancelAppointments/cancelModel.dart';
import '../model/fetchAppointments/healthRecord.dart';
import '../model/fetchAppointments/past.dart';
import '../viewModel/cancelAppointmentViewModel.dart';
import 'AppointmentDetailScreen.dart';
import 'DoctorTimeSlotWidget.dart';
import 'appointmentsCommonWidget.dart';
import 'resheduleMain.dart';


class DoctorUpcomingAppointments extends StatefulWidget {
  Past? doc;
  String? hour;
  String? minute;
  String? days;
  ValueChanged<String>? onChanged;

  DoctorUpcomingAppointments({super.key, this.doc, this.onChanged});

  @override
  DoctorUpcomingAppointmentState createState() =>
      DoctorUpcomingAppointmentState();
}

class DoctorUpcomingAppointmentState extends State<DoctorUpcomingAppointments> {
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  FlutterToast toast = FlutterToast();
  List<String?> bookingIds = [];
  List<String?> dates = [];

  late CancelAppointmentViewModel cancelAppointmentViewModel;
  SharedPreferences? prefs;
  ChatViewModel chatViewModel = ChatViewModel();
  List<CategoryResult> filteredCategoryData = [];
  CategoryListBlock _categoryListBlock = CategoryListBlock();

  AppointmentDetailsController appointmentDetailsController =
      CommonUtil().onInitAppointmentDetailsController();

  @override
  void initState() {
    cancelAppointmentViewModel =
        Provider.of<CancelAppointmentViewModel>(context, listen: false);
    getCategoryList();
    commonWidget.getCategoryList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          appointmentDetailsController
              .getAppointmentDetail(widget.doc?.id ?? "");
          Get.to(() => AppointmentDetailScreen());
        } catch (e, stackTrace) {
          CommonUtil().appLogs(message: e, stackTrace: stackTrace);

          if (kDebugMode) {
            printError(info: e.toString());
          }
        }
      },
      child: Card(
          color: Colors.white,
          elevation: 0.5,
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonWidget.docPhotoView(widget.doc!),
                              SizedBoxWidget(
                                width: 10.0.w,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      commonWidget.docName(
                                          context,
                                          commonWidget
                                              .getDoctorAndHealthOrganizationName(
                                                  widget.doc!)),
                                      SizedBoxWidget(
                                          height: 3.0.h, width: 0.0.h),
                                      widget.doc!.doctorSessionId == null ||
                                              widget.doc?.doctor
                                                      ?.specialization ==
                                                  null
                                          ? SizedBox.shrink()
                                          : Container(
                                              width: 1.sw / 2,
                                              child: Text(
                                                toBeginningOfSentenceCase((widget
                                                                .doc!
                                                                .doctor!
                                                                .doctorProfessionalDetailCollection !=
                                                            null &&
                                                        widget
                                                                .doc!
                                                                .doctor!
                                                                .doctorProfessionalDetailCollection!
                                                                .length >
                                                            0)
                                                    ? widget
                                                                .doc!
                                                                .doctor!
                                                                .doctorProfessionalDetailCollection![
                                                                    0]
                                                                .specialty !=
                                                            null
                                                        ? widget
                                                                    .doc!
                                                                    .doctor!
                                                                    .doctorProfessionalDetailCollection![
                                                                        0]
                                                                    .specialty!
                                                                    .name !=
                                                                null
                                                            ? widget
                                                                .doc!
                                                                .doctor!
                                                                .doctorProfessionalDetailCollection![
                                                                    0]
                                                                .specialty!
                                                                .name
                                                            : ''
                                                        : ''
                                                    : '')!,
                                                style: TextStyle(
                                                    fontSize: fhbStyles
                                                        .fnt_doc_specialist),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                      widget.doc!.doctorSessionId == null ||
                                              widget.doc?.doctor
                                                      ?.specialization ==
                                                  null
                                          ? SizedBox.shrink()
                                          : SizedBox(height: 3.0),
                                      commonWidget.docLoc(
                                          context,
                                          commonWidget
                                              .getLocation(widget.doc!)),
                                      widget.doc!.doctorSessionId == null ||
                                              widget.doc?.doctor
                                                      ?.specialization ==
                                                  null
                                          ? SizedBox.shrink()
                                          : SizedBox(height: 3.0),
                                      widget.doc!.doctorSessionId == null
                                          ? commonWidget.docLoc(
                                              context,
                                              commonWidget.getServiceCategory(
                                                  widget.doc!))
                                          : SizedBox.shrink(),
                                      widget.doc!.doctorSessionId == null ||
                                              widget.doc?.doctor
                                                      ?.specialization ==
                                                  null
                                          ? SizedBox.shrink()
                                          : SizedBox(height: 3.0),
                                      widget.doc!.doctorSessionId == null
                                          ? commonWidget.docLoc(
                                              context,
                                              commonWidget.getModeOfService(
                                                  widget.doc!))
                                          : SizedBox.shrink(),
                                      SizedBox(height: 5.0),
                                      widget.doc!.doctorSessionId == null
                                          ? SizedBox.shrink()
                                          : DoctorTimeSlotWidget(
                                              doc: widget.doc,
                                              onChanged: widget.onChanged,
                                            ),
                                      SizedBoxWidget(height: 15.0),
                                      widget.doc!.doctorSessionId == null
                                          ? SizedBox.shrink()
                                          : commonWidget.docIcons(
                                              true, widget.doc!, context, () {
                                              widget.onChanged!(
                                                  TranslationConstants.callback
                                                      .t());
                                              setState(() {});
                                            })
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          child: Column(
                            children: [
                              //joinCallIcon(doc),
                              widget.doc!.doctorSessionId == null
                                  ? SizedBox.shrink()
                                  : IconButton(
                                      icon: ImageIcon(AssetImage(
                                          Constants.Appointments_chatImage)),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus!
                                            .unfocus();
                                        goToChatIntegration(widget.doc!);
                                      }),
//                          SizedBoxWidget(
//                            height: (widget.hour == Constants.STATIC_HOUR ||
//                                widget.minute == Constants.STATIC_HOUR)
//                                ? 0
//                                : 15,
//                          ),
                              SizedBoxWidget(
                                height: widget.doc?.doctor?.specialization ==
                                            null ||
                                        widget.doc!.doctorSessionId == null
                                    ? 10
                                    : 20,
                              ),
                              widget.doc!.doctorSessionId == null
                                  ? SizedBox.shrink()
                                  : commonWidget.count(widget.doc!.slotNumber),
                              TextWidget(
                                fontsize: 12.0.sp,
                                text: DateFormat(CommonUtil.REGION_CODE == 'IN'
                                        ? Constants.Appointments_time_format
                                        : Constants.Appointments_time_formatUS)
                                    .format(DateTime.parse(
                                        widget.doc!.plannedStartDateTime!))
                                    .toString(),
                                fontWeight: FontWeight.w600,
                                colors: mAppThemeProvider.primaryColor,
                              ),
                              TextWidget(
                                fontsize: 12.0.sp,
                                text: DateFormat.yMMMEd()
                                    .format(DateTime.parse(
                                        widget.doc!.plannedStartDateTime!))
                                    .toString(),
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.visible,
                                colors: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
              SizedBoxWidget(height: 10.0),
              Container(height: 1, color: Colors.black26),
              widget.doc!.doctorSessionId == null
                  ? SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 67, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          commonWidget.iconWithText(
                              Constants.Appointments_receiptImage,
                              Colors.black38,
                              TranslationConstants.receipt.t(), () {
                            moveToBilsPage(widget.doc!.healthRecord);
                          }, null),
                          SizedBoxWidget(width: 15.0.w),
                          commonWidget.iconWithText(
                              Constants.Appointments_resheduleImage,
                              Colors.black38,
                              TranslationConstants.reschedule.t(), () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            (widget.doc!.status != null &&
                                    widget.doc!.status!.code ==
                                        Constants.PATDNA)
                                ? toast.getToast(
                                    TranslationConstants.dnaAppointment.t(),
                                    Colors.red)
                                : navigateToProviderScreen(widget.doc, true);
                          }, null),
                          SizedBoxWidget(width: 15.0.w),
                          commonWidget.iconWithText(
                              Constants.Appointments_cancelImage,
                              Colors.black38,
                              TranslationConstants.cancel.t(), () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            (widget.doc!.status != null &&
                                    widget.doc!.status!.code ==
                                        Constants.PATDNA)
                                ? toast.getToast(
                                    TranslationConstants.dnaAppointment.t(),
                                    Colors.red)
                                : _displayDialog(context, [widget.doc]);
                          }, null),
                          SizedBoxWidget(width: 15.0.w),
                        ],
                      ),
                    )
            ],
          )),
    );
  }

  void goToChatIntegration(Past doc) {
    //chat integration start
    String? doctorId = doc.doctor!.id;
    String? userId = doc.doctor!.user!.id;
    String? doctorName = doc.doctor!.user!.name;
    String? doctorPic = doc.doctor!.user!.profilePicThumbnailUrl;
    String? chatListId = doc.chatListId;
    String strLastDate = doc.chatMessage!.deliveredOn != null &&
            doc.chatMessage!.deliveredOn != ''
        ? CommonUtil().getFormattedDateTime(doc.chatMessage!.deliveredOn!)
        : '';
    /* chatViewModel.storePatientDetailsToFCM(
        doctorId, doctorName, doctorPic, '', '', '', context, false);*/
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatDetail(
                peerId: userId,
                peerAvatar: doctorPic,
                peerName: doctorName,
                groupId: chatListId,
                patientId: '',
                patientName: '',
                patientPicture: '',
                isFromVideoCall: false,
                isCareGiver: false,
                lastDate: strLastDate)));
  }

  void navigateToProviderScreen(Past? doc, isReshedule) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResheduleMain(
                doc: doc,
                isReshedule: isReshedule,
                isFromFollowUpApp: false,
                isFromNotification: false,
              )),
    ).then((value) => widget.onChanged!(TranslationConstants.callback.t()));
  }

  _displayDialog(BuildContext context, List<Past?> appointments) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: Colors.transparent,
            content: Container(
              width: double.maxFinite,
              height: 250.0,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          height: 160,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextWidget(
                                  text: parameters
                                      .cancellationAppointmentConfirmation,
                                  fontsize: 15.0.sp,
                                  fontWeight: FontWeight.w500,
                                  colors: Colors.grey[600]),
                              widget.doc?.feeDetails == null
                                  ? Container()
                                  : widget.doc?.feeDetails
                                              ?.doctorCancellationCharge ==
                                          null
                                      ? Container()
                                      : RichText(
                                          text: TextSpan(
                                              text: TranslationConstants
                                                  .cancellationCharge
                                                  .t(),
                                              style: TextStyle(
                                                  fontSize: 14.0.sp,
                                                  fontFamily: Constants.poppins,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                              children: <InlineSpan>[
                                              TextSpan(
                                                  text: widget.doc?.feeDetails
                                                              ?.paymentMode ==
                                                          strOFFMODE
                                                      ? ' ${CommonUtil.CURRENCY} 0'
                                                      : ' ${CommonUtil.CURRENCY} ${widget.doc!.feeDetails!.doctorCancellationCharge}',
                                                  style: TextStyle(
                                                      fontSize: 14.0.sp,
                                                      fontFamily:
                                                          Constants.poppins,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: mAppThemeProvider.primaryColor))
                                            ])),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90.0.w,
                                    height: 40.0.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: mAppThemeProvider.primaryColor)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mAppThemeProvider.primaryColor,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                          text: parameters.no,
                                          fontsize: 14.0.sp),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90.0.w,
                                    height: 40.0.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: mAppThemeProvider.primaryColor)),
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: mAppThemeProvider.primaryColor,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context,
                                            getCancelAppoitment(appointments));
                                      },
                                      child: TextWidget(
                                          text: parameters.yes,
                                          fontsize: 14.0.sp),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  getCancelAppoitment(List<Past?> appointments) {
    try {
      cancelAppointment(appointments).then((value) {
        if (value == null) {
          toast.getToast(TranslationConstants.bookingCancel.t(), Colors.red);
        } else if (value.isSuccess == true) {
          widget.onChanged!(TranslationConstants.callback.t());
          toast.getToast(
              TranslationConstants.yourBookingSuccess.t(), Colors.green);
        } else {
          toast.getToast(TranslationConstants.bookingCancel.t(), Colors.red);
        }
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  Future<CancelAppointmentModel?> cancelAppointment(
      List<Past?> appointments) async {
    try {
      for (int i = 0; i < appointments.length; i++) {
        bookingIds.add(appointments[i]!.bookingId);
        dates.add(appointments[i]!.plannedStartDateTime);
      }
      CancelAppointmentModel? cancelAppointment =
          await cancelAppointmentViewModel.fetchCancelAppointment(
              bookingIds, dates);

      return cancelAppointment ?? CancelAppointmentModel();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e);
    }
  }

  void moveToBilsPage(HealthRecord? healthRecord) async {
    List<String> paymentID = [];
    if (healthRecord != null &&
        healthRecord.bills != null &&
        healthRecord.bills!.length > 0) {
      for (int i = 0; i < healthRecord.bills!.length; i++) {
        paymentID.add(healthRecord.bills![i]);
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
              isFromBills: true,
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
    List<CategoryResult>? categoryDataList = [];
    categoryDataList = getCategoryList();
    for (int i = 0;
        i < (categoryDataList == null ? 0 : categoryDataList.length);
        i++) {
      if (categoryName == categoryDataList![i].categoryName) {
        print(categoryName + ' ****' + categoryDataList[i].categoryName!);
        position = i;
      }
    }
    if (categoryName == AppConstants.prescription) {
      return position;
    } else {
      return position;
    }
  }

  List<CategoryResult>? getCategoryList() {
    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock.getCategoryLists().then((value) {
        filteredCategoryData = CommonUtil().fliterCategories(value!.result!);

        //filteredCategoryData.add(categoryDataObjClone);
        return filteredCategoryData;
      });
    } else {
      return filteredCategoryData;
    }
  }
}
