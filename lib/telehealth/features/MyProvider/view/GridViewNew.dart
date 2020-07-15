import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/DoctorTimeSlots.dart';
import 'package:myfhb/styles/styles.dart' as fhbStyles;
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';

class GridViewNew extends StatefulWidget {

  List<Slots> dateTimingsSlot;
  GridViewNew(this.dateTimingsSlot);

  @override
  State<StatefulWidget> createState() {
    return _GridViewNew();
  }

}


class _GridViewNew extends State<GridViewNew> {

  int _selectedIndex = -1;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 1.0,
      childAspectRatio: 1.5,
      children: List.generate(widget.dateTimingsSlot.length, (index) {
        return GestureDetector(
          onTap: (){
            _onSelected(index);
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _selectedIndex != null && _selectedIndex == index
                  ? Colors.blue
                  : Colors.white,
              border: Border.all(color: Colors.green),
              borderRadius: new BorderRadius.circular(5),
            ),
            child: Text(removeLastThreeDigits(widget.dateTimingsSlot[index].startTime),style: TextStyle(fontSize: fhbStyles.fntSlots),),
          ),
        );
      }),
    );
  }

  removeLastThreeDigits(String string){

    String removedString='';
    removedString = string.substring(0, string.length - 3);

    return removedString;
  }

}


