import 'package:flutter/material.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Image.asset(
                    widget.deviceData.icon,
                    height: 30.0.h,
                    width: 30.0.h,
                  ),
                  isSelected
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                          ),
                        )
                      : Container()
                ],
              ),
              SizedBox(
                height: 5.0.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
