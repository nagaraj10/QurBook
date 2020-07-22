import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/BadgesBlue.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/showAlertDialog.dart';
import 'package:gmiwidgetspackage/widgets/IconButtonWidget.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/models/FamilyMembersResponse.dart';
import 'package:myfhb/my_family/models/ProfileData.dart';
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/MyProviders.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

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


  final List<ProfileData> _familyNames = new List();

  String slotNumber='',slotTime='';
  ProfileData selectedUser;
  var selectedId = '';

  @override
  void initState() {

    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();
     getSlotsTimeNumber();
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

  getSlotsTimeNumber(){

     slotTime = commonUtil.removeLastThreeDigits(widget.sessionData[widget.rowPosition].slots[widget.itemPosition].startTime);
     slotNumber = widget.sessionData[widget.rowPosition].slots[widget.itemPosition].slotNumber.toString();

  }

  Widget getFamilyMembers() {
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
          PreferenceUtil.saveFamilyData(
              Constants.KEY_FAMILYMEMBER, snapshot.data.response.data);
          return snapshot.data!=null&&snapshot.data.response.data.sharedbyme.length>0?Container(
            child: dropDownButton(snapshot.data.response.data.sharedbyme),
          ):getFamilyMembers();
        }
      },
    );
  }

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
              Text("Please Choose", style: TextStyle(fontSize: 12)),
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
                Text('The Appointment is for',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          SizedBoxWidget(
            height: 8.0,
          ),
          PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null
              ? dropDownButton(
              PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER).sharedbyme):getFamilyMembers(),
          SizedBoxWidget(
            height: 10.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                TextWidget(
                  text: 'Date & Time',
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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        title: getTitle('Confirmation Details'),
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
                            Text('Pre Consulting Details',
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
                                        iconPath: NOTES_ICON_LINK,
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
                                    text: 'Add Notes',
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
                                        iconPath: VOICE_ICON_LINK,
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
                                    text: 'Add Voice',
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
                                        iconPath: RECORDS_ICON_LINK,
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
                                    text: 'Records',
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
                                        iconPath: DEVICE_ICON_LINK,
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
                                    text: 'Device Readings',
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
                    text: 'Pay INR 350',
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
                        Fluttertoast.showToast(
                      msg: "Under Maintenance..",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue[800],
                      textColor: Colors.white,
                      fontSize: 14.0
                  );
                      },
                      child: TextWidget(text: 'Pay Now', fontsize: 12),
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
                      Expanded(
                        child: commonWidgets
                            .getTextForDoctors('${widget.docs[widget.i].name}'),
                      ),

                      //commonWidgets.getSizeBoxWidth(10.0),
                      /* commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.info,
                          onTap: () {
                            print('on Info pressed');
                            commonWidgets.showDoctorDetailView(
                                widget.docs[widget.i], context);
                          }),*/
                    ],
                  )),
                  /*widget.docs[widget.i].isActive
                      ? commonWidgets.getIcon(
                          width: fhbStyles.imageWidth,
                          height: fhbStyles.imageHeight,
                          icon: Icons.check_circle,
                          onTap: () {
                            print('on check  pressed');
                          })
                      : SizedBox(),*/
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
