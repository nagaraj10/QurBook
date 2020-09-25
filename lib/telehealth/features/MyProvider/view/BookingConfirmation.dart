import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/FlutterToast.dart';
import 'package:gmiwidgetspackage/widgets/IconButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/LinkedData.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/AssociateRecordResponse.dart';
import 'file:///C:/Users/fmohamed/Documents/Flutter%20Projects/asgard_myfhb/lib/telehealth/features/MyProvider/model/appointments/CreateAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/SlotSessionsModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/CreateAppointmentViewModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/Payment/PaymentPage.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BookingConfirmation extends StatefulWidget {
  final followUpFee;
  bool isNewAppointment;
  final List<DoctorIds> docs;
  final int i;
  final DateTime selectedDate;
  final List<SlotSessionsModel> sessionData;
  final int rowPosition;
  final int itemPosition;
  final bool isFollowUp;
  History doctorsData;

  BookingConfirmation(
      {this.docs,
      this.i,
      this.selectedDate,
      this.sessionData,
      this.rowPosition,
      this.followUpFee,
      this.itemPosition,
      this.isNewAppointment,
      this.isFollowUp,
      this.doctorsData});

  @override
  BookingConfirmationState createState() => BookingConfirmationState();
}

class BookingConfirmationState extends State<BookingConfirmation> {
  //final GlobalKey<State> _key = new GlobalKey<State>();
  CommonWidgets commonWidgets = new CommonWidgets();
  CommonUtil commonUtil = new CommonUtil();
  MyProviderViewModel providerViewModel;
  CreateAppointMentViewModel createAppointMentViewModel;
  FamilyListBloc _familyListBloc;
  FamilyMembersList familyMembersModel = new FamilyMembersList();
  List<Sharedbyme> sharedbyme = new List();
  FlutterToast toast = new FlutterToast();
  FamilyData familyData = new FamilyData();

  final List<ProfileData> _familyNames = new List();

  List<String> recordIds = new List();
  List<String> notesId = new List();
  List<String> voiceIds = new List();

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
  ProfileData selectedUser;
  var selectedId = '';
  ProgressDialog pr;

  CategoryListBlock _categoryListBlock;

  List<CategoryData> categoryDataList = new List();
  List<CategoryData> filteredCategoryData = new List();
  CategoryData categoryDataObjClone = new CategoryData();

  String doctorId;

  @override
  void initState() {
    providerViewModel = new MyProviderViewModel();
    createAppointMentViewModel = new CreateAppointMentViewModel();
    createdBy = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    selectedId = createdBy;
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();

    _categoryListBlock = null;
    _categoryListBlock = new CategoryListBlock();

    getCategoryList();
    getDataFromWidget();
  }

  addHealthRecords() {
    //healthRecords.addAll(recordIds);
    healthRecords.addAll(notesId);
    healthRecords.addAll(voiceIds);
  }

  Future<FamilyMembersList> getList() async {
    _familyListBloc.getFamilyMembersList().then((familyMembersList) {
      familyMembersModel = familyMembersList;

      for (int i = 0;
          i < familyMembersModel.response.data.sharedbyme.length;
          i++) {
        sharedbyme.add(familyMembersModel.response.data.sharedbyme[i]);
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

    doctorId = widget.docs[widget.i].id;
    try {
      fees = widget.isNewAppointment
          ? widget.followUpFee == null
              ? widget.docs[widget.i].fees.consulting.fee
              : widget.followUpFee
          : widget.docs[widget.i].fees.consulting.fee;
    } catch (e) {
      fees = '';
    }
  }

  Widget getDropdown() {
    return StreamBuilder<ApiResponse<FamilyMembersList>>(
      stream: _familyListBloc.familyMemberListStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<FamilyMembersList>> snapshot) {
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
              if (snapshot.data.data.response.data != null) {
                familyData = snapshot.data.data.response.data;

                // PreferenceUtil.saveFamilyData(Constants.KEY_FAMILYMEMBER,
                //     snapshot.data.data.response.data);
              }
              return dropDownButton(snapshot.data.data.response.data != null
                  ? snapshot.data.data.response.data.sharedbyme
                  : null);
              break;
          }
        } else {
          return Container(height: 0, color: Colors.white);
        }
      },
    );
  }

  /*Widget getFamilyMembers() {
    sharedbyme.clear();
    return FutureBuilder<FamilyMembersList>(
      future: getList(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Center(
              child: new Column(
            children: <Widget>[
              new SizedBox(
                child: CircularProgressIndicator(
                    strokeWidth: 2.0, backgroundColor: Color(0xff138fcf)),
                height: 20.0,
                width: 20.0,
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          print(snapshot.data.toString());
          familyData = snapshot.data.response.data;
          PreferenceUtil.saveFamilyData(
              Constants.KEY_FAMILYMEMBER, snapshot.data.response.data);
          return snapshot.data!=null&&snapshot.data.response.data.sharedbyme.length>0?Container(
            child: dropDownButton(snapshot.data.response.data.sharedbyme),
          ):getFamilyMembers();
        }
      },
    );
  }*/

  Widget dropDownButton(List<Sharedbyme> sharedByMeList) {
    ProfileData profileData = new ProfileData(
      id: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
      name: variable.Self,
      userId: PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN),
    );
    LinkedData linkedData =
        new LinkedData(roleName: variable.Self, nickName: variable.Self);

    if (sharedByMeList == null) {
      sharedByMeList = new List();
      sharedByMeList.add(
          new Sharedbyme(profileData: profileData, linkedData: linkedData));
    } else {
      sharedByMeList.insert(
          0, new Sharedbyme(profileData: profileData, linkedData: linkedData));
    }
    if (_familyNames.length == 0) {
      for (int i = 0; i < sharedByMeList.length; i++) {
        _familyNames.add(sharedByMeList[i].profileData);
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
        child: DropdownButton<ProfileData>(
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
              .map((ProfileData user) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        SizedBoxWidget(width: 20),
                        Text(user.name == null ? 'Self' : user.name,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    value: user,
                  ))
              .toList(),
          onChanged: (ProfileData user) {
            setState(() {
              selectedUser = user;
              selectedId = user.id;
              print(selectedId);
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
          /*familyData!=null
              ? dropDownButton(
              familyData.sharedbyme):*/
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
                    color: Colors.blue[100], // border color
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2), // border width
                    child: Container(
                      // or ClipRRect if you need to clip the content
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[800], // inner circle color
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

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
                                        color: Colors.blue[800],
                                        padding: new EdgeInsets.all(1.0),
                                        onPressed: () {
                                          FetchRecords(
                                              getCategoryPosition(
                                                  Constants.STR_NOTES),
                                              false,
                                              false,
                                              true,
                                              notesId);
                                        },
                                      ),
                                    ),
                                    notesIdCount > 0
                                        ? BadgesBlue(
                                            badgeValue: notesIdCount.toString(),
                                            backColor: Color(
                                                commonUtil.getMyPrimaryColor()))
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
                                        color: Colors.blue[800],
                                        padding: new EdgeInsets.all(1.0),
                                        onPressed: () {
                                          FetchRecords(
                                              getCategoryPosition(
                                                  Constants.STR_VOICERECORDS),
                                              false,
                                              true,
                                              false,
                                              voiceIds);
                                        },
                                      ),
                                    ),
                                    voiceIdCount > 0
                                        ? BadgesBlue(
                                            badgeValue: voiceIdCount.toString(),
                                            backColor: Color(
                                                commonUtil.getMyPrimaryColor()))
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
                                        color: Colors.blue[800],
                                        padding: new EdgeInsets.all(1.0),
                                        onPressed: () {
                                          FetchRecords(
                                              getCategoryPosition(
                                                  Constants.STR_PRESCRIPTION),
                                              true,
                                              false,
                                              false,
                                              recordIds);
                                        },
                                      ),
                                    ),
                                    recordIdCount > 0
                                        ? BadgesBlue(
                                            badgeValue:
                                                recordIdCount.toString(),
                                            backColor: Color(
                                                commonUtil.getMyPrimaryColor()))
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
                    text: fees != null ? 'Pay INR ' + fees : 'Pay INR 0.00',
                    fontsize: 22.0,
                    fontWeight: FontWeight.w500,
                    colors: Colors.blue[800]),
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
                          side: BorderSide(color: Colors.blue[800])),
                      color: Colors.transparent,
                      textColor: Colors.blue[800],
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        _displayDialog(context);
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
    );
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
                                              color: Colors.blue[800])),
                                      color: Colors.transparent,
                                      textColor: Colors.blue[800],
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
                                            widget.isFollowUp,
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

  Future<CreateAppointmentModel> bookAppointmentCall(
      String createdBy,
      String createdFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {History doc}) async {
    CreateAppointmentModel bookAppointmentModel =
        await createAppointMentViewModel.putBookAppointment(
            createdBy,
            createdFor,
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
      String createdFor,
      String doctorSessionId,
      String scheduleDate,
      String slotNumber,
      bool isMedicalShared,
      bool isFollowUp,
      List<String> healthRecords,
      {History doc}) {
    setState(() {
      pr.show();
    });

    try {
      associateRecords(doctorId, createdBy, recordIds).then((value) {
        if (value != null && value.success) {
          bookAppointmentCall(
                  createdBy,
                  createdFor,
                  doctorSessionId,
                  scheduleDate,
                  slotNumber,
                  isMedicalShared,
                  isFollowUp,
                  healthRecords,
                  doc: doc)
              .then((value) {
            if (value != null) {
              if (value.isSuccess != null &&
                  value.message != null &&
                  value.result != null) {
                if (value.isSuccess == true &&
                    value.message == appointmentCreatedMessage) {
                  if (value.result.paymentInfo.payload.paymentGatewayDetail.responseInfo.result.paymentRequest.longurl != null) {
                    goToPaymentPage(
                        value.result.paymentInfo.payload.paymentGatewayDetail.responseInfo.result.paymentRequest.longurl,
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
                toast.getToast(someWentWrong, Colors.red);
              }
            } else {
              pr.hide();
              toast.getToast(noUrl, Colors.red);
            }
          });
        } else {
          pr.hide();
          toast.getToast(value.message != null ? value.message : someWentWrong,
              Colors.red);
        }
      });
    } catch (e) {
      pr.hide();
      toast.getToast(someWentWrong, Colors.red);
    }
  }

  goToPaymentPage(String longurl, String paymentId) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                redirectUrl: longurl,
                paymentId: paymentId)));
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
        Icon(Icons.notifications),
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
                  widget.docs[widget.i].profilePicThumbnailURL,
                  fhbStyles.cardClipImage),
            ),
            new Positioned(
              bottom: 0.0,
              right: 2.0,
              child: commonWidgets.getDoctorStatusWidget(
                  widget.docs[widget.i], widget.i),
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
                      commonWidgets
                          .getTextForDoctors('${widget.docs[widget.i].name}'),
                      commonWidgets.getSizeBoxWidth(10.0),
                      commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            commonWidgets.showDoctorDetailView(
                                widget.docs[widget.i], context);
                          }),
                    ],
                  )),
                  widget.docs[widget.i].isActive
                      ? commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.check_circle,
                          onTap: () {})
                      : SizedBox(),
                  commonWidgets.getSizeBoxWidth(15.0),
                  commonWidgets.getBookMarkedIcon(widget.docs[widget.i], () {
                    providerViewModel
                        .bookMarkDoctor(!(widget.docs[widget.i].isDefault),
                            widget.docs[widget.i])
                        .then((status) {
                      if (status) {
                        setState(() {});
                      }
                    });
                  }),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              ),
              commonWidgets.getSizedBox(5.0),
              Row(children: [
                Expanded(
                    child: widget.docs[widget.i].professionalDetails != null
                        ? widget.docs[widget.i].professionalDetails[0]
                                    .specialty !=
                                null
                            ? widget.docs[widget.i].professionalDetails[0]
                                        .specialty.name !=
                                    null
                                ? commonWidgets.getDoctoSpecialist(
                                    '${widget.docs[widget.i].professionalDetails[0].specialty.name}')
                                : SizedBox()
                            : SizedBox()
                        : SizedBox()),
                /*
                Expanded(
                    child: widget.docs[widget.i].specialization != null
                        ? commonWidgets.getDoctoSpecialist(
                            '${widget.docs[widget.i].specialization}')
                        : SizedBox()),*/
                widget.docs[widget.i].fees != null
                    ? widget.docs[widget.i].fees.consulting != null
                        ? (widget.docs[widget.i].fees.consulting != null &&
                                widget.docs[widget.i].fees.consulting != '')
                            ? commonWidgets.getDoctoSpecialist(
                                '${widget.docs[widget.i].fees.consulting.fee}')
                            : SizedBox()
                        : SizedBox()
                    : SizedBox(),
                commonWidgets.getSizeBoxWidth(10.0),
              ]),
              commonWidgets.getSizedBox(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: commonWidgets
                          .getDoctorsAddress('${widget.docs[widget.i].city}')),
                  widget.docs[widget.i].isMCIVerified
                      ? commonWidgets.getMCVerified(
                          widget.docs[widget.i].isMCIVerified, 'Verified')
                      : commonWidgets.getMCVerified(
                          widget.docs[widget.i].isMCIVerified, 'Not Verified'),
                  commonWidgets.getSizeBoxWidth(10.0),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  List<CategoryData> getCategoryList() {
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

  void FetchRecords(int position, bool allowSelect, bool isAudioSelect,
      bool isNotesSelect, List<String> mediaIds) async {
    print(allowSelect);
    print(isAudioSelect);
    print(isNotesSelect);
    print(position);

    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
        categoryPosition: position,
        allowSelect: allowSelect,
        isAudioSelect: isAudioSelect,
        isNotesSelect: isNotesSelect,
        selectedMedias: mediaIds,
        isFromChat: false,
      ),
    ))
        .then((results) {
      if (results.containsKey('metaId')) {
        var metaIds = results['metaId'];
        print(metaIds.toString());

        if (allowSelect) {
          recordIds = results['metaId'].cast<String>();
          recordIdCount = recordIds.length;
        } else if (isAudioSelect) {
          voiceIds = results['metaId'].cast<String>();

          voiceIdCount = voiceIds.length;
        } else if (isNotesSelect) {
          notesId = results['metaId'].cast<String>();

          notesIdCount = notesId.length;
        }
        print(recordIdCount);
        setState(() {});
        print(metaIds.toString());
      }
    });
  }

  Future<AssociateRecordsResponse> associateRecords(
      String doctorId, String userId, List<String> healthRecords) async {
    AssociateRecordsResponse associateResponseList = await providerViewModel
        .associateRecords(doctorId, userId, healthRecords);

    return associateResponseList;
  }
}
