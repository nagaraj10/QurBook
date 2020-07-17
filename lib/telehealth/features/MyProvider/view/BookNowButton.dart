import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/BookingConfirmation.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class BookNowButton extends StatelessWidget{

  final List<DoctorIds> docs;
  final int i;

  BookNowButton({this.docs,this.i});

  @override
  Widget build(BuildContext context) {
    return  SizedBoxWithChild(
      width: 85,
      height: 35,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12.0),
            side: BorderSide(color: Color(new CommonUtil().getMyPrimaryColor()))),
        color: Colors.transparent,
        textColor: Color(new CommonUtil().getMyPrimaryColor()),
        padding: EdgeInsets.all(8.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorDetail(docs: docs,i: i)),
          );
        },
        child:
        TextWidget(text: 'Book Now', fontsize: 12),
      ),
    );

  }


}