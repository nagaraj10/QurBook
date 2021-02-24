import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/FlutterToast.dart';
import 'package:gmiwidgetspackage/widgets/IconButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';

import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorsFromHospitalModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/associaterecords/associate_success_response.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/getAvailableSlots/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/CreateAppointmentViewModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/Payment/PaymentPage.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BookingConfirmation extends StatefulWidget {
  final followUpFee;
  bool isNewAppointment;
  final List<Doctors> docs;
  final int i;
  final int doctorListIndex;
  final DateTime selectedDate;
  final List<SlotSessionsModel> sessionData;
  final int rowPosition;
  final int itemPosition;
  final bool isFollowUp;
  Past doctorsData;
  final List<HealthOrganizationResult> healthOrganizationResult;
  final List<ResultFromHospital> resultFromHospitalList;
  final int doctorListPos;
  Function(String) closePage;
  Function() refresh;
  bool isFromHospital;

  BookingConfirmation(
      {this.docs,
      this.i,
      this.doctorListIndex,
      this.selectedDate,
      this.sessionData,
      this.rowPosition,
      this.followUpFee,
      this.itemPosition,
      this.isNewAppointment,
      this.isFollowUp,
      this.doctorsData,
      this.healthOrganizationResult,
      this.resultFromHospitalList,
      this.doctorListPos,
      this.closePage,
      this.refresh,
      this.isFromHospital});

  @override
  BookingConfirmationState createState() => BookingConfirmationState();
}

class BookingConfirmationState extends State<BookingConfirmation> {
  CommonWidgets commonWidgets = new CommonWidgets();
  CommonUtil commonUtil = new CommonUtil();
  MyProviderViewModel providerViewModel;
  CreateAppointMentViewModel createAppointMentViewModel;
  FamilyListBloc _familyListBloc;
  FamilyMembers familyMembersModel = new FamilyMembers();
  List<SharedByUsers> sharedbyme = new List();
  FlutterToast toast = new FlutterToast();
  FamilyMembers familyData = new FamilyMembers();

  List<SharedByUsers> _familyNames = new List();

  /* List<String> recordIds = new List();
  List<String> notesId = new List();
  List<String> voiceIds = new List();*/

  List<String> healthRecords = new List();

  int recordIdCount = 0;
  int notesIdCount = 0;
  int voiceIdCount = 0;

  String slotNumber = '',
      slotTime = '',
      createdBy = '',
      createdFor = '',
      doctorSessionId = '',
      scheduleDate = '',
      fees = '';
  String apiStartTime = '', apiEndTime = '';
  SharedByUsers selectedUser;
  var selectedId = '';
  ProgressDialog pr;

  CategoryListBlock _categoryListBlock;

  List<CategoryResult> categoryDataList = new List();
  List<CategoryResult> filteredCategoryData = new List();
  CategoryResult categoryDataObjClone = new CategoryResult();

  String doctorId;

  @override
  void initState() {
    providerViewModel = new MyProviderViewModel();
    createAppointMentViewModel = new CreateAppointMentViewModel();
    createdBy = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    selectedId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersListNew();

    _categoryListBlock = null;
    _categoryListBlock = new CategoryListBlock();

    getCategoryList();
    getDataFromWidget();
    setLengthValue();
  }

  addHealthRecords() {
    healthRecords.addAll(CommonUtil.recordIds);
    healthRecords.addAll(CommonUtil.notesId);
    healthRecords.addAll(CommonUtil.voiceIds);
  }

  clearAttachedRecords() {
    CommonUtil.recordIds.clear();
    CommonUtil.notesId.clear();
    CommonUtil.voiceIds.clear();
    voiceIdCount = 0;
    recordIdCount = 0;
    notesIdCount = 0;
  }

  Future<FamilyMembers> getList() async {
    _familyListBloc.getFamilyMembersListNew().then((familyMembersList) {
      familyMembersModel = familyMembersList;

      for (int i = 0; i < familyMembersModel.result.sharedByUsers.length; i++) {
        sharedbyme.add(familyMembersModel.result.sharedByUsers[i]);
      }
    });

    return familyMembersModel;
  }

  getDataFromWidget() {
    slotTime = commonUtil.removeLastThreeDigits(widget
        .sessionData[widget.rowPosition].slots[widget.itemPosition].startTime);
    apiStartTime = widget
        .sessionData[widget.rowPosition].slots[widget.itemPosition].startTime;
    apiEndTime = widget
        .sessionData[widget.rowPosition].slots[widget.itemPosition].endTime;
    slotNumber = widget
        .sessionData[widget.rowPosition].slots[widget.itemPosition].slotNumber
        .toString();
    doctorSessionId = widget.sessionData[widget.rowPosition].doctorSessionId;
    scheduleDate =
        commonUtil.dateConversionToApiFormat(widget.selectedDate).toString();

    doctorId = widget.isFromHospital
        ? widget.resultFromHospitalList[widget.doctorListIndex].doctor.user.id
        : widget.docs[widget.doctorListPos].user.id;
  }

  Widget getDropdown() {
    return StreamBuilder<ApiResponse<FamilyMembers>>(
      stream: _familyListBloc.familyMemberListNewStream,
      builder: (context, AsyncSnapshot<ApiResponse<FamilyMembers>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: SizedBox(
                  child: CircularProgressIndicator(
                    backgroundColor:
                        Color(new CommonUtil().getMyPrimaryColor()),
                  ),
                  width: 30,
                  height: 30,
                )),
              );
              break;

            case Status.ERROR:
              return FHBBasicWidget.getRefreshContainerButton(
                  snapshot.data.message, () {
                setState(() {});
              });
              break;

            case Status.COMPLETED:
              //_healthReportListForUserBlock = null;
              print(snapshot.data.toString());
              if (snapshot.data.data.result != null) {
                familyData = snapshot.data.data;
              }

              return dropDownButton(snapshot.data.data.result != null
                  ? snapshot.data.data.result.sharedByUsers
                  : null);
              break;
          }
        } else {
          return Container(height: 0, color: Colors.white);
        }
      },
    );
  }

  Widget dropDownButton(List<SharedByUsers> sharedByMeList) {
    MyProfileModel myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile.result != null
          ? myProfile.result.firstName + ' ' + myProfile.result.lastName
          : '';
    } catch (e) {}

    if (sharedByMeList == null) {
      sharedByMeList = new List();
      sharedByMeList
          .add(new SharedByUsers(id: myProfile.result.id, nickName: 'Self'));
    } else {
      sharedByMeList.insert(
          0, new SharedByUsers(id: myProfile.result.id, nickName: 'Self'));
    }
    if (_familyNames.length == 0) {
      for (int i = 0; i < sharedByMeList.length; i++) {
        _familyNames.add(sharedByMeList[i]);
      }
    }

    if (_familyNames.length > 0) {
      for (SharedByUsers sharedByUsers in _familyNames) {
        if (sharedByUsers != null) {
          if (sharedByUsers.child != null) {
            if (sharedByUsers.child.id == selectedId) {
              selectedUser = sharedByUsers;
            }
          }
        }
      }
    }

    return SizedBoxWithChild(
      height: 30,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButton<SharedByUsers>(
          value: selectedUser,
          underline: SizedBox(),
          isExpanded: true,
          hint: Row(
            children: <Widget>[
              SizedBoxWidget(width: 20),
              Text(parameters.self, style: TextStyle(fontSize: 12)),
            ],
          ),
          items: _familyNames
              .map((SharedByUsers user) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        SizedBoxWidget(width: 20),
                        Text(user.nickName == null ? 'Self' : user.nickName,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    value: user,
                  ))
              .toList(),
          onChanged: (SharedByUsers user) {
            setState(() {
              if (selectedUser != user) {
                clearAttachedRecords();
              }
              selectedUser = user;
              if (user.child != null) {
                if (user.child.id != null) {
                  selectedId = user.child.id;
                }
              } else {
                selectedId = createdBy;
              }
            });
          },
        ),
      ),
    );
  }

  Widget nameDateCard() {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
      child: Column(
        children: <Widget>[
          SizedBoxWidget(
            height: 10.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(parameters.theAppointmentIsFor,
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          SizedBoxWidget(
            height: 8.0,
          ),
          getDropdown(),
          SizedBoxWidget(
            height: 10.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                TextWidget(
                  text: parameters.dateAndTime,
                  fontsize: 10,
                  colors: Colors.grey,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    commonWidgets.getIcon(
                        width: fhbStyles.imageWidth,
                        height: fhbStyles.imageHeight,
                        icon: Icons.mode_edit,
                        onTap: () {
                          Navigator.pop(context);
                          widget.refresh();
                        }),
                    SizedBoxWidget(
                      width: 10.0,
                    ),
                    TextWidget(
                      text: widget.selectedDate != null
                          ? commonUtil
                              .dateConversionToDayMonthYear(widget.selectedDate)
                              .toString()
                          : '',
                      fontsize: 12,
                    ),
                    SizedBoxWidget(
                      width: 5.0,
                    ),
                    TextWidget(
                      text: slotTime != null ? slotTime : '0.00',
                      fontsize: 12,
                    ),
                  ],
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(
                        new CommonUtil().getMyPrimaryColor()), // border color
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2), // border width
                    child: Container(
                      // or ClipRRect if you need to clip the content
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(new CommonUtil()
                            .getMyPrimaryColor()), // inner circle color
                      ),
                      child: Center(
                        child: TextWidget(
                            text: slotNumber != null ? slotNumber : '0',
                            fontsize: 18,
                            fontWeight: FontWeight.w900,
                            colors: Colors.white),
                      ), // inner content
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: checkSlots,
        borderRadius: 6.0,
        backgroundColor: Colors.white,
        progressWidget: SizedBoxWithChild(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
                strokeWidth: 2.0,
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()))),
        elevation: 6.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600));

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        widget.refresh();
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: GestureDetector(
            onTap: () {
              widget.refresh();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
            ),
          ),
          title: getTitle(parameters.confirmDetails),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[100],
                child: Card(
                  margin: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 10.0,
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: getDoctorsWidget(),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    nameDateCard(),
                    new Divider(
                      color: Colors.grey[400],
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(parameters.preConsultingDetails,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          SizedBoxWidget(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBoxWidget(
                                width: 10,
                              ),
                              Column(
                                children: <Widget>[
                                  new Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      SizedBoxWithChild(
                                        height: 22.0,
                                        width: 22.0,
                                        child: IconButtonWidget(
                                          iconPath: Constants.NOTES_ICON_LINK,
                                          size: 18.0,
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          padding: new EdgeInsets.all(1.0),
                                          onPressed: () {
                                            FetchRecords(
                                                getCategoryPosition(
                                                    Constants.STR_NOTES),
                                                false,
                                                false,
                                                true,
                                                CommonUtil.notesId);
                                          },
                                        ),
                                      ),
                                      notesIdCount > 0
                                          ? Positioned(
                                              top: -5.0,
                                              right: -5.0,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBoxWidget(height: 2.0),
                                  TextWidget(
                                      text: parameters.addNotes,
                                      fontsize: 8.0,
                                      colors: Colors.grey),
                                ],
                              ),
                              SizedBoxWidget(
                                width: 25,
                              ),
                              Column(
                                children: <Widget>[
                                  new Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      SizedBoxWithChild(
                                        height: 22.0,
                                        width: 22.0,
                                        child: IconButtonWidget(
                                          iconPath: Constants.VOICE_ICON_LINK,
                                          size: 18.0,
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          padding: new EdgeInsets.all(1.0),
                                          onPressed: () {
                                            FetchRecords(
                                                getCategoryPosition(
                                                    Constants.STR_VOICERECORDS),
                                                false,
                                                true,
                                                false,
                                                CommonUtil.voiceIds);
                                          },
                                        ),
                                      ),
                                      voiceIdCount > 0
                                          ? Positioned(
                                              top: -5.0,
                                              right: -5.0,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBoxWidget(height: 2.0),
                                  TextWidget(
                                      text: parameters.addVoice,
                                      fontsize: 8.0,
                                      colors: Colors.grey),
                                ],
                              ),
                              SizedBoxWidget(
                                width: 25,
                              ),
                              Column(
                                children: <Widget>[
                                  new Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      SizedBoxWithChild(
                                        height: 22.0,
                                        width: 22.0,
                                        child: IconButtonWidget(
                                          iconPath: Constants.RECORDS_ICON_LINK,
                                          size: 18.0,
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          padding: new EdgeInsets.all(1.0),
                                          onPressed: () {
                                            FetchRecords(
                                                getCategoryPosition(
                                                    Constants.STR_PRESCRIPTION),
                                                true,
                                                false,
                                                false,
                                                CommonUtil.recordIds);
                                          },
                                        ),
                                      ),
                                      recordIdCount > 0
                                          ? BadgesBlue(
                                              badgeValue:
                                                  recordIdCount.toString(),
                                              backColor: Color(commonUtil
                                                  .getMyPrimaryColor()))
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBoxWidget(height: 2.0),
                                  TextWidget(
                                      text: parameters.records,
                                      fontsize: 8.0,
                                      colors: Colors.grey),
                                ],
                              ),
                              SizedBoxWidget(
                                width: 25,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBoxWidget(height: 15.0),
                    new Divider(
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
              SizedBoxWidget(height: 25.0),
              Container(
                child: Center(
                  child: TextWidget(
                      text: 'Pay INR ' +
                          commonWidgets.getMoneyWithForamt(widget.isFollowUp
                              ? getFollowUpFee()
                              : widget.isFromHospital
                                  ? getFeesFromHospital(
                                      widget.resultFromHospitalList[
                                          widget.doctorListIndex])
                                  : getFees(widget
                                      .healthOrganizationResult[widget.i])),
                      fontsize: 22.0,
                      fontWeight: FontWeight.w500,
                      colors: Color(new CommonUtil().getMyPrimaryColor())),
                ),
              ),
              SizedBoxWidget(height: 35.0),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBoxWithChild(
                      width: 130,
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.grey)),
                        color: Colors.transparent,
                        textColor: Colors.grey,
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          widget.refresh();
                          Navigator.pop(context);
                        },
                        child: TextWidget(text: Constants.Cancel, fontsize: 12),
                      ),
                    ),
                    SizedBoxWithChild(
                      width: 130,
                      height: 40,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                                color: Color(
                                    new CommonUtil().getMyPrimaryColor()))),
                        color: Colors.transparent,
                        textColor: Color(new CommonUtil().getMyPrimaryColor()),
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          new FHBUtils().check().then((intenet) {
                            if (intenet != null && intenet) {
                              _displayDialog(context);
                            } else {
                              toast.getToast(Constants.STR_NO_CONNECTIVITY,
                                  Colors.black54);
                            }
                          });
                        },
                        child: TextWidget(text: payNow, fontsize: 12),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getFollowUpFee() {
    if (widget.doctorsData?.plannedFollowupDate != null &&
        widget.followUpFee != null) {
      if (widget.doctorsData.isFollowUpTaken == true) {
        return widget.isFromHospital
            ? getFeesFromHospital(
                widget.resultFromHospitalList[widget.doctorListIndex])
            : getFees(widget.healthOrganizationResult[widget.i]);
      } else if (widget.doctorsData?.plannedFollowupDate == null) {
        return widget.isFromHospital
            ? getFeesFromHospital(
                widget.resultFromHospitalList[widget.doctorListIndex])
            : getFees(widget.healthOrganizationResult[widget.i]);
      } else {
        if (widget.selectedDate
                .difference(
                    DateTime.parse(widget.doctorsData.plannedFollowupDate))
                .inDays <=
            0) {
          return widget.followUpFee;
        } else {
          return widget.isFromHospital
              ? getFeesFromHospital(
                  widget.resultFromHospitalList[widget.doctorListIndex])
              : getFees(widget.healthOrganizationResult[widget.i]);
        }
      }
    } else {
      return widget.isFromHospital
          ? getFeesFromHospital(
              widget.resultFromHospitalList[widget.doctorListIndex])
          : getFees(widget.healthOrganizationResult[widget.i]);
    }
  }

  _displayDialog(BuildContext context) async {
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
                                  text: redirectedToPaymentMessage,
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
                                          text: 'Cancel', fontsize: 12),
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
                                              color: Color(new CommonUtil()
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        addHealthRecords();
                                        Navigator.pop(context);
                                        bookAppointment(
                                            createdBy,
                                            selectedId,
                                            doctorSessionId,
                                            scheduleDate,
                                            slotNumber,
                                            (healthRecords != null &&
                                                    healthRecords.length > 0)
                                                ? true
                                                : false,
                                            isFollowUp(),
                                            (healthRecords != null &&
                                                    healthRecords.length > 0)
                                                ? healthRecords
                                                : [],
                                            doc: widget.isFollowUp
                                                ? widget.doctorsData
                                                : null);
                                      },
                                      child: TextWidget(text: ok, fontsize: 12),
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

  bool isFollowUp() {
    if (widget.doctorsData?.plannedFollowupDate != null &&
        widget.followUpFee != null &&
        widget.isFollowUp == true) {
      if (widget.doctorsData.isFollowUpTaken == true) {
        return false;
      } else if (widget.doctorsData?.plannedFollowupDate == null) {
        return false;
      } else {
        if (widget.selectedDate
                .difference(
                    DateTime.parse(widget.doctorsData.plannedFollowupDate))
                .inDays <=
            0) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<CreateAppointmentModel> bookAppointmentCall(
      String createdBy,
      String bookedFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {Past doc}) async {
    CreateAppointmentModel bookAppointmentModel =
        await createAppointMentViewModel.putBookAppointment(
            createdBy,
            bookedFor,
            doctorSessionId,
            scheduleDate,
            slotNumber,
            isMedicalShared,
            isFollowUp,
            healthRecords,
            doc: doc);

    return bookAppointmentModel;
  }

  bookAppointment(
      String createdBy,
      String bookedFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {Past doc}) {
    setState(() {
      pr.show();
    });

    try {
      if (CommonUtil.recordIds.length > 0) {
        associateRecords(doctorId, selectedId, CommonUtil.recordIds)
            .then((value) {
          if (value != null && value.isSuccess) {
            bookAppointmentOnly(
                createdBy,
                bookedFor,
                doctorSessionId,
                scheduleDate,
                slotNumber,
                isMedicalShared,
                isFollowUp,
                healthRecords,
                doc: doc);
          } else {
            pr.hide();
            toast.getToast(errAssociateRecords, Colors.red);
          }
        });
      } else {
        bookAppointmentOnly(createdBy, bookedFor, doctorSessionId, scheduleDate,
            slotNumber, isMedicalShared, isFollowUp, healthRecords,
            doc: doc);
      }
    } catch (e) {
      pr.hide();
      toast.getToast(someWentWrong, Colors.red);
    }
  }

  bookAppointmentOnly(
      String createdBy,
      String bookedFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {Past doc}) {
    bookAppointmentCall(createdBy, bookedFor, doctorSessionId, scheduleDate,
            slotNumber, isMedicalShared, isFollowUp, healthRecords,
            doc: doc)
        .then((value) {
      if (value != null) {
        if (value.isSuccess != null &&
            value.message != null &&
            value.result != null) {
          if (value.isSuccess == true &&
              value.message == appointmentCreatedMessage) {
            if (value.result.paymentInfo.payload.paymentGatewayDetail
                    .responseInfo.longurl !=
                null) {
              PreferenceUtil.saveString(Constants.KEY_USERID_BOOK, '');

              goToPaymentPage(
                  value.result.paymentInfo.payload.paymentGatewayDetail
                      .responseInfo.longurl,
                  value.result.paymentInfo.payload.payment.id);
            } else {
              pr.hide();
              toast.getToast(noUrl, Colors.red);
            }
          } else {
            pr.hide();
            toast.getToast(
                value.message != null ? value.message : someWentWrong,
                Colors.red);
          }
        } else {
          pr.hide();
          toast.getToast(value.message != null ? value.message : someWentWrong,
              Colors.red);
        }
      } else {
        pr.hide();
        toast.getToast(noUrl, Colors.red);
      }
      PreferenceUtil.saveString(Constants.KEY_USERID_BOOK, '');
    });
  }

  goToPaymentPage(String longurl, String paymentId) {
    CommonUtil.recordIds.clear();
    CommonUtil.notesId.clear();
    CommonUtil.voiceIds.clear();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                  redirectUrl: longurl,
                  paymentId: paymentId,
                  closePage: (value) {
                    if (value == 'success') {
                      widget.closePage(value);
                      Navigator.pop(context);
                    } else {
                      widget.refresh();
                      Navigator.pop(context);
                    }
                  },
                )));
  }

  Widget getTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        new CommonUtil().getNotificationIcon(context),
        //new SwitchProfile().buildActions(context, _key, callBackToRefresh),
      ],
    );
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget getDoctorsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: commonWidgets.getClipOvalImageNew(
                  widget.isFromHospital
                      ? widget.resultFromHospitalList[widget.doctorListIndex]
                          .doctor.user.profilePicThumbnailUrl
                      : widget.docs[widget.doctorListPos].user
                          .profilePicThumbnailUrl,
                  fhbStyles.cardClipImage),
            ),
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: widget.isFromHospital
                  ? commonWidgets.getDoctorStatusWidgetNewForHos(
                      widget.resultFromHospitalList[widget.doctorListIndex]
                          .doctor,
                      widget.i)
                  : commonWidgets.getDoctorStatusWidgetNew(
                      widget.docs[widget.doctorListPos], widget.i),
            )
          ],
        ),
        commonWidgets.getSizeBoxWidth(10.0),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      widget.isFromHospital
                          ? commonWidgets.setDoctornameForHos(widget
                              .resultFromHospitalList[widget.doctorListIndex]
                              .doctor
                              .user)
                          : commonWidgets.setDoctorname(
                              widget.docs[widget.doctorListPos].user),
                      commonWidgets.getSizeBoxWidth(10.0),
                      commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            widget.isFromHospital
                                ? commonWidgets.showDoctorDetailViewNewForHos(
                                    widget
                                        .resultFromHospitalList[
                                            widget.doctorListIndex]
                                        .doctor,
                                    context)
                                : commonWidgets.showDoctorDetailViewNew(
                                    widget.docs[widget.doctorListPos], context);
                          }),
                    ],
                  )),
                  widget.isFromHospital
                      ? widget.resultFromHospitalList[widget.doctorListIndex]
                              .doctor.isActive
                          ? commonWidgets.getIcon(
                              width: fhbStyles.imageWidth,
                              height: fhbStyles.imageHeight,
                              icon: Icons.check_circle,
                              onTap: () {})
                          : widget.docs[widget.doctorListPos].isActive
                              ? commonWidgets.getIcon(
                                  width: fhbStyles.imageWidth,
                                  height: fhbStyles.imageHeight,
                                  icon: Icons.check_circle,
                                  onTap: () {})
                              : SizedBox()
                      : SizedBox(),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: widget.isFromHospital
                        ? commonWidgets.getDoctoSpecialistOnlyForHos(widget
                            .resultFromHospitalList[widget.doctorListIndex]
                            .doctor)
                        : commonWidgets.getDoctoSpecialistOnly(
                            widget.docs[widget.doctorListPos])),
              ]),
              commonWidgets.getSizedBox(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    widget.isFromHospital
                        ? '' +
                            commonWidgets.getCityDoctorsModelForHos(widget
                                .resultFromHospitalList[widget.doctorListIndex]
                                .doctor)
                        : '' +
                            commonWidgets.getCityDoctorsModel(
                                widget.docs[widget.doctorListPos]),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey[600],
                        fontSize: fhbStyles.fnt_city),
                  )),
                  widget.isFromHospital
                      ? widget.resultFromHospitalList[widget.doctorListIndex]
                              .doctor.isMciVerified
                          ? commonWidgets.getMCVerified(
                              widget.isFromHospital
                                  ? widget
                                      .resultFromHospitalList[
                                          widget.doctorListIndex]
                                      .doctor
                                      .isMciVerified
                                  : widget
                                      .resultFromHospitalList[
                                          widget.doctorListIndex]
                                      .doctor
                                      .isMciVerified,
                              'Verified')
                          : commonWidgets.getMCVerified(
                              widget.isFromHospital
                                  ? widget
                                      .resultFromHospitalList[
                                          widget.doctorListIndex]
                                      .doctor
                                      .isMciVerified
                                  : widget
                                      .resultFromHospitalList[
                                          widget.doctorListIndex]
                                      .doctor
                                      .isMciVerified,
                              'Not Verified')
                      : widget.docs[widget.doctorListPos].isMciVerified
                          ? commonWidgets.getMCVerified(
                              widget.isFromHospital
                                  ? widget
                                      .resultFromHospitalList[
                                          widget.doctorListPos]
                                      .doctor
                                      .isMciVerified
                                  : widget
                                      .docs[widget.doctorListPos].isMciVerified,
                              'Verified')
                          : commonWidgets.getMCVerified(
                              widget.isFromHospital
                                  ? widget
                                      .resultFromHospitalList[
                                          widget.doctorListPos]
                                      .doctor
                                      .isMciVerified
                                  : widget
                                      .docs[widget.doctorListPos].isMciVerified,
                              'Not Verified'),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  List<CategoryResult> getCategoryList() {
    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock.getCategoryLists().then((value) {
        categoryDataList = value.result;

        filteredCategoryData =
            new CommonUtil().fliterCategories(categoryDataList);

        //filteredCategoryData.add(categoryDataObjClone);
        return filteredCategoryData;
      });
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
        saveCategoryToprefernce(categoryDataList[i]);
        position = i;
      }
    }
    if (categoryName == Constants.STR_PRESCRIPTION) {
      return position;
    } else {
      return position;
    }
  }

  void FetchRecords(int position, bool allowSelect, bool isAudioSelect,
      bool isNotesSelect, List<String> mediaIds) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
        categoryPosition: position,
        allowSelect: allowSelect,
        isAudioSelect: isAudioSelect,
        isNotesSelect: isNotesSelect,
        selectedMedias: mediaIds,
        isFromChat: false,
        showDetails: false,
        isAssociateOrChat: true,
        userID: selectedId,
      ),
    ))
        .then((results) {
      if (results.containsKey(STR_META_ID)) {
        var metaIds = results[STR_META_ID];
        print(metaIds.toString());

        if (allowSelect) {
          CommonUtil.recordIds = results['metaId'].cast<String>();
          recordIdCount = CommonUtil.recordIds.length;
        } else if (isAudioSelect) {
          CommonUtil.voiceIds = results['metaId'].cast<String>();

          voiceIdCount = CommonUtil.voiceIds.length;
        } else if (isNotesSelect) {
          CommonUtil.notesId = results['metaId'].cast<String>();

          notesIdCount = CommonUtil.notesId.length;
        }
        print(recordIdCount);
        setState(() {});
        print(metaIds.toString());
      }
    });
  }

  setLengthValue() {
    recordIdCount = CommonUtil.recordIds.length;
    voiceIdCount = CommonUtil.voiceIds.length;
    notesIdCount = CommonUtil.notesId.length;
  }

  Future<AssociateSuccessResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    AssociateSuccessResponse associateResponseList = await providerViewModel
        .associateRecords(doctorId, userId, healthRecords);

    return associateResponseList;
  }

  String getFees(HealthOrganizationResult result) {
    String fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection.length; i++) {
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          bool isActive = result.doctorFeeCollection[i].isActive;
          if (feesCode == CONSULTING && isActive == true) {
            fees = result.doctorFeeCollection[i].fee;
          }
        }
      } else {
        fees = '';
      }
    } else {
      fees = '';
    }
    return fees;
  }

  String getFeesFromHospital(ResultFromHospital result) {
    String fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection.length; i++) {
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          bool isActive = result.doctorFeeCollection[i].isActive;
          if (feesCode == CONSULTING && isActive == true) {
            fees = result.doctorFeeCollection[i].fee;
          }
        }
      } else {
        fees = '';
      }
    } else {
      fees = '';
    }
    return fees;
  }

  void saveCategoryToprefernce(CategoryResult category) async {
    await PreferenceUtil.saveString(
        Constants.KEY_CATEGORYNAME, category.categoryName);
    await PreferenceUtil.saveString(Constants.KEY_CATEGORYID, category.id);
    await PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, selectedId);
  }
}
