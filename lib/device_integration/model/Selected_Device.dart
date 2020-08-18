import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/DeviceValue.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/view/screens/getDevice_Values.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:provider/provider.dart';

class SelectedDevice extends StatefulWidget {
  SelectedDevice({this.deviceData, this.deviceValues});
  DeviceData deviceData;
  DevResult deviceValues;
  @override
  _SelectedDeviceState createState() => _SelectedDeviceState();
}

class _SelectedDeviceState extends State<SelectedDevice> {
  var date;
  var devicevalue1;
  var devicevalue2;
  @override
  Widget build(BuildContext context) {
    return Container(child: projectWidget(context));
  }

  Widget projectWidget(BuildContext context) {
    //print(widget.deviceValues.length);
    //for (int i = 0; i < widget.deviceValues.length; i++) {
    if (widget.deviceData.value_name == strBP) {
      date = widget.deviceValues.bloodPressure.entities[0].lastsyncdatetime;
      devicevalue1 = widget.deviceValues.bloodPressure.entities[0].systolic;
      devicevalue2 = widget.deviceValues.bloodPressure.entities[0].diastolic;
      return getDeviceData(date, devicevalue1, devicevalue2);
    } else if (widget.deviceData.value_name == strBGlucose) {
      date = widget.deviceValues.bloodGlucose.entities[0].lastsyncdatetime;
      /* devicevalue1 =
            widget.deviceValues[1].bloodGlucose.entities[0].bloodGlucoseLevel;*/
      return getDeviceData(date, devicevalue1, '');
    } else if (widget.deviceData.value_name == strOxygen) {
      date = widget.deviceValues.oxygenSaturation.entities[0].lastsyncdatetime;
      devicevalue1 =
          widget.deviceValues.oxygenSaturation.entities[0].oxygenSaturation;
      return getDeviceData(date, devicevalue1, '');
    } else if (widget.deviceData.value_name == strTemp) {
      date = widget.deviceValues.bodyTemperature.entities[0].lastsyncdatetime;
      devicevalue1 =
          widget.deviceValues.bodyTemperature.entities[0].temperature;
      return getDeviceData(date, devicevalue1, '');
    } else {
      date = widget.deviceValues.bodyWeight.entities[0].lastsyncdatetime;
      devicevalue1 = widget.deviceValues.bodyWeight.entities[0].weight;
      return getDeviceData(date, devicevalue1, '');
    }
    //}
  }

  Widget getDeviceData(String date, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (context) => DevicesViewModel(),
                          child: EachDeviceValues(
                            device_name: widget.deviceData.value_name,
                          ),
                        )),
              );
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.deviceData.color,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          widget.deviceData.icon,
                          height: 30.0,
                          width: 30.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Last Readings',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              widget.deviceData.value1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            Text(
                              value1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              widget.deviceData.value2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            Text(
                              value2,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                        /* Column(
                          children: [
                            Text(
                              'Pul',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            Text(
                              '99.0',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  )
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.deviceData.title,
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
