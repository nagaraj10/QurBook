import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:myfhb/common/CommonUtil.dart';

import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/view/screens/getDevice_Values.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/device_integration/model/DeviceValue.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class ShowDevicesNew extends StatefulWidget {
  @override
  _ShowDevicesNewState createState() => _ShowDevicesNewState();
}

class _ShowDevicesNewState extends State<ShowDevicesNew> {
  DevicesViewModel devicesViewModel;

  DevResult chartData;
  DevResult devicesList;
  DevResult deviceValues;
  List<DeviceData> finalList;

  String date;
  String time;
  DateTime dateTimeStamp;
  var devicevalue1;
  var devicevalue2;
  @override
  void initState() {
    finalList = new List();
    finalList = CommonUtil().getDeviceList();
    super.initState();
  }

  Widget build(BuildContext context) {
    finalList = CommonUtil().getDeviceList();
    print("Refresh and updated the devices list");
    return getBody(context);
    /*Stack(
      children: <Widget>[
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: getBody(context))
      ],
    );*/
  }

  Widget getBody(BuildContext context) {
    DevicesViewModel _devicesmodel = Provider.of<DevicesViewModel>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      child: getValues(context, _devicesmodel),
      /*
      child: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: getValues(context, _devicesmodel),
          ),
        ],
      ),
      */
    );
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    return FutureBuilder<DevResult>(
        future: devicesViewModel.fetchDeviceDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            deviceValues = snapshot.data;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                verticalDirection: VerticalDirection.down,
                spacing: 10,
                runSpacing: 10,
                children: getDeviceCards(context, finalList),
              ),
            );

            /*
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: finalList.length,
                              itemBuilder: (context, i) {
                                return Container(child: projectWidget(context, finalList[i]));
                              });
                              */
          } else {
            return new Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            );
          }
        });
  }

  Widget projectWidget(BuildContext context, DeviceData deviceData) {
    if (deviceValues.toString() == null) {
      print('device Values is empty reload to get data');
      return new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.grey,
        ),
      );
    }

    switch (deviceData.value_name) {
      case parameters.strDataTypeBP:
        {
          if (deviceValues.bloodPressure.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.bloodPressure.entities[0].lastsyncdatetime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";

            devicevalue1 =
                deviceValues.bloodPressure.entities[0].systolic.toString();
            devicevalue2 =
                deviceValues.bloodPressure.entities[0].diastolic.toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, devicevalue2, deviceData);
        }
      case parameters.strGlusoceLevel:
        {
          if (deviceValues.bloodGlucose.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.bloodGlucose.entities[0].lastsyncdatetime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 = deviceValues
                .bloodGlucose.entities[0].bloodGlucoseLevel
                .toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
      case parameters.strOxgenSaturation:
        {
          if (deviceValues.oxygenSaturation.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.oxygenSaturation.entities[0].lastsyncdatetime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 = deviceValues
                .oxygenSaturation.entities[0].oxygenSaturation
                .toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
      case parameters.strTemperature:
        {
          if (deviceValues.bodyTemperature.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.bodyTemperature.entities[0].lastsyncdatetime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 =
                deviceValues.bodyTemperature.entities[0].temperature.toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
      case parameters.strWeight:
        {
          if (deviceValues.bodyWeight.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.bodyWeight.entities[0].lastsyncdatetime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 =
                deviceValues.bodyWeight.entities[0].weight.toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
    }
    //}
  }

  Widget getDeviceData(BuildContext context, String date, String time,
      String value1, String value2, DeviceData deviceData) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                        create: (context) => DevicesViewModel(),
                        child: EachDeviceValues(
                          device_name: deviceData.value_name,
                        ),
                      )),
            );
          },
          child: Container(
            width: 180,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: deviceData.color)
                //color: Colors.white,
                ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              date,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white70),
                            )
                          ],
                        ),
                      ),
                      Image.asset(
                        deviceData.icon,
                        height: 32.0,
                        width: 32.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            deviceData.value1,
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          Text(
                            value1.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          deviceData.value2 != ''
                              ? Text(
                                  deviceData.value2,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11),
                                )
                              : SizedBox(
                                  width: 0,
                                ),
                          value2.toString() != ''
                              ? Text(
                                  value2.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                )
                              : SizedBox(
                                  width: 0,
                                ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  getDeviceCards(BuildContext context, List<DeviceData> finalList) {
    List<Widget> deviceCards = [];

    for (int i = 0; i < finalList.length; i++) {
      deviceCards.add(projectWidget(context, finalList[i]));
    }

    return deviceCards;
  }
}
