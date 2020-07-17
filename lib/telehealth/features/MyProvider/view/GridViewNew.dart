import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';

class GridViewNew extends StatefulWidget {

  List<Slots> dateTimingsSlot;
  int rowPosition=0;
  GridViewNew(this.dateTimingsSlot,this.rowPosition);

  @override
  State<StatefulWidget> createState() {
    return _GridViewNew();
  }

}


class _GridViewNew extends State<GridViewNew> {

  int _selectedIndex = -1;
  int rowPosition = -1;
  CommonWidgets commonWidgets = new CommonWidgets();


  _onSelected(int index) {

    rowPosition = widget.rowPosition;

    print(rowPosition.toString());
    _selectedIndex = index;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 15,
      childAspectRatio: 2.2,
      children: List.generate(widget.dateTimingsSlot.length, (index) {
        return GestureDetector(
          onTap: (){
            _onSelected(index);
          },
          child:getSpecificSlots(removeLastThreeDigits(widget.dateTimingsSlot[index].startTime),index),
        );
      }),
    );
  }

  removeLastThreeDigits(String string){

    String removedString='';
    removedString = string.substring(0, string.length - 3);

    return removedString;
  }

  Widget getSpecificSlots(String time,int index) {
    return Container(
      width: 35,
      decoration: myBoxDecoration(index),
      child: Center(
        child: Text(removeLastThreeDigits(widget.dateTimingsSlot[index].startTime),
          style:
          TextStyle(fontSize: fhbStyles.fnt_date_slot, color:
          _selectedIndex != null && _selectedIndex == index && rowPosition==widget.rowPosition
              ? Colors.white
              : Colors.green),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration(int index) {
    return BoxDecoration(
      border: Border.all(
          width: 1, //
          color: Colors.green
      ),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      color: _selectedIndex != null && _selectedIndex == index && rowPosition==widget.rowPosition
          ? Color(new CommonUtil().getMyPrimaryColor())
          : Colors.white,
    );
  }

}


