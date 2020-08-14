import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myfhb/device_integration/model/BPValues_Screen.dart';
import 'package:myfhb/device_integration/model/GulcoseValues_Screen.dart';
import 'package:myfhb/device_integration/model/OxySaturation_Values.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/Values_Screen.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class EachDeviceValues extends StatelessWidget {
  EachDeviceValues({this.device_name});
  final String device_name;
  @override
  Widget build(BuildContext context) {
    DevicesViewModel _devicesmodel = Provider.of<DevicesViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Container(
        color: Color(0xFFDCDCDC),
        child: Column(
          children: [
            SizedBox(
              height: 5.0,
            ),
            Container(
                height: 50.0,
                color: Colors.lightBlueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getStringValue() + ' ' + 'Chart',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(
                      Icons.refresh,
                      color: Colors.black87,
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Today July 08th',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: getValues(context, _devicesmodel),
            ),
          ],
        ),
      ),
    );
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    switch (device_name) {
      case 'bloodPressure':
        {
          return FutureBuilder(
              future:
                  DefaultAssetBundle.of(context).loadString('assets/BPValues'),
              builder: (context, snapshot) {
                List<BPResult> translist =
                    devicesViewModel.fetchBPDetails(snapshot.data.toString());
                return !translist.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: translist.length,
                        itemBuilder: (context, i) {
                          return buildRow(
                              translist[i].sourceType,
                              translist[i].startDateTime,
                              '${translist[i].systolic}',
                              '${translist[i].diastolic}',
                              'Systolic',
                              'Diastolic');
                        },
                      )
                    : new Center(child: new CircularProgressIndicator());
              });
        }
        break;
      case 'bloodGlucose':
        {
          return FutureBuilder(
              future:
              DefaultAssetBundle.of(context).loadString('assets/glucose'),
              builder: (context, snapshot) {
                List<GVResult> translist =
                devicesViewModel.fetchGLDetails(snapshot.data.toString());
                return !translist.isEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: translist.length,
                  itemBuilder: (context, i) {
                    return buildRow(
                        translist[i].sourceType,
                        translist[i].startDateTime,
                        '${translist[i].bloodGlucoseLevel}',
                        '',
                        'mg/dL',
                        '');
                  },
                )
                    : new Center(child: new CircularProgressIndicator());
              });
        }
        break;
      case 'oxygenSaturation':
        {
          return FutureBuilder(
              future:
              DefaultAssetBundle.of(context).loadString('assets/oxysat'),
              builder: (context, snapshot) {
                List<OxyResult> translist =
                devicesViewModel.fetchOXYDetails(snapshot.data.toString());
                return !translist.isEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: translist.length,
                  itemBuilder: (context, i) {
                    return buildRow(
                        translist[i].sourceType,
                        translist[i].startDateTime,
                        '${translist[i].oxygenSaturation}',
                        '',
                        'OxygenSaturation Value',
                        '');
                  },
                )
                    : new Center(child: new CircularProgressIndicator());
              });
        }
        break;
      case 'bodyWeight':
        {
          return FutureBuilder(
              future:
              DefaultAssetBundle.of(context).loadString('assets/WeightValues'),
              builder: (context, snapshot) {
                List<WVResult> translist =
                devicesViewModel.fetchWVDetails(snapshot.data.toString());
                return !translist.isEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: translist.length,
                  itemBuilder: (context, i) {
                    return buildRow(
                        translist[i].sourceType,
                        translist[i].startDateTime,
                        '${translist[i].weight}',
                        '',
                        'KG',
                        '');
                  },
                )
                    : new Center(child: new CircularProgressIndicator());
              });
        }
        break;
      case 'bodyTemperature':
        {
          return FutureBuilder(
              future:
              DefaultAssetBundle.of(context).loadString('assets/bodytemp'),
              builder: (context, snapshot) {
                List<TMPResult> translist =
                devicesViewModel.fetchTMPDetails(snapshot.data.toString());
                return !translist.isEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: translist.length,
                  itemBuilder: (context, i) {
                    return buildRow(
                        translist[i].sourceType,
                        translist[i].startDateTime,
                        '${translist[i].temperature}',
                        '',
                        'F',
                        '');
                  },
                )
                    : new Center(child: new CircularProgressIndicator());
              });
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  getStringValue() {
    switch (device_name) {
      case 'bloodPressure':
        {
          return 'BP Readings';
        }
        break;
      case 'bloodGlucose':
        {
          return 'Glucose Readings';
        }
        break;
      case 'oxygenSaturation':
        {
          return 'Sugar Readings';
        }
        break;
      case 'bodyWeight':
        {
          return 'Weight Values';
        }
        break;
      case 'bodyTemperature':
        {
          return 'Temperature Readings';
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }
}

Widget buildRow(String type, String date, String value1, String value2,
    String valuename1, String valuename2) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TypeIcon(type),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Text(
                      valuename1,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      value1,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Text(
                      valuename2,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      value2,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                /*Column(
                  children: [
                    Text(
                      values.title3,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      values.value3,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),*/
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 5.0,
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget TypeIcon(String type) {
  print(type);
  if (type == 'Apple Health') {
    return Image.asset(
      'assets/fit.png',
      height: 40.0,
      width: 40.0,
    );
  } else if (type == 'Google Fit') {
    return Image.asset(
      'assets/settings/googlefit.png',
      height: 40.0,
      width: 40.0,
    );
  }
}
