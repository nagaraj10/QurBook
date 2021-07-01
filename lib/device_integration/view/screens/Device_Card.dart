import 'package:flutter/material.dart';
import 'Device_Data.dart';
import '../../../common/CommonUtil.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

class DeviceCard extends StatefulWidget {
  final DeviceData deviceData;
  @override
  final Key key;
  final ValueChanged<bool> isSelected;
  const DeviceCard({this.deviceData, this.isSelected, this.key});
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
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Image.asset(
                    widget.deviceData.icon,
                    height: 30.0.h,
                    width: 30.0.h,
                  ),
                  if (isSelected)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(new CommonUtil().getMyPrimaryColor()),
                      ),
                    )
                  else
                    Container()
                ],
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Row(
                children: [
                  Text(
                    widget.deviceData.title,
                    style: TextStyle(
                      fontSize: 13.0.sp,
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
