import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/FlutterToast.dart';
import 'package:gmiwidgetspackage/widgets/IconButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_providers/models/GetDoctorsByIdModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
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
import 'package:myfhb/constants/router_variable.dart' as router;

import 'TelehealthProviders.dart';

class BookingConfirmation extends StatefulWidget {
  final followUpFee;
  bool isNewAppointment;
  final List<Doctors> docs;
  final List<DoctorResult> docsReschedule;
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
  bool isFromFollowReschedule;

  BookingConfirmation(
      {this.docs,
      this.docsReschedule,
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
      this.isFromHospital,
      this.isFromFollowReschedule});

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

  bool isFamilyChanged = false;

  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool checkedValue = false;

  String INR_Price = '';
  String btnLabelChange = payNow;

  @override
  void initState() {
    mInitialTime = DateTime.now();
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

    INR_Price = commonWidgets.getMoneyWithForamt(isFollowUp()
        ? getFollowUpFee()
        : widget.isFromHospital
            ? getFeesFromHospital(
                widget.resultFromHospitalList[widget.doctorListIndex], false)
            : getFees(widget.healthOrganizationResult[widget.i], false));
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Booking Confirmation Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  addHealthRecords() {
    //healthRecords.addAll(CommonUtil.recordIds);
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
        : widget.isFromFollowReschedule
            ? widget.docsReschedule[widget.doctorListPos].user.id
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
          ? myProfile.result.firstName?.capitalizeFirstofEach +
              ' ' +
              myProfile.result.lastName?.capitalizeFirstofEach
          : '';
    } catch (e) {}

    if (sharedByMeList == null) {
      sharedByMeList = new List();
      sharedByMeList
          .add(new SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    } else {
      sharedByMeList.insert(
          0, new SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
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
              Text(parameters.self,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                  )),
            ],
          ),
          items: _familyNames
              .map((SharedByUsers user) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        SizedBoxWidget(width: 20),
                        Text(
                            user.nickName == null
                                ? 'Self'
                                : user.nickName?.capitalizeFirstofEach,
                            style: TextStyle(
                              fontSize: 14.0.sp,
                            )),
                      ],
                    ),
                    value: user,
                  ))
              .toList(),
          onChanged: (SharedByUsers user) {
            isFamilyChanged = true;
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
                    style: TextStyle(fontSize: 12.0.sp, color: Colors.grey)),
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
                  fontsize: 12.0.sp,
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
                      fontsize: 14.0.sp,
                    ),
                    SizedBoxWidget(
                      width: 5.0,
                    ),
                    TextWidget(
                      text: slotTime != null ? slotTime : '0.00',
                      fontsize: 14.0.sp,
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
                            fontsize: 18.0.sp,
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
        progressWidget: SizedBox(
          height: 1.sh,
          child: Center(
            child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    backgroundColor:
                        Color(new CommonUtil().getMyPrimaryColor()))),
          ),
        ),
        elevation: 6.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 12.0.sp,
            fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w600));

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        widget.refresh();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: GestureDetector(
            onTap: () {
              widget.refresh();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios, // add custom icons also
              size: 24.0.sp,
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
                                      fontSize: 12.0.sp, color: Colors.grey)),
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
                                      fontsize: 10.0.sp,
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
                                      fontsize: 10.0.sp,
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
                                      fontsize: 10.0.sp,
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
                    SizedBoxWidget(height: 10.0),
                    new Divider(
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
              isFollowUp()
                  ? SizedBox.shrink()
                  : getCSRCheckBox(
                      widget.isFromHospital
                          ? getFeesFromHospital(
                              widget.resultFromHospitalList[
                                  widget.doctorListIndex],
                              true)
                          : getFees(
                              widget.healthOrganizationResult[widget.i], true),
                      commonWidgets.getMoneyWithForamt(widget.isFromHospital
                          ? getFeesFromHospital(
                              widget.resultFromHospitalList[
                                  widget.doctorListIndex],
                              false)
                          : getFees(widget.healthOrganizationResult[widget.i],
                              false))),
              SizedBoxWidget(height: 15.0),
              Container(
                child: Center(
                  child: Text(
                    'Pay INR ' + INR_Price,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 22.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(new CommonUtil().getMyPrimaryColor())),
                  ),
                ),
              ),
              SizedBoxWidget(height: 20.0),
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
                            side: BorderSide(
                                color: Color(
                                    new CommonUtil().getMyPrimaryColor()))),
                        color: Colors.transparent,
                        textColor: Color(new CommonUtil().getMyPrimaryColor()),
                        padding: EdgeInsets.all(8.0),
                        onPressed: () {
                          widget.refresh();
                          Navigator.pop(context);
                        },
                        child: TextWidget(
                          text: Constants.Cancel,
                          fontsize: 14.0.sp,
                        ),
                      ),
                    ),
                    SizedBoxWithChild(
                      width: 130.0.w,
                      height: 40.0.h,
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
                              if (isFamilyChanged) {
                                profileValidationCheck(
                                    context,
                                    selectedId != ''
                                        ? selectedId
                                        : PreferenceUtil.getStringValue(
                                            Constants.KEY_USERID));
                              } else {
                                if (btnLabelChange == bookNow) {
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
                                } else {
                                  _displayDialog(context);
                                }
                              }
                            } else {
                              toast.getToast(Constants.STR_NO_CONNECTIVITY,
                                  Colors.black54);
                            }
                          });
                        },
                        child: TextWidget(
                          text: btnLabelChange,
                          fontsize: 14.0.sp,
                        ),
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

  Widget getCSRCheckBox(String discount, String originalFees) {
    Widget widget;
    if (discount != null &&
        discount != '' &&
        originalFees != null &&
        originalFees != '') {
      if (discount != '0.00' && discount != '0') {
        try {
          discount = new CommonUtil()
              .doubleWithoutDecimalToInt(double.parse(discount))
              .toString();
        } catch (e) {
          widget = SizedBox.shrink();
        }
        widget = Container(
          child: Center(
            child: CheckboxListTile(
              title: Text("Qurhealth Discount (" + discount + '%)'),
              value: checkedValue,
              activeColor: Colors.green,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue;
                  if (checkedValue) {
                    if (originalFees.contains(',')) {
                      originalFees = originalFees.replaceAll(',', '');
                    }
                    INR_Price = getDiscountedFee(
                        double.parse(discount), double.parse(originalFees));
                    if (INR_Price == '0' || INR_Price == '0.00') {
                      btnLabelChange = bookNow;
                    } else {
                      btnLabelChange = payNow;
                    }
                  } else {
                    INR_Price = originalFees;
                    btnLabelChange = payNow;
                  }
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ),
        );
      } else {
        widget = SizedBox.shrink();
      }
    } else {
      widget = SizedBox.shrink();
    }
    return widget;
  }

  profileValidationCheck(BuildContext context, String userId) async {
    await addFamilyUserInfoRepository.getMyProfileInfoNew(userId).then((value) {
      myProfile = value;
    });

    if (myProfile != null) {
      addressValidation(context);
    } else {
      toast.getToast(noGender, Colors.red);
    }
  }

  String getFollowUpFee() {
    if (widget.followUpFee != null && widget.followUpFee != '') {
      return widget?.followUpFee;
    } else {
      return '';
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
                              Center(
                                child: TextWidget(
                                    text: redirectedToPaymentMessage,
                                    fontsize: 16.0.sp,
                                    fontWeight: FontWeight.w500,
                                    colors: Colors.grey[600]),
                              ),
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
                                          side: BorderSide(
                                              color: Color(new CommonUtil()
                                                  .getMyPrimaryColor()))),
                                      color: Colors.transparent,
                                      textColor: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                        text: 'Cancel',
                                        fontsize: 14.0.sp,
                                      ),
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
                                      child: TextWidget(
                                        text: ok,
                                        fontsize: 14.0.sp,
                                      ),
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
        if (widget.selectedDate
            .difference(
            DateTime.parse(widget.doctorsData.plannedFollowupDate))
            .inDays <=
            0) {
          return true;
        } else {
          return false;
        }
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
      bool isCSRDiscount,
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
            isCSRDiscount,
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
                checkedValue,
                doc: doc);
          } else {
            pr.hide();
            toast.getToast(errAssociateRecords, Colors.red);
          }
        });
      } else {
        bookAppointmentOnly(
            createdBy,
            bookedFor,
            doctorSessionId,
            scheduleDate,
            slotNumber,
            isMedicalShared,
            isFollowUp,
            healthRecords,
            checkedValue,
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
      bool isCSRDiscount,
      {Past doc}) {
    bookAppointmentCall(
            createdBy,
            bookedFor,
            doctorSessionId,
            scheduleDate,
            slotNumber,
            isMedicalShared,
            isFollowUp,
            healthRecords,
            isCSRDiscount,
            doc: doc)
        .then((value) {
      if (value != null) {
        if (value.isSuccess != null &&
            value.message != null &&
            value.result != null) {
          if (value.isSuccess == true &&
              value.message == appointmentCreatedMessage) {
            if (value?.result?.paymentInfo != null &&
                value?.result.paymentInfo?.payload?.paymentGatewayDetail !=
                    null) {
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
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelehealthProviders(
                            arguments: HomeScreenArguments(selectedIndex: 0),
                          )));
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
                  isFromSubscribe: false,
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
            style: TextStyle(
              fontSize: 18.0.sp,
            ),
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
              child: commonWidgets.getClipOvalImageBookConfirm(
                  widget.isFromHospital
                      ? widget.resultFromHospitalList[widget.doctorListIndex]
                          .doctor.user.profilePicThumbnailUrl
                      : widget.isFromFollowReschedule
                          ? widget.docsReschedule[widget.doctorListPos].user
                              .profilePicThumbnailUrl
                          : widget.docs[widget.doctorListPos].user
                              .profilePicThumbnailUrl),
            ),
            /* Container(
              alignment: Alignment.center,
              child: widget.isFromHospital?commonWidgets.getClipOvalImageForHos(widget.resultFromHospitalList[widget.doctorListIndex]
                  .doctor):commonWidgets.getClipOvalImageNew(widget.docs[widget.doctorListPos]),
            ),*/
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: widget.isFromHospital
                  ? commonWidgets.getDoctorStatusWidgetNewForHos(
                      widget.resultFromHospitalList[widget.doctorListIndex]
                          .doctor,
                      widget.i)
                  : widget.isFromFollowReschedule
                      ? commonWidgets.getDoctorStatusWidgetForReschedule(
                          widget.docsReschedule[widget.doctorListPos], widget.i)
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
                          : commonWidgets.setDoctorname(widget
                                  .isFromFollowReschedule
                              ? widget.docsReschedule[widget.doctorListPos].user
                              : widget.docs[widget.doctorListPos].user),
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
                                : widget.isFromFollowReschedule
                                    ? commonWidgets
                                        .showDoctorDetailViewForReschedule(
                                            widget.docsReschedule[
                                                widget.doctorListPos],
                                            context)
                                    : commonWidgets.showDoctorDetailViewNew(
                                        widget.docs[widget.doctorListPos],
                                        context);
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
                          : widget.isFromFollowReschedule
                              ? widget.docsReschedule[widget.doctorListIndex]
                                      .isActive
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
                        : widget.isFromFollowReschedule
                            ? commonWidgets.getDoctoSpecialistForReschedule(
                                widget.docsReschedule[widget.doctorListPos])
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
                        : widget.isFromFollowReschedule
                            ? '' +
                                commonWidgets.getCityDoctorsModelForReschedule(
                                    widget.docsReschedule[widget.doctorListPos])
                            : commonWidgets.getCityDoctorsModel(
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
                      : widget.isFromFollowReschedule
                          ? widget.docsReschedule[widget.doctorListPos]
                                  .isMciVerified
                              ? commonWidgets.getMCVerified(
                                  widget.isFromHospital
                                      ? widget
                                          .resultFromHospitalList[
                                              widget.doctorListPos]
                                          .doctor
                                          .isMciVerified
                                      : widget
                                          .docsReschedule[widget.doctorListPos]
                                          .isMciVerified,
                                  'Verified')
                              : commonWidgets.getMCVerified(
                                  widget.isFromHospital
                                      ? widget
                                          .resultFromHospitalList[
                                              widget.doctorListPos]
                                          .doctor
                                          .isMciVerified
                                      : widget
                                          .docsReschedule[widget.doctorListPos]
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
                                      : widget.docs[widget.doctorListPos]
                                          .isMciVerified,
                                  'Verified')
                              : commonWidgets.getMCVerified(
                                  widget.isFromHospital
                                      ? widget
                                          .resultFromHospitalList[
                                              widget.doctorListPos]
                                          .doctor
                                          .isMciVerified
                                      : widget.docs[widget.doctorListPos]
                                          .isMciVerified,
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
        argument: MyRecordsArgument(
            categoryPosition: position,
            allowSelect: allowSelect,
            isAudioSelect: isAudioSelect,
            isNotesSelect: isNotesSelect,
            selectedMedias: mediaIds,
            isFromChat: false,
            showDetails: false,
            isAssociateOrChat: true,
            userID: selectedId,
            fromClass: 'appointments'),
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

  String getFees(HealthOrganizationResult result, bool isCSRDiscount) {
    String fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection.length; i++) {
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          bool isActive = result.doctorFeeCollection[i].isActive;
          if (isCSRDiscount) {
            if (feesCode == CSR_DISCOUNT && isActive == true) {
              fees = result?.doctorFeeCollection[i]?.fee;
            }
          } else {
            if (feesCode == CONSULTING && isActive == true) {
              fees = result?.doctorFeeCollection[i]?.fee;
            }
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

  String getFeesFromHospital(ResultFromHospital result, bool isCSRDiscount) {
    String fees;
    if (result.doctorFeeCollection != null) {
      if (result.doctorFeeCollection.length > 0) {
        for (int i = 0; i < result.doctorFeeCollection.length; i++) {
          String feesCode = result.doctorFeeCollection[i].feeType.code;
          bool isActive = result.doctorFeeCollection[i].isActive;
          if (isCSRDiscount) {
            if (feesCode == CSR_DISCOUNT && isActive == true) {
              fees = result?.doctorFeeCollection[i]?.fee;
            }
          } else {
            if (feesCode == CONSULTING && isActive == true) {
              fees = result?.doctorFeeCollection[i]?.fee;
            }
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

  addressValidation(BuildContext context) {
    if (myProfile != null) {
      if (myProfile.isSuccess) {
        if (myProfile.result != null) {
          if (myProfile.result.gender != null &&
              myProfile.result.gender.isNotEmpty) {
            if (myProfile.result.dateOfBirth != null &&
                myProfile.result.dateOfBirth.isNotEmpty) {
              if (myProfile.result.additionalInfo != null) {
                if (myProfile.result.additionalInfo.height != null &&
                    myProfile.result.additionalInfo.height.isNotEmpty) {
                  if (myProfile.result.additionalInfo.weight != null &&
                      myProfile.result.additionalInfo.weight.isNotEmpty) {
                    if (myProfile.result.userAddressCollection3 != null) {
                      if (myProfile.result.userAddressCollection3.length > 0) {
                        patientAddressCheck(
                            myProfile.result.userAddressCollection3[0],
                            context);
                      } else {
                        //toast.getToast(noAddress, Colors.red);
                        showInSnackBar(noAddressFamily, 'Add');
                        //CommonUtil().mSnackbar(context, noAddress, 'Add');
                      }
                    } else {
                      //toast.getToast(noAddress, Colors.red);
                      showInSnackBar(noAddressFamily, 'Add');
                      //CommonUtil().mSnackbar(context, noAddress, 'Add');
                    }
                  } else {
                    //toast.getToast(noWeight, Colors.red);
                    showInSnackBar(noWeightFamily, 'Add');
                    //CommonUtil().mSnackbar(context, noWeight, 'Add');
                  }
                } else {
                  //toast.getToast(noHeight, Colors.red);
                  showInSnackBar(noHeightFamily, 'Add');
                  //CommonUtil().mSnackbar(context, noHeight, 'Add');
                }
              } else {
                //toast.getToast(noAdditionalInfo, Colors.red);
                showInSnackBar(noAdditionalInfoFamily, 'Add');
                //CommonUtil().mSnackbar(context, noAdditionalInfo, 'Add');
              }
            } else {
              //toast.getToast(noDOB, Colors.red);
              showInSnackBar(noDOBFamily, 'Add');
              //CommonUtil().mSnackbar(context, noDOB, 'Add');
            }
          } else {
            showInSnackBar(noGenderFamily, 'Add');
            //toast.getToast(noGender, Colors.red);
          }
        } else {
          //toast.getToast(noAddress, Colors.red);
          showInSnackBar(noAddressFamily, 'Add');
          //CommonUtil().mSnackbar(context, noAddress, 'Add');
        }
      } else {
        //toast.getToast(noAddress, Colors.red);
        showInSnackBar(noAddressFamily, 'Add');
        //CommonUtil().mSnackbar(context, noAddress, 'Add');
      }
    } else {
      //toast.getToast(noAddress, Colors.red);
      showInSnackBar(noAddressFamily, 'Add');
      //CommonUtil().mSnackbar(context, noAddress, 'Add');
    }
  }

  patientAddressCheck(
      UserAddressCollection3 userAddressCollection, BuildContext context) {
    String address1 = userAddressCollection.addressLine1 != null
        ? userAddressCollection.addressLine1
        : '';
    String city = userAddressCollection.city.name != null
        ? userAddressCollection.city.name
        : '';
    String state = userAddressCollection.state.name != null
        ? userAddressCollection.state.name
        : '';

    if (address1 != '' && city != '' && state != '') {
      //normal appointment
      if (btnLabelChange == bookNow) {
        bookAppointment(
            createdBy,
            selectedId,
            doctorSessionId,
            scheduleDate,
            slotNumber,
            (healthRecords != null && healthRecords.length > 0) ? true : false,
            isFollowUp(),
            (healthRecords != null && healthRecords.length > 0)
                ? healthRecords
                : [],
            doc: widget.isFollowUp ? widget.doctorsData : null);
      } else {
        _displayDialog(context);
      }
    } else {
      toast.getToast(noAddress, Colors.red);
    }
  }

  void showInSnackBar(String message, String actionName) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(message),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 5.0,
        action: SnackBarAction(
            label: actionName,
            onPressed: () async {
              if (myProfile?.result != null) {
                Navigator.pushNamed(context, router.rt_AddFamilyUserInfo,
                    arguments: AddFamilyUserInfoArguments(
                        myProfileResult: myProfile?.result,
                        fromClass: CommonConstants.user_update));
              } else {
                FlutterToast()
                    .getToast('Unable to Fetch User Profile data', Colors.red);
              }
            }),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  String getDiscountedFee(double percent, double price) {
    var discountedPrice;
    String priceLast;

    if (percent != null && price != null && percent != '' && price != '') {
      discountedPrice = (percent / 100) * price;

      price = price - discountedPrice;

      try {
        priceLast = new CommonUtil()
            .doubleWithoutDecimalToInt(double.parse(price.toString()))
            .toString();
      } catch (e) {
        return price.toString();
      }
    }

    return priceLast.toString();
  }
}
