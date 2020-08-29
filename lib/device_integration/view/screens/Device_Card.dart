import 'package:flutter/material.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';

class DeviceCard extends StatefulWidget {
  final DeviceData deviceData;
  final Key key;
  final ValueChanged<bool> isSelected;
  DeviceCard({this.deviceData, this.isSelected, this.key});
  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Color colors = Colors.white;
  bool isSelected; 
  @override
  Widget build(BuildContext context) {
    isSelected = widget.deviceData.isSelected;
    return InkWell(
      onTap: () {
        setState(() 
        {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Image.asset(
                    widget.deviceData.icon,
                    height: 30.0,
                    width: 30.0,
                  ),
                  isSelected
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.blue,
                          ),
                        )
                      : Container()
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.deviceData.title,
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
