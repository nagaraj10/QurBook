import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/device_integration/model/DeviceValue.dart';
import 'package:myfhb/device_integration/model/Selected_Device.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ShowDevices extends StatefulWidget {
  final List<DeviceData> lists1;
  final DevResult lists2;

  ShowDevices({this.lists1, this.lists2});
  @override
  _ShowDevicesState createState() => _ShowDevicesState();
}

class _ShowDevicesState extends State<ShowDevices> {
  DevResult chartData;
  DevResult devicesList;
  DevicesViewModel devicesViewModel;

  @override
  void initState() {
    // TODO: implement initState
    //devicesList = List();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    devicesViewModel = Provider.of<DevicesViewModel>(context);
    //print(devicesList.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Devices'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: Container(
                    height: 150,
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.lists1.length,
                      itemBuilder: (context, i) {
                        return SelectedDevice(
                          deviceData: widget.lists1[i],
                          deviceValues: widget.lists2,
                        );
                      },
                    ))),
          ],
        ),
      ),
    );
  }
}
