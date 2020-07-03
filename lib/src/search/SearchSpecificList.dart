import 'package:flutter/material.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:shimmer/shimmer.dart';

import 'Doctors/DoctorsListBlock.dart';
import 'Doctors/DoctorsListResponse.dart';

import 'Hospitals/HospitalListBlock.dart';
import 'Hospitals/HospitalListResponse.dart';
export 'Hospitals/HospitalListResponse.dart';

import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'dart:convert';

class SearchSpecificList extends StatefulWidget {
  final String searchKeyWord;

  SearchSpecificList(this.searchKeyWord);

  @override
  SearchSpecificListState createState() => new SearchSpecificListState();
}

class SearchSpecificListState extends State<SearchSpecificList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  DoctorsListBlock _doctorsListBlock;

  HospitalListBlock _hospitalListBlock;
  TextEditingController _textFieldController =
      new TextEditingController(text: '');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String value;
  @override
  void initState() {
    _doctorsListBlock = new DoctorsListBlock();
    _hospitalListBlock = new HospitalListBlock();
    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    value = _textFieldController.text.toString();
    
    if (value != '') {
      _doctorsListBlock.getDoctorsList(
          _textFieldController.text.toString() == null
              ? ''
              : _textFieldController.text.toString());
    }
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  const Color(0XFF6717CD),
                  const Color(0XFF0A41A6)
                ],
                    stops: [
                  0.3,
                  1
                ])),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('${widget.searchKeyWord} Search')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Column(
        children: <Widget>[
          new Container(
            //margin: EdgeInsets.all(5),
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                controller: _textFieldController,
                onChanged: (editedValue) {
                  value = editedValue;
                  widget.searchKeyWord == 'Doctors'
                      ? _doctorsListBlock.getDoctorsList(value)
                      : _hospitalListBlock.getHospitalList(value);
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    const Color(0XFF6717CD),
                    const Color(0XFF0A41A6)
                  ],
                  stops: [
                    0.3,
                    1
                  ]),
              /* borderRadius: new BorderRadius.all(
                  new Radius.circular(30.0),
                ), */
              //border: Border.all(color: Colors.black),
              //color: Colors.white
            ),
            padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          ),
          new Expanded(
              child: value == ''
                  ? getEmptyCard()
                  : widget.searchKeyWord == 'Doctors'
                      ? getResponseFromApiWidgetForDoctors()
                      : getResponseFromApiWidgetForHospital()),
        ],
      ),
    );
  }

  Widget getResponseFromApiWidgetForDoctors() {
    

    return StreamBuilder<ApiResponse<DoctorsListResponse>>(
      stream: _doctorsListBlock.doctorsStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<DoctorsListResponse>> snapshot) {
        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 30,
              height: 30,
            ));

            break;

          case Status.ERROR:
            rebuildBlockObject();
            return Text('Unable To load Tabs',
                style: TextStyle(color: Colors.red));
            break;

          case Status.COMPLETED:
            rebuildBlockObject();
            return snapshot.data.data.response.count == 0
                ? getEmptyCard()
                : Container(
                    child: getAllDatasInDoctorsList(
                        snapshot.data.data.response.data),
                    margin: EdgeInsets.all(5),
                  );
            break;
        }
      },
    );
  }

  Widget getResponseFromApiWidgetForHospital() {
    
    return StreamBuilder<ApiResponse<HospitalListResponse>>(
      stream: _hospitalListBlock.hospitalStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<HospitalListResponse>> snapshot) {
        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 30,
              height: 30,
            ));

            break;

          case Status.ERROR:
            rebuildBlockObject();
            return Text('Unable To load Tabs',
                style: TextStyle(color: Colors.red));
            break;

          case Status.COMPLETED:
            rebuildBlockObject();
            return snapshot.data.data.response.count == 0
                ? getEmptyCard()
                : Container(
                    child: getAllDatasInHospitalList(
                        snapshot.data.data.response.data),
                    margin: EdgeInsets.all(5),
                  );
            break;
        }
      },
    );
  }

  void rebuildBlockObject() {
    _doctorsListBlock = null;
    _doctorsListBlock = new DoctorsListBlock();

    _hospitalListBlock = null;
    _hospitalListBlock = new HospitalListBlock();
  }

  Widget getEmptyCard() {
    return Container(
      child: Center(
        child: Text('No Data Available'),
      ),
      color: Colors.grey[300],
    );
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 300));
  }

  Widget getAllDatasInDoctorsList(List<DoctorsData> data) {
    

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: data != null
          ? Container(
              color: Colors.grey[300],
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchDoctorList(data[i]),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: Colors.grey[300],
            ),
    );
  }

  Widget getCardToDisplaySearchDoctorList(DoctorsData data) {
    return GestureDetector(
      child: Padding(
          padding: new EdgeInsets.only(top: 2, bottom: 2),
          child: Container(
              padding: EdgeInsets.all(2.0),
              margin: EdgeInsets.all(5),
              color: Colors.white,
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: getDoctorProfileImageWidget(data.id)),
                Expanded(
                    flex: 5,
                    child: getDataToView(data.name, data.addressLine1, data.id))
              ]))),
      onTap: () => passDoctorsValue(data, context),
    );
  }

  void passDoctorsValue(DoctorsData doctorData, BuildContext context) {
    Navigator.of(context).pop({'doctor': json.encode(doctorData)});
  }

  void passHospitalValue(HospitalData hospitaData, BuildContext context) {
    
    Navigator.of(context).pop({'hospital': json.encode(hospitaData)});
  }

  getCardToDisplaySearchHospitalList(HospitalData data) {
    return GestureDetector(
      child: Padding(
          padding: new EdgeInsets.only(top: 2, bottom: 2),
          child: Container(
              padding: EdgeInsets.all(2.0),
              margin: EdgeInsets.all(5),
              color: Colors.white,
              child: Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: getHospitalLogoImage(data.logo),
                ),
                Expanded(
                    flex: 5,
                    child: getDataToView(data.name, data.addressLine1, data.id))
              ]))),
      onTap: () {
        passHospitalValue(data, context);
      },
    );
  }

  Widget getCardToDisplaySearchList(
      String name, String address, String id, String logo) {
    return GestureDetector(
      child: Padding(
          padding: new EdgeInsets.only(top: 2, bottom: 2),
          child: Container(
              padding: EdgeInsets.all(2.0),
              margin: EdgeInsets.all(5),
              color: Colors.white,
              child: Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: widget.searchKeyWord == 'Doctors'
                      ? getDoctorProfileImageWidget(id)
                      : getHospitalLogoImage(logo),
                ),
                Expanded(flex: 5, child: getDataToView(name, address, id))
              ]))),
      onTap: () => passdataToPreviousScreen(name, context),
    );
  }

  getCorrespondingImageWidget(String id) {
    return Icon(Icons.verified_user);
  }

  getDataToView(String name, String address, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(name != null ? name : ''),
          padding: EdgeInsets.all(10),
        ),
        Container(
          child: Text(address != null ? address : ''),
          padding: EdgeInsets.all(10),
        )
      ],
    );
  }

  getDoctorProfileImageWidget(String id) {
    return FutureBuilder(
      future: _healthReportListForUserBlock.getProfilePic(id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else {
          return new SizedBox(
            width: 75.0,
            height: 75.0,
            child: Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[550],
                child:
                    Container(width: 50, height: 50, color: Colors.grey[200])),
          );
        }

        ///load until snapshot.hasData resolves to true
      },
    );
  }

  Widget getHospitalLogoImage(String logo) {
    if (logo == null || logo == '') {
      return Container();
    } else {
      return Image.network(
        Constants.BASERURL + logo,
      );
    }
  }

  getAllDatasInHospitalList(List<HospitalData> data) {
    

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: data != null
          ? Container(
              color: Colors.grey[300],
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchHospitalList(data[i]),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: Colors.grey[300],
            ),
    );
  }

  void passdataToPreviousScreen(String name, BuildContext context) {
    if (widget.searchKeyWord == 'Doctors') {
      Navigator.of(context).pop({'doctor': name});
    } else if (widget.searchKeyWord == 'Hospitals') {
      Navigator.of(context).pop({'hospital': name});
    }
  }
}
