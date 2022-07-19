import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/exception/FetchException.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/record_detail/services/downloadmultipleimages.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/images_model.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
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
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/resources/network/api_services.dart';

class CreateTicketScreen extends StatefulWidget {
  CreateTicketScreen(this.ticketList);

  final TicketTypesResult ticketList;

  @override
  State createState() {
    return _CreateTicketScreenState();
  }
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  TicketViewModel ticketViewModel = TicketViewModel();
  DateTime dateTime = DateTime.now();
  var preferredDateStr;

  final preferredDateController = TextEditingController(text: '');
  final titleController = TextEditingController();
  final descController = TextEditingController();
  FocusNode preferredDateFocus = FocusNode();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
  var controller = Get.put(CreateTicketController());
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

  List<ImagesModel> imagePaths = [];
  List<Asset> images = <Asset>[];
  List<String> recordIds = [];
  var healthRecordList;
  String authToken;
  MenuItem dropdownValue;
  Future<Map<String, List<MenuItem>>> healthConditions;
  Map<String, List<MenuItem>> healthConditionsResult;
  var packageName;
  var package_title_ctrl = TextEditingController(text: '');
  PlanListResult planListModel;
  List<PlanListResult> planListModelList = List();

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

      setDefaultValues();
      _getInitialDate(context);
      tckConstants.tckTitleOpt = widget.ticketList.name;
      setAuthToken();
      _medicalPreferenceList = _providersBloc.getMedicalPreferencesForDoctors();
      _medicalhospitalPreferenceList =
          _providersBloc.getMedicalPreferencesForHospital();
      healthConditions =
          Provider.of<PlanWizardViewModel>(context, listen: false)
              .getHealthConditions();
    } catch (e) {
      print(e);
    }

    setBooleanValues();
  }

  @override
  void dispose() {
    controller = null;

    controller.dispose();

    super.dispose();
  }

  void setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
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
          if (field.type == tckConstants.tckTypeFile) {
            isFileUpload = true;
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
        body: Obx(() => isFirstTym && controller.isCTLoading?.value ?? false
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                addAutomaticKeepAlives: true,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                getWidgetForTitleText(
                                    title: "Category : ", isbold: false),
                                getWidgetForTitleText(
                                    title: tckConstants.tckTitleOpt,
                                    isbold: true)
                              ],
                            ),
                            SizedBox(height: 25.h),
                            getColumnBody(widget.ticketList),
                            SizedBox(height: 25.h),
                            getWidgetForCreateButton()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )));
  }

  Widget getColumnBody(TicketTypesResult ticketTypesResult) {
    List<Widget> widgetForColumn = List();
    try {
      if (ticketTypesResult.additionalInfo != null) {
        for (Field field in ticketTypesResult.additionalInfo?.field) {
          (field.type == tckConstants.tckTypeTitle &&
                  field.name != tckConstants.tckPackageTitle)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 10.h),
                    getWidgetForTitleText(),
                    SizedBox(height: 10.h),
                    getWidgetForTitleValue()
                  ],
                ))
              : SizedBox.shrink();

          field.type == tckConstants.tckTypeDescription
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 10.h),
                    getWidgetForTitleDescription(),
                    SizedBox(height: 10.h),
                    getWidgetForTitleDescriptionValue(),
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDropdown && field.isDoctor)
              ? widgetForColumn.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
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
            height: 10,
          ));
          (field.type == tckConstants.tckTypeDropdown && field.isHospital)
              ? widgetForColumn.add(Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
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
                                    context, CommonConstants.keyHospital,
                                    setState: setState);
                              },
                            )
                          : getAllHospitalRoles(hospitalObj, () {
                              Navigator.pop(context);
                              moveToSearchScreen(
                                  context, CommonConstants.keyHospital,
                                  setState: setState);
                            }),
                    ),
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDate)
              ? widgetForColumn.add(Column(
                  children: [
                    getWidgetForPreferredDate(),
                    SizedBox(height: 10.h),
                    getWidgetForPreferredDateValue(),
                    SizedBox(height: 25.h),
                  ],
                ))
              : SizedBox.shrink();

          field.type == tckConstants.tckTypeFile
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 10.h),
                    getWidgetForFileText(),
                    imagePaths.length > 0 ? SizedBox(height: 20.h) : SizedBox(),
                    imagePaths.length > 0 ? buildGridView() : SizedBox()
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeTitle &&
                  field.name == tckConstants.tckPackageTitle)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 10.h),
                    getWidgetForTitleText(title: "Package Name"),
                    SizedBox(height: 10.h),
                    getTitleForPlanPackage()
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDropdown && field.isCategory)
              ? widgetForColumn.add(Column(
                  children: [
                    getWidgetForTitleText(title: "Category"),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                                height: 50,
                                child: healthConditionsResult != null
                                    ? getDropDownForPlanCategory(
                                        healthConditionsResult) //getDropDownForPlanCategory(healthConditionsResult)
                                    : getExpandedDropdownForCategory())),
                      ],
                    )
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDropdown && field.isLab)
              ? widgetForColumn.add(getWidgetForLab())
              : SizedBox.shrink();

          isFirstTym = false;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    // widgetForColumn.add(getWidgetForLab());

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
          doctor.text = doctorsData[parameters.strName];
        } else if (results.containsKey(tckConstants.keyHospital)) {
          hospitalData = json.decode(results[tckConstants.keyHospital]);

          hospital.text = hospitalData[parameters.strHealthOrganizationName];
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

  Widget getWidgetForTitleText({String title, bool isbold = false}) {
    return Row(
      children: [
        Text(title ?? tckConstants.strTicketTitle,
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: isbold ? FontWeight.bold : FontWeight.w400)),
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
                showAlertMsg(CommonConstants.ticketDate);
              }
            } else {
              showAlertMsg(CommonConstants.ticketDesc);
            }
          }
        } else {
          showAlertMsg(CommonConstants.ticketDoctor);
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
              showAlertMsg(CommonConstants.ticketDate);
            }
          } else {
            showAlertMsg(CommonConstants.ticketDesc);
          }
        } else {
          showAlertMsg(CommonConstants.ticketTitle);
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
            showAlertMsg(CommonConstants.ticketDesc);
          }
        } else {
          showAlertMsg(CommonConstants.ticketTitle);
        }
      } else if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("order prescription")) {
        if (imagePaths.length > 0) {
          if (isDescription && descController.text.isNotEmpty) {
            tckConstants.tckDesc = descController.text.toString();
            commonMethodToCreateTicket(ticketListData);
          } else {
            showAlertMsg(CommonConstants.ticketDesc);
          }
        } else {
          showAlertMsg(CommonConstants.ticketFile);
        }
      } else if (CommonUtil()
          .validString(ticketListData.name)
          .toLowerCase()
          .contains("care/diet plan")) {
        if (dropdownValue != null) {
          tckConstants.tckSelectedCategory = dropdownValue.title;
          if (package_title_ctrl.text != null &&
              package_title_ctrl.text != "") {
            Constants.tckPackageName = package_title_ctrl.text;
            if (isDescription && descController.text.isNotEmpty) {
              tckConstants.tckDesc = descController.text.toString();
              commonMethodToCreateTicket(ticketListData);
            } else {
              showAlertMsg(CommonConstants.ticketDesc);
            }
          } else {
            showAlertMsg(CommonConstants.ticketPackage);
          }
        } else {
          showAlertMsg(CommonConstants.ticketCategory);
        }
      }
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      print('Catch Error Occured : $error');
    }
  }

  void showAlertMsg(String msg) {
    Alert.displayAlert(context, title: variable.Error, content: msg);
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
          ignoring: controller.isPreferredLabDisable.value ?? false,
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
          ignoring: controller.isPreferredLabDisable.value ?? false,
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
        offset: Offset(-100, 60),
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

    ticketViewModel.createTicket().then((value) async {
      if (value != null) {
        if (CommonUtil()
                .validString(ticketListData.name)
                .toLowerCase()
                .contains("order prescription") &&
            imagePaths.length > 0) {
          ApiBaseHelper apiBaseHelper = ApiBaseHelper();
          List resposnes = await apiBaseHelper
              .uploadAttachmentForTicket(
                  CommonUtil.TRUE_DESK_URL + "tickets/uploadattachment",
                  value?.result?.ticket?.id,
                  imagePaths)
              .then((values) {
            FlutterToast().getToast('Ticket Created Successfully', Colors.grey);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            print('Hitting API .. : ${value.toJson()}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyTicketsListScreen()),
            );
          });
        } else {
          FlutterToast().getToast('Ticket Created Successfully', Colors.grey);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          print('Hitting API .. : ${value.toJson()}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyTicketsListScreen()),
          );
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }).catchError((error) {
      Navigator.of(context, rootNavigator: true).pop();
      print('API Error Occured : $error');
    });
  }

  Widget getWidgetForFileText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text("Attach File",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400)),
        ),
        Center(
            child: Visibility(
                child: IconButton(
          icon: Icon(
            Icons.photo_library,
            color: Color(new CommonUtil().getMyPrimaryColor()),
            size: 32.0.sp,
          ),
          onPressed: () async {
            await loadAssets();
          },
        ))),
        Center(
            child: Visibility(
                child: IconButton(
          icon: new ImageIcon(
            AssetImage(variable.icon_attach),
            color: Color(new CommonUtil().getMyPrimaryColor()),
            size: 32.0.sp,
          ),
          onPressed: () async {
            loadImagesFromRecords();
          },
        )))
      ],
    );
  }

  void loadImagesFromRecords() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
          argument: MyRecordsArgument(
              categoryPosition: 0,
              allowSelect: true,
              isAudioSelect: true,
              isNotesSelect: false,
              selectedMedias: recordIds,
              showDetails: false,
              isFromChat: true,
              isAssociateOrChat: true,
              fromClass: 'chats')),
    ))
        .then((results) {
      if (results != null) {
        if (results.containsKey(STR_META_ID)) {
          healthRecordList = results[STR_META_ID] as List;
          if (healthRecordList != null) {
            getMediaURL(healthRecordList);
          }
        }
      }
    });
  }

  getMediaURL(List<HealthRecordCollection> healthRecordCollection) async {
    for (int i = 0; i < healthRecordCollection.length; i++) {
      String fileType = healthRecordCollection[i].fileType;
      String fileURL = healthRecordCollection[i].healthRecordUrl;
      if ((fileType == STR_JPG) ||
          (fileType == STR_PNG) ||
          (fileType == STR_JPEG)) {
        imagePaths.add(ImagesModel(
            file: fileURL,
            isFromFile: false,
            isdownloaded: false,
            fileType: fileType));
      } else if ((fileType == STR_PDF)) {
        imagePaths.add(ImagesModel(
            file: fileURL,
            isFromFile: false,
            isdownloaded: false,
            fileType: fileType));
        //getAlertForFileSend(fileURL, 2);
      } else if ((fileType == STR_AAC)) {
        //getAlertForFileSend(fileURL, 3);
      }
    }

    await _download(healthRecordCollection);

    setState(() {});
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: variable.strChat),
        materialOptions: MaterialOptions(
          actionBarColor: fhbColors.actionColor,
          useDetailsView: false,
          selectCircleStrokeColor: fhbColors.colorBlack,
        ),
      );
    } on FetchException catch (e) {}
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    for (Asset asset in resultList) {
      String filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      imagePaths.add(ImagesModel(
          isFromFile: true, file: filePath, isdownloaded: true, asset: asset));
    }
    setState(() {
      images = resultList;
    });
  }

  Widget buildGridView() {
    return imagePaths.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var asset =
                  imagePaths[index].isFromFile ? imagePaths[index].asset : "";
              return Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                      color: Colors.white,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: imagePaths[index].isFromFile
                                ? Material(
                                    child: Container(
                                        height: double.infinity,
                                        child: AssetThumb(
                                          asset: asset,
                                          width: 150,
                                          height: 150,
                                        )))
                                : imagePaths[index].isdownloaded
                                    ? imagePaths[index].fileType.trim() ==
                                            ".pdf"
                                        ? Material(
                                            child: Container(
                                            color: Colors.black,
                                            child: IconButton(
                                              tooltip: 'View PDF',
                                              icon: ImageIcon(
                                                  AssetImage(
                                                      variable.icon_attach),
                                                  color: Colors.white),
                                              onPressed: () async {
                                                await OpenFile.open(
                                                  imagePaths[index].file,
                                                );
                                              },
                                            ),
                                          ))
                                        : Material(
                                            child: Container(
                                                height: double.infinity,
                                                child: Image.file(
                                                  File(imagePaths[index].file),
                                                  width: 150,
                                                  fit: BoxFit.fill,
                                                  height: 150,
                                                )),
                                          )
                                    : imagePaths[index].fileType.trim() ==
                                            ".pdf"
                                        ? Material(
                                            child: Container(
                                            color: Colors.black,
                                            child: IconButton(
                                              tooltip: 'View PDF',
                                              icon: ImageIcon(
                                                  AssetImage(
                                                      variable.icon_attach),
                                                  color: Colors.white),
                                              onPressed: () async {
                                                await OpenFile.open(
                                                  imagePaths[index].file,
                                                );
                                              },
                                            ),
                                          ))
                                        : Material(
                                            child: Container(
                                                height: double.infinity,
                                                child: Image.network(
                                                  imagePaths[index].file,
                                                  width: 150,
                                                  fit: BoxFit.fill,
                                                  height: 150,
                                                  headers: {
                                                    HttpHeaders
                                                            .authorizationHeader:
                                                        authToken
                                                  },
                                                )),
                                          ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                imagePaths.removeAt(index);

                                setState(() {
                                  print('set new state of images');
                                });
                              },
                              child: Icon(
                                Icons.close_sharp,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              );
            },
            itemCount: imagePaths.length,
          )
        : SizedBox(height: 0.0.h);
  }

  Widget getTitleForPlanPackage() {
    return TypeAheadFormField<PlanListResult>(
      textFieldConfiguration: TextFieldConfiguration(
          controller: package_title_ctrl,
          onChanged: (value) {
            planListModel = null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusColor: Color(CommonUtil().getMyPrimaryColor()),
            hintStyle: TextStyle(
              fontSize: 16.0.sp,
            ),
          )),
      suggestionsCallback: (pattern) async {
        if (pattern.length >= 3) {
          return await getPackageNameBasedOnSearch(pattern, '');
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion.title,
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      errorBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            'Oops. We could not find the package you typed.',
            style: TextStyle(
              fontSize: 16.0.sp,
            ),
          ),
        );
      },
      onSuggestionSelected: (suggestion) {
        package_title_ctrl.text = suggestion.title;
        //stateVal = suggestion.state;
      },
      validator: (value) {
        return null;
      },
      onSaved: (value) => packageName = value,
    );
  }

  getPackageNameBasedOnSearch(String pattern, String s) {
    fetchData();
    return planListModelList;
  }

  fetchData() async {
    var responses = await Future.wait([
      Provider.of<PlanWizardViewModel>(context, listen: false)
          .getCarePlanList(''),
      Provider.of<PlanWizardViewModel>(context, listen: false)
          .getCarePlanList(strFreeCare),
      Provider.of<PlanWizardViewModel>(context, listen: false)
          .getDietPlanListNew(isFrom: strProviderDiet),
      Provider.of<PlanWizardViewModel>(context, listen: false).getDietPlanListNew(
          isFrom:
              strFreeDiet) // make sure return type of these functions as Future.
    ]);
    planListModelList.addAll(responses[0]?.result);
    planListModelList.addAll(responses[1]?.result);
    planListModelList.addAll(responses[2]?.result);
    planListModelList.addAll(responses[3]?.result);
  }

  Widget getDropDownForPlanCategory(
      Map<String, List<MenuItem>> healthConditionsList) {
    List<MenuItem> menuItems = List();
    healthConditionsList.values.map((element) {
      menuItems.addAll(element);
    }).toList();
    return SizedBoxWithChild(
        height: 50,
        child: IgnorePointer(
            ignoring: controller.isPreferredDoctorDisable.value,
            child: Expanded(
                flex: 1,
                child: DropdownButton<MenuItem>(
                  // Initial Value
                  value: dropdownValue,
                  isExpanded: true,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  hint: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            CommonUtil().validString(
                                dropdownValue?.title ?? 'Select Category'),
                            style: TextStyle(
                              fontSize: 14.0.sp,
                            )),
                      ),
                    ],
                  ),

                  // Array list of items
                  items: menuItems.map((MenuItem items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.title),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (MenuItem newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                ))));
  }

  Widget getExpandedDropdownForCategory() {
    return FutureBuilder<Map<String, List<MenuItem>>>(
      future: healthConditions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 4.5,
              child: Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
        } else {
          var healthConditionsList =
              (Provider.of<PlanWizardViewModel>(context)?.isHealthSearch ??
                      false)
                  ? (Provider.of<PlanWizardViewModel>(context, listen: false)
                          ?.filteredHealthConditions ??
                      {})
                  : (Provider.of<PlanWizardViewModel>(context, listen: false)
                          ?.healthConditions ??
                      {});
          if ((healthConditionsList?.length ?? 0) > 0) {
            healthConditionsResult = healthConditionsList;
            return getDropDownForPlanCategory(healthConditionsResult);
          } else {
            return SafeArea(
              child: SizedBox(
                height: 1.sh / 1.3,
                child: Container(
                  child: Center(
                    child: Text(strNoHealthConditions),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _download(List<HealthRecordCollection> imagesPathMain) async {
    if (imagesPathMain.length >= 1) {
      downloadFilesFromServer(context, imagesPathMain);
    }
  }

  void downloadFilesFromServer(
      BuildContext contxt, List<HealthRecordCollection> imagesPathMain) async {
    String authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    List<String> filePathist = new List();
    for (final _currentImage in imagesPathMain) {
      try {
        await FHBUtils.createFolderInAppDocDirClone(variable.stAudioPath,
                _currentImage.healthRecordUrl.split('/').last)
            .then((filePath) async {
          var file;
          if (_currentImage.fileType == '.pdf') {
            file = File('$filePath');
          } else {
            file = File('$filePath');
          }
          final request = await ApiServices.get(
            _currentImage.healthRecordUrl,
            headers: {
              HttpHeaders.authorizationHeader: authToken,
              Constants.KEY_OffSet: CommonUtil().setTimeZone()
            },
          );
          final bytes = request.bodyBytes; //close();
          await file.writeAsBytes(bytes);

          print("file.path" + file.path);
          filePathist.add(file.path);
        });
      } catch (e) {
        //print('$e exception thrown');
      }
    }
    if (filePathist.length == imagesPathMain.length) {
      for (int i = 0; i < imagePaths.length; i++) {
        if (!imagePaths[i].isdownloaded) {
          for (int j = 0; j < imagesPathMain.length; j++) {
            if (imagePaths[i].file == imagesPathMain[j].healthRecordUrl) {
              imagePaths[i].file = filePathist[j];
              imagePaths[i].isdownloaded = true;
            }
          }
        }
      }
    } else {
      Scaffold.of(contxt).showSnackBar(SnackBar(
        content: Text(
          variable.strFileDownloadeding,
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
        ),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
      ));
    }
  }

  void setDefaultValues() {
    Constants.tckTitle = 'title';
    Constants.tckDesc = 'desc';
    Constants.tckPrefDate = 'pref_date';
    Constants.tckPrefLab = 'pref_lab';
    Constants.tckPrefLabId = 'pref_lab_id';
    Constants.ticketType = 'ticket type';
    Constants.tckPriority = 'ticket priority';
    Constants.tckID = 'ticket_id';
    Constants.tckComment = 'ticket_comment';
    Constants.tckSelectedDoctor = 'Doctor';
    Constants.tckSelectedHospital = 'Hospital';
    Constants.tckSelectedCategory = 'Category';
    Constants.tckPackageName = 'Package Name';
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
