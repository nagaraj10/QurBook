import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

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
                if (!translist.isEmpty) {
                  return ListView.builder(
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
                  );
                } else {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
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
                if (translist.isEmpty) {
                  return ListView.builder(
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
                  );
                } else {
                  new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
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
                    : new Center(
                        child: new CircularProgressIndicator(
                          backgroundColor: Colors.grey,
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
                type == null ? Icons.device_unknown : TypeIcon(type),
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
                      value1 == null ? '' : value1,
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
                      valuename2 == null ? '' : value1,
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
