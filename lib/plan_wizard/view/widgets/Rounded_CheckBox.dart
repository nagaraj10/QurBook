import 'package:flutter/material.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:provider/provider.dart';


class RoundedCheckBox extends StatelessWidget {
  bool isSelected;
  Function() onTap;

  RoundedCheckBox({this.isSelected,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.teal[300] : Colors.white,
            border: Border.all(color: isSelected?Colors.teal[300]:Colors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: isSelected
              ? Icon(
                  Icons.check,
                  size: 22.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  size: 22.0,
                  color: Colors.white,
                ),
        ),
      ),
    ));
  }
}
