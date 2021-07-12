import 'package:flutter/material.dart';

class RoundedCheckBox extends StatefulWidget {
  final Function() onCheck;
  bool isSelected;

  RoundedCheckBox(this.onCheck,this.isSelected);

  @override
  _RoundedCheckBoxState createState() => _RoundedCheckBoxState();
}

class _RoundedCheckBoxState extends State<RoundedCheckBox> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InkWell(
      onTap: () {
        widget.onCheck();
        setState(() {
          _value = widget.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _value ? Colors.teal[300] : Colors.white,
            border: Border.all(color: _value?Colors.teal[300]:Colors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: _value
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
