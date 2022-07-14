import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart' as tckConstants;
import '../../widgets/GradientAppBar.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'my_tickets_screen.dart';
import '../../src/utils/FHBUtils.dart';
import '../../constants/variable_constant.dart' as variable;
import 'dart:convert';
import '../../../my_providers/models/UserAddressCollection.dart' as address;
import '../../constants/fhb_parameters.dart' as parameters;

class CreateTicketScreenNew extends StatefulWidget {
  CreateTicketScreenNew(this.ticketList);

  final TicketTypesResult ticketList;

  @override
  State createState() {
    return _CreateTicketScreenState();
  }
}

class _CreateTicketScreenState extends State<CreateTicketScreenNew> {
  TicketViewModel ticketViewModel = TicketViewModel();
  DateTime dateTime = DateTime.now();
  var preferredDateStr;

  final preferredDateController = TextEditingController(text: '');
  final titleController = TextEditingController();
  final descController = TextEditingController();
  FocusNode preferredDateFocus = FocusNode();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
  final controller = Get.put(CreateTicketController());
  Hospitals selectedLab;
  Doctors selectedDoctor;

  ProvidersBloc _providersBloc = ProvidersBloc();
  Future<MyProvidersResponse> _medicalPreferenceList;
  Future<MyProvidersResponse> _medicalhospitalPreferenceList;

  List<Doctors> doctorsListFromProvider;
  List<Doctors> copyOfdoctorsModel;

  List<Hospitals> hospitalListFromProvider;
  List<Hospitals> copyOfhospitalModel;
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  Doctors doctorObj;
  Hospitals hospitalObj;

  var doctorsData, hospitalData, labData;
  CommonWidgets commonWidgets = new CommonWidgets();
  TextEditingController doctor = TextEditingController();
  TextEditingController lab = TextEditingController();
  TextEditingController hospital = TextEditingController();
  bool isTxt = false,
      isDescription = false,
      isDoctor = false,
      isHospital = false,
      isPreferredDate = false,
      isFileUpload = false;

  bool isFirstTym = true;
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        dateTime = picked ?? dateTime;
        preferredDateStr =
            FHBUtils().getPreferredDateString(dateTime.toString());
        preferredDateController.text = preferredDateStr;
      });
    }
  }

  @override
  void initState() {
    try {
      super.initState();
      _getInitialDate(context);
      _medicalPreferenceList = _providersBloc.getMedicalPreferencesForDoctors();
      _medicalhospitalPreferenceList =
          _providersBloc.getMedicalPreferencesForHospital();
    } catch (e) {
      print(e);
    }

    setBooleanValues();
  }

  setBooleanValues() {
    if (widget.ticketList != null) {
      if (widget.ticketList.additionalInfo != null)
        for (Field field in widget.ticketList.additionalInfo?.field) {
          if (field.type == tckConstants.tckTypeTitle) {
            isTxt = true;
          }
          if (field.type == tckConstants.tckTypeDescription) {
            isDescription = true;
          }
          if (field.type == tckConstants.tckTypeDropdown && field.isDoctor) {
            isDoctor = true;
          }
          if (field.type == tckConstants.tckTypeDropdown && field.isHospital) {
            isHospital = true;
          }
          if (field.type == tckConstants.tckTypeDate) {
            isPreferredDate = true;
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(tckConstants.strAddMyTicket),
      ),
      body: Obx(
        () {
          return isFirstTym && controller.isCTLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              /* SizedBox(height: 20.h),
                              getWidgetForTitleText(),
                              SizedBox(height: 10.h),
                              getWidgetForTitleValue(),
                              SizedBox(height: 20.h),
                              getWidgetForTitleDescription(),
                              SizedBox(height: 10.h),
                              getWidgetForTitleDescriptionValue(),
                              SizedBox(height: 20.h),
                              getWidgetForLab(),
                              getWidgetForPreferredDate(),
                              SizedBox(height: 10.h),
                              getWidgetForPreferredDateValue(),*/
                              getColumnBody(widget.ticketList),
                              SizedBox(height: 25.h),
                              getWidgetForCreateButton()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget getColumnBody(TicketTypesResult ticketTypesResult) {
    List<Widget> widgetForColumn = List();
    if (ticketTypesResult.additionalInfo != null)
      for (Field field in ticketTypesResult.additionalInfo?.field) {
        field.type == tckConstants.tckTypeTitle
            ? widgetForColumn.add(Column(
                children: [
                  SizedBox(height: 20.h),
                  getWidgetForTitleText(),
                  SizedBox(height: 10.h),
                  getWidgetForTitleValue()
                ],
              ))
            : SizedBox();

        field.type == tckConstants.tckTypeDescription
            ? widgetForColumn.add(Column(
                children: [
                  SizedBox(height: 20.h),
                  getWidgetForTitleDescription(),
                  SizedBox(height: 10.h),
                  getWidgetForTitleDescriptionValue(),
                ],
              ))
            : SizedBox();

        (field.type == tckConstants.tckTypeDropdown && field.isDoctor)
            ? widgetForColumn.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: fhbBasicWidget.getTextFiledWithHint(
                        context, 'Choose Doctor', doctor,
                        enabled: false),
                  ),
                  Container(
                    height: 50,
                    child: doctorsListFromProvider != null
                        ? getDoctorDropDown(
                            doctorsListFromProvider,
                            doctorObj,
                            () {
                              Navigator.pop(context);
                              moveToSearchScreen(
                                  context, CommonConstants.keyDoctor,
                                  setState: setState);
                            },
                          )
                        : getAllCustomRoles(doctorObj, () {
                            Navigator.pop(context);
                            moveToSearchScreen(
                                context, CommonConstants.keyDoctor,
                                setState: setState);
                          }),
                  ),
                ],
              ))
            //widgetForColumn.add(getWidgetForDoctors())
            : SizedBox();
        widgetForColumn.add(SizedBox(
          height: 20,
        ));
        (field.type == tckConstants.tckTypeDropdown && field.isHospital)
            ? widgetForColumn.add(Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: fhbBasicWidget.getTextFiledWithHint(
                        context, 'Choose Hospital', hospital,
                        enabled: false),
                  ),
                  Container(
                    height: 50,
                    child: hospitalListFromProvider != null
                        ? getHospitalDropDown(
                            hospitalListFromProvider,
                            hospitalObj,
                            () {
                              Navigator.pop(context);
                              moveToSearchScreen(
                                  context, CommonConstants.keyDoctor,
                                  setState: setState);
                            },
                          )
                        : getAllHospitalRoles(hospitalObj, () {
                            Navigator.pop(context);
                            moveToSearchScreen(
                                context, CommonConstants.keyDoctor,
                                setState: setState);
                          }),
                  ),
                ],
              ))
            : SizedBox();

        (field.type == tckConstants.tckTypeDate)
            ? widgetForColumn.add(Column(
                children: [
                  getWidgetForPreferredDate(),
                  SizedBox(height: 10.h),
                  getWidgetForPreferredDateValue(),
                  SizedBox(height: 25.h),
                ],
              ))
            : SizedBox();

        isFirstTym = false;
      }
    return Column(children: widgetForColumn);
  }

  moveToSearchScreen(BuildContext context, String searchParam,
      {setState}) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => SearchSpecificList(
                  arguments: SearchArguments(
                    searchWord: searchParam,
                  ),
                  toPreviousScreen: true,
                  isSkipUnknown:
                      searchParam == CommonConstants.keyDoctor ? true : false,
                )))
        .then((results) {
      if (results != null) {
        if (results.containsKey(tckConstants.keyDoctor)) {
          doctorsData = json.decode(results[tckConstants.keyDoctor]);
          try {
            setValueToDoctorDropdown(doctorsData, setState);
          } catch (e) {}
        } else if (results.containsKey(tckConstants.keyHospital)) {
          hospitalData = json.decode(results[tckConstants.keyHospital]);
        } else if (results.containsKey(tckConstants.keyLab)) {
          labData = json.decode(results[tckConstants.keyLab]);
        }
      }
    });
  }

  void setValueToDoctorDropdown(doctorsData, Function onTextFinished) {
    final userAddressCollection3 = address.UserAddressCollection3(
        addressLine1: doctorsData[parameters.strAddressLine1],
        addressLine2: doctorsData[parameters.strAddressLine2]);
    final List<address.UserAddressCollection3> userAddressCollection3List = [];
    userAddressCollection3List.add(userAddressCollection3);
    final user = User(
        id: doctorsData[parameters.struserId],
        name: doctorsData[parameters.strName],
        firstName: doctorsData[parameters.strFirstName],
        lastName: doctorsData[parameters.strLastName],
        userAddressCollection3: userAddressCollection3List);

    doctorObj = Doctors(
        id: doctorsData[parameters.strDoctorId],
        specialization: doctorsData[parameters.strSpecilization],
        isTelehealthEnabled: doctorsData[parameters.strisTelehealthEnabled],
        isMciVerified: doctorsData[parameters.strisMCIVerified],
        user: user);

    doctorsListFromProvider.add(doctorObj);
    filterDuplicateDoctor();
    getDoctorDropDown(doctorsListFromProvider, doctorObj, onTextFinished);
  }

  Widget getWidgetForLab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //Lab Appointment
        controller.labBookAppointment.value
            ? Row(
                children: [
                  Text(tckConstants.strPreferredLab,
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ],
              )
            : SizedBox.shrink(),

        controller.labBookAppointment.value
            ? SizedBox(height: 10.h)
            : SizedBox.shrink(),

        controller.labBookAppointment.value
            ? dropDownButton(
                controller.labsList != null && controller.labsList.length > 0
                    ? controller.labsList
                    : [])
            : SizedBox.shrink(),

        controller.labBookAppointment.value &&
                controller.isPreferredLabDisable.value
            ? SizedBox(height: 5.h)
            : SizedBox.shrink(),

        controller.labBookAppointment.value &&
                controller.isPreferredLabDisable.value
            ? RichText(
                text: TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    children: [
                      TextSpan(
                          text: tckConstants
                              .strThereAreNoPreferredLabsInYourProfile,
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp)),
                    ]),
                maxLines: 1,
                textAlign: TextAlign.left,
              )
            : SizedBox.shrink(),

        controller.labBookAppointment.value
            ? SizedBox(height: 20.h)
            : SizedBox.shrink(),
      ],
    );
  }

  Widget getWidgetForCreateButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            FHBUtils().check().then((internet) {
              if (internet != null && internet) {
                _validateAndCreateTicket(context, widget.ticketList);
              } else {
                FHBBasicWidget().showInSnackBar(
                    tckConstants.STR_NO_CONNECTIVITY, scaffold_state);
              }
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(

                    // end: Alignment.topCenter,
                    stops: [0.3, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(CommonUtil().getMyPrimaryColor()),
                      Color(CommonUtil().getMyGredientColor()),
                    ])),
            child: Text(
              tckConstants.strSubmitNewTicket,
              style: TextStyle(
                  fontSize: 16.0.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget getWidgetForPreferredDateValue() {
    return Container(
      child: TextFormField(
        autofocus: false,
        enableInteractiveSelection: false,
        readOnly: true,
        controller: preferredDateController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            onPressed: () {
              _selectDate(context);
            },
            iconSize: 15,
            icon: ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) {
                return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(new CommonUtil().getMyPrimaryColor()),
                      Color(new CommonUtil().getMyGredientColor())
                    ]).createShader(bounds);
              },
              child: Image.asset(
                'assets/icons/05.png',
                // color: Color(CommonUtil().getMyPrimaryColor())
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(width: 0, color: Colors.white),
          ),
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(8.0),
            borderSide: BorderSide(color: getColorFromHex('#fffff')),
          ),
        ),
      ),
    );
  }

  Widget getWidgetForPreferredDate() {
    return Row(
      children: [
        Text(tckConstants.strTicketPreferredDate,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForTitleText() {
    return Row(
      children: [
        Text(tckConstants.strTicketTitle,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForTitleValue() {
    return TextField(
      autofocus: false,
      controller: titleController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 0, color: Colors.white),
        ),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(new CommonUtil().getMyPrimaryColor()),
          ),
        ),
      ),
    );
  }

  Widget getWidgetForTitleDescription() {
    return Row(
      children: [
        Text(tckConstants.strTicketDesc,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForTitleDescriptionValue() {
    return TextField(
      keyboardType: TextInputType.multiline,
      autofocus: false,
      maxLines: 10,
      controller: descController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(width: 0, color: Colors.white),
        ),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Color(new CommonUtil().getMyPrimaryColor()),
          ),
        ),
      ),
    );
  }

  void _validateAndCreateTicket(var context, var ticketListData) {
    try {
      if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("doctor appointment")) {
        if (isDoctor && doctor.text.isNotEmpty) {
          tckConstants.tckSelectedDoctor = doctor.text;
          if (isHospital && hospital.text.isNotEmpty) {
            tckConstants.tckSelectedHospital = hospital.text;

            if (isDescription && descController.text.isNotEmpty) {
              tckConstants.tckDesc = descController.text.toString();
              if (isPreferredDate && preferredDateController.text.isNotEmpty) {
                tckConstants.tckPrefDate =
                    preferredDateController.text.toString();
                commonMethodToCreateTicket(ticketListData);
              } else {
                showAlertMsg();
              }
            } else {
              showAlertMsg();
            }
          }
        } else {
          showAlertMsg();
        }
      } else if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("lab appointment")) {
        if (isTxt && titleController.text.isNotEmpty) {
          tckConstants.tckTitle = titleController.text.toString();
          if (isDescription && descController.text.isNotEmpty) {
            tckConstants.tckDesc = descController.text.toString();
            if (isPreferredDate && preferredDateController.text.isNotEmpty) {
              tckConstants.tckPrefDate =
                  preferredDateController.text.toString();
              commonMethodToCreateTicket(ticketListData);
            } else {
              showAlertMsg();
            }
          } else {
            showAlertMsg();
          }
        } else {
          showAlertMsg();
        }
      } else if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("general health")) {
        if (isTxt && titleController.text.isNotEmpty) {
          tckConstants.tckTitle = titleController.text.toString();
          if (isDescription && descController.text.isNotEmpty) {
            tckConstants.tckDesc = descController.text.toString();

            commonMethodToCreateTicket(ticketListData);
          } else {
            showAlertMsg();
          }
        } else {
          showAlertMsg();
        }
      } else if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("order presecription")) {
      } else if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("care/diet plan")) {}
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      print('Catch Error Occured : $error');
    }
  }

  void showAlertMsg() {
    Alert.displayAlert(context,
        title: variable.Error, content: CommonConstants.all_fields);
  }

  void _getInitialDate(BuildContext context) {
    preferredDateStr = FHBUtils().getPreferredDateString(dateTime.toString());
    preferredDateController.text = preferredDateStr;
  }

  Widget dropDownButton(List<Hospitals> labsList) {
    try {
      if (labsList.length > 0) {
        for (Hospitals selHospitals in labsList) {
          if (selHospitals.name == controller.selPrefLab.value) {
            selectedLab = selHospitals;
            controller.selPrefLabId.value =
                CommonUtil().validString(selHospitals.id);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return SizedBoxWithChild(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: IgnorePointer(
          ignoring: controller.isPreferredLabDisable.value,
          child: DropdownButton<Hospitals>(
            value: selectedLab,
            underline: SizedBox(),
            isExpanded: true,
            hint: Row(
              children: <Widget>[
                SizedBoxWidget(width: 20),
                Text(CommonUtil().validString(selectedLab.name),
                    style: TextStyle(
                      fontSize: 14.0.sp,
                    )),
              ],
            ),
            items: labsList
                .map((Hospitals currLab) => DropdownMenuItem(
                      child: Row(
                        children: <Widget>[
                          SizedBoxWidget(width: 20),
                          Text(CommonUtil().validString(currLab.name),
                              style: TextStyle(
                                fontSize: 14.0.sp,
                              )),
                        ],
                      ),
                      value: currLab,
                    ))
                .toList(),
            onChanged: (Hospitals currLab) {
              try {
                selectedLab = currLab;
                controller.selPrefLab.value =
                    CommonUtil().validString(currLab.name);
                controller.selPrefLabId.value =
                    CommonUtil().validString(currLab.id);
                setState(() {});
              } catch (e) {}
            },
          ),
        ),
      ),
    );
  }

  Widget dropDoctorDownButton(List<Doctors> doctorsList) {
    try {
      if (doctorsList.length > 0) {
        for (Doctors selDoctors in doctorsList) {
          if (selDoctors.user.name == controller.selPrefLab.value) {
            selectedDoctor = selDoctors;
            controller.selPrefDoctorId.value =
                CommonUtil().validString(selDoctors.id);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return SizedBoxWithChild(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: IgnorePointer(
          ignoring: controller.isPreferredLabDisable.value,
          child: DropdownButton<Doctors>(
            value: selectedDoctor,
            underline: SizedBox(),
            isExpanded: true,
            hint: Row(
              children: <Widget>[
                SizedBoxWidget(width: 20),
                Text(CommonUtil().validString(selectedDoctor.user.name),
                    style: TextStyle(
                      fontSize: 14.0.sp,
                    )),
              ],
            ),
            items: doctorsList
                .map((Doctors currDoc) => DropdownMenuItem(
                      child: Row(
                        children: <Widget>[
                          SizedBoxWidget(width: 20),
                          Text(CommonUtil().validString(currDoc.user.name),
                              style: TextStyle(
                                fontSize: 14.0.sp,
                              )),
                        ],
                      ),
                      value: currDoc,
                    ))
                .toList(),
            onChanged: (Doctors currDoc) {
              try {
                selectedDoctor = currDoc;
                controller.selPrefDoctor.value =
                    CommonUtil().validString(currDoc.user.name);
                controller.selPrefDoctorId.value =
                    CommonUtil().validString(currDoc.id);
                setState(() {});
              } catch (e) {}
            },
          ),
        ),
      ),
    );
  }

  Widget getAllCustomRoles(Doctors doctorObj, Function onAdd) {
    Widget familyWidget;

    if (_providersBloc != null) {
      _providersBloc = null;
      _providersBloc = new ProvidersBloc();
    }
    return FutureBuilder<MyProvidersResponse>(
      future: _providersBloc.getMedicalPreferencesForDoctors(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));
              break;
            case ConnectionState.active:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));
              break;

            case ConnectionState.none:
              familyWidget = Center(
                  child: Text(tckConstants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0.sp,
                      )));
              break;

            case ConnectionState.done:
              if (snapshot.data != null &&
                  snapshot.data != null &&
                  snapshot.data.result != null &&
                  snapshot.data.result.doctors != null &&
                  snapshot.data.result.doctors.isNotEmpty) {
                doctorsListFromProvider = snapshot.data.result.doctors;
                controller.isCTLoading = true.obs;
                filterDuplicateDoctor();
                familyWidget = getDoctorDropDown(
                  doctorsListFromProvider,
                  doctorObj,
                  onAdd,
                );
              } else {
                doctorsListFromProvider = List();
                familyWidget = getDoctorDropDownWhenNoList(
                    doctorsListFromProvider, null, onAdd);
              }

              return familyWidget;
              break;
          }
        } else {
          doctorsListFromProvider = [];
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );
  }

  void filterDuplicateDoctor() {
    if (doctorsListFromProvider.isNotEmpty) {
      copyOfdoctorsModel = doctorsListFromProvider;
      var ids = copyOfdoctorsModel.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel.retainWhere((x) => ids.remove(x?.user?.id));
      doctorsListFromProvider = copyOfdoctorsModel;
    }
  }

  void filterDuplicateHospital() {
    if (hospitalListFromProvider.isNotEmpty) {
      copyOfhospitalModel = hospitalListFromProvider;
      var ids = copyOfhospitalModel.map((e) => e?.id).toSet();
      copyOfhospitalModel.retainWhere((x) => ids.remove(x?.id));
      hospitalListFromProvider = copyOfhospitalModel;
    }
  }

  getDoctorDropDown(
      List<Doctors> doctors, Doctors doctorObjSample, Function onAddClick,
      {Widget child}) {
    if (doctorObjSample != null) {
      for (var doctorsObjS in doctors) {
        if (doctorsObjS.id == doctorObjSample.id) {
          doctorObj = doctorsObjS;
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton<Doctors>(
        offset: Offset(-100, 70),
        //padding: EdgeInsets.all(20),
        itemBuilder: (context) => (doctors != null && doctors.isNotEmpty)
            ? doctors
                .mapIndexed((index, element) => index == doctors.length - 1
                    ? PopupMenuItem<Doctors>(
                        value: element,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 0.5.sw,
                              child: Text(element.user != null
                                  ? new CommonUtil().getDoctorName(element.user)
                                  : ''),
                            ),
                            SizedBox(height: 10),
                            fhbBasicWidget.getSaveButton(() {
                              onAddClick();
                            }, text: 'Add Doctor'),
                            SizedBox(height: 10),
                          ],
                        ))
                    : PopupMenuItem<Doctors>(
                        value: element,
                        child: Container(
                          width: 0.5.sw,
                          child: Text(element.user != null
                              ? new CommonUtil().getDoctorName(element.user)
                              : ''),
                        ),
                      ))
                .toList()
            : PopupMenuItem<Doctors>(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    fhbBasicWidget.getSaveButton(() {
                      onAddClick();
                    }, text: 'Add Doctor'),
                    SizedBox(height: 10)
                  ],
                ),
              ),
        onSelected: (value) {
          doctorObj = value;
          setDoctorValue(value);
          setState(() {
            doctor.text = value.user != null
                ? CommonUtil().getDoctorName(value.user)
                : '';
          });
        },
        child: child ?? getIconButton(),
      );
    });
  }

  getHospitalDropDown(List<Hospitals> hospitallist, Hospitals hospitalObjSample,
      Function onAddClick,
      {Widget child}) {
    if (hospitalObjSample != null) {
      for (var hospitalObjS in hospitallist) {
        if (hospitalObjS.id == hospitalObjSample.id) {
          hospitalObj = hospitalObjS;
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton<Hospitals>(
        offset: Offset(-100, 70),
        //padding: EdgeInsets.all(20),

        itemBuilder: (context) => (hospitallist != null &&
                hospitallist.isNotEmpty)
            ? hospitallist
                .mapIndexed((index, element) => index == hospitallist.length - 1
                    ? PopupMenuItem<Hospitals>(
                        value: element,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 0.5.sw,
                              child: Text(
                                  element.name != null ? element.name : ''),
                            ),
                            SizedBox(height: 10),
                            fhbBasicWidget.getSaveButton(() {
                              onAddClick();
                            }, text: 'Add Hospital'),
                            SizedBox(height: 10),
                          ],
                        ))
                    : PopupMenuItem<Hospitals>(
                        value: element,
                        child: Container(
                          width: 0.5.sw,
                          child: Text(element.name != null ? element.name : ''),
                        ),
                      ))
                .toList()
            : PopupMenuItem<Hospitals>(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    fhbBasicWidget.getSaveButton(() {
                      onAddClick();
                    }, text: 'Add Hospital'),
                    SizedBox(height: 10)
                  ],
                ),
              ),
        onSelected: (value) {
          hospitalObj = value;
          setHospitalValue(value);
          setState(() {
            hospital.text = hospitalObj.name != null ? hospitalObj.name : '';
          });
        },
        child: child ?? getIconButton(),
      );
    });
  }

  Widget getAllHospitalRoles(Hospitals hospitalObj, Function onAdd) {
    Widget familyWidget;

    return FutureBuilder<MyProvidersResponse>(
      future: _providersBloc.getMedicalPreferencesForHospital(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));
              break;
            case ConnectionState.active:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));
              break;

            case ConnectionState.none:
              familyWidget = Center(
                  child: Text(tckConstants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0.sp,
                      )));
              break;

            case ConnectionState.done:
              if (snapshot.data != null &&
                  snapshot.data != null &&
                  snapshot.data.result != null &&
                  snapshot.data.result.hospitals != null &&
                  snapshot.data.result.hospitals.isNotEmpty) {
                hospitalListFromProvider = snapshot.data.result.hospitals;
                filterDuplicateHospital();
                familyWidget = getHospitalDropDown(
                  hospitalListFromProvider,
                  hospitalObj,
                  onAdd,
                );
              } else {
                hospitalListFromProvider = List();
                familyWidget = getHospitalsDropDownWhenNoList(
                    hospitalListFromProvider, null, onAdd);
              }

              return familyWidget;
              break;
          }
        } else {
          hospitalListFromProvider = [];
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );
  }

  Widget getIconButton() {
    return IconButton(
      icon: Icon(Icons.arrow_drop_down),
      color: Color(CommonUtil().getMyPrimaryColor()),
      iconSize: 40,
    );
  }

  getDoctorDropDownWhenNoList(
      List<Doctors> doctors, Doctors doctorObjSample, Function onAddClick,
      {Widget child}) {
    if (doctorObjSample != null) {
      for (final doctorsObjS in doctors) {
        if (doctorsObjS.id == doctorObjSample.id) {
          doctorObj = doctorsObjS;
        }
      }
    }

    return (doctors != null && doctors.isNotEmpty)
        ? StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Doctors>(
              offset: Offset(-100, 70),
              //padding: EdgeInsets.all(20),
              itemBuilder: (context) => doctors
                  .mapIndexed((index, element) => index == doctors.length - 1
                      ? PopupMenuItem<Doctors>(
                          value: element,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: 0.5.sw,
                                child: Text(
                                  element.user.name,
                                ),
                              ),
                              SizedBox(height: 10),
                              fhbBasicWidget.getSaveButton(() {
                                onAddClick();
                              }, text: 'Add Doctor'),
                              SizedBox(height: 10),
                            ],
                          ))
                      : PopupMenuItem<Doctors>(
                          value: element,
                          child: Container(
                            width: 0.5.sw,
                            child: Text(
                              element.user.name,
                            ),
                          ),
                        ))
                  .toList(),
              onSelected: (value) {
                doctorObj = value;
                setDoctorValue(value);
              },
              child: child ?? getIconButton(),
            );
          })
        : StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Doctors>(
              offset: Offset(-100, 70),
              itemBuilder: (context) => <PopupMenuItem<Doctors>>[
                PopupMenuItem<Doctors>(
                    child: Container(
                  width: 150,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      fhbBasicWidget.getSaveButton(() {
                        onAddClick();
                      }, text: 'Add Doctor'),
                      SizedBox(height: 10)
                    ],
                  ),
                )),
              ],
              onSelected: (_) {},
              child: getIconButton(),
            );
          });
  }

  getHospitalsDropDownWhenNoList(List<Hospitals> hospitallist,
      Hospitals hospitalObjSample, Function onAddClick,
      {Widget child}) {
    if (hospitalObjSample != null) {
      for (var hospitalObjS in hospitallist) {
        if (hospitalObjS.id == hospitalObjSample.id) {
          hospitalObj = hospitalObjS;
        }
      }
    }

    return (hospitallist != null && hospitallist.isNotEmpty)
        ? StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Hospitals>(
              offset: Offset(-100, 70),
              //padding: EdgeInsets.all(20),
              itemBuilder: (context) => hospitallist
                  .mapIndexed(
                      (index, element) => index == hospitallist.length - 1
                          ? PopupMenuItem<Hospitals>(
                              value: element,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: 0.5.sw,
                                    child: Text(
                                      element.name,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  fhbBasicWidget.getSaveButton(() {
                                    onAddClick();
                                  }, text: 'Add Hospital'),
                                  SizedBox(height: 10),
                                ],
                              ))
                          : PopupMenuItem<Hospitals>(
                              value: element,
                              child: Container(
                                width: 0.5.sw,
                                child: Text(
                                  element.name,
                                ),
                              ),
                            ))
                  .toList(),
              onSelected: (value) {
                hospitalObj = value;
                setHospitalValue(value);
              },
              child: child ?? getIconButton(),
            );
          })
        : StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Hospitals>(
              offset: Offset(-100, 70),
              itemBuilder: (context) => <PopupMenuItem<Hospitals>>[
                PopupMenuItem<Hospitals>(
                    child: Container(
                  width: 150,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      fhbBasicWidget.getSaveButton(() {
                        onAddClick();
                      }, text: 'Add Hospital'),
                      SizedBox(height: 10)
                    ],
                  ),
                )),
              ],
              onSelected: (_) {},
              child: getIconButton(),
            );
          });
  }

  void setDoctorValue(Doctors newValue) {
    var doctorNewObj = Doctor(
      doctorId: newValue.id,
      name: newValue.user.name,
      firstName: newValue.user.firstName,
      lastName: newValue.user.lastName,
      addressLine1: newValue.user.userAddressCollection3[0].addressLine1,
      addressLine2: newValue.user.userAddressCollection3[0].addressLine2,
      isMciVerified: newValue.isMciVerified,
      isTelehealthEnabled: newValue.isTelehealthEnabled,
      profilePicThumbnailUrl: newValue.user.profilePicThumbnailUrl,
      specialization: newValue.specialization,
      userId: newValue.user.id,
    );

    doctorsData = doctorNewObj;
  }

  void setHospitalValue(Hospitals newValue) {
    final hospitalNewObj = Hospital(
      healthOrganizationId: newValue.id,
      healthOrganizationName: newValue.name,
      addressLine1:
          newValue.healthOrganizationAddressCollection[0]?.addressLine1,
      addressLine2:
          newValue.healthOrganizationAddressCollection[0]?.addressLine2,
      cityName: newValue.healthOrganizationAddressCollection[0]?.city?.name,
      stateName: newValue.healthOrganizationAddressCollection[0]?.state?.name,
      /*healthOrganizationTypeName: newValue.healthOrganizationType?.name,
      healthOrganizationTypeId: newValue.healthOrganizationType?.id,
      phoneNumber: newValue.healthOrganizationContactCollection[0]?.phoneNumber,
      phoneNumberTypeId: newValue.healthOrganizationContactCollection[0]?.phoneNumberType?.id,
      phoneNumberTypeName: newValue.healthOrganizationContactCollection[0]?.phoneNumberType?.name,
      pincode: newValue.healthOrganizationAddressCollection[0]?.pincode*/
    );

    hospitalData = hospitalNewObj;
  }

  Widget getWidgetForDoctors() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //Lab Appointment
        controller.labBookAppointment.value
            ? Row(
                children: [
                  Text(tckConstants.strPreferredDoctors,
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ],
              )
            : SizedBox.shrink(),

        controller.doctorBookAppointment.value
            ? SizedBox(height: 10.h)
            : SizedBox.shrink(),

        controller.doctorBookAppointment.value
            ? dropDoctorDownButton(controller.doctorsList != null &&
                    controller.doctorsList.length > 0
                ? controller.doctorsList
                : [])
            : SizedBox.shrink(),

        controller.doctorBookAppointment.value &&
                controller.isPreferredDoctorDisable.value
            ? SizedBox(height: 5.h)
            : SizedBox.shrink(),

        controller.doctorBookAppointment.value &&
                controller.isPreferredDoctorDisable.value
            ? RichText(
                text: TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    children: [
                      TextSpan(
                          text: tckConstants
                              .strThereAreNoPreferredLabsInYourProfile,
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp)),
                    ]),
                maxLines: 1,
                textAlign: TextAlign.left,
              )
            : SizedBox.shrink(),

        controller.doctorBookAppointment.value
            ? SizedBox(height: 20.h)
            : SizedBox.shrink(),
      ],
    );
  }

  void commonMethodToCreateTicket(var ticketListData) {
    tckConstants.ticketType = ticketListData.id;
    tckConstants.tckPriority = ticketListData.id;

    if (controller.labBookAppointment.value &&
        controller.selPrefLab.value != "Select") {
      tckConstants.tckPrefLab = controller.selPrefLab.value;
      tckConstants.tckPrefLabId = controller.selPrefLabId.value;
    } else {
      tckConstants.tckPrefLab = "";
      tckConstants.tckPrefLabId = "";
    }
    CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

    ticketViewModel.createTicket().then((value) {
      if (value != null) {
        FlutterToast().getToast('Ticket Created Successfully', Colors.grey);

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        print('Hitting API .. : ${value.toJson()}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyTicketsListScreen()),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }).catchError((error) {
      Navigator.of(context, rootNavigator: true).pop();
      print('API Error Occured : $error');
    });
  }
}

extension FicListExtension<T> on List<T> {
  /// Maps each element of the list.
  /// The [map] function gets both the original [item] and its [index].
  ///
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
  }
}
