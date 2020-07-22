import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';

class GridViewNew extends StatefulWidget {

  List<Slots> dateTimingsSlot;
  final int rowPosition;
  final int selectedRow;
  Function(int,int) onSelected;

  GridViewNew(this.dateTimingsSlot,this.rowPosition,this.onSelected,this.selectedRow);

  @override
  State<StatefulWidget> createState() {
    return _GridViewNew();
  }
}

class _GridViewNew extends State<GridViewNew> {

  int _selectedIndex = -1;
  int rowPosition = -1;
  CommonWidgets commonWidgets = new CommonWidgets();
  CommonUtil commonUtil = new CommonUtil();


  _onSelected(int index,int positionFinal) {

    rowPosition = positionFinal;
    _selectedIndex = index;
    setState(() => _selectedIndex = index);

    widget.onSelected(rowPosition,_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      childAspectRatio: 2.0,
      children: List.generate(widget.dateTimingsSlot.length, (index) {
        return GestureDetector(
          onTap: (){
            _onSelected(index,widget.rowPosition);
          },
          child:getSpecificSlots(commonUtil.removeLastThreeDigits(widget.dateTimingsSlot[index].startTime),index),
        );
      }),
    );
  }


  Widget getSpecificSlots(String time,int index) {
    return Container(
      width: 35,
      decoration: myBoxDecoration(index),
      child: Center(
        child: Text(commonUtil.removeLastThreeDigits(widget.dateTimingsSlot[index].startTime),
          style:
          TextStyle(fontSize: fhbStyles.fnt_date_slot, color:
          _selectedIndex != null && _selectedIndex == index && widget.rowPosition == widget.selectedRow
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
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      color: _selectedIndex != null && _selectedIndex == index && widget.rowPosition == widget.selectedRow
          ? Color(new CommonUtil().getMyPrimaryColor())
          : Colors.white,
    );
  }

}


