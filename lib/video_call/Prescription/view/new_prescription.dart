import 'dart:core';
import 'dart:ui';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/video_call/Prescription/model/prescription_medicines_model.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:provider/provider.dart';

import '../../utils/priscriptionConstants.dart';
import '../constants/prescription_constants.dart';
import 'popUpWidget.dart';

class NewPrescription extends StatefulWidget {
  final List<PrescriptionMedicines> duplicatedMedicines;
  bool isDuplicatedPrescription = false;
  NewPrescription(
      {Key key, this.duplicatedMedicines, this.isDuplicatedPrescription})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => NewPrescriptionState();
}

class NewPrescriptionState extends State<NewPrescription> {
  List<List<String>> schedule = new List();
  // String initial, second, third;
  bool status6 = false;
  var prescriptionMedicineCount = 0;
  // var medicationArray = [];
  var medicineList = List<PrescriptionMedicines>();

  var medicineNameTextController = TextEditingController();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    if (widget.isDuplicatedPrescription) {
      medicineList = widget.duplicatedMedicines;
    } else {
      widget.isDuplicatedPrescription = false;
    }
    //have a bool that will pass be the condition check between a new screen and a existing screen
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'New Prescription Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0.h),
                child: prescriptionAppBar()),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Consumer<CallStatus>(builder: (context, status, child) {
                    return Visibility(
                      visible: status.isCallAlive ? true : false,
                      child: InkWell(
                        child: Container(
                          height: 40.0.h,
                          color: Colors.green.withOpacity(0.9),
                          child: Center(
                            child: Text(
                              'Tap return to call',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0.sp,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          //todo return to call screen
                          Navigator.pop(context);
                        },
                        splashColor: Colors.white,
                      ),
                    );
                  }),
                  Container(
                    height: 20.0.h,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Image.asset(prescriptionImage),
                  ),
                  Container(
                    height: 5.0.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              prescriptionName,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              prescriptionname,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Text(
                          prescriptionDate,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 1.0.h,
                  ),
                  SizedBox(
                    height: 15.0.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              prescriptionGender,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(prescriptiongender,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              prescriptionAge,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(prescriptionage,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(prescriptionMobile,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(),
                            Text(prescriptionmobile,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w400))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 1.0.h,
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          itemBuilder: (context, position) {
                            // return medicineListItem(position);
                            return medicineListItem(position, medicineList);
                          },
                          itemCount: medicineList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        Container(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                medicineList.add(PrescriptionMedicines(
                                    schedule: PrescriptionMedicineSchedule(
                                        morning: '',
                                        afternoon: '',
                                        evening: '')));
                                // duplicatedMeds.add(medicineListItem(
                                //     prescriptionMedicineCount));
                                // prescriptionMedicineCount += 1;
                              });
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Color(
                                CommonUtil().getMyPrimaryColor(),
                              ),
                              size: 24.0.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            prescriptionNotes,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          width: 1.sw,
                          child: TextField(
                              maxLines: 10,
                              minLines: 1,
                              style: TextStyle(
                                  fontSize: 14.0.sp, color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 14.0.sp, color: Colors.grey),
                                  hintText: '$addNoteHint')),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Container(
                      height: 45.0.h,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Image.asset(
                        prescriptionSignature,
                        fit: BoxFit.contain,
                      )),
                  SizedBox(
                    height: 30.0.h,
                  ),
                  prescriptionButton('$prescribeButtonText'),
                ],
              ),
            )));
  }

  Widget medicineListItem(int pos, List<PrescriptionMedicines> medicine) {
    GlobalKey key = new GlobalKey();
    GlobalKey key1 = new GlobalKey();
    GlobalKey key2 = new GlobalKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20.0.h,
        ),
        tabletTextField('$medicineNameHint', medicineList[pos].medicineName),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              tabletIntakeSwitch(medicineList[pos].beforeOrAfterFood),
              daysField(medicineList[pos].days),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 10.0.w,
                  ),
                  GestureDetector(
                    key: key,
                    child: Container(
                        width: 20.0.w,
                        height: 15.0.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                width: 0.5.w)),
                        child: Text(
                          medicineList[pos].schedule.morning ?? "",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        alignment: Alignment.center),
                    onTap: () {
                      showMoreText(
                          pos, 0, medicineList[pos].schedule.morning, key);
                    },
                  ),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  GestureDetector(
                    key: key1,
                    child: Container(
                        width: 20.0.h,
                        height: 15.0.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                width: 0.5.w)),
                        child: Text(
                          medicineList[pos].schedule.afternoon ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        alignment: Alignment.center),
                    onTap: () {
                      showMoreText(
                          pos, 1, medicineList[pos].schedule.afternoon, key1);
                    },
                  ),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  GestureDetector(
                    key: key2,
                    child: Container(
                        width: 20.0.w,
                        height: 15.0.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                width: 0.5.w)),
                        child: Text(
                          medicineList[pos].schedule.evening ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        alignment: Alignment.center),
                    onTap: () {
                      showMoreText(
                          pos, 2, medicineList[pos].schedule.evening, key2);
                    },
                  ),
                ],
              ),
              quantityField(medicineList[pos].quantity),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      medicineList.removeAt(pos);
                    });
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 20.0.sp,
                  ))
            ]),
        medicationNotesField(medicineList[pos].notes),
      ],
    );
  }

  Widget medicationNotesField(text) {
    var textEditingController = TextEditingController(text: text);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
          height: 70.0.h,
          width: 1.sw * 0.9,
          child: TextField(
              controller: textEditingController,
              maxLines: null,
              expands: true,
              style: TextStyle(fontSize: 15.0.sp, color: Colors.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15.0.sp, color: Colors.grey),
                  hintText: '$addMedicineNoteHint'))),
    );
  }

  Widget quantityField(text) {
    var textEditingController = TextEditingController(text: text);
    return Container(
        width: 40.0.w,
        child: TextField(
          controller: textEditingController,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0.sp,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '$medicineQuantityHint',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15.0.sp,
              ),
              contentPadding: EdgeInsets.only(bottom: 5)),
        ));
  }

  Widget daysField(text) {
    var textEditingController = TextEditingController(text: text);
    return Container(
        width: 40.0.w,
        child: TextField(
          controller: textEditingController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0.sp,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '$numberOfDaysHint',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15.0.sp,
              ),
              contentPadding: EdgeInsets.only(bottom: 5)),
        ));
  }

  void showMoreText(medPosition, schedulePosition, text, Key) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        widget: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: Text(
                  '$scheduleOptionOne',
                  style: TextStyle(color: Colors.white, fontSize: 16.0.sp),
                ),
                onTap: () {
                  setState(() {
                    text = medicineList[medPosition].schedule.morning ?? "";
                    // text = '0';
                    // text == 'initial'
                    //     ? initial = '0'
                    //     : text == 'second' ? second = '0' : third = '0';
                  });
                  // print('0');
                },
              ),
              SizedBox(
                width: 8.0.w,
              ),
              Container(
                color: Colors.black,
                height: 15.0.h,
                width: 1.0.w,
              ),
              SizedBox(
                width: 8.0.w,
              ),
              GestureDetector(
                child: Text(
                  '$scheduleOptionTwo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0.sp,
                  ),
                ),
                onTap: () {
                  setState(() {
                    // text = '1';
                    text = medicineList[medPosition].schedule.afternoon ?? "";
                    // schedule[medPosition][schedulePosition] = '1';
                    // text = '1';
                    // schedule[medPosition][1] = '1';
                    // text == 'initial'
                    //     ? initial = '1'
                    //     : text == 'second' ? second = '1' : third = '1';
                  });
                },
              ),
              SizedBox(
                width: 8.0.w,
              ),
              Container(
                color: Colors.black,
                height: 15.0.h,
                width: 1.0.w,
              ),
              SizedBox(
                width: 8.0.w,
              ),
              GestureDetector(
                child: Text(
                  '$scheduleOptionThree',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0.sp,
                  ),
                ),
                onTap: () {
                  setState(() {
                    // text = '0.5';
                    text = medicineList[medPosition].schedule.evening ?? "";
                    // schedule[medPosition][2] = '0.5';
                    // text == 'initial'
                    //     ? initial = '0.5'
                    //     : text == 'second' ? second = '0.5' : third = '0.5';
                  });
                },
              )
            ],
          ),
        ),
        textStyle: TextStyle(color: Colors.black),
        height: 25.0.h,
        width: 96.0.w,
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        padding: EdgeInsets.all(4.0),
        borderRadius: BorderRadius.circular(5.0));

    /// show the popup for specific widget
    popup.show(
      widgetKey: Key,
    );
  }

  Widget prescriptionButton(buttonText) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
        ),
      ),
      onPressed: () {},
    );
  }

  Widget noUnderLineTextField(hint, text) {
    return TextField(
      controller: medicineNameTextController,
      autocorrect: true,
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15.0.sp,
        ),
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.0.sp,
      ),
    );
  }

  Widget tabletTextField(hintText, text) {
    return Container(
        height: 40.0.h, child: noUnderLineTextField(hintText, text));
  }

  Widget tabletIntakeSwitch(beforeOrAfter) {
    var status = beforeOrAfter == '$beforeFoodSwitchText' ? true : false;
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Container(
        width: 40.0.w,
        height: 18.0.h,
        child: FlutterSwitch(
          activeColor: Colors.grey.withOpacity(0.4),
          activeText: "$beforeFoodSwitchText",
          inactiveColor: Colors.grey.withOpacity(0.4),
          inactiveText: "$afterFoodSwitchText",
          value: status,
          toggleSize: 12.0.sp,
          valueFontSize: 10.0.sp,
          borderRadius: 30.0.sp,
          showOnOff: true,
          activeTextColor: Colors.black,
          inactiveTextColor: Colors.black,
          toggleColor: Color(CommonUtil().getMyPrimaryColor()),
          onToggle: (val) {
            setState(() {
              status6 = val;
            });
          },
        ),
      ),
    );
  }

  Widget prescriptionAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        flexibleSpace: SafeArea(
            child: Row(
          children: <Widget>[
            SizedBox(
              width: 15.0.w,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20.0.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0.h,
                ),
                Text(
                  '$testPatientName',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  '$testPatientID',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ],
            )
          ],
        )));
  }
}
