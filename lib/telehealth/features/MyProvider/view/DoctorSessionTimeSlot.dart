import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/DatePicker/date_picker_widget.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';

import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/MyProvider/viewModel/MyProviderViewModel.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/GetAllPatientsModel.dart';
import '../../SearchWidget/view/SearchWidget.dart';

import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';

import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class DoctorSessionTimeSlot extends StatefulWidget {

  final String doctorId;
  final String date;
  final List<DoctorIds> docs;
  final int i;

  DoctorSessionTimeSlot({this.doctorId,this.date,this.docs,this.i});

  @override
  State<StatefulWidget> createState() {
    return DoctorSessionTimeSlotState();
  }

}

class DoctorSessionTimeSlotState extends State<DoctorSessionTimeSlot> {
  MyProviderViewModel providerViewModel;
  CommonWidgets commonWidgets = new CommonWidgets();
  DateTime _selectedValue;
  DatePickerController _controller = DatePickerController();


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          height: 65,
          color: Colors.grey[200],
          child: DatePicker(
            DateTime.now().add(Duration(days: -0)),
            controller: _controller,
            width: 40,
            height: 45,
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(new CommonUtil().getMyPrimaryColor()),
            selectedTextColor: Colors.white,
            dayTextStyle: TextStyle(
                fontSize: fhbStyles.fnt_day, fontWeight: FontWeight.w600),
            dateTextStyle: TextStyle(
                fontSize: fhbStyles.fnt_date, fontWeight: FontWeight.w700),
            onDateChange: (date) {
              setState(() {
                _selectedValue = date;
              });
            },
          ),
        ),
        getTimeSlots(),
      ],
    );

  }

  Widget getTimeSlots(){

    providerViewModel = Provider.of<MyProviderViewModel>(context);

    return new FutureBuilder<SessionData>(
      future: providerViewModel.fetchTimeSlots(_selectedValue.toString(), widget.doctorId),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Center(
              child:
                  new Column(
                    children: <Widget>[
                      SizedBoxWidget(height: 20.0),
                      new SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Color(new CommonUtil().getMyPrimaryColor())),
                        height: 20.0,
                        width: 20.0,
                      ),
                      SizedBoxWidget(height: 120.0),
                    ],
                  )

            );
          } else if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          } else {
            print('check' + snapshot.data.toString());
            return Container(
              margin: EdgeInsets.only(left: 5, top: 12),
              child: Column(
                children: commonWidgets.getTimeSlots(snapshot.data,widget.docs,widget.i),
              ),
            );
          }
        } else {
          return new Text('No Slots');
        }
      },
    );

  }


}