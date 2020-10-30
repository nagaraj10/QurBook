import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/healthOrganization/HealthOrganization.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/DoctorTimeSlotWidget.dart';
import 'package:myfhb/telehealth/features/appointments/view/appointmentsCommonWidget.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/telehealth/features/appointments/viewModel/cancelAppointmentViewModel.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorUpcomingAppointments extends StatefulWidget {
  Past doc;
  String hour;
  String minute;
  String days;
  ValueChanged<String> onChanged;

  DoctorUpcomingAppointments({this.doc, this.onChanged});

  @override
  DoctorUpcomingAppointmentState createState() =>
      DoctorUpcomingAppointmentState();
}

class DoctorUpcomingAppointmentState extends State<DoctorUpcomingAppointments> {
  AppointmentsCommonWidget commonWidget = AppointmentsCommonWidget();
  FlutterToast toast = new FlutterToast();
  List<String> bookingIds = new List();
  List<String> dates = new List();

  CancelAppointmentViewModel cancelAppointmentViewModel;
  SharedPreferences prefs;
  ChatViewModel chatViewModel = ChatViewModel();
  List<CategoryResult> filteredCategoryData = new List();
  CategoryListBlock _categoryListBlock = new CategoryListBlock();

  @override
  void initState() {
    // TODO: implement initState
    cancelAppointmentViewModel =
        Provider.of<CancelAppointmentViewModel>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 0.5,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonWidget.docPhotoView(widget.doc),
                          SizedBoxWidget(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              commonWidget.docName(
                                  context,
                                  widget.doc.doctor.user.firstName +
                                      ' ' +
                                      widget.doc.doctor.user.lastName),
                              SizedBoxWidget(height: 3.0, width: 0),
                              widget.doc?.doctor?.specialization == null
                                  ? Container()
                                  : Text((widget.doc.doctor.doctorProfessionalDetailCollection !=
                                              null &&
                                          widget
                                                  .doc
                                                  .doctor
                                                  .doctorProfessionalDetailCollection
                                                  .length >
                                              0)
                                      ? widget.doc.doctor.doctorProfessionalDetailCollection[0].specialty != null
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
                                                  .doctorProfessionalDetailCollection[0]
                                                  .specialty
                                                  .name
                                              : ''
                                          : ''
                                      : ''),
                              widget.doc.doctor.specialization == null
                                  ? Container()
                                  : SizedBox(height: 3.0),
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
                              SizedBox(height: 5.0),
                              DoctorTimeSlotWidget(
                                doc: widget.doc,
                                onChanged: widget.onChanged,
                              ),
                              SizedBoxWidget(height: 15.0),
                              commonWidget.docIcons(true, widget.doc, context,
                                  () {
                                widget.onChanged(Constants.callBack);
                                setState(() {});
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          //joinCallIcon(doc),
                          IconButton(
                              icon: ImageIcon(
                                  AssetImage(Constants.Appointments_chatImage)),
                              onPressed: () {
                                goToChatIntegration(widget.doc);
                              }),
//                          SizedBoxWidget(
//                            height: (widget.hour == Constants.STATIC_HOUR ||
//                                widget.minute == Constants.STATIC_HOUR)
//                                ? 0
//                                : 15,
//                          ),
                          SizedBoxWidget(
                            height: widget.doc?.doctor?.specialization == null
                                ? 10
                                : 20,
                          ),
                          commonWidget.count(widget.doc.slotNumber),
                          TextWidget(
                            fontsize: 10,
                            text: DateFormat(Constants.Appointments_time_format)
                                    .format(DateTime.parse(
                                        widget.doc.plannedStartDateTime))
                                    .toString() ??
                                '',
                            fontWeight: FontWeight.w600,
                            colors: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                          TextWidget(
                            fontsize: 10,
                            text: DateFormat.yMMMEd()
                                    .format(DateTime.parse(
                                        widget.doc.plannedStartDateTime))
                                    .toString() ??
                                '',
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.visible,
                            colors: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBoxWidget(height: 10.0),
            Container(height: 1, color: Colors.black26),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 67, top: 10, bottom: 10),
              child: Row(
                children: [
                  commonWidget.iconWithText(Constants.Appointments_receiptImage,
                      Colors.black38, Constants.Appointments_receipt, () {
                    moveToBilsPage(widget.doc.healthRecord);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(
                      Constants.Appointments_resheduleImage,
                      Colors.black38,
                      Constants.Appointments_reshedule, () {
                    (widget.doc.status != null &&
                        widget.doc.status.code == Constants.PATDNA)
                        ? toast.getToast(Constants.DNA_APPOINTMENT, Colors.red)
                        : navigateToProviderScreen(widget.doc, true);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                  commonWidget.iconWithText(Constants.Appointments_cancelImage,
                      Colors.black38, Constants.Appointments_cancel, () {
                        (widget.doc.status != null &&
                            widget.doc.status.code == Constants.PATDNA)
                            ? toast.getToast(Constants.DNA_APPOINTMENT, Colors.red)
                        : _displayDialog(context, [widget.doc]);
                  }, null),
                  SizedBoxWidget(width: 15.0),
                ],
              ),
            )
          ],
        ));
  }

  void goToChatIntegration(Past doc) {
    //chat integration start
    String doctorId = doc.doctor.id;
    String doctorName = doc.doctor.user.name;
    String doctorPic = doc.doctor.user.profilePicThumbnailUrl;
    chatViewModel.storePatientDetailsToFCM(
        doctorId, doctorName, doctorPic, context);
  }

  void navigateToProviderScreen(Past doc, isReshedule) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResheduleMain(
                doc: doc,
                isReshedule: isReshedule,
              )),
    ).then((value) => widget.onChanged(Constants.callBack));
  }

  _displayDialog(BuildContext context, List<Past> appointments) async {
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
                            children: <Widget>[
                              TextWidget(
                                  text: parameters
                                      .cancellationAppointmentConfirmation,
                                  fontsize: 14,
                                  fontWeight: FontWeight.w500,
                                  colors: Colors.grey[600]),
                              SizedBoxWidget(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(color: Colors.grey)),
                                      color: Colors.transparent,
                                      textColor: Colors.grey,
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                          text: parameters.no, fontsize: 12),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: Colors.blue[800])),
                                      color: Colors.transparent,
                                      textColor: Colors.blue[800],
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context,
                                            getCancelAppoitment(appointments));
                                      },
                                      child: TextWidget(
                                          text: parameters.yes, fontsize: 12),
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

  getCancelAppoitment(List<Past> appointments) {
    cancelAppointment(appointments).then((value) {
      if (value == null) {
        toast.getToast(Constants.BOOKING_CANCEL, Colors.red);
      } else if (value.isSuccess == true) {
        widget.onChanged(Constants.callBack);
        toast.getToast(Constants.YOUR_BOOKING_SUCCESS, Colors.green);
      } else {
        toast.getToast(Constants.BOOKING_CANCEL, Colors.red);
      }
    });
  }

  Future<CancelAppointmentModel> cancelAppointment(
      List<Past> appointments) async {
    for (int i = 0; i < appointments.length; i++) {
      bookingIds.add(appointments[i].bookingId);
      dates.add(appointments[i].plannedStartDateTime);
    }
    CancelAppointmentModel cancelAppointment = await cancelAppointmentViewModel
        .fetchCancelAppointment(bookingIds, dates);

    return cancelAppointment;
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
    int position = getCategoryPosition(Constants.STR_BILLS);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MyRecords(
          categoryPosition: position,
          allowSelect: true,
          isAudioSelect: false,
          isNotesSelect: false,
          selectedMedias: paymentID,
          isFromChat: false,
          showDetails: true,
          isAssociateOrChat: false),
    ));
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
        return filteredCategoryData;
      });
    } else {
      return filteredCategoryData;
    }
  }
}
