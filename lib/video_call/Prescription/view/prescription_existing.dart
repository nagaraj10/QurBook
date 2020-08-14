import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:myfhb/video_call/Prescription/model/prescription_medicines_model.dart';
import 'package:myfhb/video_call/Prescription/view/new_prescription.dart';

import '../../utils/priscriptionConstants.dart';
import '../constants/prescription_constants.dart';

class ExistingPrescription extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExistingPrescriptionState();
}

class ExistingPrescriptionState extends State<ExistingPrescription> {
  bool status1 = false;
  bool status2 = false;
  bool status5 = false;
  bool status6 = false;
  var prescriptionMedicineCount = 0;
  var mockMedicines = List<PrescriptionMedicinesList>();
  var meds = List<PrescriptionMedicines>();

  createMockUpMedicines() {
    var medication = {
      'status': 'success',
      'data': [
        {
          'medicineName': 'Brufen',
          'beforeOrAfterFood': 'BF',
          'days': '4',
          'schedule': {'morning': '0', 'afternoon': '0', 'evening': '0.5'},
          'quantity': '15',
          'notes': 'Please take brufen only when experiencing pain'
        },
        {
          'medicineName': 'Paracip',
          'beforeOrAfterFood': 'AF',
          'days': '4',
          'schedule': {'morning': '1', 'afternoon': '0.5', 'evening': '1'},
          'quantity': '5',
          'notes': 'take paracip on alternate days after food'
        },
        {
          'medicineName': 'Aspirin',
          'beforeOrAfterFood': 'BF',
          'days': '4',
          'schedule': {'morning': '0.5', 'afternoon': '0', 'evening': '0'},
          'quantity': '8',
          'notes': 'take aspirin when feeling light headed'
        },
        {
          'medicineName': 'Adderall',
          'beforeOrAfterFood': 'AF',
          'days': '4',
          'schedule': {'morning': '1', 'afternoon': '0', 'evening': '1'},
          'quantity': '4',
          'notes': 'use in moderation and do not overdose'
        }
      ]
    };
    mockMedicines.add(PrescriptionMedicinesList.fromJson(medication));

    mockMedicines.forEach((medicine) {
      medicine.medicines.forEach((med) {
        meds.add(med);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    createMockUpMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: prescriptionAppBar()),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Image.asset(prescriptionImage),
                  ),
                  Container(
                    height: 5,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              prescriptionname,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Text(
                          prescriptionDate,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: 15,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(prescriptiongender,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(prescriptionage,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(prescriptionMobile,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(),
                            Text(prescriptionmobile,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 1,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 75,
                          child: Text(
                            prescriptionName,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
//                      SizedBoxWidget(
//                          width: MediaQuery.of(context).size.width * 0.12),
                        Text(
                          bfaf,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
//                      SizedBoxWidget(
//                          width: MediaQuery.of(context).size.width * 0.04),
                        Text(
                          days,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          schedule,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          qty,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemBuilder: (context, position) {
                      return medicineListItem(meds, position, context);
                    },
                    itemCount: meds.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            prescriptionNotes,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(prescriptiondescription,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 45,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Image.asset(
                        prescriptionSignature,
                        fit: BoxFit.contain,
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      prescriptionButton(
                          '$createNewButtonText',
                          NewPrescription(
                            isDuplicatedPrescription: false,
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      prescriptionButton(
                          '$duplicateButtonText',
                          NewPrescription(
                            duplicatedMedicines: meds,
                            isDuplicatedPrescription: true,
                          )),
                    ],
                  )
                ],
              ),
            )));
  }

  Widget medicineListItem(
      List<PrescriptionMedicines> medsList, int pos, BuildContext ctxt) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5, top: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
//      SizedBoxWidget(
//        width: MediaQuery.of(context).size.width * 0.08,
//      ),
        // Text(''),
        Container(
            width: 75, //MediaQuery.of(context).size.width * 0.2,
            child: Text(
              medsList[pos].medicineName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            )),
//      SizedBoxWidget(
//        width: 8,
//      ),
        tabletIntakeSwitch(meds[pos].beforeOrAfterFood),
//      SizedBoxWidget(
//        width: 20,
//      ),
        Text(
          meds[pos].days,
          textAlign: TextAlign.end,
          style: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
        ),
//      SizedBoxWidget(
//        width: 15,
//      ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              child: Container(
                  width: 20,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Color(0xff138fcf), width: 0.5)),
                  child: Text(
                    medsList[pos].schedule.morning,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  alignment: Alignment.center),
              onTap: () {},
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              child: Container(
                  width: 20,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Color(0xff138fcf), width: 0.5)),
                  child: Text(
                    medsList[pos].schedule.morning,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  alignment: Alignment.center),
              onTap: () {},
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              child: Container(
                  width: 20,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Color(0xff138fcf), width: 0.5)),
                  child: Text(
                    medsList[pos].schedule.morning,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  alignment: Alignment.center),
              onTap: () {},
            ),
          ],
        ),

        Text(
          medsList[pos].quantity,
          style: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ]),
    );
  }

  Widget prescriptionButton(buttonText, NewPrescription newPrescription) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Color(0xff138fcf))),
      child: Text(
        buttonText,
        style: TextStyle(color: Color(0xff138fcf)),
      ),
      onPressed: () {
        // Navigator.of(context).
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return newPrescription;
        }));
      },
    );
  }

  Widget noUnderLineTextField(medString) {
    return TextFormField(
      initialValue: medString,
      autocorrect: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white70,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget tabletTextField(medName) {
    return Container(
        height: 30,
        width: MediaQuery.of(context).size.width * 0.3,
        child: noUnderLineTextField(medName));
  }

  Widget tabletIntakeSwitch(beforeOrAfter) {
    var status = beforeOrAfter == '$beforeFoodSwitchText' ? true : false;

    return Stack(
      children: <Widget>[
        Container(
          width: 40,
          height: 23,
          child: FlutterSwitch(
            activeColor: Colors.grey.withOpacity(0.4),
            activeText: "$beforeFoodSwitchText",
            inactiveText: "$afterFoodSwitchText",
            value: status,
            inactiveColor: Colors.grey.withOpacity(0.4),
            toggleSize: 10,
            valueFontSize: 10.0,
            borderRadius: 30.0,
            showOnOff: true,
            activeTextColor: Colors.black,
            inactiveTextColor: Colors.black,
            toggleColor: Color(0xff138fcf),
            onToggle: (val) {
              setState(() {
                status6 = val;
              });
            },
          ),
        ),
        Container(
          width: 50,
          height: 23,
          color: Colors.transparent,
        )
      ],
    );
  }
  // Widget tabletIntakeSwitch(beforeOrAfter) {
  //   var status = beforeOrAfter == 'BF' ? true : false;

  //   return Container(
  //     width: 40,
  //     height: 23,
  //     child: FlutterSwitch(
  //       activeColor: Colors.grey.withOpacity(0.4),
  //       activeText: "BF",
  //       inactiveText: "AF",
  //       value: status,
  //       inactiveColor: Colors.grey.withOpacity(0.4),
  //       toggleSize: 10,
  //       valueFontSize: 10.0,
  //       borderRadius: 30.0,
  //       showOnOff: true,
  //       activeTextColor: Colors.black,
  //       inactiveTextColor: Colors.black,
  //       toggleColor: Color(0xff138fcf),
  //       onToggle: (val) {
  //         setState(() {
  //           status6 = val;
  //           status6 == true ? print('After food') : print('before food');
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget prescriptionAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff138fcf),
        flexibleSpace: SafeArea(
            child: Row(
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  '$testPatientName',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  '$testPatientID',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ],
            )
          ],
        )));
  }
}
