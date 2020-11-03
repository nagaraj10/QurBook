import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

import 'package:myfhb/widgets/GradientAppBar.dart';

import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';

class EachDeviceValues extends StatelessWidget {
  EachDeviceValues({this.device_name});
  final String device_name;
  @override
  Widget build(BuildContext context) {
    DevicesViewModel _devicesmodel = Provider.of<DevicesViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getStringValue(),
        ),
        flexibleSpace: GradientAppBar(),
      ),
      body: Container(
        color: Color(0xFFDCDCDC),
        child: Column(
          children: [
            Container(
              height: 10.0,
            ),
            Expanded(
              child: getValues(context, _devicesmodel),
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedDateTime(String datetime) {
    print(datetime.toString());
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate =
        DateFormat('MMM d, yyyy').format(dateTimeStamp);
    return formattedDate;
  }

  String getFormattedTime(String datetime) {
    print(datetime.toString());
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate =
    DateFormat('h:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    switch (device_name) {
      case strDataTypeBP:
        {
          return FutureBuilder<List<BPResult>>(
              future: devicesViewModel.fetchBPDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
                List<BPResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: translist.length,
                        itemBuilder: (context, i) {
                          return buildRow(
                              translist[i].sourceType,
                              getFormattedDateTime(translist[i].startDateTime),
                              '${translist[i].systolic}',
                              '${translist[i].diastolic}',
                              '',
                              'Systolic',
                              'Diastolic',
                              '',getFormattedTime(translist[i].startDateTime));
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strGlusoceLevel:
        {
          return FutureBuilder(
              future: devicesViewModel.fetchGLDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
                List<GVResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: translist.length,
                        itemBuilder: (context, i) {
                          return buildRowForGulcose(
                              translist[i].sourceType,
                              getFormattedDateTime(translist[i].startDateTime),
                              '${translist[i].bloodGlucoseLevel}',
                              translist[i].mealContext == null
                                  ? 'Not Provided'
                                  : '${translist[i].mealContext}',
                              translist[i].mealType == null
                                  ? 'Not Provided'
                                  : '${translist[i].mealType}',
                              '${translist[i].bgUnit}',
                              'Meal Context',
                              'Meal Type',getFormattedTime(translist[i].startDateTime));
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strOxgenSaturation:
        {
          return FutureBuilder(
              future: devicesViewModel.fetchOXYDetails(''),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
                List<OxyResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: translist.length,
                        itemBuilder: (context, i) {
                          return buildRow(
                              translist[i].sourceType,
                              getFormattedDateTime(translist[i].startDateTime),
                              '${translist[i].oxygenSaturation}',
                              '',
                              '',
                              'OxygenSaturation Value',
                              '',
                              '',getFormattedTime(translist[i].startDateTime));
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strWeight:
        {
          return FutureBuilder(
              future: devicesViewModel.fetchWVDetails(''),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
                List<WVResult> translist = snapshot.data;
                //devicesViewModel.fetchWVDetails(snapshot.data.toString());
                return !translist.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: translist.length,
                        itemBuilder: (context, i) {
                          return buildRow(
                              translist[i].sourceType,
                              getFormattedDateTime(translist[i].startDateTime),
                              '${translist[i].weight}',
                              '',
                              '',
                              '${translist[i].weightUnit}',
                              '',
                              '',getFormattedTime(translist[i].startDateTime));
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strTemperature:
        {
          return FutureBuilder<List<TMPResult>>(
              future: devicesViewModel.fetchTMPDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
                List<TMPResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: translist.length,
                        itemBuilder: (context, i) {
                          return buildRow(
                              translist[i].sourceType,
                              getFormattedDateTime(translist[i].startDateTime),
                              '${translist[i].temperature}',
                              '',
                              '',
                              '${translist[i].temperatureUnit}',
                              '',
                              '',getFormattedTime(translist[i].startDateTime));
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
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
      case strDataTypeBP:
        {
          return strBPTitle;
        }
        break;
      case strGlusoceLevel:
        {
          return strGLTitle;
        }
        break;
      case strOxgenSaturation:
        {
          return strOxyTitle;
        }
        break;
      case strWeight:
        {
          return strWgTitle;
        }
        break;
      case strTemperature:
        {
          return strTmpTitle;
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
    String value3, String valuename1, String valuename2, String valuename3,time) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      height: 90,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              type == null ? Icons.device_unknown : TypeIcon(type),
              SizedBox(
                width: 20,
              ),
              valuename1!=''?Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      valuename1,
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      value1 == '' ? '' : value1,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ):SizedBox(),
              valuename2!=''?Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      valuename2 == '' ? '' : valuename2,
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
              ):SizedBox(),
              valuename3!=''?Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text(
                      valuename3 == '' ? '' : valuename3,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ):SizedBox(),
              Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          time,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildRowForGulcose(String type, String date, String value1, String value2,
    String value3, String valuename1, String valuename2, String valuename3,time) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      height: 100,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 2.0,
                ),
                type == null ? Icons.device_unknown : TypeIcon(type),
                SizedBox(
                  width: 6.0,
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
                      value1 == '' ? '' : value1,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 6.0,
                ),
                Column(
                  children: [
                    Text(
                      valuename2 == '' ? '' : valuename2,
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
                  width: 6.0,
                ),
                Column(
                  children: [
                    Text(
                      valuename3 == '' ? '' : valuename3,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 6.0,
                ),
                Column(
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey,fontSize: 10),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey,fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /* Row(
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
          )*/
        ],
      ),
    ),
  );
}

Widget TypeIcon(String type) {
  if (type == strsourceHK) {
    return Image.asset(
      'assets/devices/fit.png',
      height: 40.0,
      width: 40.0,
    );
  } else if (type == strsourceGoogle) {
    return Image.asset(
      'assets/settings/googlefit.png',
      height: 40.0,
      width: 40.0,
    );
  } else if (type == strsourceSheela) {
    return Image.asset(
      'assets/maya/maya_us.png',
      height: 40.0,
      width: 40.0,
    );
  }
}
