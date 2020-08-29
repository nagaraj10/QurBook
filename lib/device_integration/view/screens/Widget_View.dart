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
    );
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    return FutureBuilder<DevResult>(
        future: devicesViewModel.fetchDeviceDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            deviceValues = snapshot.data;

            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: finalList.length,
                itemBuilder: (context, i) {
                  return Container(
                      child: projectWidget(context, finalList[i]));
                });
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
    
    
    if (deviceData.value_name ==parameters.strDataTypeBP) {
      dateTimeStamp = deviceValues.bloodPressure.entities[0].lastsyncdatetime;
      date = DateFormat(parameters.strDateYMD,variable.strenUs).format(dateTimeStamp)
      + " " +DateFormat(parameters.strTimeHMS,variable.strenUs).format(dateTimeStamp) ;
      devicevalue1 = deviceValues.bloodPressure.entities[0].systolic.toString();
      devicevalue2 =
          deviceValues.bloodPressure.entities[0].diastolic.toString();
      return getDeviceData(
          context, date, devicevalue1, devicevalue2, deviceData);
    } else if (deviceData.value_name ==  parameters.strGlusoceLevel) {
      dateTimeStamp = deviceValues.bloodGlucose.entities[0].lastsyncdatetime;
       date = DateFormat(parameters.strDateYMD,variable.strenUs).format(dateTimeStamp)
      + " " +DateFormat(parameters.strTimeHMS,variable.strenUs).format(dateTimeStamp) ;
      devicevalue1 =
          deviceValues.bloodGlucose.entities[0].bloodGlucoseLevel.toString();
      return getDeviceData(context, date, devicevalue1, '', deviceData);
    } else if (deviceData.value_name == parameters.strOxgenSaturation) {
      dateTimeStamp =
          deviceValues.oxygenSaturation.entities[0].lastsyncdatetime;
           date = DateFormat(parameters.strDateYMD,variable.strenUs).format(dateTimeStamp)
      + " " +DateFormat(parameters.strTimeHMS,variable.strenUs).format(dateTimeStamp) ;
      devicevalue1 =
          deviceValues.oxygenSaturation.entities[0].oxygenSaturation.toString();
      return getDeviceData(context, date, devicevalue1, '', deviceData);
    } else if (deviceData.value_name == parameters.strTemperature) {
      dateTimeStamp =
          deviceValues.bodyTemperature.entities[0].lastsyncdatetime;
           date = DateFormat(parameters.strDateYMD,variable.strenUs).format(dateTimeStamp)
      + " " +DateFormat(parameters.strTimeHMS,variable.strenUs).format(dateTimeStamp) ;
      devicevalue1 =
          deviceValues.bodyTemperature.entities[0].temperature.toString();
      return getDeviceData(context, date, devicevalue1, '', deviceData);
    } else if(deviceData.value_name == parameters.strWeight){
      dateTimeStamp = deviceValues.bodyWeight.entities[0].lastsyncdatetime;
       date = DateFormat(parameters.strDateYMD,variable.strenUs).format(dateTimeStamp)
      + " " +DateFormat(parameters.strTimeHMS,variable.strenUs).format(dateTimeStamp) ;
      devicevalue1 = deviceValues.bodyWeight.entities[0].weight.toString();
      return getDeviceData(context, date, devicevalue1, '', deviceData);
    }
    //}
  }

  Widget getDeviceData(BuildContext context, String date, String value1,
      String value2, DeviceData deviceData) {
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
                            device_name: deviceData.value_name,
                          ),
                        )),
              );
            },
            child: Container(
              width: 220,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: deviceData.color,
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
                          deviceData.icon,
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
                                parameters.strLatestTitle,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                              deviceData.value1,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            Text(
                              value1.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              deviceData.value2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                            Text(
                              value2.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
