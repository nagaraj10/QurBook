import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myfhb/add_providers/models/add_providers_arguments.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/search_providers/bloc/labs_list_block.dart';
import 'package:myfhb/search_providers/models/doctors_data.dart';
import 'package:myfhb/search_providers/models/hospital_data.dart';
import 'package:myfhb/search_providers/models/lab_data.dart';
import 'package:myfhb/search_providers/models/labs_list_response.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

import '../bloc/doctors_list_block.dart';
import '../bloc/hospital_list_block.dart';
import '../models/doctors_list_response.dart';
import '../models/hospital_list_response.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

export '../models/hospital_list_response.dart';

class SearchSpecificList extends StatefulWidget {
  SearchArguments arguments;

  bool toPreviousScreen;
  SearchSpecificList({this.arguments, this.toPreviousScreen});

  @override
  State<StatefulWidget> createState() {
    return SearchSpecificListState();
  }
}

class SearchSpecificListState extends State<SearchSpecificList> {
  HealthReportListForUserBlock _healthReportListForUserBlock;

  DoctorsListBlock _doctorsListBlock;

  HospitalListBlock _hospitalListBlock;

  LabsListBlock _labsListBlock;

  TextEditingController _textFieldController =
      new TextEditingController(text: '');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String value;

  @override
  void initState() {
    super.initState();

    _doctorsListBlock = new DoctorsListBlock();
    _hospitalListBlock = new HospitalListBlock();
    _labsListBlock = new LabsListBlock();

    _healthReportListForUserBlock = new HealthReportListForUserBlock();

    value = _textFieldController.text.toString();
    
    if (value != '') {
      _doctorsListBlock.getDoctorsList(
          _textFieldController.text.toString() == null
              ? ''
              : _textFieldController.text.toString());
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          flexibleSpace: GradientAppBar(),
        
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context, [1]);
            },
          ),
          title: Text('${widget.arguments.searchWord} Search')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Column(
        children: <Widget>[
          new Container(
            //margin: EdgeInsets.all(5),
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                controller: _textFieldController,
                autofocus: true,
                onChanged: (editedValue) {
                  value = editedValue;
                  widget.arguments.searchWord == CommonConstants.doctors
                      ? _doctorsListBlock.getDoctorsList(value)
                      : widget.arguments.searchWord == CommonConstants.hospitals
                          ? _hospitalListBlock.getHospitalList(value)
                          : _labsListBlock.getLabsList(value);
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
                    Color(new CommonUtil().getMyPrimaryColor()),
                    Color(new CommonUtil().getMyGredientColor())
                  ],
                  stops: [
                    0.3,
                    1
                  ]),
            ),
            padding: new EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          ),
          new Expanded(
              child: value == ''
                  ? getEmptyCard()
                  : widget.arguments.searchWord == CommonConstants.doctors
                      ? getResponseFromApiWidgetForDoctors()
                      : widget.arguments.searchWord == CommonConstants.hospitals
                          ? getResponseFromApiWidgetForHospital()
                          : getResponseFromApiWidgetForLabs()),
        ],
      ),
    );
  }

  Widget getResponseFromApiWidgetForDoctors() {

    return StreamBuilder<ApiResponse<DoctorsListResponse>>(
      stream: _doctorsListBlock.doctorsStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<DoctorsListResponse>> snapshot) {
        if (!snapshot.hasData) return Container();

        switch (snapshot.data.status) {
          case Status.LOADING:
            rebuildBlockObject();
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),),
              width: 30,
              height: 30,
            ));

            break;

          case Status.ERROR:
            rebuildBlockObject();
            return Text('', style: TextStyle(color: Colors.red));
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
        if (!snapshot.hasData) return Container();

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

  Widget getResponseFromApiWidgetForLabs() {
    return StreamBuilder<ApiResponse<LabsListResponse>>(
      stream: _labsListBlock.labStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<LabsListResponse>> snapshot) {
        if (!snapshot.hasData) return Container();

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
                    child:
                        getAllDatasInLabsList(snapshot.data.data.response.data),
                    margin: EdgeInsets.all(5),
                  );
            break;

          default:
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

    _labsListBlock = null;
    _labsListBlock = new LabsListBlock();
  }

  Widget getEmptyCard() {
    return value.length > 0
        ? SingleChildScrollView(
            child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Image.asset(ImageUrlUtils.fileImg, width: 65, height: 90),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Add',
                        style: new TextStyle(
                          color: ColorUtils.blackcolor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(width: 5),
                    Text(value,
                        style: new TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
                SizedBox(height: 10),
                _showAddButton()
              ],
            )),
            color: Colors.white,
          ))
        : Container();
  }

  Future<void> _refresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 300));
  }

  Widget _showAddButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: _addBtnTapped,
      child: new Container(
        width: 100,
        height: 40.0,
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.all(Radius.circular(25.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: new Center(
          child: new Text(
            'Add',
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return new Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: loginButtonWithGesture);
  }

  Widget getAllDatasInDoctorsList(List<DoctorsData> data) {
    
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: data != null
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      data[i].name,
                      data[i].addressLine1,
                      data[i].id,
                      '',
                      data[i],
                      HospitalData(),
                      LabData()),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: Color(fhbColors.bgColorContainer),
            ),
    );
  }

  getAllDatasInHospitalList(List<HospitalData> data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: data != null
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      data[i].name,
                      data[i].addressLine1,
                      data[i].id,
                      data[i].logo == null ? '' : data[i].logo,
                      DoctorsData(),
                      data[i],
                      LabData()),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: Color(fhbColors.bgColorContainer),
            ),
    );
  }

  Widget getAllDatasInLabsList(List<LabData> data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: data != null
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      data[i].name,
                      data[i].addressLine1,
                      data[i].id,
                      '',
                      DoctorsData(),
                      HospitalData(),
                      data[i]),
                ),
                itemCount: data.length,
              ))
          : Container(
              child: Center(
                child: Text('No Data Available'),
              ),
              color: Color(fhbColors.bgColorContainer),
            ),
    );
  }

  Widget getCardToDisplaySearchList(String name, String address, String id,
      String logo, DoctorsData data, HospitalData hospitalData, LabData labData) {
    return GestureDetector(
        child: Padding(
            padding:
                new EdgeInsets.only(top: 0, bottom: 4, left: 10, right: 10),
            child: Container(
                padding: EdgeInsets.only(bottom: 2.0),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  ClipOval(
                      child: Container(
                    height: 50,
                    width: 50,
                    color: Color(fhbColors.bgColorContainer),
                    child:
                        widget.arguments.searchWord == CommonConstants.doctors
                            ? getDoctorProfileImageWidget(id)
                            : getHospitalLogoImage(logo),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: getDataToView(
                            widget.arguments.searchWord ==
                                    CommonConstants.doctors
                                ? data.name
                                : widget.arguments.searchWord ==
                                        CommonConstants.hospitals
                                    ? hospitalData.name
                                    : labData.name,
                            address,
                            id),
                      ))
                ]))),
        onTap: () {
          if (widget.toPreviousScreen) {
            widget.arguments.searchWord == CommonConstants.doctors
                ? passDoctorsValue(data, context)
                : widget.arguments.searchWord == CommonConstants.hospitals
                    ? passHospitalValue(hospitalData, context)
                    : passLaboratoryValue(labData, context);
          } else {
            passdataToNextScreen(
                data.name, context, data, hospitalData, labData);
          }
        }
        );
  }

  getCorrespondingImageWidget(String id) {
    return Icon(Icons.verified_user);
  }

  void passDoctorsValue(DoctorsData doctorData, BuildContext context) {
    Navigator.of(context).pop({'doctor': json.encode(doctorData)});
  }

  void passHospitalValue(HospitalData hospitaData, BuildContext context) {
    Navigator.of(context).pop({'hospital': json.encode(hospitaData)});
  }

  void passLaboratoryValue(LabData laboratoryData, BuildContext context) {
    Navigator.of(context).pop({'laborartory': json.encode(laboratoryData)});
  }

  getDataToView(String name, String address, String id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          name != null ? name : '',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: ColorUtils.blackcolor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 10),
        Text(
          address != null ? address : '',
          style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: ColorUtils.lightgraycolor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  getDoctorProfileImageWidget(String id) {
    return FutureBuilder(
      future: _healthReportListForUserBlock.getProfilePic(id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          );
        } else {
          return ImageIcon(
            AssetImage('assets/icons/stetho.png'),
            size: 40,
            color: Color(CommonUtil().getMyPrimaryColor()),
          );
        }
      },
    );
  }

  Widget getHospitalLogoImage(String logo) {
    if (logo == null || logo == '') {
      return Container();
    } else {
      return Image.network(
        Constants.BASE_URL + logo,
      );
    }
  }

  void passdataToNextScreen(String name, BuildContext context, DoctorsData data,
      HospitalData hospitalData, LabData labData) {
    if (widget.arguments.searchWord == CommonConstants.doctors) {
      Navigator.pushNamed(
        context,
        '/add-providers',
        arguments: AddProvidersArguments(
            data: data, searchKeyWord: CommonConstants.doctors, hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    } else if (widget.arguments.searchWord == CommonConstants.hospitals) {
      Navigator.pushNamed(
        context,
        '/add-providers',
        arguments: AddProvidersArguments(
            hospitalData: hospitalData,
            searchKeyWord: CommonConstants.hospitals,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    } else {
      Navigator.pushNamed(
        context,
        '/add-providers',
        arguments: AddProvidersArguments(
            labData: labData,
            searchKeyWord: CommonConstants.labs,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    }
  }
  void _addBtnTapped() {
    Navigator.pushNamed(context, '/add-providers',
            arguments: AddProvidersArguments(
                searchText: value,
                fromClass: widget.arguments.fromClass == 'add_providers'
                    ? widget.arguments.fromClass
                    : CommonConstants.serach_specific_list,
                searchKeyWord: widget.arguments.searchWord ==
                        CommonConstants.doctors
                    ? CommonConstants.doctors
                    : widget.arguments.searchWord == CommonConstants.hospitals
                        ? CommonConstants.hospitals
                        : CommonConstants.labs,
                hasData: false))
        .then((results) {
      if (results != null) {
        widget.arguments.searchWord == CommonConstants.doctors
            ? passDoctorsValueSample(results, context)
            : widget.arguments.searchWord == CommonConstants.hospitals
                ? passHospitalValueSample(results, context)
                : passLaboratoryValueSample(results, context);
      }
    });
    //  );
  }

  passDoctorsValueSample(dynamic results, BuildContext context) {
    DoctorsData jsonDecodeForDoctor = results['doctor'];

    passDoctorsValue(jsonDecodeForDoctor, context);
  }

  passHospitalValueSample(dynamic results, BuildContext context) {
    HospitalData jsonDecodeForDoctor = results['hospital'];

    passHospitalValue(jsonDecodeForDoctor, context);
  }

  passLaboratoryValueSample(dynamic results, BuildContext context) {
    
    LabData jsonDecodeForDoctor = results['laborartory'];

    passLaboratoryValue(jsonDecodeForDoctor, context);
  }
}
