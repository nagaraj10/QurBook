import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/IconButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyData.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/BookAppointmentModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/BookAppointmentOld.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/DoctorIds.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/telehealth/features/Payment/payment_page.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:progress_dialog/progress_dialog.dart';


class BookingConfirmation extends StatefulWidget {
  final List<DoctorIds> docs;
  final int i;
  final DateTime selectedDate;
  final List<SessionsTime> sessionData;
  final int rowPosition;
  final int itemPosition;

  BookingConfirmation({this.docs, this.i, this.selectedDate,this.sessionData,this.rowPosition,this.itemPosition});

  @override
  BookingConfirmationState createState() => BookingConfirmationState();
}

class BookingConfirmationState extends State<BookingConfirmation> {
  //final GlobalKey<State> _key = new GlobalKey<State>();
  CommonWidgets commonWidgets = new CommonWidgets();
  CommonUtil commonUtil = new CommonUtil();
  MyProviderViewModel providerViewModel;
  FamilyListBloc _familyListBloc;
  FamilyMembersList familyMembersModel = new FamilyMembersList();
  List<Sharedbyme> sharedbyme = new List();
  FlutterToast toast = new FlutterToast();
  FamilyData familyData = new FamilyData();


  final List<ProfileData> _familyNames = new List();

  String slotNumber='',slotTime='',createdBy='',createdFor='',doctorSessionId='',scheduleDate='';
  String apiStartTime='',apiEndTime='';
  ProfileData selectedUser;
  var selectedId = '';
  ProgressDialog pr;

  @override
  void initState() {

    providerViewModel = new MyProviderViewModel();

     createdBy = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
     selectedId = createdBy;
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();
     getDataFromWidget();
  }

  Future<FamilyMembersList> getList() async {
    _familyListBloc.getFamilyMembersList().then((familyMembersList) {
     familyMembersModel = familyMembersList;

     for(int i = 0;i<familyMembersModel.response.data.sharedbyme.length;i++){
       sharedbyme.add(familyMembersModel.response.data.sharedbyme[i]);
     }

    });

    return familyMembersModel;
  }

  getDataFromWidget(){

     slotTime = commonUtil.removeLastThreeDigits(widget.sessionData[widget.rowPosition].slots[widget.itemPosition].startTime);
     apiStartTime = widget.sessionData[widget.rowPosition].slots[widget.itemPosition].startTime;
     apiEndTime = widget.sessionData[widget.rowPosition].slots[widget.itemPosition].endTime;
     slotNumber = widget.sessionData[widget.rowPosition].slots[widget.itemPosition].slotNumber.toString();
     doctorSessionId = widget.sessionData[widget.rowPosition].doctorSessionId;
     scheduleDate = commonUtil.dateConversionToApiFormat(widget.selectedDate).toString();

  }

  Widget getDropdown() {
    return StreamBuilder<ApiResponse<FamilyMembersList>>(
      stream: _familyListBloc.familyMemberListStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<FamilyMembersList>> snapshot) {
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
              familyData = snapshot.data.data.response.data;

              print(familyData.sharedbyme.length.toString());

              PreferenceUtil.saveFamilyData(
                  Constants.KEY_FAMILYMEMBER, snapshot.data.data.response.data);
              return dropDownButton(snapshot.data.data.response.data.sharedbyme);
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

    if(_familyNames.length==0){

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
              Text(parameters.pleaseChoose, style: TextStyle(fontSize: 12)),
            ],
          ),
          items: _familyNames
              .map((ProfileData user) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        SizedBoxWidget(width: 20),
                        Text(user.name, style: TextStyle(fontSize: 12)),
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
              familyData.sharedbyme):*/getDropdown(),
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
                      text: slotTime!=null?slotTime:'0.00',
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
                            text: slotNumber!=null?slotNumber:'0',
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
        message: 'Redirecting',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SizedBox(
          child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Color(0xff138fcf)),
          height: 20.0,
          width: 20.0,
        ),
        elevation: 6.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w600)
    );

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
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
                                        onPressed: () {},
                                      ),
                                    ),
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
                                        onPressed: () {},
                                      ),
                                    ),
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
                                        onPressed: () {},
                                      ),
                                    ),
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
                            Column(
                              children: <Widget>[
                                new Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    SizedBoxWithChild(
                                      height: 22.0,
                                      width: 22.0,
                                      child: IconButtonWidget(
                                        iconPath: Constants.DEVICE_ICON_LINK,
                                        size: 18.0,
                                        color: Colors.blue[800],
                                        padding: new EdgeInsets.all(1.0),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBoxWidget(height: 2.0),
                                TextWidget(
                                    text: parameters.deviceReading,
                                    fontsize: 8.0,
                                    colors: Colors.grey),
                              ],
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
                    text: 'Pay INR 120',
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
                      child: TextWidget(text: 'Cancel', fontsize: 12),
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
                      child: TextWidget(text: parameters.payNow, fontsize: 12),
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
                                  text: 'You are being re-directed to a secure third party site for payment',
                                  fontsize: 14,
                                  fontWeight: FontWeight.w500,
                                  colors: Colors.grey[600]),
                              SizedBoxWidget(height: 10,),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBoxWithChild(
                                    width: 90,
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
                                      child: TextWidget(text: 'Cancel', fontsize: 12),
                                    ),
                                  ),
                                  SizedBoxWithChild(
                                    width: 90,
                                    height: 40,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          side: BorderSide(color: Colors.blue[800])),
                                      color: Colors.transparent,
                                      textColor: Colors.blue[800],
                                      padding: EdgeInsets.all(8.0),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        bookAppointment(createdBy,selectedId,doctorSessionId,
                                            scheduleDate,apiStartTime,apiEndTime,slotNumber,"false","false");
                                      },
                                      child: TextWidget(text: 'Ok', fontsize: 12),
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

  ////NEW BOOKING APPOINTMENT API

  /*Future<BookAppointmentModel> bookAppointmentCall(String createdBy,String createdFor,String doctorSessionId,
      String scheduleDate,String slotNumber,String isMedicalShared,String isFollowUp) async {

    BookAppointmentModel bookAppointmentModel = await providerViewModel.putBookAppointment(createdBy,createdFor,doctorSessionId,
        scheduleDate,slotNumber,isMedicalShared,isFollowUp);

    return bookAppointmentModel;
  }


  bookAppointment(String createdBy,String createdFor,String doctorSessionId,String scheduleDate,
      String slotNumber,String isMedicalShared,String isFollowUp){

    bookAppointmentCall(createdBy,createdFor,doctorSessionId,
        scheduleDate,slotNumber,isMedicalShared,isFollowUp).then((value) {
          print(value.response);
      if(value.status==200 && value.success==true){
        toast.getToast('Your appointment has been booked... Go To Payment..',Colors.green);
      }else{
        print(value.response.toString());
        print(value.message);
        toast.getToast('Booking appointment failed.. Some went wrong!',Colors.red);
      }
    });

  }*/

  //////OLD API

  Future<BookAppointmentOld> bookAppointmentCall(String createdBy,String createdFor,String doctorSessionId,
      String scheduleDate,String startTime,String endTime,String slotNumber,String isMedicalShared,String isFollowUp) async {

    BookAppointmentOld bookAppointmentModel = await providerViewModel.putBookAppointment(createdBy,createdFor,doctorSessionId,
        scheduleDate,startTime,endTime,slotNumber,isMedicalShared,isFollowUp);

    return bookAppointmentModel;
  }


  bookAppointment(String createdBy,String createdFor,String doctorSessionId,String scheduleDate,String startTime,String endTime,
      String slotNumber,String isMedicalShared,String isFollowUp){

    setState(() {
      pr.show();
    });

    bookAppointmentCall(createdBy,createdFor,doctorSessionId,
        scheduleDate,startTime,endTime,slotNumber,isMedicalShared,isFollowUp).then((value) {
      if(value.status==200 && value.success==true && value.message=='Created a new  appointment(s) successfully'){
        pr.hide();
        goToPaymentPage();
      }else{
        pr.hide();
        toast.getToast('Booking appointment failed.. Some went wrong!',Colors.red);
      }
    });

  }

  goToPaymentPage(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage()));
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
                  widget.docs[widget.i].profilePicThumbnail,
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
                          commonWidgets.getTextForDoctors('${widget.docs[widget.i].name}'),
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
                      onTap: () {
                        
                      })
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
                  child: commonWidgets.getDoctoSpecialist(
                      '${widget.docs[widget.i].specialization}'),
                )
              ]),
              commonWidgets.getSizedBox(5.0),
              commonWidgets.getDoctorsAddress('${widget.docs[widget.i].city}')
            ],
          ),
        ),
      ],
    );
  }
}
