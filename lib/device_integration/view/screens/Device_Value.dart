import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/ui/bot/view/ChatScreen.dart';
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

class EachDeviceValues extends StatefulWidget {
  EachDeviceValues(
      {this.device_name, this.device_icon, this.sheelaRequestString});

  final String device_name;
  final String device_icon;
  final String sheelaRequestString;

  @override
  _EachDeviceValuesState createState() => _EachDeviceValuesState();
}

class _EachDeviceValuesState extends State<EachDeviceValues> {
  @override
  Widget build(BuildContext context) {
    DevicesViewModel _devicesmodel = Provider.of<DevicesViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getStringValue(),
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          Image.asset(
            widget.device_icon,
            height: 40.0,
            width: 40.0,
          ),
          SizedBoxWidget(
            width: 15,
          )
        ],
        flexibleSpace: GradientAppBar(),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              height: 6.0,
            ),
            Expanded(
              child: getValues(context, _devicesmodel),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Image.asset(icon_mayaMain),
        iconSize: 60,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  sheelaInputs: widget.sheelaRequestString,
                );
              },
            ),
          ).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('d MMM yyyy').format(dateTimeStamp);
    return formattedDate;
  }

  String getFormattedTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('h:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    var todayDate = getFormattedDateTime(DateTime.now().toString());
    switch (widget.device_name) {
      case strDataTypeBP:
        {
          return FutureBuilder<List<BPResult>>(
              future: devicesViewModel.fetchBPDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }
                List<BPResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? GroupedListView<BPResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15),
                              Text(
                                todayDate != value ? value : 'Today, ' + value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForBp(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].systolic}',
                              '${translist[index].diastolic}',
                              '',
                              'Systolic',
                              'Diastolic',
                              '',
                              getFormattedTime(translist[index].startDateTime));
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
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }
                List<GVResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? GroupedListView<GVResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15),
                              Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForGulcose(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].bloodGlucoseLevel}',
                              translist[index].mealContext == null ||
                                      translist[index].mealContext == ''
                                  ? 'Random'
                                  : '${translist[index].mealContext}',
                              '',
                              'Blood Glucose',
                              'Meal Type',
                              '',
                              getFormattedTime(translist[index].startDateTime),
                              translist[index].bgUnit);
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
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }
                List<OxyResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? GroupedListView<OxyResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15),
                              Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForOxygen(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].oxygenSaturation}',
                              '',
                              '',
                              'Oxygen Saturation Value',
                              '',
                              '',
                              getFormattedTime(translist[index].startDateTime),
                              'bpm');
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
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }
                List<WVResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? GroupedListView<WVResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15),
                              Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForOxygen(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].weight}',
                              '',
                              '',
                              'Weight',
                              '',
                              '',
                              getFormattedTime(translist[index].startDateTime),
                              'Kgs');
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
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }
                List<TMPResult> translist = snapshot.data;
                return !translist.isEmpty
                    ? GroupedListView<TMPResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15),
                              Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForOxygen(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].temperature}',
                              '',
                              '',
                              'Temperature',
                              '',
                              '',
                              getFormattedTime(translist[index].startDateTime),
                              'Fahrenheit');
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
    switch (widget.device_name) {
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

Widget buildRowForBp(
    String type,
    String date,
    String value1,
    String value2,
    String value3,
    String valuename1,
    String valuename2,
    String valuename3,
    String time) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      height: 60,
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
              Column(
                children: [
                  Center(
                    child: Text(time,
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  type == null ? Icons.device_unknown : TypeIcon(type),
                ],
              ),
              SizedBox(
                width: 60,
              ),
              valuename1 != ''
                  ? Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            valuename1,
                            style: TextStyle(color: Colors.black, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                value1 == '' ? '' : value1,
                                style: TextStyle(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBoxWidget(
                                width: 2,
                              ),
                              Text(
                                value1 == '' ? '' : 'mm Hg',
                                style: TextStyle(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              valuename2 != ''
                  ? Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            valuename2 == '' ? '' : valuename2,
                            style: TextStyle(color: Colors.black, fontSize: 11),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                value2,
                                style: TextStyle(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBoxWidget(
                                width: 2,
                              ),
                              Text(
                                value1 == '' ? '' : 'mm Hg',
                                style: TextStyle(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                    fontSize: 9),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              /*valuename3 != ''
                  ? Expanded(
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
                    )
                  : SizedBox(),*/
              /*Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )),*/
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildRowForGulcose(
    String type,
    String date,
    String value1,
    String value2,
    String value3,
    String valuename1,
    String valuename2,
    String valuename3,
    String time,
    String unit) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      height: 60,
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
                  width: 8.0,
                ),
                Column(
                  children: [
                    Center(
                      child: Text(time,
                          style: TextStyle(color: Colors.grey, fontSize: 9)),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    type == null ? Icons.device_unknown : TypeIcon(type),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename1,
                      style: TextStyle(color: Colors.black, fontSize: 11),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          value1 == '' ? '' : value1,
                          style: TextStyle(
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBoxWidget(
                          width: 2,
                        ),
                        Text(
                          value1 == '' ? '' : unit,
                          style: TextStyle(
                              color:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              fontSize: 9),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: 18.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename2 == '' ? '' : valuename2,
                      style: TextStyle(color: Colors.black, fontSize: 11),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      value2,
                      style: TextStyle(
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  width: 18.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename3 == '' ? '' : valuename3,
                      style: TextStyle(color: Colors.black, fontSize: 11),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          fontSize: 12),
                    ),
                  ],
                ),
                /* SizedBox(
                  width: 6.0,
                ),
                Column(
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),*/
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

Widget buildRowForOxygen(
    String type,
    String date,
    String value1,
    String value2,
    String value3,
    String valuename1,
    String valuename2,
    String valuename3,
    String time,
    String unit) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0),
    child: Container(
      height: 60,
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
              Column(
                children: [
                  /*Container(
                    width: 42,
                    height: 14,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(new CommonUtil().getMyPrimaryColor()),
                              Color(new CommonUtil().getMyGredientColor())
                            ],
                            stops: [
                              0.3,
                              1.0
                            ])),
                    child: Center(
                      child: Text(time,
                          style: TextStyle(color: Colors.white, fontSize: 9)),
                    ),
                  ),*/
                  Center(
                    child: Text(time,
                        style: TextStyle(color: Colors.grey, fontSize: 9)),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  type == null ? Icons.device_unknown : TypeIcon(type),
                ],
              ),
              valuename1 != ''
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            valuename1,
                            style: TextStyle(color: Colors.black, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                value1 == '' ? '' : value1,
                                style: TextStyle(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBoxWidget(
                                width: 5,
                              ),
                              Text(
                                unit != '' ? unit : '',
                                style: TextStyle(
                                    color: Color(
                                        new CommonUtil().getMyPrimaryColor()),
                                    fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : SizedBoxWidget()
            ],
          ),
        ],
      ),
    ),
  );
}

Widget TypeIcon(String type) {
  if (type == strsourceHK) {
    return Image.asset(
      'assets/devices/fit.png',
      height: 32.0,
      width: 32.0,
    );
  } else if (type == strsourceGoogle) {
    return Image.asset(
      'assets/settings/googlefit.png',
      height: 32.0,
      width: 32.0,
    );
  } else if (type == strsourceSheela) {
    return Image.asset(
      'assets/maya/maya_us.png',
      height: 32.0,
      width: 32.0,
    );
  } else {
    return Image.asset(
      'assets/launcher/myfhb.png',
      height: 32.0,
      width: 32.0,
    );
  }
}
