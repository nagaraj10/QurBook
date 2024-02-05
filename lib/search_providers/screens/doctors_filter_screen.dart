import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/search_providers/screens/doctor_filter_request_model.dart';

import '../../constants/fhb_constants.dart';
import '../../src/ui/MyRecord.dart';
import '../../src/ui/loader_class.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../widgets/GradientAppBar.dart';
import '../doctors_filter_bloc/doctors_filter_bloc.dart';
import '../models/doctor_list_response_new.dart';
import 'left_side_menu_widget.dart';
import 'right_side_menu_widget.dart';

class DoctorsFilterScreen extends StatefulWidget {
  final Function(
    Map<String, List<String>> filterMenuCount,
    List<DoctorsListResult> doctorFilterList,
    FilteredSelectedModel selectdFilterItemIndex,
    int count, DoctorFilterRequestModel doctorFilterRequestModel,
  ) filterApplied;
  final FilteredSelectedModel selectedItems;
  final int filterMenuCount;
  final Map<String, List<String>> filterSelectedItems;
  final DoctorFilterRequestModel doctorFilterRequestModel;

  const DoctorsFilterScreen({
    super.key,
    required this.filterApplied,
    required this.selectedItems,
    required this.filterMenuCount,
    required this.filterSelectedItems,
    required this.doctorFilterRequestModel,
  });

  @override
  State<DoctorsFilterScreen> createState() => _DoctorsFilterScreenState();
}

class _DoctorsFilterScreenState extends State<DoctorsFilterScreen> {
  String selectedMenu = "";
  String selectedState = "";
  String selectedCity = "";
  int selectedIndex = 0;

  List<String> menu = const [
    'Gender',
    'Language Spoken',
    'Specialization',
    'State',
    'City',
    'Hospital',
    'Years of experience',
  ];

  List<String> labsMenu = const [
    'State',
    'City',
  ];

  List<String> menuItems = [];
  FilteredSelectedModel selectdFilterItemIndex = FilteredSelectedModel(
    selectedGenderIndex: [],
    selectedLanguageIndex: [],
    selectedSpecializationeIndex: [],
    selectedStateIndex: [],
    selectedCityIndex: [],
    selectedHospitalIndex: [],
    selectedYOEIndex: [],
  );
  List<DoctorsListResult> doctorFilterList = [];
  int filterMenuCount = 0;
  Map<String, List<String>> selectedItems = {};
  List<String> searchFilterOption = [];
  late DoctorFilterRequestModel doctorFilterRequestModel;

  var createTicketController = CommonUtil().onInitCreateTicketController();

  @override
  void initState() {
    super.initState();
    selectdFilterItemIndex = widget.selectedItems;
    selectedItems = widget.filterSelectedItems;
    selectedState = selectdFilterItemIndex.selectedStateIndex.isEmpty ? "" : selectdFilterItemIndex.selectedStateIndex.first;
    selectedCity = selectdFilterItemIndex.selectedCityIndex.isEmpty ? "" : selectdFilterItemIndex.selectedCityIndex.first;
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => DoctorsFilterBloc()
          ..add(GetDoctorSpecializationList(
            selectedIndex: selectedIndex,
            selectedMenu: createTicketController.searchWord.value ==
                    CommonConstants.doctors
                ? menu[0]
                : labsMenu[0],
          )),
        child: BlocListener<DoctorsFilterBloc, DoctorsFilterState>(
          listener: (context, state) {
            if (state is ShowMenuItemList) {
              selectedMenu = state.selectedMenu;
              menuItems = state.menuItemList;
              selectedIndex = state.selectedIndex;
            } else if (state is HideProgressBar) {
              LoaderClass.hideLoadingDialog(context);
            } else if (state is ShowProgressBar) {
              LoaderClass.showLoadingDialog(context);
            } else if (state is ShowDoctorFilterList) {
              doctorFilterList = state.doctorFilterList;
              filterMenuCount = state.filterMenuCount;
              doctorFilterRequestModel = state.doctorFilterRequestModel;
              widget.filterApplied(selectedItems, doctorFilterList, selectdFilterItemIndex, filterMenuCount,doctorFilterRequestModel);
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<DoctorsFilterBloc, DoctorsFilterState>(
            builder: (context, state) => Scaffold(
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
                title: Text(createTicketController.searchWord.value ==
                    CommonConstants.doctors
                    ?DoctorFilterConstants.filterDoctors:DoctorFilterConstants.filterLabs),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        LeftSideMenuWidget(
                          menuItems: createTicketController.searchWord.value ==
                              CommonConstants.doctors
                              ?menu:labsMenu,
                          selectedOptionChanged: (int value, String selectedMenuItem) {
                            BlocProvider.of<DoctorsFilterBloc>(context).add(GetDoctorSpecializationList(
                              selectedIndex: value,
                              selectedMenu: selectedMenuItem,
                              cityName: selectedCity,
                              stateName: selectedState,
                            ));
                          },
                        ),
                        RightSideMenuWidget(
                          searchFilterOption: [],
                          filterOptions: menuItems,
                          selectedMenuIndex: selectedIndex,
                          filterSelectdModel: selectdFilterItemIndex,
                          selectedFilterOption: (
                            Map<String, List<String>> value,
                            FilteredSelectedModel selectedIndex,
                            String city,
                            String state,
                          ) {
                            selectedItems.addAll(value);
                            selectedState = state;
                            selectedCity = city;
                            selectdFilterItemIndex = selectedIndex;
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: Platform.isIOS ? 30 : 10, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                selectedItems.clear();
                                selectedState = "";
                                selectedCity = "";
                                selectdFilterItemIndex = FilteredSelectedModel(
                                  selectedGenderIndex: [],
                                  selectedLanguageIndex: [],
                                  selectedSpecializationeIndex: [],
                                  selectedStateIndex: [],
                                  selectedCityIndex: [],
                                  selectedHospitalIndex: [],
                                  selectedYOEIndex: [],
                                );
                                widget.filterApplied({}, [], selectdFilterItemIndex, 0,new DoctorFilterRequestModel());
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(CommonUtil().getMyPrimaryColor()),
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Center(
                                  child: Text(
                                    DoctorFilterConstants.reset,
                                    style: TextStyle(
                                      color: Color(CommonUtil().getMyPrimaryColor()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                BlocProvider.of<DoctorsFilterBloc>(context).add(
                                  ApplyFilters(
                                    selectedItems: selectedItems,
                                    count: 0,
                                  ),
                                );
                              },
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  color: Color(CommonUtil().getMyPrimaryColor()),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    DoctorFilterConstants.applyFilters,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
