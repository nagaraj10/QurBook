import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../Qurhome/QurhomeDashboard/model/location_data_model.dart';
import '../../add_providers/bloc/update_providers_bloc.dart';
import '../../add_providers/models/add_providers_arguments.dart';
import '../../authentication/model/Country.dart';
import '../../authentication/widgets/country_code_picker.dart';
import '../../colors/fhb_colors.dart' as fhbColors;
import '../../common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../common/FHBBasicWidget.dart';
import '../../common/PreferenceUtil.dart';
import '../../common/common_circular_indicator.dart';
import '../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../../constants/fhb_constants.dart' as Constants;
import '../../constants/fhb_constants.dart';
import '../../constants/fhb_parameters.dart'as Parameters;
import '../../constants/router_variable.dart' as router;
import '../../constants/variable_constant.dart' as variable;
import '../../my_family/bloc/FamilyListBloc.dart';
import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/screens/FamilyListView.dart';
import '../../src/blocs/health/HealthReportListForUserBlock.dart';
import '../../src/model/user/MyProfileModel.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/colors_utils.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../bloc/doctors_list_block.dart';
import '../bloc/hospital_list_block.dart';
import '../bloc/labs_list_block.dart';
import '../models/CityListModel.dart' as cityListModel;
import '../models/doctor_list_response_new.dart';
import '../models/hospital_list_response_new.dart';
import '../models/labs_list_response_new.dart';
import '../models/search_arguments.dart';
import '../services/doctors_list_repository.dart';
import '../services/hospital_list_repository.dart';
import 'doctor_filter_request_model.dart';
import 'doctors_filter_screen.dart';
import 'right_side_menu_widget.dart';

export '../models/hospital_list_response.dart';

class SearchSpecificList extends StatefulWidget {
  SearchArguments? arguments;

  bool? toPreviousScreen;
  bool? isSkipUnknown;
  bool isFromCreateTicket;

  SearchSpecificList(
      {this.arguments,
      this.toPreviousScreen,
      this.isSkipUnknown,
      this.isFromCreateTicket = false});

  @override
  State<StatefulWidget> createState() => SearchSpecificListState();
}

class SearchSpecificListState extends State<SearchSpecificList> {
  late HealthReportListForUserBlock _healthReportListForUserBlock;

  DoctorsListBlock? _doctorsListBlock;

  HospitalListBlock? _hospitalListBlock;

  LabsListBlock? _labsListBlock;

  final TextEditingController _textFieldController =
      TextEditingController(text: '');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? value;

  final mobileNoController = TextEditingController();
  FocusNode mobileNoFocus = FocusNode();

  final nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();

  final firstNameController = TextEditingController();
  FocusNode firstNameFocus = FocusNode();

  final lastNameController = TextEditingController();
  FocusNode lastNameFocus = FocusNode();

  final specializationController = TextEditingController();
  FocusNode specializationFocus = FocusNode();

  final hospitalNameController = TextEditingController();
  FocusNode hospitalNameFocus = FocusNode();

  DoctorsListRepository doctorsListRepository = DoctorsListRepository();
  HospitalListRepository hospitalListRepository = HospitalListRepository();

  //var _selected = Country.IN;
  Country _selectedDialogCountry = Country.fromCode(CommonUtil.REGION_CODE);
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();

  MyProfileModel? myProfile;
  final doctorController = TextEditingController();
  FamilyListBloc? _familyListBloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  String? updatedProfilePic;
  String? selectedFamilyMemberName, switchedUserId;
  String? USERID;
  FlutterToast toast = FlutterToast();
  late UpdateProvidersBloc updateProvidersBloc;
  bool? teleHealthAlertShown = false;

  var regController = CommonUtil().onInitQurhomeRegimenController();
  List<DoctorsListResult> doctorFilterList = [];
  Map<String, List<String>> filterMenuCount = {};
  int count = 0;
  FilteredSelectedModel selectedItems = FilteredSelectedModel(
    selectedGenderIndex: [],
    selectedLanguageIndex: [],
    selectedSpecializationeIndex: [],
    selectedStateIndex: [],
    selectedCityIndex: [],
    selectedHospitalIndex: [],
    selectedYOEIndex: [],
  );

  // Create an instance of CommonUtil and call the onInitCreateTicketController method to obtain a createTicketController
  var createTicketController = CommonUtil().onInitCreateTicketController();

  @override
  void initState() {
    try {
      super.initState();
      FABService.trackCurrentScreen(FBADoctorSearchScreen);
      createTicketController.searchWord.value =
          widget.arguments!.searchWord ?? '';
      USERID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      switchedUserId = USERID;
      _doctorsListBlock = DoctorsListBlock();
      _hospitalListBlock = HospitalListBlock();
      _labsListBlock = LabsListBlock();

      updateProvidersBloc = UpdateProvidersBloc();

      _healthReportListForUserBlock = HealthReportListForUserBlock();

      value = _textFieldController.text.toString();

      createTicketController.strSearchText.value = value ?? '';

      _familyListBloc = FamilyListBloc();
      _familyListBloc!.getFamilyMembersListNew();

      if (widget.isFromCreateTicket) {

        // Set the value of isLabNameAscendingOrder to 0
        createTicketController.isLabNameAscendingOrder.value = 0;
        // Set the value of isDoctorSort to 0
        createTicketController.isDoctorSort.value = 0;


        var searchWord = widget.arguments!.searchWord ?? '';

        // Create a common filter request model
        DoctorFilterRequestModel commonFilterRequestModel =
            DoctorFilterRequestModel(
          page: 0,
          size: createTicketController.limit,
          searchText: CommonUtil()
              .validString(createTicketController.strSearchText.value),
          filters: [],
          sorts: [],
        );

        // Determine the controller and pagingController based on the searchWord
        if (searchWord == CommonConstants.doctors) {
          createTicketController.doctorFilterRequestModel =
              commonFilterRequestModel;

          createTicketController.pagingController = PagingController(
            firstPageKey: 0,
            invisibleItemsThreshold: 1,
          );

          createTicketController.pagingController
              .addPageRequestListener((pageKey) {
            createTicketController.fetchDoctorsListData(pageKey);
          });
        } else if (searchWord == CommonConstants.labs ||
            searchWord == CommonConstants.lab) {
          commonFilterRequestModel.healthOrganizationType =
              CommonConstants.keyLab.toUpperCase();
          createTicketController.labListFilterRequestModel =
              commonFilterRequestModel;

          createTicketController.labListResultPagingController =
              PagingController(
            firstPageKey: 0,
            invisibleItemsThreshold: 1,
          );

          createTicketController.labListResultPagingController
              .addPageRequestListener((pageKey) {
            createTicketController.fetchLabListData(pageKey);
          });
        }
      } else {
        if (value != '') {
          _doctorsListBlock!.getDoctorsListNew(
              _textFieldController.text.toString(), widget.isSkipUnknown);
        } else {
          if (widget.arguments!.searchWord == CommonConstants.doctors) {
            _doctorsListBlock!.getExistingDoctorList('40');
          } else if (widget.arguments!.searchWord ==
              CommonConstants.hospitals) {
            _hospitalListBlock!
                .getExistingHospitalListNew(Constants.STR_HEALTHORG_HOSPID);
          } else if (widget.arguments!.searchWord == CommonConstants.labs ||
              widget.arguments!.searchWord == CommonConstants.lab) {
            _labsListBlock!.getExistingLabsListNew(
                Constants.STR_HEALTHORG_LABID, widget.isFromCreateTicket);
          } else if (widget.arguments!.searchWord == CommonConstants.keyCity) {
            _labsListBlock!.getCityList('a');
          }
        }
      }

      // Execute the following code after the current frame is built
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        // Show the RefreshIndicator programmatically
        _refreshIndicatorKey.currentState?.show();

        // Hide the keyboard when the page opens
        FocusManager.instance.primaryFocus?.unfocus();
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isFromCreateTicket ? Colors.grey[200] : null,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: GradientAppBar(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.pop(context, [1]);
          },
        ),
        title: Text(
          // Check if the widget is from creating a ticket and searching for doctors
          (widget.isFromCreateTicket &&
                  widget.arguments!.searchWord == CommonConstants.doctors)
              ? Constants
                  .strChooseDoctor // Display "Choose Doctor" if searching for doctors
              :
              // Check if the widget is from creating a ticket and searching for labs or lab
              (widget.isFromCreateTicket &&
                      (widget.arguments!.searchWord == CommonConstants.labs ||
                          widget.arguments!.searchWord == CommonConstants.lab))
                  ? Constants
                      .strChooseLab // Display "Choose Lab" if searching for labs or lab
                  :
                  // Display the search word and variable string if none of the above conditions match
                  ('${widget.arguments!.searchWord} ' + variable.strSearch),
        ),
      ),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Column(
        children: <Widget>[
          Container(
            //margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(256, 256, 256, 0),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(CommonUtil().getMyPrimaryColor()),
                    Color(CommonUtil().getMyGredientColor())
                  ],
                  stops: [
                    0.3,
                    1
                  ]),
            ),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            //margin: EdgeInsets.all(5),
            child: Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
                controller: _textFieldController,
                autofocus: false,
                onChanged: (editedValue) {
                  createTicketController.strSearchText.value =
                      editedValue ?? '';
                  if (editedValue != '') {
                    value = editedValue;

                    // Check if the widget is from CreateTicket and searching for doctors
                    if (widget.isFromCreateTicket &&
                        widget.arguments!.searchWord ==
                            CommonConstants.doctors) {
                      // Create a new DoctorFilterRequestModel with updated values
                      DoctorFilterRequestModel doctorFilterRequestModel =
                          DoctorFilterRequestModel(
                        page: 0,
                        size: createTicketController.limit,
                        searchText: CommonUtil().validString(
                            createTicketController.strSearchText.value),
                            filters: createTicketController
                                .doctorFilterRequestModel?.filters ??
                            [],
                        sorts: createTicketController
                                .doctorFilterRequestModel?.sorts ??
                            [],
                      );

                      // Set the newly created DoctorFilterRequestModel to the controller
                      createTicketController.doctorFilterRequestModel =
                          doctorFilterRequestModel;

                      // Refresh the doctor paging controller
                      createTicketController.pagingController.refresh();
                    }
                    // Check if the widget is from CreateTicket and searching for labs or lab
                    else if (widget.isFromCreateTicket &&
                        (widget.arguments!.searchWord == CommonConstants.labs ||
                            widget.arguments!.searchWord ==
                                CommonConstants.lab)) {
                      // Create a new LabListFilterRequestModel with updated values
                      DoctorFilterRequestModel labListFilterRequestModel =
                          DoctorFilterRequestModel(
                        page: 0,
                        size: createTicketController.limit,
                        searchText: CommonUtil().validString(
                            createTicketController.strSearchText.value),
                        filters: createTicketController
                                .labListFilterRequestModel?.filters ??
                            [],
                        sorts: createTicketController
                                .labListFilterRequestModel?.sorts ??
                            [],
                        healthOrganizationType:
                            CommonConstants.keyLab.toUpperCase(),
                      );

                      // Set the newly created LabListFilterRequestModel to the controller
                      createTicketController.labListFilterRequestModel =
                          labListFilterRequestModel;

                      // Refresh the lab paging controller
                      createTicketController.labListResultPagingController
                          .refresh();
                    } else {
                      widget.arguments!.searchWord == CommonConstants.doctors
                          ? _doctorsListBlock!
                              .getDoctorsListNew(value, widget.isSkipUnknown)
                          : widget.arguments!.searchWord ==
                                  CommonConstants.hospitals
                              ? _hospitalListBlock!.getHospitalListNew(value)
                              : widget.arguments!.searchWord! ==
                                          CommonConstants.labs ||
                                      widget.arguments!.searchWord ==
                                          CommonConstants.lab
                                  ? _labsListBlock!.getLabsListNew(
                                      value!, widget.isFromCreateTicket)
                                  : _labsListBlock!.getCityList(value!);
                    }
                    setState(() {});
                  } else {
                    // Check if the widget is from CreateTicket and searching for doctors
                    if (widget.isFromCreateTicket &&
                        widget.arguments!.searchWord ==
                            CommonConstants.doctors) {
                      // Clear search criteria and refresh doctor paging controller
                      onClear();
                      createTicketController.pagingController.refresh();
                    }
                    // Check if the widget is from CreateTicket and searching for labs or lab
                    else if (widget.isFromCreateTicket &&
                        (widget.arguments!.searchWord == CommonConstants.labs ||
                            widget.arguments!.searchWord ==
                                CommonConstants.lab)) {
                      // Clear search criteria and refresh lab paging controller
                      onClear();
                      createTicketController.labListResultPagingController
                          .refresh();
                    } else {
                      widget.arguments!.searchWord == CommonConstants.doctors
                          ? _doctorsListBlock!.getExistingDoctorList('50')
                          : widget.arguments!.searchWord ==
                                  CommonConstants.hospitals
                              ? _hospitalListBlock!.getExistingHospitalListNew(
                                  Constants.STR_HEALTHORG_HOSPID)
                              : widget.arguments!.searchWord ==
                                          CommonConstants.labs ||
                                      widget.arguments!.searchWord ==
                                          CommonConstants.lab
                                  ? _labsListBlock!.getExistingLabsListNew(
                                      Constants.STR_HEALTHORG_LABID,
                                      widget.isFromCreateTicket)
                                  : _labsListBlock!.getCityList('a');
                    }
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  hintText: variable.strSearch,
                  hintStyle:
                      TextStyle(color: Colors.black54, fontSize: 16.0.sp),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
              child: value == ''
                  ? widget.arguments!.searchWord == CommonConstants.doctors
                      ? getResponseFromApiWidgetForDoctors()
                      : widget.arguments!.searchWord ==
                              CommonConstants.hospitals
                          ? getResponseFromApiWidgetForHospital()
                          : widget.arguments!.searchWord ==
                                      CommonConstants.labs ||
                                  widget.arguments!.searchWord ==
                                      CommonConstants.lab
                              ? getResponseFromApiWidgetForLabs()
                              : getResponseFromApiWidgetForCity()
                  : widget.arguments!.searchWord == CommonConstants.doctors
                      ? getResponseFromApiWidgetForDoctors()
                      : widget.arguments!.searchWord ==
                              CommonConstants.hospitals
                          ? getResponseFromApiWidgetForHospital()
                          : widget.arguments!.searchWord ==
                                      CommonConstants.labs ||
                                  widget.arguments!.searchWord ==
                                      CommonConstants.lab
                              ? getResponseFromApiWidgetForLabs()
                              : getResponseFromApiWidgetForCity()),
        ],
      ),
      bottomNavigationBar: (widget.isFromCreateTicket &&
              ((widget.arguments!.searchWord == CommonConstants.doctors) ||
                  (widget.arguments!.searchWord == CommonConstants.labs ||
                      widget.arguments!.searchWord == CommonConstants.lab)))
          ? Container(
              height: 50,
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color(CommonUtil().getMyPrimaryColor())),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showSortOrderDialog(widget.arguments!.searchWord ==
                                CommonConstants.doctors
                            ? true
                            : false);
                      },
                      child: Center(
                        child: Text(
                          Constants.strSort,
                          style: TextStyle(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Spacer(),
                  Container(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    width: 1,
                  ),
                  Flexible(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.to(DoctorsFilterScreen(
                          selectedItems: selectedItems,
                          filterMenuCount:
                              count != 0 ? count : filterMenuCount.length,
                          filterApplied: (
                            Map<String, List<String>> item,
                            List<DoctorsListResult> list,
                            FilteredSelectedModel items,
                            int filterCount,
                            DoctorFilterRequestModel doctorFilterRequestModel,
                          ) {
                            doctorFilterList = list;
                            selectedItems = items;
                            filterMenuCount = item;
                            count = filterCount;
                            if (createTicketController.searchWord.value ==
                                CommonConstants.doctors) {
                              doctorFilterRequestModel.sorts = createTicketController.doctorFilterRequestModel?.sorts ?? [];
                              createTicketController.doctorFilterRequestModel =
                                  doctorFilterRequestModel;
                              createTicketController.pagingController.refresh();
                            } else if (createTicketController
                                        .searchWord.value ==
                                    CommonConstants.labs ||
                                createTicketController.searchWord.value ==
                                    CommonConstants.lab) {
                              doctorFilterRequestModel.sorts = createTicketController.labListFilterRequestModel?.sorts ?? [];
                              createTicketController.labListFilterRequestModel =
                                  doctorFilterRequestModel;
                              createTicketController
                                  .labListResultPagingController
                                  .refresh();
                            }
                          },
                          filterSelectedItems: filterMenuCount,
                          doctorFilterRequestModel: createTicketController
                                      .searchWord.value ==
                                  CommonConstants.doctors
                              ? createTicketController.doctorFilterRequestModel
                              : createTicketController
                                  .labListFilterRequestModel,
                        ))?.then((value) {
                          setState(() {});
                        });
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Text(
                              Constants.strFilter,
                              style: TextStyle(
                                color: Color(CommonUtil().getMyPrimaryColor()),
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Visibility(
                              visible: count != 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    count.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // Function to get the widget based on the API response for labs
  Widget getResponseFromApiWidgetForLabs() {
    if (widget.isFromCreateTicket &&
        (widget.arguments!.searchWord == CommonConstants.labs ||
            widget.arguments!.searchWord == CommonConstants.lab)) {
      return getWidgetForLabServiceRequest();
    } else {
      return StreamBuilder<ApiResponse<LabsSearchListResponse>>(
        stream: _labsListBlock!.labNewStream,
        builder: (context, snapshot) {
          String strText = value ?? "";
          if (!snapshot.hasData) return Container();

          switch (snapshot.data!.status) {
            case Status.LOADING:
              rebuildBlockObject();
              return Center(
                child: SizedBox(
                  width: 30.0.h,
                  height: 30.0.h,
                  child: CommonCircularIndicator(),
                ),
              );
              break;

            case Status.ERROR:
              rebuildBlockObject();
              return Text(
                variable.strNoDataAvailable + ' ' + CommonConstants.labs,
                style: const TextStyle(color: Colors.red),
              );
              break;

            case Status.COMPLETED:
              rebuildBlockObject();
              return (strText.trim().isNotEmpty &&
                      strOthers.toLowerCase().contains(strText))
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      child: getAllDatasInLabsList(
                          snapshot.data?.data?.result ?? []),
                    )
                  : snapshot.data!.data!.result == null
                      ? Container(
                          child: const Center(
                            child: Text(variable.strNodata),
                          ),
                        )
                      : snapshot.data!.data!.result!.isEmpty
                          ? Container(
                              child: const Center(
                                child: Text(variable.strNodata),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(5),
                              child: getAllDatasInLabsList(
                                  snapshot.data!.data!.result),
                            );

              break;

            default:
              break;
          }
          return Container();
        },
      );
    }
  }

// Function to get the widget for lab service request
  Widget getWidgetForLabServiceRequest() {
    return Column(
      children: [
        Expanded(
          child: PagedListView(
            pagingController:
                createTicketController.labListResultPagingController,
            builderDelegate: PagedChildBuilderDelegate<LabListResult>(
              itemBuilder: (context, item, index) =>
                  labListView(labListResultData: item),
              noItemsFoundIndicatorBuilder: (_) => emptyView(),
              newPageErrorIndicatorBuilder: (_) => emptyView(),
              firstPageErrorIndicatorBuilder: (_) => emptyView(),
            ),
          ),
        ),
      ],
    );
  }

// Function to display the first two letters of a name
  Widget getFirstTwoLettersText(String strName) {
    if (strName != null) {
      var nameParts = strName.split(' ');
      var initials = '';

      if (nameParts.isNotEmpty) {
        initials = nameParts[0][0].toUpperCase();

        if (nameParts.length > 1) {
          initials += nameParts[1][0].toUpperCase();
        }
      }

      return Text(
        initials,
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w200,
        ),
      );
    }
  }

// Function to create the list view for labs
  Widget labListView({LabListResult? labListResultData}) {
    if (labListResultData != null) {
      return GestureDetector(
        onTap: () {
          try {
            if (widget.toPreviousScreen!) {
              passLaboratoryValue(labListResultData, context);
            } else {
              passdataToNextScreen(
                  labListResultData.healthOrganizationName,
                  context,
                  new DoctorsListResult(),
                  new HospitalsListResult(),
                  labListResultData);
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.only(
            top: 5.0.sp,
            bottom: 5.0.sp,
            left: 10.0.sp,
            right: 10.0.sp,
          ),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Container(
              padding: EdgeInsets.all(2.0.sp),
              margin: EdgeInsets.only(
                left: 8.0.w,
                right: 15.0.w,
                top: 8.0.h,
                bottom: 8.0.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipOval(
                    child: CommonUtil()
                            .validString(
                                labListResultData.healthOrganizationName)
                            .trim()
                            .isNotEmpty
                        ? CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: 50.0,
                              height: 50.0,
                              padding: const EdgeInsets.all(15.0),
                              child: CommonCircularIndicator(),
                            ),
                            imageUrl: labListResultData?.logoURL ?? '',
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              height: 50.0.h,
                              width: 50.0.h,
                              color: Colors.grey[200],
                              child: Center(
                                child: getFirstTwoLettersText(
                                    labListResultData.healthOrganizationName ??
                                        ''),
                              ),
                            ),
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 50.0,
                            color: Colors.grey,
                          ),
                  ),
                  SizedBoxWidget(
                    width: 12.0.w,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBoxWidget(
                          height: 5.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 4.0.w,
                          ),
                          child: Text(
                            labListResultData.healthOrganizationName != null
                                ? labListResultData.healthOrganizationName!
                                    .capitalizeFirstofEach
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                              color: Colors.black,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SizedBoxWidget(
                          height: 2.0.h,
                        ),
                        CommonUtil()
                                .validString(
                                    labListResultData.addressLine1 ?? '')
                                .trim()
                                .isNotEmpty
                            ? Row(
                                children: [
                                  SvgPicture.asset(
                                    doctorSearchHospital,
                                    color: Colors.grey,
                                    height: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      labListResultData.addressLine1!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0.sp,
                                        color: Colors.grey,
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

// Function to get the widget based on the API response for doctors
  Widget getResponseFromApiWidgetForDoctors() {
    if ((widget.isFromCreateTicket &&
        widget.arguments!.searchWord == CommonConstants.doctors)) {
      return getWidgetForDoctorServiceRequest();
    } else {
      return StreamBuilder<ApiResponse<DoctorsSearchListResponse>>(
        stream: _doctorsListBlock!.doctorsNewStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          switch (snapshot.data!.status) {
            case Status.LOADING:
              rebuildBlockObject();
              return Center(
                child: SizedBox(
                  child: CommonCircularIndicator(),
                  width: 30.0.h,
                  height: 30.0.h,
                ),
              );
              break;

            case Status.ERROR:
              rebuildBlockObject();
              return Text(
                variable.strNoDataAvailable + ' ' + CommonConstants.doctors,
                style: TextStyle(color: Colors.red),
              );
              break;

            case Status.COMPLETED:
              rebuildBlockObject();
              return (snapshot.data!.data!.isSuccess == false &&
                      widget.isSkipUnknown == true)
                  ? Container(
                      margin: EdgeInsets.all(5),
                      child:
                          getAllDatasInDoctorsListScrap(snapshot.data!.data!),
                    )
                  : (snapshot.data!.data!.result == null)
                      ? getEmptyCard(snapshot.data!.data!.diagnostics)
                      : snapshot.data!.data!.result!.isEmpty
                          ? Container(
                              child: Center(
                                child: Text(variable.strNodata),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.all(5),
                              child: getAllDatasInDoctorsList(
                                  snapshot.data!.data!.result),
                            );
              break;
          }
        },
      );
    }
  }

// Function to get the widget for doctor service request
  Widget getWidgetForDoctorServiceRequest() {
    return Column(
      children: [
        Expanded(
          child: PagedListView(
            pagingController: createTicketController.pagingController,
            builderDelegate: PagedChildBuilderDelegate<DoctorsListResult>(
              itemBuilder: (context, item, index) =>
                  doctorsListView(doctorsListResultData: item),
              noItemsFoundIndicatorBuilder: (_) => emptyView(),
              newPageErrorIndicatorBuilder: (_) => emptyView(),
              firstPageErrorIndicatorBuilder: (_) => emptyView(),
            ),
          ),
        ),
      ],
    );
  }

// Function to create the list view for doctors
  Widget doctorsListView({DoctorsListResult? doctorsListResultData}) {
    if (doctorsListResultData != null) {
      var strExperience = CommonUtil()
          .validString(doctorsListResultData?.experience.toString());
      strExperience = strExperience?.trim().isNotEmpty ?? false
          ? strExperience != '0'
              ? '$strExperience ${strExperience=='1'?Constants.strYear:Constants.strYears}'
              : ''
          : '';
      var locationString = doctorsListResultData.healthOrganizationName ?? '';
      locationString += CommonUtil()
              .validString(doctorsListResultData?.city ?? '')
              .trim()
              .isNotEmpty
          ? ' - ${doctorsListResultData.city}'
          : '';
      locationString += CommonUtil()
              .validString(doctorsListResultData?.state ?? '')
              .trim()
              .isNotEmpty
          ? ' , ${doctorsListResultData.state}'
          : '';
      return GestureDetector(
        onTap: () {
          try {
            if (widget.toPreviousScreen!) {
              widget.arguments!.searchWord == CommonConstants.doctors
                  ? passDoctorsValue(doctorsListResultData, context)
                  : widget.arguments!.searchWord == CommonConstants.hospitals
                      ? passHospitalValue(new HospitalsListResult(), context)
                      : passLaboratoryValue(new LabListResult(), context);
            } else {
              passdataToNextScreen(
                  doctorsListResultData.name,
                  context,
                  doctorsListResultData,
                  new HospitalsListResult(),
                  new LabListResult());
            }
          } catch (e, stackTrace) {
            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.only(
            top: 5.0.sp,
            bottom: 5.0.sp,
            left: 10.0.sp,
            right: 10.0.sp,
          ),
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Container(
              padding: EdgeInsets.all(2.0.sp),
              margin: EdgeInsets.only(
                left: 8.0.w,
                right: 15.0.w,
                top: 8.0.h,
                bottom: 8.0.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ClipOval(
                          child: CommonUtil()
                                  .validString(doctorsListResultData.firstName)
                                  .trim()
                                  .isNotEmpty
                              ? CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    width: 50.0,
                                    height: 50.0,
                                    padding: const EdgeInsets.all(15.0),
                                    child: CommonCircularIndicator(),
                                  ),
                                  imageUrl: doctorsListResultData
                                          ?.profilePicThumbnailUrl ??
                                      '',
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 50.0.h,
                                    width: 50.0.h,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: getFirstLastNameText(
                                          doctorsListResultData),
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 50.0,
                                  color: Colors.grey,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            strExperience,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBoxWidget(
                    width: 10.0.w,
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBoxWidget(
                          height: 5.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 4.0.w,
                          ),
                          child: Text(
                            doctorsListResultData.name != null
                                ? doctorsListResultData
                                    .name!.capitalizeFirstofEach
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                              color: Colors.black,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SizedBoxWidget(
                          height: 2.0.h,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              doctorSpecialization,
                              color: Color(CommonUtil().getMyPrimaryColor()),
                              height: 15,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                CommonUtil().validString(
                                    doctorsListResultData.specialization ?? ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0.sp,
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxWidget(
                          height: 2.0.h,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              doctorSearchHospital,
                              color: Colors.grey,
                              height: 15,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                locationString,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0.sp,
                                  color: Colors.grey,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBoxWidget(
                          height: 2.0.h,
                        ),
                        Row(children: [
                          SvgPicture.asset(
                            doctorSearchLanguage,
                            color: Colors.blue,
                            height: 15,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Container(
                                  height: 25.0.sp,
                                  width: double.infinity,
                                  child: getTagsWidget(
                                      doctorsListResultData.doctorLanguage ??
                                          [])))
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

// Function to get the tags widget
  Widget getTagsWidget(List<String> tags) {
    return ((tags?.length ?? 0) > 0)
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: tags.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: EdgeInsets.only(left: 5),
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
                color: Colors.blue,
                child: Center(
                  child: Text(
                    tags[i],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            },
          )
        : SizedBox.shrink();
  }

// Function to create an empty view
  Widget emptyView() {
    return Container(
      height: 1.sh,
      alignment: Alignment.center,
      child: Center(
        child: Text(
          variable.strNodata,
        ),
      ),
    );
  }

  Widget getResponseFromApiWidgetForHospital() =>
      StreamBuilder<ApiResponse<HospitalsSearchListResponse>>(
        stream: _hospitalListBlock!.hospitalNewStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          switch (snapshot.data!.status) {
            case Status.LOADING:
              rebuildBlockObject();
              return Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));

              break;

            case Status.ERROR:
              rebuildBlockObject();
              return Text(
                  variable.strNoDataAvailable + ' ' + CommonConstants.hospitals,
                  style: const TextStyle(color: Colors.red));
              break;

            case Status.COMPLETED:
              rebuildBlockObject();

              return snapshot.data!.data!.result == null
                  ? /*Container(
                    child: Center(
                      child: Text(variable.strNodata),
                    ),
                  )*/
                  getEmptyCard(snapshot.data!.data!.diagnostics)
                  : snapshot.data!.data!.result!.isEmpty
                      ? Container(
                          child: const Center(
                            child: Text(variable.strNodata),
                          ),
                        )
                      //getEmptyCard()
                      : Container(
                          child: getAllDatasInHospitalList(
                              snapshot.data!.data!.result),
                          margin: const EdgeInsets.all(5),
                        );
              break;
          }
        },
      );

  void rebuildBlockObject() {
    _doctorsListBlock = null;
    _doctorsListBlock = DoctorsListBlock();

    _hospitalListBlock = null;
    _hospitalListBlock = HospitalListBlock();

    _labsListBlock = null;
    _labsListBlock = LabsListBlock();
  }

  Widget getEmptyCard(Diagnostics? diagnostics) => !widget.toPreviousScreen!
      ? Center(
          child: Text(
            'No Records Found ',
            style: TextStyle(
              color: ColorUtils.blackcolor,
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Records Found ',
                style: TextStyle(
                  color: ColorUtils.blackcolor,
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              fhbBasicWidget.getSaveButton(() {
                if (widget.toPreviousScreen!) {
                  widget.arguments!.searchWord == CommonConstants.doctors
                      ? saveMediaDialog(context)
                      : widget.arguments!.searchWord ==
                              CommonConstants.hospitals
                          ? saveHospitalDialog(context)
                          : widget.arguments!.searchWord ==
                                      CommonConstants.labs ||
                                  widget.arguments!.searchWord ==
                                      CommonConstants.lab
                              ? passLaboratoryValue(null, context)
                              : passCityValue(null, context);
                }
              }, text: 'Click here to add', width: 150.w),
            ],
          ),
        );

  Future<void> _refresh() async {
    await _refreshIndicatorKey.currentState?.show(atTop: false);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Widget _showAddButton(Diagnostics diagnostics) {
    final loginButtonWithGesture = GestureDetector(
      onTap: () {
        if (widget.toPreviousScreen!) {
          widget.arguments!.searchWord == CommonConstants.doctors
              ? passDoctorsValue(diagnostics.errorData, context)
              : widget.arguments!.searchWord == CommonConstants.hospitals
                  ? passHospitalValue(null, context)
                  : widget.arguments!.searchWord == CommonConstants.labs ||
                          widget.arguments!.searchWord == CommonConstants.lab
                      ? passLaboratoryValue(null, context)
                      : passCityValue(null, context);
        }
      },
      child: Container(
        width: 100.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Click Here',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: loginButtonWithGesture);
  }

  Widget getAllDatasInDoctorsList(List<DoctorsListResult>? data) {
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
                      (data[i].name != null && data[i].name != '')
                          ? data[i].name!.capitalizeFirstofEach
                          : data[i].firstName!.capitalizeFirstofEach +
                              ' ' +
                              data[i].lastName!.capitalizeFirstofEach,
                      getDoctorsAddress(data[i]),
                      data[i].doctorId,
                      data[i].profilePicThumbnailUrl,
                      data[i],
                      HospitalsListResult(),
                      LabListResult()),
                ),
                itemCount: data.length,
              ))
          : Container(
              color: Color(fhbColors.bgColorContainer),
              child: Center(
                child: Text(variable.strNodata),
              ),
            ),
    );
  }

  Widget getAllDatasInDoctorsListScrap(DoctorsSearchListResponse data) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: (data.isSuccess == false &&
              widget.isSkipUnknown == true &&
              data.diagnostics?.errorData != null)
          ? Container(
              color: Color(fhbColors.bgColorContainer),
              child: getEmptyCard(data.diagnostics),
            )
          : data.result != null
              ? Container(
                  color: Color(fhbColors.bgColorContainer),
                  child: ListView.builder(
                    itemBuilder: (c, i) => Container(
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      child: getCardToDisplaySearchList(
                          (data.result![i].name != null &&
                                  data.result![i].name != '')
                              ? data.result![i].name!.capitalizeFirstofEach
                              : data.result![i].firstName!
                                      .capitalizeFirstofEach +
                                  ' ' +
                                  data.result![i].lastName!
                                      .capitalizeFirstofEach,
                          getDoctorsAddress(data.result![i]),
                          data.result![i].doctorId,
                          data.result![i].profilePicThumbnailUrl,
                          data.result![i],
                          HospitalsListResult(),
                          LabListResult()),
                    ),
                    itemCount: data.result!.length,
                  ))
              : Container(
                  color: Color(fhbColors.bgColorContainer),
                  child: Center(
                    child: Text(variable.strNodata),
                  ),
                ),
    );
  }

  getAllDatasInHospitalList(List<HospitalsListResult>? data) =>
      RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        color: Color(CommonUtil().getMyPrimaryColor()),
        child: data != null
            ? Container(
                color: const Color(fhbColors.bgColorContainer),
                child: ListView.builder(
                  itemBuilder: (c, i) => Container(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: getCardToDisplaySearchList(
                        (data[i].name != null && data[i].name != "")
                            ? data[i].name
                            : data[i].healthOrganizationName,
                        data[i].addressLine1,
                        data[i].healthOrganizationId ??
                            data[i].healthOrganizationReferenceId,
                        null,
                        DoctorsListResult(),
                        data[i],
                        LabListResult(),
                        cityAndState: getHospitalCityAndState(data[i])),
                  ),
                  itemCount: data.length,
                ))
            : Container(
                color: const Color(fhbColors.bgColorContainer),
                child: const Center(
                  child: Text(variable.strNodata),
                ),
              ),
      );

  Widget getAllDatasInLabsList(List<LabListResult>? data) {
    try {
      if (widget.isFromCreateTicket) {
        Location? locationModel = regController.locationModel;

        List<LabListResult>? tempLabListResult = data;

        //print("tempLabListResult length ${tempLabListResult.length}");

        List<LabListResult> subLocalBasedLabListResult = [];
        List<LabListResult> cityBasedLabListResult = [];
        List<LabListResult> otherLabListResult = [];

        //finalSortList
        List<LabListResult> finalLabListResult = [];

        if (tempLabListResult != null && tempLabListResult.length > 0) {
          if (locationModel != null && locationModel.locality != null) {
            subLocalBasedLabListResult = tempLabListResult
                .where((item) =>
                    CommonUtil()
                        .validString(item.addressLine1)
                        .trim()
                        .isNotEmpty &&
                    CommonUtil().validString(item.addressLine1).contains(
                        CommonUtil().validString(locationModel.locality)))
                .toList();
          }
          if (locationModel != null && locationModel.subAdminArea != null) {
            cityBasedLabListResult = tempLabListResult
                .where((item) =>
                    CommonUtil().validString(item.cityName).trim().isNotEmpty &&
                    CommonUtil().validString(item.cityName).contains(
                        CommonUtil().validString(locationModel.subAdminArea)))
                .toList();
          }

          otherLabListResult = tempLabListResult
              .where((item) =>
                  !CommonUtil().validString(item.addressLine1).contains(
                      locationModel != null && locationModel.locality != null
                          ? CommonUtil().validString(locationModel.locality)
                          : "") ||
                  !CommonUtil().validString(item.cityName).contains(
                      locationModel != null &&
                              locationModel.subAdminArea != null
                          ? CommonUtil().validString(locationModel.subAdminArea)
                          : ""))
              .toList();

          otherLabListResult.sort((a, b) => CommonUtil()
              .validString(a.healthOrganizationName.toString())
              .toLowerCase()
              .compareTo(CommonUtil()
                  .validString(b.healthOrganizationName.toString())
                  .toLowerCase()));

          finalLabListResult = subLocalBasedLabListResult +
              cityBasedLabListResult +
              otherLabListResult;
          finalLabListResult = finalLabListResult.toSet().toList();
          data = finalLabListResult;
        }

        String strText = value ?? "";

        if (strText.trim().isEmpty ||
            strOthers.toLowerCase().contains(strText)) {
          LabListResult labListResult = LabListResult();
          labListResult.healthOrganizationName =
              toBeginningOfSentenceCase(strOthers);
          labListResult.healthOrganizationId = strOthers;
          data!.add(labListResult);
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      //print(e);
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: data != null
          ? Container(
              color: const Color(fhbColors.bgColorContainer),
              child: ListView.builder(
                itemBuilder: (c, i) => Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: getCardToDisplaySearchList(
                      data![i].healthOrganizationName,
                      data[i].addressLine1,
                      data[i].healthOrganizationId ??
                          data[i].healthOrganizationReferenceId,
                      '',
                      DoctorsListResult(),
                      HospitalsListResult(),
                      data[i]),
                ),
                itemCount: data.length,
              ))
          : Container(
              color: const Color(fhbColors.bgColorContainer),
              child: const Center(
                child: Text(variable.strNodata),
              ),
            ),
    );
  }

  Widget getCardToDisplaySearchList(
      String? name,
      String? address,
      String? id,
      String? logo,
      DoctorsListResult data,
      HospitalsListResult hospitalData,
      LabListResult labData,
      {String? cityAndState}) {
    return GestureDetector(
        child: Padding(
            padding: EdgeInsets.only(bottom: 4, left: 10, right: 10),
            child: Container(
                padding: EdgeInsets.only(bottom: 2),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: <Widget>[
                  SizedBox(
                    width: 10.0.w,
                  ),
                  ClipOval(
                      child: Container(
                    height: 50.0.h,
                    width: 50.0.h,
                    color: Color(fhbColors.bgColorContainer),
                    child:
                        widget.arguments!.searchWord == CommonConstants.doctors
                            ? getHospitalLogoImage(logo, data)
                            : getHospitalLogoImage(logo, data),
                  )),
                  SizedBox(width: 10.0.w),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: getDataToView(
                          widget.arguments!.searchWord ==
                                  CommonConstants.doctors
                              ? name
                              : widget.arguments!.searchWord ==
                                      CommonConstants.hospitals
                                  ? name
                                  : labData.healthOrganizationName,
                          address,
                          id,
                          data,
                          specialization: widget.arguments!.searchWord ==
                                  CommonConstants.hospitals
                              ? hospitalData.specialization
                              : null,
                        ),
                      ))
                ]))),
        onTap: () {
          if (widget.toPreviousScreen!) {
            widget.arguments!.searchWord == CommonConstants.doctors
                ? passDoctorsValue(data, context)
                : widget.arguments!.searchWord == CommonConstants.hospitals
                    ? passHospitalValue(hospitalData, context)
                    : passLaboratoryValue(labData, context);
          } else {
            passdataToNextScreen(
                data.name, context, data, hospitalData, labData);
          }
        });
  }

  getCorrespondingImageWidget(String id) => const Icon(Icons.verified_user);

  void passDoctorsValue(DoctorsListResult? doctorData, BuildContext context) {
    Navigator.of(context).pop({Constants.keyDoctor: json.encode(doctorData)});
  }

  void passHospitalValue(
      HospitalsListResult? hospitaData, BuildContext context) {
    Navigator.of(context)
        .maybePop({Constants.keyHospital: json.encode(hospitaData)});
  }

  void passLaboratoryValue(
      LabListResult? laboratoryData, BuildContext context) {
    Navigator.of(context).pop({Constants.keyLab: json.encode(laboratoryData)});
  }

  void passCityValue(
      cityListModel.CityListData? cityData, BuildContext context) {
    Navigator.of(context).pop({Constants.keyCity: cityData});
  }

  getDataToView(
    String? name,
    String? address,
    String? id,
    DoctorsListResult data, {
    String? cityAndState,
    String? specialization,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name != null ? name.capitalizeFirstofEach : '',
            style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w500,
                color: ColorUtils.blackcolor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.0.h),
          if (address != null)
            Text(
              address,
              style: TextStyle(
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.lightgraycolor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (cityAndState != null)
            Text(
              cityAndState,
              style: TextStyle(
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.lightgraycolor),
            ),
          widget.arguments!.searchWord == CommonConstants.doctors
              ? (data.specialty != null && data.specialty != '')
                  ? Text(
                      toBeginningOfSentenceCase(data.specialty ?? '')!,
                      style: TextStyle(
                          fontSize: 15.0.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.lightgraycolor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : SizedBox(height: 10.0.h)
              : (specialization != null && specialization != '')
                  ? Text(
                      toBeginningOfSentenceCase(specialization)!,
                      style: TextStyle(
                          fontSize: 15.0.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.lightgraycolor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : SizedBox(height: 10.0.h),
        ],
      );

  getDoctorProfileImageWidget(String id) => FutureBuilder(
        future: _healthReportListForUserBlock.getProfilePic(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data as Uint8List,
              height: 50.0.h,
              width: 50.0.h,
              fit: BoxFit.cover,
            );
          } else {
            return ImageIcon(
              const AssetImage(variable.icon_stetho),
              size: 40.0.sp,
              color: Color(CommonUtil().getMyPrimaryColor()),
            );
          }
        },
      );

  Widget getHospitalLogoImage(String? logo, DoctorsListResult docs) {
    if (logo == null || logo == '') {
      return Container();
    } else {
      return Image.network(logo,
          errorBuilder: (context, exception, stackTrace) => Container(
                height: 50.0.h,
                width: 50.0.h,
                color: Colors.grey[200],
                child: Center(
                  child: getFirstLastNameText(docs),
                ),
              ));
    }
  }

  Widget getFirstLastNameText(DoctorsListResult myProfile) {
    if (myProfile.firstName != null && myProfile.lastName != null) {
      return Text(
        myProfile.firstName![0].toUpperCase() +
            (myProfile.lastName!.length > 0
                ? myProfile.lastName![0].toUpperCase()
                : ''),
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else if (myProfile.firstName != null) {
      return Text(
        myProfile.firstName![0].toUpperCase(),
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    } else {
      return Text(
        '',
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w200,
        ),
      );
    }
  }

  void passdataToNextScreen(
      String? name,
      BuildContext context,
      DoctorsListResult data,
      HospitalsListResult hospitalData,
      LabListResult labData) {
    if (widget.arguments!.searchWord == CommonConstants.doctors) {
      if (data.patientAssociationRequest!) {
        selectedFamilyMemberName = null;
        showDialogBoxToAddDoctorWhenPermissionRequired(context, data);
      } else {
        Navigator.pushNamed(
          context,
          router.rt_AddProvider,
          arguments: AddProvidersArguments(
              data: data,
              searchKeyWord: CommonConstants.doctors,
              fromClass: widget.arguments!.fromClass == router.cn_AddProvider
                  ? widget.arguments!.fromClass
                  : router.rt_TelehealthProvider,
              hasData: true),
        ).then((value) {
          if (value == 1) {
            Navigator.pop(context);
          }
        });
      }
    } else if (widget.arguments!.searchWord == CommonConstants.hospitals) {
      Navigator.pushNamed(
        context,
        router.rt_AddProvider,
        arguments: AddProvidersArguments(
            hospitalData: hospitalData,
            searchKeyWord: CommonConstants.hospitals,
            fromClass: widget.arguments!.fromClass == router.cn_AddProvider
                ? widget.arguments!.fromClass
                : router.rt_TelehealthProvider,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    } else {
      Navigator.pushNamed(
        context,
        router.rt_AddProvider,
        arguments: AddProvidersArguments(
            labData: labData,
            searchKeyWord: CommonConstants.labs,
            fromClass: widget.arguments!.fromClass == router.cn_AddProvider
                ? widget.arguments!.fromClass
                : router.rt_TelehealthProvider,
            hasData: true),
      ).then((value) {
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    }
  }

  _addBtnTapped(Diagnostics diagnostics) {
    /* Navigator.pushNamed(context, router.rt_AddProvider,
        arguments: AddProvidersArguments(
          searchText: value,
          fromClass: widget.arguments.fromClass == router.cn_AddProvider
              ? widget.arguments.fromClass
              : router.rt_TelehealthProvider,
          searchKeyWord: widget.arguments.searchWord == CommonConstants.doctors
              ? CommonConstants.doctors
              : widget.arguments.searchWord == CommonConstants.hospitals
                  ? CommonConstants.hospitals
                  : CommonConstants.labs,
          hasData: false,
        )).then((results) {
      if (results != null) {
        widget.arguments.searchWord == CommonConstants.doctors
            ? passDoctorsValueSample(results, context)
            : widget.arguments.searchWord == CommonConstants.hospitals
                ? passHospitalValueSample(results, context)
                : passLaboratoryValueSample(results, context);
      }
    });*/

    if (widget.toPreviousScreen!) {
      widget.arguments!.searchWord == CommonConstants.doctors
          ? passDoctorsValue(diagnostics.errorData, context)
          : widget.arguments!.searchWord == CommonConstants.hospitals
              ? passHospitalValue(null, context)
              : widget.arguments!.searchWord == CommonConstants.labs ||
                      widget.arguments!.searchWord == CommonConstants.lab
                  ? passLaboratoryValue(null, context)
                  : passCityValue(null, context);
    }
  }

  passDoctorsValueSample(results, BuildContext context) {
    final DoctorsListResult? jsonDecodeForDoctor = results[Constants.keyDoctor];

    passDoctorsValue(jsonDecodeForDoctor, context);
  }

  passHospitalValueSample(results, BuildContext context) {
    final HospitalsListResult? jsonDecodeForDoctor =
        results[Constants.keyHospital];

    passHospitalValue(jsonDecodeForDoctor, context);
  }

  passLaboratoryValueSample(results, BuildContext context) {
    final LabListResult? jsonDecodeForDoctor = results[Constants.keyLab];

    passLaboratoryValue(jsonDecodeForDoctor, context);
  }

  String? getDoctorsAddress(DoctorsListResult data) {
    String? address = '';
    if (data.addressLine1 != '' && data.addressLine1 != null) {
      address = toBeginningOfSentenceCase(data.addressLine1);
    }
    if (data.addressLine2 != '' && data.addressLine2 != null) {
      address = address! + ',' + toBeginningOfSentenceCase(data.addressLine2)!;
    }
    if (data.city != '' && data.city != null) {
      address = address! + '\n' + toBeginningOfSentenceCase(data.city)!;
    }
    if (data.state != '' && data.state != null) {
      address = address! + ',' + toBeginningOfSentenceCase(data.state)!;
    }
    return address;
  }

  String? getHospitalCityAndState(HospitalsListResult data) {
    String? city = '';

    if (data.cityName != '' && data.cityName != null) {
      city = toBeginningOfSentenceCase(data.cityName);
    }
    if (data.stateName != '' && data.stateName != null) {
      city = city! + ',' + toBeginningOfSentenceCase(data.stateName)!;
    }
    return city;
  }

  saveMediaDialog(BuildContext context) {
    firstNameController.text = _textFieldController.text;
    lastNameController.text = '';
    mobileNoController.text = '';
    specializationController.text = '';
    hospitalNameController.text = '';
    _textFieldController.text = '';

    return showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1)),
                content: Container(
                    width: 1.sw,
                    height: 1.sh / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 24.0.sp,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    _showFirstNameTextField(),
                                  ],
                                ),

                                SizedBox(
                                  height: 10.0.h,
                                ),
                                Row(
                                  children: <Widget>[
                                    _showLastNameTextField(),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                Row(
                                  children: <Widget>[
                                    CountryCodePickerPage(
                                      selectedCountry: _selectedDialogCountry,
                                      onValuePicked: (country) => setState(
                                        () => _selectedDialogCountry = country,
                                      ),
                                      isEnabled: BASE_URL != prodUSURL,
                                    ),
                                    _ShowMobileNoTextField()
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),

                                Row(
                                  children: <Widget>[
                                    _showSpecializationTextField(),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                                /*Row(
                              children: <Widget>[
                                _showHospitalNameTextField(false),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),*/

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _showAddDoctorButton(),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0.h,
                                ),
                                // callAddFamilyStreamBuilder(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              )),
    );
  }

  saveHospitalDialog(BuildContext context) {
    hospitalNameController.text = _textFieldController.text;

    return showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1)),
                content: Container(
                    width: 1.sw,
                    height: 1.sh / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 24.0.sp,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    _showHospitalNameTextField(true),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _showAddHospitalButton(),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.0.h,
                                ),
                                // callAddFamilyStreamBuilder(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              )),
    );
  }

  Widget _showFirstNameTextField() => Expanded(
          child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: firstNameController,
        keyboardType: TextInputType.text,
        focusNode: firstNameFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(firstNameFocus);
        },
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
          labelText: CommonConstants.firstNameWithStar,
          hintText: CommonConstants.firstName,
          labelStyle: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w400,
              color: ColorUtils.myFamilyGreyColor),
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            color: ColorUtils.myFamilyGreyColor,
            fontWeight: FontWeight.w400,
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
        ),
      ));

  Widget _showLastNameTextField() => Expanded(
          child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: lastNameController,
        keyboardType: TextInputType.text,
        focusNode: lastNameFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          lastNameFocus.unfocus();
        },
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
          labelText: CommonConstants.lastName,
          hintText: CommonConstants.lastName,
          labelStyle: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w400,
              color: ColorUtils.myFamilyGreyColor),
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            color: ColorUtils.myFamilyGreyColor,
            fontWeight: FontWeight.w400,
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
        ),
      ));

  Widget _ShowMobileNoTextField() => Expanded(
        child: TextField(
            textCapitalization: TextCapitalization.sentences,
            cursorColor: Color(CommonUtil().getMyPrimaryColor()),
            controller: mobileNoController,
            enabled: true,
            keyboardType: TextInputType.text,
            focusNode: mobileNoFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: (term) {
              mobileNoFocus.unfocus();
            },
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              hintText: CommonConstants.mobile_number,
              labelStyle: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 16.0.sp,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            )),
      );

  Widget _showSpecializationTextField() => Expanded(
          child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: specializationController,
        keyboardType: TextInputType.text,
        focusNode: specializationFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(lastNameFocus);
        },
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
          labelText: CommonConstants.specialization,
          hintText: CommonConstants.specialization,
          labelStyle: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w400,
              color: ColorUtils.myFamilyGreyColor),
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            color: ColorUtils.myFamilyGreyColor,
            fontWeight: FontWeight.w400,
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
        ),
      ));

  Widget _showHospitalNameTextField(bool condition) => Expanded(
          child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: hospitalNameController,
        keyboardType: TextInputType.text,
        focusNode: hospitalNameFocus,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(specializationFocus);
        },
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
          labelText: condition
              ? CommonConstants.hospitalNameWithStar
              : CommonConstants.hospitalName,
          hintText: condition
              ? CommonConstants.hospitalNameWithStar
              : CommonConstants.hospitalName,
          labelStyle: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w400,
              color: ColorUtils.myFamilyGreyColor),
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            color: ColorUtils.myFamilyGreyColor,
            fontWeight: FontWeight.w400,
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
        ),
      ));

  _showAddDoctorButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _addDoctorToList,
      child: Container(
        width: 130.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Add Doctor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  _showAddHospitalButton() {
    final addButtonWithGesture = GestureDetector(
      onTap: _addHospitalToList,
      child: Container(
        width: 130.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Add Hospital',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: addButtonWithGesture);
  }

  void _addDoctorToList() {
    final addDoctorData = {};
    final doctorReferenced = {};
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    if (firstNameController.text.trim() != '') {
      addDoctorData['firstName'] =
          toBeginningOfSentenceCase(firstNameController.text);
      addDoctorData['lastName'] = lastNameController.text.trim() == ''
          ? ''
          : toBeginningOfSentenceCase(lastNameController.text);
      addDoctorData['specialization'] =
          specializationController.text.trim() == ''
              ? null
              : specializationController.text;
      if (mobileNoController.text.trim() == '') {
        addDoctorData['phoneNumber'] = mobileNoController.text.trim() == ''
            ? null
            : mobileNoController.text;
      } else {
        final phoneNumber = '+' +
            _selectedDialogCountry.phoneCode.toString() +
            '' +
            mobileNoController.text;
        addDoctorData['phoneNumber'] = phoneNumber;
      }
      addDoctorData['hospitalName'] = hospitalNameController.text.trim() == ''
          ? null
          : hospitalNameController.text;
      addDoctorData['email'] = null;
      addDoctorData['addressLine1'] = null;
      addDoctorData['addressLine2'] = null;
      addDoctorData['city'] = null;
      addDoctorData['state'] = null;
      addDoctorData['isReferenced'] = null;
      addDoctorData['pincode'] = null;

      doctorReferenced['id'] = userid;
      addDoctorData['referredPatient'] = doctorReferenced;
      final params = json.encode(addDoctorData);
      print(params.toString());

      doctorsListRepository.addDoctorFromProvider(params).then((value) {
        Navigator.pop(context);
        passDoctorsValue(value, context);
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text(variable.strAPP_NAME),
                content: Text('Enter First Name'),
              ));
    }
  }

  void _addHospitalToList() {
    final addHospitalData = {};
    final hospitalReferenced = {};
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    if (hospitalNameController.text.trim() != '') {
      addHospitalData['name'] =
          toBeginningOfSentenceCase(hospitalNameController.text);

      hospitalReferenced['id'] = Constants.STR_HEALTHORG_HOSPID;
      addHospitalData['healthOrganizationType'] = hospitalReferenced;
      final params = json.encode(addHospitalData);
      print(params.toString());

      hospitalListRepository.addHospitalList(params).then((value) {
        if (value!.isSuccess!) {
          Navigator.pop(context);
          HospitalsListResult hospitaData = HospitalsListResult();
          hospitaData.name = '';
          hospitaData.healthOrganizationName = value.result!.name;
          hospitaData.healthOrganizationId = null;
          hospitaData.healthOrganizationReferenceId = value.result!.id;
          hospitaData.healthOrganizationTypeId = Constants.STR_HEALTHORG_HOSPID;
          hospitaData.healthOrganizationTypeName = 'Hospital';
          hospitaData.pincode = null;
          hospitaData.specialization = null;
          hospitaData.stateName = null;
          hospitaData.addressLine1 = null;
          hospitaData.addressLine2 = null;
          hospitaData.phoneNumber = null;
          hospitaData.phoneNumberTypeId = null;
          hospitaData.phoneNumberTypeName = null;
          hospitaData.cityName = null;
          passHospitalValue(hospitaData, context);
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(variable.strAPP_NAME),
                    content: Text(value.isSuccess.toString()),
                  ));

          //
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text(variable.strAPP_NAME),
                content: Text('Enter hospital Name'),
              ));
    }
  }

  showDialogBoxToAddDoctorWhenPermissionRequired(
      BuildContext context, DoctorsListResult data) {
    if (data.isTelehealthEnabled != null) {
      teleHealthAlertShown = data.isTelehealthEnabled;
    }
    var dialog = StatefulBuilder(
        builder: (context, setState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            title: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  ' Add ' + widget.arguments!.searchWord!,
                  style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorUtils.blackcolor),
                ),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 24.0.sp,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            )),
            content: Container(
                width: 1.sw,
                height: 1.sh / 2.5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _ShowDoctorTextField((data.name != null
                                ? data.name
                                    ?.capitalizeFirstofEach //toBeginningOfSentenceCase(widget.arguments.data.name)
                                : '')!),
                            SizedBox(height: 10.0.h),
                            Text(
                              variable.strAssociateMember,
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorUtils.greycolor1),
                            ),
                            SizedBox(height: 10.0.h),
                            _showUser(setState),
                            SizedBox(height: 20.0.h),
                            Text(
                              variable.strApprovAdd,
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor())),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _showCancelButton(),
                                _showAddButtonForProvider(data),
                              ],
                            ),
                          ],
                        )),
                      )
                    ]))));

    return showDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  _addBtnTappedProvider(DoctorsListResult doctorModel) {
    CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait); //

    updateProvidersBloc.isPreferred = false;

    if (widget.arguments!.searchWord == CommonConstants.doctors) {
      if (teleHealthAlertShown!) {
        if (switchedUserId != USERID) {
          updateProvidersBloc.userId = switchedUserId;
          updateProvidersBloc.providerId = doctorModel.doctorId;
          updateProvidersBloc.providerReferenceId = null;
        } else {
          updateProvidersBloc.userId = USERID;

          updateProvidersBloc.providerId = doctorModel.doctorId;
          updateProvidersBloc.providerReferenceId =
              doctorModel.doctorReferenceId;
        }
        updateProvidersBloc.selectedCategories = [];

        updateDoctorsIdWithUserDetails();
      } else {
        showDialogForDoctor(doctorModel);
      }
    }
  }

  void showDialogForDoctor(DoctorsListResult data) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text(variable.strDisableTeleconsulting),
              actions: <Widget>[
                FlatButtonWidget(
                  bgColor: Colors.transparent,
                  isSelected: true,
                  onPress: () {
                    Navigator.of(context).pop();
                    teleHealthAlertShown = true;
                    _addBtnTappedProvider(data);
                  },
                  title: 'Ok',
                )
              ],
            ));
  }

  updateDoctorsIdWithUserDetails() {
    updateProvidersBloc
        .updateDoctorsIdWithUserDetails(isPAR: true)
        .then((value) async {
      if (value!.success!) {
        // set up the button
        Navigator.pop(context);
        Widget okButton = TextButton(
          child: const Text("OK"),
          onPressed: () {
            var routeClassName = '';

            if (widget.arguments!.fromClass == router.cn_AddProvider ||
                widget.arguments!.fromClass == router.rt_myprovider) {
              routeClassName = router.rt_UserAccounts;
            } else if (widget.arguments!.fromClass ==
                router.rt_TelehealthProvider) {
              routeClassName = router.rt_TelehealthProvider;
            }

            if (CommonUtil.isUSRegion()) {
              Get.close(3);
            } else {
              Navigator.popUntil(context, (route) {
                var shouldPop = false;
                if (route.settings.name == routeClassName) {
                  shouldPop = true;
                }
                return shouldPop;
              });
            }
          },
        );

        showAlertDialog(
            context,
            okButton,
            (value.message != null &&
                    value.message !=
                        "New Provider Request has been created successfully.")
                ? value.message ?? ""
                : "Request sent successfully");
      } else {
        Navigator.pop(context);

        Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            });

        showAlertDialog(context, okButton, value.message!);
      }
    });
  }

  showAlertDialog(BuildContext context, Widget widget, String msg) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text(variable.strAPP_NAME),
      content: Text(msg),
      actions: [
        widget,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  Widget _showAddButtonForProvider(DoctorsListResult doctor) {
    var addButtonWithGesture = GestureDetector(
      onTap: () {
        _addBtnTappedProvider(doctor);
      },
      child: Container(
        height: 40.0.h,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: Color(CommonUtil().getMyPrimaryColor()),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Color.fromARGB(15, 0, 0, 0),
              offset: Offset(0, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Send Request",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return addButtonWithGesture;
  }

  Widget _ShowDoctorTextField(String doctorName) {
    doctorController.text = doctorName;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: doctorController,
        keyboardType: TextInputType.emailAddress,
        //focusNode: _doctorFocus,
        textInputAction: TextInputAction.done,
        autofocus: false,
        enabled: false,
        //widget.arguments.fromClass == router.rt_myprovider ? false : true,
        onSubmitted: (term) {
          //_doctorFocus.unfocus();
        },
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0.sp,
            color: Color(CommonUtil().getMyPrimaryColor())),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Color(CommonUtil().getMyPrimaryColor())),
            ),
            labelText: widget.arguments!.searchWord,
            labelStyle: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.greycolor1),
            hintStyle: TextStyle(
              color: ColorUtils.greycolor1,
            ),
            border: const UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }

  Widget _showUser(StateSetter setState) {
    MyProfileModel? primaryUserProfile;
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      primaryUserProfile =
          PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
    return InkWell(
        onTap: () {
          CommonUtil.showLoadingDialog(
              context, _keyLoader, variable.Please_Wait);

          if (_familyListBloc != null) {
            _familyListBloc = null;
            _familyListBloc = FamilyListBloc();
          }
          _familyListBloc!.getFamilyMembersListNew().then((familyMembersList) {
            // Hide Loading
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();

            if (familyMembersList != null &&
                familyMembersList.result != null &&
                familyMembersList.result?.sharedByUsers?.length > 0) {
              selectedFamilyMemberName = null;
              getDialogBoxWithFamilyMemberScrap(
                  familyMembersList.result, setState);
            } else {
              toast.getToast(Constants.NO_DATA_FAMIY_CLONE, Colors.black54);
            }
          });
        },
        child: Align(
          alignment: Alignment.topLeft,
          child: UnconstrainedBox(
              child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 246, 246, 246),
              border: Border.all(
                width: 0.7356,
                color: const Color.fromARGB(255, 239, 239, 239),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: Row(
              children: [
                ClipOval(
                    child: Container(
                  height: 30.0.h,
                  width: 30.0.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: updatedProfilePic != null
                      ? updatedProfilePic!.length > 5
                          ? getProfilePicWidget(updatedProfilePic)
                          : Center(
                              child: Text(
                                (selectedFamilyMemberName == null
                                    ? myProfile!.result?.lastName!.toUpperCase()
                                    : selectedFamilyMemberName![0]
                                        .toUpperCase())!,
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            )
                      : myProfile != null
                          ? myProfile?.result != null
                              ? myProfile?.result?.profilePicThumbnailUrl !=
                                      null
                                  ? getProfilePicWidget(myProfile
                                          ?.result?.profilePicThumbnailUrl ??
                                      '')
                                  : Center(
                                      child: Text(
                                        (selectedFamilyMemberName == null
                                            ? myProfile?.result?.lastName!
                                                .toUpperCase()
                                            : selectedFamilyMemberName![0]
                                                .toUpperCase())!,
                                        style: TextStyle(
                                            fontSize: 16.0.sp,
                                            color: Color(CommonUtil()
                                                .getMyPrimaryColor())),
                                      ),
                                    )
                              : Center(
                                  child: Text(
                                    selectedFamilyMemberName == null
                                        ? myProfile?.result != null
                                            ? myProfile?.result!.lastName ?? ''
                                            : ''
                                        : selectedFamilyMemberName![0]
                                            .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16.0.sp,
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor())),
                                  ),
                                )
                          : Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    color: Color(
                                        CommonUtil().getMyPrimaryColor())),
                              ),
                            ),
                )),
                SizedBox(width: 10.0.w),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    selectedFamilyMemberName == null
                        ? (myProfile?.result?.id ==
                                primaryUserProfile?.result?.id
                            ? variable.Self
                            : myProfile?.result?.firstName!)!
                        : selectedFamilyMemberName!
                            .capitalizeFirstofEach, //toBeginningOfSentenceCase(selectedFamilyMemberName),
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 85, 92, 89),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Future<Widget?> getDialogBoxWithFamilyMemberScrap(
          FamilyMemberResult? familyData, StateSetter setState) =>
      FamilyListView(familyData)
          .getDialogBoxWithFamilyMember(familyData, context, _keyLoader,
              (context, userId, userName, profilePic) {
        switchedUserId = userId;
        selectedFamilyMemberName = userName;
        myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
        updatedProfilePic = profilePic;
        Navigator.pop(context);
        setState(() {});
      }, removeDuplicate: true);

  Widget getProfilePicWidget(String? profilePicThumbnail) =>
      profilePicThumbnail != null
          ? Image.network(
              profilePicThumbnail,
              height: 30.0.h,
              width: 30.0.h,
              fit: BoxFit.cover,
            )
          : Container(
              color: const Color(fhbColors.bgColorContainer),
              height: 30.0.h,
              width: 30.0.h,
            );

  void _cancelBtnTapped() async {
    Navigator.pop(context);
  }

  Widget _showCancelButton() {
    final loginButtonWithGesture = GestureDetector(
      onTap: _cancelBtnTapped,
      child: Container(
        width: 100.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: ColorUtils.greycolor,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorUtils.greycolor.withOpacity(0.2),
              blurRadius: 100,
              offset: const Offset(0, 100),
            ),
          ],
        ),
        child: Center(
          child: Text(
            variable.Cancel,
            style: TextStyle(
              color: ColorUtils.blackcolor,
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return loginButtonWithGesture;
  }

  Widget getResponseFromApiWidgetForCity() =>
      StreamBuilder<ApiResponse<cityListModel.CityListModel>>(
        stream: _labsListBlock!.cityNewStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          switch (snapshot.data!.status) {
            case Status.LOADING:
              rebuildBlockObject();
              return Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
              ));

              break;

            case Status.ERROR:
              rebuildBlockObject();
              return Text(
                  variable.strNoDataAvailable + ' ' + CommonConstants.keyCity,
                  style: const TextStyle(color: Colors.red));
              break;

            case Status.COMPLETED:
              rebuildBlockObject();
              return snapshot.data!.data!.result == null
                  ? Container(
                      child: const Center(
                        child: Text(variable.strNodata),
                      ),
                    )
                  //getEmptyCard()
                  : snapshot.data!.data!.result!.isEmpty
                      ? Container(
                          child: const Center(
                            child: Text(variable.strNodata),
                          ),
                        )
                      //getEmptyCard()
                      : Container(
                          margin: const EdgeInsets.all(5),
                          child: getAllDatasInCityList(
                              snapshot.data!.data!.result!),
                        );

              break;

            default:
              break;
          }
          return Container();
        },
      );

  Widget getAllDatasInCityList(List<cityListModel.CityListData> data) =>
      RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        color: Color(CommonUtil().getMyPrimaryColor()),
        child: data != null
            ? Container(
                color: const Color(fhbColors.bgColorContainer),
                child: ListView.builder(
                  itemBuilder: (c, index) => Container(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: InkWell(
                      onTap: () {
                        try {
                          if (widget.toPreviousScreen!) {
                            passCityValue(data[index], context);
                          }
                        } catch (e, stackTrace) {
                          CommonUtil()
                              .appLogs(message: e, stackTrace: stackTrace);
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.only(
                          top: 5.0.sp,
                          bottom: 5.0.sp,
                          left: 10.0.sp,
                          right: 10.0.sp,
                        ),
                        elevation: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(15.0))),
                          child: Container(
                            padding: EdgeInsets.all(
                              10.0.sp,
                            ),
                            margin: EdgeInsets.only(
                              left: 8.0.w,
                              right: 15.0.w,
                              top: 8.0.h,
                              bottom: 8.0.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: 4.0.w,
                                    ),
                                    child: Text(
                                      CommonUtil()
                                          .validString(data[index].name ?? ""),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0.sp,
                                        color: Colors.black,
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemCount: data.length,
                ))
            : Container(
                color: const Color(fhbColors.bgColorContainer),
                child: const Center(
                  child: Text(variable.strNodata),
                ),
              ),
      );

  // Function to handle clearing the search criteria for doctors and labs
  onClear() {
    try {
      // Extract the searchWord from widget arguments with default value ''
      var searchWord = widget.arguments?.searchWord ?? '';

      // Create a common filter request model
      DoctorFilterRequestModel commonFilterRequestModel =
          DoctorFilterRequestModel(
        page: 0,
        size: createTicketController.limit,
        searchText: CommonUtil()
            .validString(createTicketController.strSearchText.value),
        filters: [],
        sorts: [],
      );

      // Determine the current controller and set the common filter request model accordingly
      if (searchWord == CommonConstants.doctors) {
        // If searching for doctors, use existing doctor filters
        commonFilterRequestModel.filters =
            createTicketController.doctorFilterRequestModel?.filters ?? [];
        commonFilterRequestModel.sorts =
            createTicketController.doctorFilterRequestModel?.sorts ?? [];
        createTicketController.doctorFilterRequestModel =
            commonFilterRequestModel;
      } else if (searchWord == CommonConstants.labs ||
          searchWord == CommonConstants.lab) {
        // If searching for labs, use existing lab filters and set healthOrganizationType
        commonFilterRequestModel.filters =
            createTicketController.labListFilterRequestModel?.filters ?? [];
        commonFilterRequestModel.sorts =
            createTicketController.labListFilterRequestModel?.sorts ?? [];
        commonFilterRequestModel.healthOrganizationType =
            CommonConstants.keyLab.toUpperCase();
        createTicketController.labListFilterRequestModel =
            commonFilterRequestModel;
      }
    } catch (e, stackTrace) {
      // Handle any errors that occur during the clearing process
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  showSortOrderDialog(bool isDoctor) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Container(
              color: Colors.white,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  // Using StatefulBuilder to rebuild parts of the dialog when state changes
                  return Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              Constants.strSortby,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                Get.back();
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      // ListTile for sorting options
                      ListTile(
                        title: Text(Constants.strAlphabetAZ),
                        trailing: buildRadio(
                          value: 1,
                          groupValue: isDoctor
                              ? createTicketController.isDoctorSort.value
                              : createTicketController.isLabNameAscendingOrder.value,
                          onChanged: (value) {
                            // Update sort value based on user selection
                            if (isDoctor) {
                              createTicketController.isDoctorSort.value = value ?? 0;
                            } else {
                              createTicketController.isLabNameAscendingOrder.value = value ?? 0;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 2),
                      // Another sorting option
                      ListTile(
                        title: Text(Constants.strAlphabetZA),
                        trailing: buildRadio(
                          value: 2,
                          groupValue: isDoctor
                              ? createTicketController.isDoctorSort.value
                              : createTicketController.isLabNameAscendingOrder.value,
                          onChanged: (value) {
                            // Update sort value based on user selection
                            if (isDoctor) {
                              createTicketController.isDoctorSort.value = value ?? 0;
                            } else {
                              createTicketController.isLabNameAscendingOrder.value = value ?? 0;
                            }
                          },
                        ),
                      ),
                      // Additional sorting options for doctors
                      if (isDoctor) ...[
                        SizedBox(height: 2),
                        ListTile(
                          title: Text(Constants.strExperienceASC),
                          trailing: buildRadio(
                            value: 3,
                            groupValue: createTicketController.isDoctorSort.value,
                            onChanged: (value) {
                              // Update sort value based on user selection
                              createTicketController.isDoctorSort.value = value ?? 0;
                            },
                          ),
                        ),
                        SizedBox(height: 2),
                        ListTile(
                          title: Text(Constants.strExperienceDESC),
                          trailing: buildRadio(
                            value: 4,
                            groupValue: createTicketController.isDoctorSort.value,
                            onChanged: (value) {
                              // Update sort value based on user selection
                              createTicketController.isDoctorSort.value = value ?? 0;
                            },
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Button to reset sorting options
                            buildButton(
                              text: DoctorFilterConstants.reset,
                              textColor: Color(CommonUtil().getMyPrimaryColor()),
                              onTap: () async {
                                // Reset sorting options and refresh data
                                if (isDoctor) {
                                  createTicketController.isDoctorSort.value = 0;
                                  createTicketController.doctorFilterRequestModel = new DoctorFilterRequestModel();
                                  createTicketController.pagingController.refresh();
                                } else {
                                  createTicketController.isLabNameAscendingOrder.value = 0;
                                  createTicketController.labListFilterRequestModel = new DoctorFilterRequestModel();
                                  createTicketController.labListResultPagingController.refresh();
                                }
                                Get.back();
                              },
                            ),
                            SizedBox(width: 15),
                            // Button to apply sorting options
                            buildButton(
                              text: Constants.strApply,
                              textColor: Colors.white,
                              onTap: () {
                                // Apply sorting options and refresh data
                                if (isDoctor) {
                                  var doctorSort = createTicketController.isDoctorSort.value;
                                  createTicketController.doctorFilterRequestModel.page = 0;
                                  createTicketController.doctorFilterRequestModel.sorts = [];
                                  if (doctorSort != 0) {
                                    Sorts docSorts = Sorts();
                                    docSorts?.field = (doctorSort == 1 || doctorSort == 2)
                                        ? Parameters.strDoctorName
                                        : Parameters.stringDoctorExperience;
                                    docSorts?.orderBy = (doctorSort == 1 || doctorSort == 3)
                                        ? Constants.strASC
                                        : Constants.strDESC;
                                    createTicketController.doctorFilterRequestModel.sorts?.add(docSorts);
                                  }
                                  createTicketController.pagingController.refresh();
                                } else {
                                  var labName = createTicketController.isLabNameAscendingOrder.value;
                                  createTicketController.labListFilterRequestModel.page = 0;
                                  createTicketController.labListFilterRequestModel.sorts = [];
                                  if (labName != 0) {
                                    Sorts labSorts = Sorts();
                                    labSorts?.field = variable.strHealthOrganizationName;
                                    labSorts?.orderBy = labName == 1 ? Constants.strASC : Constants.strDESC;
                                    createTicketController.labListFilterRequestModel.sorts?.add(labSorts);
                                  }
                                  createTicketController.labListResultPagingController.refresh();
                                }
                                Get.back();
                              },
                              backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ));
                },
              ),
            ),
          ),
        );
      },
    );
  }

// Widget to build radio buttons for sorting options
  Widget buildRadio({
    required int value,
    required int groupValue,
    required ValueChanged<int?> onChanged,
  }) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Color(CommonUtil().getMyPrimaryColor()),
    );
  }

// Widget to build buttons for resetting and applying sorting options
  Widget buildButton({
    required String text,
    required Color textColor,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Color(CommonUtil().getMyPrimaryColor())),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }



}
