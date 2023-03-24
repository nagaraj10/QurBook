import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
// import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/exception/FetchException.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/plan_dashboard/model/PlanListModel.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/utils/alert.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/ticket_support/controller/create_ticket_controller.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/images_model.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/view_model/tickets_view_model.dart';
import 'package:open_filex/open_filex.dart';
//import 'package:open_file/open_file.dart'; FU2.5
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
import 'package:flutter_absolute_path/flutter_absolute_path.dart'; //FU2.5
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/search_providers/models/CityListModel.dart'as cityListModel;

class CreateTicketScreen extends StatefulWidget {
  CreateTicketScreen(this.ticketList);

  final TicketTypesResult? ticketList;

  @override
  State createState() {
    return _CreateTicketScreenState();
  }
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  TicketViewModel ticketViewModel = TicketViewModel();
  DateTime dateTime = DateTime.now();
  static TimeOfDay selectedTime = TimeOfDay.now();
  var preferredDateStr;
  var preferredTimeStr;

  final preferredDateController = TextEditingController(text: '');
  final preferredTimeController = TextEditingController(text: '');
  final titleController = TextEditingController();
  final descController = TextEditingController();
  FocusNode preferredDateFocus = FocusNode();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
  var controller = Get.put(CreateTicketController());
  var regController = CommonUtil().onInitQurhomeRegimenController();
  Hospitals? selectedLab;
  Doctors? selectedDoctor;

  ProvidersBloc? _providersBloc = ProvidersBloc();
  Future<MyProvidersResponse?>? _medicalPreferenceList;
  Future<MyProvidersResponse?>? _medicalhospitalPreferenceList;

  List<Doctors?>? doctorsListFromProvider;
  List<Doctors?>? copyOfdoctorsModel;

  List<Hospitals>? hospitalListFromProvider;
  List<Hospitals>? copyOfhospitalModel;
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  Doctors? doctorObj;
  Hospitals? hospitalObj;

  var doctorsData, hospitalData, labData;
  CommonWidgets commonWidgets = new CommonWidgets();
  TextEditingController doctor = TextEditingController();
  TextEditingController lab = TextEditingController();
  TextEditingController hospital = TextEditingController();
  //TextEditingController modeOfServiceController = TextEditingController();
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
  String? authToken;
  MenuItem? dropdownValue;
  Future<Map<String?, List<MenuItem>>>? healthConditions;
  Map<String?, List<MenuItem>>? healthConditionsResult;
  var packageName;
  var package_title_ctrl = TextEditingController(text: '');
  PlanListResult? planListModel;
  List<PlanListResult> planListModelList = [];

  //FieldData selectedModeOfService;

  Map<String?, TextEditingController> textEditingControllers = {};
  String? docId = "";
  String? hosId = "";

  bool isLabAddressVisible = false;
  bool isLabNameOthers = false;
  cityListModel.CityListData? cityListData;
  bool isProviderOthers = false;

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

  Future<void> _selectTime(BuildContext context) async {
    try {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        setState(() {
          selectedTime = pickedTime;
          preferredTimeStr = FHBUtils().formatTimeOfDay(selectedTime);
          preferredTimeController.text = preferredTimeStr;
        });
      }
    } catch (e) {
      //print(e);
    }
  }

  @override
  void initState() {
    try {
      super.initState();

      setDefaultValues();
      _getInitialDate(context);
      tckConstants.tckTitleOpt = widget.ticketList!.name;
      setAuthToken();
      _medicalPreferenceList =
          _providersBloc!.getMedicalPreferencesForDoctors();
      _medicalhospitalPreferenceList =
          _providersBloc!.getMedicalPreferencesForHospital();
      healthConditions =
          Provider.of<PlanWizardViewModel>(context, listen: false)
              .getHealthConditions() as Future<Map<String?, List<MenuItem>>>?;

      setBooleanValues();
    } catch (e) {
      //print(e);
    }
  }

  @override
  void dispose() {
    try {
      setDefaultValues();
      // controller = null;

      //controller.dispose();
      textEditingControllers.forEach((_, v) {
        v.dispose();
      });

      super.dispose();
    } catch (e) {
      //print(e);
    }
  }

  void setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
  }

  setBooleanValues() async {
    try {
      if (widget.ticketList != null) {
        if (widget.ticketList!.additionalInfo != null)
          for (int i = 0;
              i < widget.ticketList!.additionalInfo!.field!.length;
              i++) {
            Field field = widget.ticketList!.additionalInfo!.field![i];
            if (field.type == tckConstants.tckTypeTitle &&
                field.name == tckConstants.tckMainTitle) {
              isTxt = true;
            }
            if (field.type == tckConstants.tckTypeTitle &&
                (field.name != tckConstants.tckMainTitle &&
                    field.name != tckConstants.tckPackageTitle) &&
                field.isVisible == null) {
              getTextField(field);
            }

            if (field.type == tckConstants.tckTypeTitle &&
                (field.name != tckConstants.tckMainTitle &&
                    field.name != tckConstants.tckPackageTitle) &&
                field.isVisible != null) {
              getTextField(field);
            }

            if (field.type == tckConstants.tckTypeDescription &&
                field.name == tckConstants.tckMainDescription) {
              isDescription = true;
            }
            if (field.type == tckConstants.tckTypeDescription &&
                field.name != tckConstants.tckMainDescription &&
                field.isVisible == null) {
              getTextField(field);
            }

            if (field.type == tckConstants.tckTypeDescription &&
                field.name != tckConstants.tckMainDescription &&
                field.isVisible != null) {
              getTextField(field);
            }

            if (field.type == tckConstants.tckTypeDropdown && field.isDoctor!) {
              isDoctor = true;
            }
            if (field.type == tckConstants.tckTypeDropdown &&
                field.isHospital!) {
              isHospital = true;
            }
            if (field.type == tckConstants.tckTypeDate) {
              isPreferredDate = true;
            }
            if (field.type == tckConstants.tckTypeFile) {
              isFileUpload = true;
            }
            if (field.type == tckConstants.tckTypeDropdown &&
                field.fieldData != null &&
                (field.fieldData?.length??0) > 0) {
              getTextField(field);
              if (field.fieldData!.length == 1) {
                onSelectDD(field.fieldData![0], field);
              }
            }

            if (field.type == tckConstants.tckTypeDropdown &&
                (field.isProvider != null && field.isProvider!)) {
              if (field.providerType != null && field.providerType!.length > 0) {
                await controller.getProviderList(
                    field.providerType![0] ?? "", field);
              }
              getTextField(field);
              if (field.fieldData != null &&
                  (field.fieldData?.length ?? 0) > 0 &&
                  field?.fieldData?.length == 1) {
                await Future.delayed(Duration(milliseconds: 50));
                onSelectDD(field.fieldData![0], field);
              }
            }

            if ((field.type == tckConstants.tckTypeDropdown ||
                    field.type == tckConstants.tckTypeLookUp) &&
                field.name == strCity) {
              getTextField(field);
            }

          }
      }
    } catch (e) {
      //print(e);
    }
  }

  getTextField(Field field) {
    try {
      var textEditingController = new TextEditingController();
      textEditingControllers.putIfAbsent(
          CommonUtil().getFieldName(field.name), () => textEditingController);
    } catch (e) {}
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
        body: Obx(() => isFirstTym && controller.isCTLoading.value ?? false
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
                                    title: "Ticket Type : ", isbold: false),
                                getWidgetForTitleText(
                                    title: tckConstants.tckTitleOpt,
                                    isbold: true)
                              ],
                            ),
                            SizedBox(height: 25.h),
                            getColumnBody(widget.ticketList!),
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
    List<Widget> widgetForColumn = [];
    try {
      if (ticketTypesResult.additionalInfo != null) {
        for (int i = 0;
            i < ticketTypesResult.additionalInfo!.field!.length;
            i++) {
          Field field = ticketTypesResult.additionalInfo!.field![i];
          String? displayName = displayFieldName(field);
          String placeHolderName = CommonUtil().validString(field.placeholder);
          placeHolderName = placeHolderName.trim().isNotEmpty
              ? placeHolderName
              : displayName!;
          bool isVisible = false;
          if (CommonUtil().validString(field.isVisible).trim().isNotEmpty) {
            for (int i = 0;
                i < ticketTypesResult.additionalInfo!.field!.length;
                i++) {
              Field tempField = ticketTypesResult.additionalInfo!.field![i];
              if (tempField.selValueDD != null &&
                  field.isVisible!.contains(tempField.selValueDD!.id!) &&
                  field.isVisible!.contains(tempField.selValueDD!.fieldName!)) {
                isVisible = true;
                break;
              }
            }
          }
          //print("displayName2 $displayName");

          /*if (field.type == tckConstants.tckTypeDropdown &&
              field.name == tckConstants.tckTypeModeOfService &&
              field.fieldData != null &&
              field.fieldData.length == 1) {
            selectedModeOfService = field.fieldData[0];
            modeOfServiceController.text = selectedModeOfService.name != null
                ? selectedModeOfService.name
                : '';
          }*/

          (field.type == tckConstants.tckTypeTitle &&
                  field.name == tckConstants.tckMainTitle)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getWidgetForTitleValue()
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeTitle &&
                  (field.name != tckConstants.tckMainTitle &&
                      field.name != tckConstants.tckPackageTitle) &&
                  field.isVisible == null)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getWidgetForTextValue(
                        i, CommonUtil().getFieldName(field.name),field),
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeTitle &&
                  (field.name != tckConstants.tckMainTitle &&
                      field.name != tckConstants.tckPackageTitle) &&
                  field.isVisible != null)
              ? widgetForColumn.add(Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      getWidgetForTitleText(
                          title: displayName,
                          isRequired: /*field.isRequired*/ isVisible ?? false),
                      SizedBox(height: 10.h),
                      getWidgetForTextValue(
                          i, CommonUtil().getFieldName(field.name),field),
                    ],
                  ),
                ))
              : SizedBox.shrink();

          field.type == tckConstants.tckTypeDescription &&
                  field.name == tckConstants.tckMainDescription
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleDescription(
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getWidgetForTitleDescriptionValue(),
                  ],
                ))
              : SizedBox.shrink();

          field.type == tckConstants.tckTypeDescription &&
                  field.name != tckConstants.tckMainDescription &&
                  field.isVisible != null
              ? widgetForColumn.add(Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      getWidgetForTitleText(
                          title: displayName,
                          isRequired: /*field.isRequired*/ isVisible ?? false),
                      SizedBox(height: 10.h),
                      getWidgetForTextAreaValue(
                          i, CommonUtil().getFieldName(field.name)),
                    ],
                  ),
                ))
              : SizedBox.shrink();

          field.type == tckConstants.tckTypeDescription &&
                  field.name != tckConstants.tckMainDescription &&
                  field.isVisible == null
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getWidgetForTextAreaValue(
                        i, CommonUtil().getFieldName(field.name)),
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDropdown && field.isDoctor!)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    Row(
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
                                        context, CommonConstants.keyDoctor,field,
                                        setState: setState);
                                  },
                                )
                              : getAllCustomRoles(doctorObj, () {
                                  Navigator.pop(context);
                                  moveToSearchScreen(
                                      context, CommonConstants.keyDoctor,field,
                                      setState: setState);
                                }),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ))
              //widgetForColumn.add(getWidgetForDoctors())
              : SizedBox();
          /*widgetForColumn.add(SizedBox(
            height: 10,
          ));*/
          (field.type == tckConstants.tckTypeDropdown && field.isHospital!)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    Row(
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
                                        context, CommonConstants.keyHospital,field,
                                        setState: setState);
                                  },
                                )
                              : getAllHospitalRoles(hospitalObj, () {
                                  Navigator.pop(context);
                                  moveToSearchScreen(
                                      context, CommonConstants.keyHospital,field,
                                      setState: setState);
                                }),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ))
              : SizedBox.shrink();

          /*widgetForColumn.add(SizedBox(
            height: 10,
          ));*/

          (field.type == tckConstants.tckTypeDropdown &&
                  field.fieldData != null &&
                  field.fieldData!.length > 0)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: fhbBasicWidget.getTextFiledWithHint(
                              context,
                              placeHolderName,
                              textEditingControllers[
                                  CommonUtil().getFieldName(field.name)],
                              enabled: false),
                        ),
                        Container(
                          height: 50,
                          child: getDropDownFields(field),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDate)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForPreferredDate(
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getWidgetForPreferredDateValue(),
                    //SizedBox(height: 25.h),
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeTime)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForPreferredTime(
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getWidgetForPreferredTimeValue(),
                    //SizedBox(height: 25.h),
                  ],
                ))
              : SizedBox.shrink();

          field.type == tckConstants.tckTypeFile
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForFileText(isRequired: field.isRequired ?? false),
                    imagePaths.length > 0 ? SizedBox(height: 20.h) : SizedBox(),
                    imagePaths.length > 0 ? buildGridView() : SizedBox()
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeTitle &&
                  field.name == tckConstants.tckPackageTitle)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    getTitleForPlanPackage()
                  ],
                ))
              : SizedBox.shrink();

          (field.type == tckConstants.tckTypeDropdown && field.isCategory!)
              ? widgetForColumn.add(Column(
                  children: [
                    SizedBox(height: 15.h),
                    getWidgetForTitleText(
                        title: displayName,
                        isRequired: field.isRequired ?? false),
                    SizedBox(height: 10.h),
                    healthConditionsResult != null
                        ? getDropDownForPlanCategory(
                            healthConditionsResult!) //getDropDownForPlanCategory(healthConditionsResult)
                        : getExpandedDropdownForCategory(),
                    SizedBox(height: 10.h),
                  ],
                ))
              : SizedBox.shrink();

          ((field.type == tckConstants.tckTypeDropdown ||
                      field.type == tckConstants.tckTypeLookUp) &&
                  field.isLab!)
              ? CommonUtil.REGION_CODE == "IN"
                  ? widgetForColumn.add(Column(
                      children: [
                        SizedBox(height: 15.h),
                        getWidgetForTitleText(
                            title: displayName,
                            isRequired: field.isRequired ?? false),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: fhbBasicWidget.getTextFiledWithHint(
                                  context, '$placeHolderName', lab,
                                  enabled: false),
                            ),
                            Container(
                              height: 50,
                              child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      //Navigator.pop(context);
                                      bool serviceEnabled =
                                          await CommonUtil().checkGPSIsOn();
                                      if (!serviceEnabled) {
                                        FlutterToast().getToast(
                                            'Please turn on your GPS location services and try again',
                                            Colors.red);
                                        return;
                                      }
                                      await regController.getCurrentLocation();
                                      moveToSearchScreen(
                                          context, CommonConstants.keyLabs,field,
                                          setState: setState);
                                    } catch (e) {
                                      //print(e);
                                    }
                                  },
                                  child: getIconButton()),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        controller!.strAddressLine.value.trim().isNotEmpty &&
                                isLabAddressVisible
                            ? CommonUtil().commonWidgetForTitleValue(
                                tckConstants.address, controller.strAddressLine.value)
                            : SizedBox.shrink(),
                        controller!.strCityName.value.trim().isNotEmpty &&
                                isLabAddressVisible
                            ? CommonUtil().commonWidgetForTitleValue(
                                tckConstants.city, controller.strCityName.value)
                            : SizedBox.shrink(),
                        controller.strStateName.value.trim().isNotEmpty &&
                                isLabAddressVisible
                            ? CommonUtil().commonWidgetForTitleValue(
                                tckConstants.state,
                                controller.strStateName.value)
                            : SizedBox.shrink(),
                        controller!.strPincode.value.trim().isNotEmpty &&
                                isLabAddressVisible
                            ? CommonUtil().commonWidgetForTitleValue(
                                tckConstants.pincode, controller.strPincode.value)
                            : SizedBox.shrink(),
                      ],
                    ))
                  : widgetForColumn.add(getWidgetForLab())
              : SizedBox.shrink();

          (field.type == tckTypeTitle &&
                                field.isVisible != null &&
                                field.name == strLabName &&
                                isLabNameOthers)
                  ? widgetForColumn.add(Visibility(
                      visible: isLabNameOthers,
                      child: Column(
                        children: [
                          SizedBox(height: 15.h),
                          getWidgetForTitleText(
                              title: displayName,
                              isRequired:isLabNameOthers ??
                                  false),
                          SizedBox(height: 10.h),
                          getWidgetForTextValue(
                              i, CommonUtil().getFieldName(field.name), field),
                        ],
                      ),
                    ))
                  : SizedBox.shrink();

          ((field.type == tckConstants.tckTypeDropdown ||
                      field.type == tckConstants.tckTypeLookUp) &&
                  field.name == strCity)
              ? widgetForColumn.add(Visibility(
                  visible: field.isVisible != null ? isVisible : true,
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      getWidgetForTitleText(
                          title: displayName,
                          isRequired: isVisible ?? false),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: fhbBasicWidget.getTextFiledWithHint(
                                context,
                                placeHolderName,
                                textEditingControllers[
                                    CommonUtil().getFieldName(field.name)],
                                enabled: false),
                          ),
                          Container(
                            height: 50,
                            child: GestureDetector(
                                onTap: () async {
                                  try {
                                    moveToSearchScreen(
                                        context, CommonConstants.keyCity, field,
                                        setState: setState);
                                  } catch (e) {}
                                },
                                child: getIconButton()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ))
              : SizedBox.shrink();

          isFirstTym = false;
        }
      }
    } catch (e) {
      //print(e.toString());
    }
    // widgetForColumn.add(getWidgetForLab());

    return Column(children: widgetForColumn);
  }

  moveToSearchScreen(BuildContext context, String searchParam,Field field,
      {setState}) async {
    try {
      await Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => SearchSpecificList(
                    arguments: SearchArguments(
                      searchWord: searchParam,
                    ),
                    toPreviousScreen: true,
                    isSkipUnknown:
                        searchParam == CommonConstants.keyDoctor ? true : false,
                    isFromCreateTicket: true,
                  )))
          .then((results) {
        if (results != null) {
          if (results.containsKey(tckConstants.keyDoctor)) {
            doctorsData = json.decode(results[tckConstants.keyDoctor]);
            doctor.text = doctorsData[parameters.strName];
            docId = doctorsData[parameters.strDoctorId];
          } else if (results.containsKey(tckConstants.keyHospital)) {
            hospitalData = json.decode(results[tckConstants.keyHospital]);

            hospital.text = hospitalData[parameters.strHealthOrganizationName];
            hosId = hospitalData[parameters.strHealthOrganizationId];
          } else if (results.containsKey(tckConstants.keyLab)) {
            labData = json.decode(results[tckConstants.keyLab]);
            lab.text = labData[parameters.strHealthOrganizationName];
            controller!.selPrefLab.value =
                labData[parameters.strHealthOrganizationName];
            controller!.selPrefLabId.value =
                labData[parameters.strHealthOrganizationId];
            controller!.strAddressLine.value =
                CommonUtil().validString(labData[parameters.strAddressLine1]);
            controller!.strCityName.value =
                CommonUtil().validString(labData[parameters.strcityName]);
            controller!.strPincode.value =
                CommonUtil().validString(labData[parameters.strpincode]);
            controller.strStateName.value =
                CommonUtil().validString(labData[parameters.strstateName]);
            if (lab.text.trim().toLowerCase() == strOthers) {
              isLabNameOthers = true;
            } else {
              isLabNameOthers = false;
            }
            onRefreshWidget();
          } else if (results.containsKey(tckConstants.keyCity)) {
            cityListData = results[tckConstants.keyCity];

            textEditingControllers[CommonUtil().getFieldName(field.name)]
                ?.text = CommonUtil().validString(cityListData?.name ?? "");
            textEditingControllers[CommonUtil().getFieldName(strState)]?.text =
                CommonUtil().validString(cityListData?.state?.name);
          }
        }
      });
    } catch (e) {
      //print(e);
    }
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

    doctorsListFromProvider!.add(doctorObj);
    filterDuplicateDoctor();
    getDoctorDropDown(doctorsListFromProvider, doctorObj, onTextFinished);
  }

  Widget getWidgetForLab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //Lab Appointment

        controller!.labBookAppointment.value
            ? SizedBox(height: 15.h)
            : SizedBox.shrink(),

        controller!.labBookAppointment.value
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

        controller!.labBookAppointment.value
            ? SizedBox(height: 10.h)
            : SizedBox.shrink(),

        controller!.labBookAppointment.value
            ? dropDownButton(
                controller!.labsList != null && controller!.labsList!.length > 0
                    ? controller!.labsList!
                    : [])
            : SizedBox.shrink(),

        controller!.labBookAppointment.value &&
                controller!.isPreferredLabDisable.value
            ? SizedBox(height: 5.h)
            : SizedBox.shrink(),

        controller!.labBookAppointment.value &&
                controller!.isPreferredLabDisable.value
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

        controller!.labBookAppointment.value
            ? SizedBox(height: 10.h)
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
            try {
              FHBUtils().check().then((internet) {
                if (internet != null && internet) {
                  _validateAndCreateTicket(context, widget.ticketList);
                } else {
                  FHBBasicWidget().showInSnackBar(
                      tckConstants.STR_NO_CONNECTIVITY, scaffold_state);
                }
              });
            } catch (e) {
              //print(e);
            }
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
        textCapitalization: TextCapitalization.sentences,
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

  Widget getWidgetForPreferredDate({bool isRequired = false}) {
    return Row(
      children: [
        Text("${tckConstants.strTicketPreferredDate}${isRequired ? "\t*" : ""}",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForPreferredTimeValue() {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        autofocus: false,
        enableInteractiveSelection: false,
        readOnly: true,
        controller: preferredTimeController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            onPressed: () {
              _selectTime(context);
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
                'assets/icons/11.png',
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

  Widget getWidgetForPreferredTime({bool isRequired = false}) {
    return Row(
      children: [
        Text("${tckConstants.strTicketPreferredTime}${isRequired ? "\t*" : ""}",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForTitleText(
      {String? title, bool isbold = false, bool isRequired = false}) {
    return Row(
      children: [
        Text(
            "${title ?? tckConstants.strTicketTitle}${isRequired ? "\t*" : ""}",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: isbold ? FontWeight.bold : FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForTitleValue() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
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

  Widget getWidgetForTextAreaValue(int index, String? strName) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      autofocus: false,
      maxLines: 6,
      controller: textEditingControllers[strName],
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

  Widget getWidgetForTextValue(int index, String? strName,Field field) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      autofocus: false,
      controller: textEditingControllers[strName],
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabled: field.isDisable != null && field.isDisable! ? false : true,
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

  Widget getWidgetForTitleDescription({bool isRequired = false}) {
    return Row(
      children: [
        Text("${tckConstants.strTicketDesc}${isRequired ? "\t*" : ""}",
            style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget getWidgetForTitleDescriptionValue() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
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
      String strName =
          CommonUtil().validString(ticketListData.name ?? "").toLowerCase();
      controller!.dynamicTextFiledObj = {};
      if (widget.ticketList != null) {
        if (widget.ticketList!.additionalInfo != null)
          for (int i = 0;
              i < widget.ticketList!.additionalInfo!.field!.length;
              i++) {
            Field field = widget.ticketList!.additionalInfo!.field![i];
            String displayName = displayFieldName(field)!;

            if (field.type == tckConstants.tckTypeTitle &&
                field.name == tckConstants.tckMainTitle) {
              if (titleController.text.trim().isNotEmpty) {
                tckConstants.tckTitle = titleController.text.toString();
              } else if (field.isRequired!) {
                showAlertMsg("Please fill $displayName");
                return;
              }
            }

            if (field.type == tckConstants.tckTypeTitle &&
                field.name == tckConstants.tckPackageTitle) {
              if (package_title_ctrl.text.trim().isNotEmpty) {
                controller.dynamicTextFiledObj[field.name] =
                    package_title_ctrl.text.toString();
              } else if (field.isRequired!) {
                showAlertMsg("Please fill $displayName");
                return;
              }
            }

            if (field.type == tckConstants.tckTypeDescription &&
                field.name == tckConstants.tckMainDescription) {
              if (descController.text.isNotEmpty) {
                tckConstants.tckDesc = descController.text.toString();
                controller.dynamicTextFiledObj[field.name] =
                    descController.text.toString();
              } else if (field.isRequired!) {
                showAlertMsg("Please fill $displayName");
                return;
              }
            }

            if (field.type == tckConstants.tckTypeDropdown && field.isDoctor!) {
              if (doctor.text.isNotEmpty) {
                tckConstants.tckSelectedDoctor = doctor.text;
                tckConstants.tckSelectedDoctorId = docId;
              } else if (field.isRequired!) {
                showAlertMsg("Please choose $displayName");
                return;
              }
            }

            if (field.type == tckConstants.tckTypeDropdown &&
                field.isHospital!) {
              if (hospital.text.isNotEmpty) {
                tckConstants.tckSelectedHospital = hospital.text;
                tckConstants.tckSelectedHospitalId = hosId;
              } else if (field.isRequired!) {
                showAlertMsg("Please choose $displayName");
                return;
              }
            }

            if ((field.type == tckConstants.tckTypeDropdown ||
                    field.type == tckConstants.tckTypeLookUp) &&
                field.isLab!) {
              if (CommonUtil.REGION_CODE == "IN") {
                if (lab.text.isNotEmpty) {
                  controller!.dynamicTextFiledObj[field.name] =
                      controller.selPrefLabId.value;
                  if (!isLabNameOthers) {
                    controller!.dynamicTextFiledObj[strLabName] =
                        lab.text.toString().trim();
                  }
                } else if (field.isRequired!) {
                  showAlertMsg("Please choose $displayName");
                  return;
                }
              } else {
                if (controller!.selPrefLab.value != "Select") {
                  controller!.dynamicTextFiledObj[field.name] =
                      controller!.selPrefLab.value;
                }
              }
            }

            if (field.type == tckConstants.tckTypeDate) {
              if (preferredDateController.text.isNotEmpty) {
                tckConstants.tckPrefDate =
                    preferredDateController.text.toString();
                controller!.dynamicTextFiledObj[field.name] =
                    preferredDateController.text.toString();
              } else if (field.isRequired!) {
                showAlertMsg("Please select $displayName");
                return;
              }
            }

            if (field.type == tckConstants.tckTypeDropdown &&
                field.isCategory!) {
              if (dropdownValue != null) {
                controller.dynamicTextFiledObj[field.name] = dropdownValue;
              } else if (field.isRequired!) {
                showAlertMsg("Please choose $displayName");
                return;
              }
            }

            if (field.type == tckConstants.tckTypeFile &&
                field.name == tckConstants.tckTypeFileUpload) {
              if (field.isRequired! && imagePaths.length == 0) {
                showAlertMsg(CommonConstants.ticketFile);
                return;
              }
            }
          }
      }

      if (strName.contains(variable.strDoctorAppointment) ||
          strName.contains(variable.strLabAppointment)) {
        controller.dynamicTextFiledObj["title"] =
            titleController.text.toString();
        controller.dynamicTextFiledObj["serviceType"] = widget.ticketList!.name;
        controller.dynamicTextFiledObj["healthOrgTypeId"] =
            widget.ticketList!.additionalInfo!.healthOrgTypeId ?? "";
        commonMethodToCreateTicket(ticketListData);
      } else if (strName.contains(variable.strGeneralHealth)) {
        controller.dynamicTextFiledObj["title"] =
            titleController.text.toString();
        controller.dynamicTextFiledObj["serviceType"] = widget.ticketList!.name;

        commonMethodToCreateTicket(ticketListData);
      } else if (strName.contains(variable.strOrderPrescription)) {
        controller.dynamicTextFiledObj["serviceType"] = widget.ticketList!.name;
        commonMethodToCreateTicket(ticketListData);
      } else if (strName.contains(variable.strCareDietPlan)) {
        tckConstants.tckSelectedCategory = dropdownValue?.title ?? "";
        Constants.tckPackageName = package_title_ctrl.text;
        controller.dynamicTextFiledObj["serviceType"] = widget.ticketList!.name;
        commonMethodToCreateTicket(ticketListData);
      } else if (strName.contains(variable.strTransportation) ||
          strName.contains(variable.strHomecareServices) ||
          strName.contains(variable.strFoodDelivery)||strName.contains(strOthers)) {
        controller.dynamicTextFiledObj["title"] =
            titleController.text.toString();
        controller.dynamicTextFiledObj["serviceType"] = widget.ticketList!.name;
        controller.dynamicTextFiledObj["healthOrgTypeId"] =
            widget.ticketList!.additionalInfo!.healthOrgTypeId ?? "";

        commonMethodToCreateTicket(ticketListData);
      }
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      //print('Catch Error Occured : $error');
    }
  }

  void showAlertMsg(String msg) {
    Alert.displayAlert(context, title: variable.Error, content: msg);
  }

  void _getInitialDate(BuildContext context) {
    try {
      preferredDateStr = FHBUtils().getPreferredDateString(dateTime.toString());
      preferredDateController.text = preferredDateStr;
      selectedTime = TimeOfDay.now();
      preferredTimeStr = FHBUtils().formatTimeOfDay(selectedTime);
      preferredTimeController.text = preferredTimeStr;
    } catch (e) {
      //print(e);
    }
  }

  Widget dropDownButton(List<Hospitals> labsList) {
    try {
      if (labsList.length > 0) {
        for (Hospitals selHospitals in labsList) {
          if (selHospitals.name == controller!.selPrefLab.value) {
            selectedLab = selHospitals;
            controller!.selPrefLabId.value =
                CommonUtil().validString(selHospitals.id);
            controller!.selPrefLab.value =
                CommonUtil().validString(selHospitals.name);
          }
        }
      }
    } catch (e) {
      //print(e);
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
          ignoring: controller!.isPreferredLabDisable.value ?? false,
          child: DropdownButton<Hospitals>(
            value: selectedLab,
            underline: SizedBox(),
            isExpanded: true,
            hint: Row(
              children: <Widget>[
                SizedBoxWidget(width: 20),
                Text(CommonUtil().validString(selectedLab!.name),
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
            onChanged: (Hospitals? currLab) {
              try {
                selectedLab = currLab;
                controller!.selPrefLab.value =
                    CommonUtil().validString(currLab!.name);
                controller!.selPrefLabId.value =
                    CommonUtil().validString(currLab.id);
                setState(() {});
              } catch (e) {}
            },
          ),
        ),
      ),
    );
  }

  Widget dropDoctorDownButton(List<Doctors?> doctorsList) {
    try {
      if (doctorsList.length > 0) {
        for (Doctors? selDoctors in doctorsList) {
          if (selDoctors!.user!.name == controller!.selPrefLab.value) {
            selectedDoctor = selDoctors;
            controller!.selPrefDoctorId.value =
                CommonUtil().validString(selDoctors.id);
          }
        }
      }
    } catch (e) {
      //print(e);
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
          ignoring: controller!.isPreferredLabDisable.value ?? false,
          child: DropdownButton<Doctors>(
            value: selectedDoctor,
            underline: SizedBox(),
            isExpanded: true,
            hint: Row(
              children: <Widget>[
                SizedBoxWidget(width: 20),
                Text(CommonUtil().validString(selectedDoctor!.user!.name),
                    style: TextStyle(
                      fontSize: 14.0.sp,
                    )),
              ],
            ),
            items: doctorsList
                .map((Doctors? currDoc) => DropdownMenuItem(
                      child: Row(
                        children: <Widget>[
                          SizedBoxWidget(width: 20),
                          Text(CommonUtil().validString(currDoc!.user!.name),
                              style: TextStyle(
                                fontSize: 14.0.sp,
                              )),
                        ],
                      ),
                      value: currDoc,
                    ))
                .toList(),
            onChanged: (Doctors? currDoc) {
              try {
                selectedDoctor = currDoc;
                controller!.selPrefDoctor.value =
                    CommonUtil().validString(currDoc!.user!.name);
                controller!.selPrefDoctorId.value =
                    CommonUtil().validString(currDoc.id);
                setState(() {});
              } catch (e) {}
            },
          ),
        ),
      ),
    );
  }

  Widget getAllCustomRoles(Doctors? doctorObj, Function onAdd) {
    late Widget familyWidget;

    if (_providersBloc != null) {
      _providersBloc = null;
      _providersBloc = new ProvidersBloc();
    }
    return FutureBuilder<MyProvidersResponse?>(
      future: _providersBloc!.getMedicalPreferencesForDoctors(),
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
                  snapshot.data!.result != null &&
                  snapshot.data!.result!.doctors != null &&
                  snapshot.data!.result!.doctors!.isNotEmpty) {
                doctorsListFromProvider = snapshot.data!.result!.doctors;
                controller!.isCTLoading = true.obs;
                filterDuplicateDoctor();
                familyWidget = getDoctorDropDown(
                  doctorsListFromProvider,
                  doctorObj,
                  onAdd,
                );
              } else {
                doctorsListFromProvider = [];
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
    if (doctorsListFromProvider!.isNotEmpty) {
      copyOfdoctorsModel = doctorsListFromProvider;
      var ids = copyOfdoctorsModel!.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel!.retainWhere((x) => ids.remove(x?.user?.id));
      doctorsListFromProvider = copyOfdoctorsModel;
    }
  }

  void filterDuplicateHospital() {
    if (hospitalListFromProvider!.isNotEmpty) {
      copyOfhospitalModel = hospitalListFromProvider;
      var ids = copyOfhospitalModel!.map((e) => e?.id).toSet();
      copyOfhospitalModel!.retainWhere((x) => ids.remove(x?.id));
      hospitalListFromProvider = copyOfhospitalModel;
    }
  }

  getDoctorDropDown(
      List<Doctors?>? doctors, Doctors? doctorObjSample, Function onAddClick,
      {Widget? child}) {
    if (doctorObjSample != null) {
      for (var doctorsObjS in doctors!) {
        if (doctorsObjS!.id == doctorObjSample.id) {
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
                              child: Text(element!.user != null
                                  ? new CommonUtil()
                                      .getDoctorName(element.user!)!
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
                          child: Text(element!.user != null
                              ? new CommonUtil().getDoctorName(element.user!)!
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
              ) as List<PopupMenuEntry<Doctors>>,
        onSelected: (value) {
          doctorObj = value;
          setDoctorValue(value);
          setState(() {
            doctor.text = value.user != null
                ? CommonUtil().getDoctorName(value.user!)!
                : '';
            docId =
                value.user != null ? CommonUtil().validString(value.id) : '';
          });
        },
        child: child ?? getIconButton(),
      );
    });
  }

  getHospitalDropDown(List<Hospitals>? hospitallist,
      Hospitals? hospitalObjSample, Function onAddClick,
      {Widget? child}) {
    if (hospitalObjSample != null) {
      for (var hospitalObjS in hospitallist!) {
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
                                  element.name != null ? element.name! : ''),
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
                          child:
                              Text(element.name != null ? element.name! : ''),
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
              ) as List<PopupMenuEntry<Hospitals>>,
        onSelected: (value) {
          hospitalObj = value;
          setHospitalValue(value);
          setState(() {
            hospital.text = hospitalObj!.name != null ? hospitalObj!.name! : '';
            hosId = hospitalObj!.id != null ? hospitalObj!.id : '';
          });
        },
        child: child ?? getIconButton(),
      );
    });
  }

  Widget getAllHospitalRoles(Hospitals? hospitalObj, Function onAdd) {
    late Widget familyWidget;

    return FutureBuilder<MyProvidersResponse?>(
      future: _providersBloc!.getMedicalPreferencesForHospital(),
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
                  snapshot.data!.result != null &&
                  snapshot.data!.result!.hospitals != null &&
                  snapshot.data!.result!.hospitals!.isNotEmpty) {
                hospitalListFromProvider = snapshot.data!.result!.hospitals;
                filterDuplicateHospital();
                familyWidget = getHospitalDropDown(
                  hospitalListFromProvider,
                  hospitalObj,
                  onAdd,
                );
              } else {
                hospitalListFromProvider = [];
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
    return Icon(Icons.arrow_drop_down,color: Color(CommonUtil().getMyPrimaryColor()),size: 40,);
  }

  getDoctorDropDownWhenNoList(
      List<Doctors?>? doctors, Doctors? doctorObjSample, Function onAddClick,
      {Widget? child}) {
    if (doctorObjSample != null) {
      for (final doctorsObjS in doctors!) {
        if (doctorsObjS!.id == doctorObjSample.id) {
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
                                  element!.user!.name!,
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
                              element!.user!.name!,
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

  getHospitalsDropDownWhenNoList(List<Hospitals>? hospitallist,
      Hospitals? hospitalObjSample, Function onAddClick,
      {Widget? child}) {
    if (hospitalObjSample != null) {
      for (var hospitalObjS in hospitallist!) {
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
                                      element.name!,
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
                                  element.name!,
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
      name: newValue.user!.name,
      firstName: newValue.user!.firstName,
      lastName: newValue.user!.lastName,
      addressLine1: newValue.user!.userAddressCollection3![0].addressLine1,
      addressLine2: newValue.user!.userAddressCollection3![0].addressLine2,
      isMciVerified: newValue.isMciVerified,
      isTelehealthEnabled: newValue.isTelehealthEnabled,
      profilePicThumbnailUrl: newValue.user!.profilePicThumbnailUrl,
      specialization: newValue.specialization,
      userId: newValue.user!.id,
    );

    doctorsData = doctorNewObj;
  }

  void setHospitalValue(Hospitals newValue) {
    final hospitalNewObj = Hospital(
      healthOrganizationId: newValue.id,
      healthOrganizationName: newValue.name,
      addressLine1:
          newValue.healthOrganizationAddressCollection![0]?.addressLine1,
      addressLine2:
          newValue.healthOrganizationAddressCollection![0]?.addressLine2,
      cityName: newValue.healthOrganizationAddressCollection![0]?.city?.name,
      stateName: newValue.healthOrganizationAddressCollection![0]?.state?.name,
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
        controller!.labBookAppointment.value
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

        controller!.doctorBookAppointment.value
            ? SizedBox(height: 10.h)
            : SizedBox.shrink(),

        controller!.doctorBookAppointment.value
            ? dropDoctorDownButton(controller!.doctorsList != null &&
                    controller!.doctorsList!.length > 0
                ? controller!.doctorsList!
                : [])
            : SizedBox.shrink(),

        controller!.doctorBookAppointment.value &&
                controller!.isPreferredDoctorDisable.value
            ? SizedBox(height: 5.h)
            : SizedBox.shrink(),

        controller!.doctorBookAppointment.value &&
                controller!.isPreferredDoctorDisable.value
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

        controller!.doctorBookAppointment.value
            ? SizedBox(height: 20.h)
            : SizedBox.shrink(),
      ],
    );
  }

  void commonMethodToCreateTicket(var ticketListData) {
    try {
      if (ticketListData.additionalInfo != null) {

        for (Field field in widget.ticketList!.additionalInfo!.field!) {
          String displayName = displayFieldName(field)!;
          bool isVisible = false;
          if (CommonUtil().validString(field.isVisible).trim().isNotEmpty) {
            for (int i = 0;
                i < widget.ticketList!.additionalInfo!.field!.length;
                i++) {
              Field tempField = widget.ticketList!.additionalInfo!.field![i];
              if (tempField.selValueDD != null &&
                  field.isVisible!.contains(tempField.selValueDD!.id!) &&
                  field.isVisible!.contains(tempField.selValueDD!.fieldName!)) {
                isVisible = true;
                break;
              }
            }
          }

          if (field.type == tckConstants.tckTypeDropdown &&
              (field.fieldData != null && field.fieldData!.length > 0)&&!field.isProvider!)
          {
            String strMOS = CommonUtil().validString(
                textEditingControllers[CommonUtil().getFieldName(field.name)]!
                    .text);
            if (strMOS.isNotEmpty) {
              tckConstants.tckPrefMOSId = field.selValueDD != null
                  ? CommonUtil().validString(field.selValueDD!.id)
                  : "";
              tckConstants.tckPrefMOSName = strMOS;
              controller!.dynamicTextFiledObj[field.name] = field.selValueDD;
            } else if (field.isRequired!) {
              showAlertMsg("Please choose $displayName");
              return;
            }
          }

          if (field.type == tckConstants.tckTypeDropdown &&
              (field.fieldData != null && field.fieldData!.length > 0) &&
              field.isProvider!) {
            String strProviderField = getText(field);
            if (strProviderField.isNotEmpty) {
              controller.dynamicTextFiledObj[field.name] =
                  field?.selValueDD?.id ?? "";
              if (!isProviderOthers) {
                controller.dynamicTextFiledObj[strProviderName] =
                    field?.selValueDD?.name ?? "";
              }
            } else if (field.isRequired!) {
              showAlertMsg("Please choose $displayName");
              return;
            }
          }

          if (field.type == tckConstants.tckTypeTime) {
            String strTime =
                CommonUtil().validString(preferredTimeController.text);
            if (strTime.isNotEmpty) {
              tckConstants.tckPrefTime = strTime;
              controller!.dynamicTextFiledObj[field.name] = strTime;
            } else if (field.isRequired!) {
              showAlertMsg("Please select $displayName");
              return;
            }
          }

          if (field.type == tckConstants.tckTypeTitle &&
              (field.name != tckConstants.tckMainTitle &&
                  field.name != tckConstants.tckPackageTitle) &&
              field.isVisible == null) {
            String strText = getText(field);
            if (strText.isNotEmpty) {
              controller.dynamicTextFiledObj[field.name] = strText;
            } else if (field.isRequired!) {
              showAlertMsg("Please fill $displayName");
              return;
            }
          }

          if (field.type == tckConstants.tckTypeTitle &&
              (field.name != tckConstants.tckMainTitle &&
                  field.name != tckConstants.tckPackageTitle) &&
              field.isVisible != null) {
            String strText = getText(field);
            if (isVisible) {
              if (strText.isNotEmpty) {
                controller!.dynamicTextFiledObj[field.name] = strText;
              } else if (isVisible) {
                showAlertMsg("Please fill $displayName");
                return;
              }
            }
          }

          if (field.type == tckConstants.tckTypeDescription &&
              field.name != tckConstants.tckMainDescription &&
              field.isVisible == null) {
            String strText = getText(field);
            if (strText.isNotEmpty) {
              controller.dynamicTextFiledObj[field.name] = strText;
            } else if (field.isRequired!) {
              showAlertMsg("Please fill $displayName");
              return;
            }
          }

          if (field.type == tckConstants.tckTypeDescription &&
              field.name != tckConstants.tckMainDescription &&
              field.isVisible != null) {
            String strText = getText(field);
            if (isVisible) {
              if (strText.isNotEmpty) {
                controller!.dynamicTextFiledObj[field.name] = strText;
              } else if (isVisible) {
                showAlertMsg("Please fill $displayName");
                return;
              }
            }
          }

          if ((field.type == tckConstants.tckTypeTitle) &&
              field.isVisible != null &&
              field.name == strLabName &&
              isLabNameOthers) {
            String strText = getText(field);
            if (strText.isNotEmpty) {
              controller.dynamicTextFiledObj[field.name] =
                  strText;
            } else if (isLabNameOthers) {
              showAlertMsg("Please fill $displayName");
              return;
            }
          }

          if ((field.type == tckConstants.tckTypeDropdown ||
                  field.type == tckConstants.tckTypeLookUp) &&
              field.name == strCity) {
            bool isVisibleTrue = isVisible;
            if (field.isVisible == null) {
              isVisibleTrue = true;
            }
            String strText = getText(field);
            controller.dynamicTextFiledObj[field.name] = cityListData?.id??"";
            controller.dynamicTextFiledObj[strcityName] = cityListData?.name??"";
            if (isVisibleTrue && strText.trim().isEmpty) {
              showAlertMsg("Please select $displayName");
              return;
            }
          }

        }
      }

      tckConstants.ticketType = ticketListData.id;
      tckConstants.tckPriority = ticketListData.id;

      if (controller!.labBookAppointment.value &&
          controller!.selPrefLab.value != "Select") {
        tckConstants.tckPrefLab = controller!.selPrefLab.value;
        tckConstants.tckPrefLabId = controller!.selPrefLabId.value;
      } else {
        tckConstants.tckPrefLab = "";
        tckConstants.tckPrefLabId = "";
      }

      FocusScope.of(context).unfocus();

      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      ticketViewModel.createTicket().then((value) async {
        if (value != null && value.isSuccess!) {
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
                  FlutterToast()
                      .getToast('Ticket Created Successfully', Colors.grey);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  //print('Hitting API .. : ${value.toJson()}');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyTicketsListScreen()),
                  );
                } as FutureOr<List<dynamic>> Function(dynamic));
          } else {
            FlutterToast().getToast('Ticket Created Successfully', Colors.grey);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            //print('Hitting API .. : ${value.toJson()}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyTicketsListScreen()),
            );
          }
        } else {
          try {
            Navigator.of(context, rootNavigator: true).pop();
            String strMsg = CommonUtil().validString(value!.message);
            if (strMsg.trim().isNotEmpty) {
              FlutterToast().getToast(strMsg, Colors.red);
            }
          } catch (e) {
            //print(e);
          }
        }
      }).catchError((error) {
        Navigator.of(context, rootNavigator: true).pop();
        //print('API Error Occured : $error');
      });
    } catch (e) {
      //print(e);
    }
  }

  Widget getWidgetForFileText({bool isRequired = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text("Attach File${isRequired ? "\t*" : ""}",
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
          healthRecordList = results[STR_META_ID] as List?;
          if (healthRecordList != null) {
            getMediaURL(healthRecordList);
          }
        }
      }
    });
  }

  getMediaURL(List<HealthRecordCollection> healthRecordCollection) async {
    for (int i = 0; i < healthRecordCollection.length; i++) {
      String? fileType = healthRecordCollection[i].fileType;
      String? fileURL = healthRecordCollection[i].healthRecordUrl;
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
      // String? filePath = await LecleFlutterAbsolutePath.getAbsolutePath(uri: asset.identifier??'');
      // if(filePath!=null)imagePaths.add(ImagesModel(isFromFile: true, file: filePath, isdownloaded: true, asset: asset));
      String filePath =
          await FlutterAbsolutePath.getAbsolutePath(asset.identifier ?? '');
      imagePaths.add(ImagesModel(
          isFromFile: true,
          file: filePath,
          isdownloaded: true,
          asset: asset)); //FU2.5
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
              return InkWell(
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
                                        asset: asset as Asset,
                                        width: 150,
                                        height: 150,
                                      )))
                              : imagePaths[index].isdownloaded
                                  ? imagePaths[index].fileType!.trim() == ".pdf"
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
                                              await OpenFilex.open(
                                                imagePaths[index].file,
                                              ); // FU2.5
                                            },
                                          ),
                                        ))
                                      : Material(
                                          child: Container(
                                              height: double.infinity,
                                              child: Image.file(
                                                File(imagePaths[index].file!),
                                                width: 150,
                                                fit: BoxFit.fill,
                                                height: 150,
                                              )),
                                        )
                                  : imagePaths[index].fileType!.trim() == ".pdf"
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
                                              await OpenFilex.open(
                                                imagePaths[index].file,
                                              ); //FU2.5
                                            },
                                          ),
                                        ))
                                      : Material(
                                          child: Container(
                                              height: double.infinity,
                                              child: Image.network(
                                                imagePaths[index].file!,
                                                width: 150,
                                                fit: BoxFit.fill,
                                                height: 150,
                                                headers: {
                                                  HttpHeaders
                                                          .authorizationHeader:
                                                      authToken!
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
                                //print('set new state of images');
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
        } else {
          return [];
        }
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion.title!,
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
        package_title_ctrl.text = suggestion.title!;
        //stateVal = suggestion.state;
      },
      validator: (value) {
        if (value != null && value.length > 0) {
          package_title_ctrl.text = value;
        }

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
    planListModelList.addAll(responses[0]!.result!);
    planListModelList.addAll(responses[1]!.result!);
    planListModelList.addAll(responses[2]!.result!);
    planListModelList.addAll(responses[3]!.result!);
  }

  Widget getDropDownForPlanCategory(
      Map<String?, List<MenuItem>> healthConditionsList) {
    List<MenuItem> menuItems = [];
    healthConditionsList.values.map((element) {
      menuItems.addAll(element);
    }).toList();
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
              ignoring: controller!.isPreferredDoctorDisable.value,
              child: DropdownButton<MenuItem>(
                // Initial Value
                value: dropdownValue,
                isExpanded: true,
                underline: SizedBox(),
                hint: Row(
                  children: <Widget>[
                    SizedBoxWidget(width: 20),
                    Text(
                        CommonUtil().validString(
                            dropdownValue?.title ?? 'Select category'),
                        style: TextStyle(
                          fontSize: 14.0.sp,
                        )),
                  ],
                ),

                // Array list of items
                items: menuItems
                    .map((MenuItem items) => DropdownMenuItem(
                          child: Row(
                            children: <Widget>[
                              SizedBoxWidget(width: 20),
                              Text(CommonUtil().validString(items.title),
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                  )),
                            ],
                          ),
                          value: items,
                        ))
                    .toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (MenuItem? newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
              ),
            )));
  }

  Widget getExpandedDropdownForCategory() {
    return FutureBuilder<Map<String?, List<MenuItem>>>(
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
            return getDropDownForPlanCategory(healthConditionsResult!);
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
    String? authToken =
        await PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

    List<String?> filePathist = [];
    for (final _currentImage in imagesPathMain) {
      try {
        await FHBUtils.createFolderInAppDocDirClone(variable.stAudioPath,
                _currentImage.healthRecordUrl!.split('/').last)
            .then((filePath) async {
          var file;
          if (_currentImage.fileType == '.pdf') {
            file = File('$filePath');
          } else {
            file = File('$filePath');
          }
          final request = await ApiServices.get(
            _currentImage.healthRecordUrl!,
            headers: {
              HttpHeaders.authorizationHeader: authToken!,
              Constants.KEY_OffSet: CommonUtil().setTimeZone()
            },
          );
          final bytes = request!.bodyBytes; //close();
          await file.writeAsBytes(bytes);

          //print("file.path" + file.path);
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
    try {
      Constants.tckTitle = '';
      Constants.tckDesc = '';
      Constants.tckPrefDate = 'pref_date';
      Constants.tckPrefTime = 'pref_time';
      Constants.tckPrefMOSId = 'pref_mos_id';
      Constants.tckPrefMOSName = 'pref_mos_name';
      Constants.tckPrefLab = 'pref_lab';
      Constants.tckPrefLabId = 'pref_lab_id';
      Constants.ticketType = 'ticket type';
      Constants.tckPriority = 'ticket priority';
      Constants.tckID = 'ticket_id';
      Constants.tckComment = 'ticket_comment';
      Constants.tckSelectedDoctor = 'Doctor';
      Constants.tckSelectedDoctorId = 'DoctorId';
      Constants.tckSelectedHospital = 'Hospital';
      Constants.tckSelectedHospitalId = 'HospitalId';
      Constants.tckSelectedCategory = 'Category';
      Constants.tckPackageName = 'Package Name';
      controller!.strAddressLine.value = "";
      controller!.strCityName.value = "";
      controller!.strPincode.value = "";
      controller!.strStateName.value = ""; 
    } catch (e) {
      //print(e);
    }
  }

  getDropDownFields(Field field,
      {Widget? child}) {
    if (field.selValueDD != null) {
      for (var modeOfServiceObj in field.fieldData!) {
        if (modeOfServiceObj.id == field.selValueDD!.id) {
          field.selValueDD = modeOfServiceObj;
          field.selValueDD!.fieldName = field.name;
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton<FieldData>(
        offset: Offset(-100, 60),
        //padding: EdgeInsets.all(20),

        itemBuilder: (context) => (field.fieldData != null &&
                field.fieldData!.isNotEmpty)
            ? field.fieldData!
                .mapIndexed((index, element) => index ==
                        field.fieldData!.length - 1
                    ? PopupMenuItem<FieldData>(
                        value: element,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 0.5.sw,
                              child: Text(
                                  element.name != null ? element.name! : ''),
                            ),
                            SizedBox(height: 10),
                          ],
                        ))
                    : PopupMenuItem<FieldData>(
                        value: element,
                        child: Container(
                          width: 0.5.sw,
                          child:
                              Text(element.name != null ? element.name! : ''),
                        ),
                      ))
                .toList()
            : SizedBox.shrink() as List<PopupMenuEntry<FieldData>>,
        onSelected: (value) {
          onSelectDD(value,field);
        },
        child: child ?? getIconButton(),
      );
    });
  }

  onSelectDD(FieldData value, Field field) {
    try {
      field.selValueDD = value;
      field.selValueDD!.fieldName = field.name;
      if (controller.labBookAppointment.value &&
          (field.selValueDD!.name!.contains("Centre") ||
              field.selValueDD!.name!.contains("Center"))) {
        isLabAddressVisible = true;
      } else {
        isLabAddressVisible = false;
      }
      if (field.isProvider != null && field.isProvider!) {
        if (value?.id?.toLowerCase() == strOthers) {
          isProviderOthers = true;
        } else {
          isProviderOthers = false;
        }
      }
      setState(() {
        textEditingControllers[CommonUtil().getFieldName(field.name)]!.text =
            field.selValueDD!.name! != null ? field.selValueDD!.name! : '';
      });
      onRefreshWidget();
    } catch (e) {}
  }

  onRefreshWidget() {
    try {
      setState(() {});
    } catch (e) {
      //print(e);
    }
  }

  String? displayFieldName(Field field) {
    String? displayName = "";
    try {
      displayName = CommonUtil().validString(field.displayName);
      displayName = displayName.trim().isNotEmpty
          ? displayName
          : CommonUtil().getFieldName(field.name)!;
      return displayName;
    } catch (e) {}
    return displayName;
  }

  String getText(Field field) {
    String strText = "";
    try {
      strText = CommonUtil().validString(
          textEditingControllers[CommonUtil().getFieldName(field.name)]!.text);
      return strText;
    } catch (e) {}
    return strText;
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
