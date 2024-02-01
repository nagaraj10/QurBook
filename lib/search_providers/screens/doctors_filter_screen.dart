import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    int filterMenuCount,
    List<DoctorsListResult> doctorFilterList,
    FilteredSelectedModel selectdFilterItemIndex,
  ) filterApplied;
  final List<int> selectedBrandOption;
  final List<int> selectedCategoryOption;
  final FilteredSelectedModel selectedItems;
  final int filterMenuCount;

  const DoctorsFilterScreen({
    super.key,
    required this.filterApplied,
    required this.filterMenuCount,
    required this.selectedItems,
    this.selectedBrandOption = const [],
    this.selectedCategoryOption = const [],
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

  @override
  void initState() {
    super.initState();
    selectdFilterItemIndex = widget.selectedItems;
    filterMenuCount = widget.filterMenuCount;
    selectedState = selectdFilterItemIndex.selectedStateIndex.isEmpty ? "" : selectdFilterItemIndex.selectedStateIndex.first;
    selectedCity = selectdFilterItemIndex.selectedCityIndex.isEmpty ? "" : selectdFilterItemIndex.selectedCityIndex.first;
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => DoctorsFilterBloc()
          ..add(GetDoctorSpecializationList(
            selectedIndex: selectedIndex,
            selectedMenu: menu[0],
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
              filterMenuCount = (selectdFilterItemIndex.selectedGenderIndex.length) +
                  (selectdFilterItemIndex.selectedLanguageIndex.length) +
                  (selectdFilterItemIndex.selectedSpecializationeIndex.length) +
                  (selectdFilterItemIndex.selectedCityIndex.length) +
                  (selectdFilterItemIndex.selectedStateIndex.length) +
                  (selectdFilterItemIndex.selectedHospitalIndex.length) +
                  selectdFilterItemIndex.selectedYOEIndex.length;
              widget.filterApplied(filterMenuCount, doctorFilterList, selectdFilterItemIndex);
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
                title: Text(DoctorFilterConstants.filterDoctors),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        LeftSideMenuWidget(
                          menuItems: menu,
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
                      padding: const EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
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
                                widget.filterApplied(0, [], selectdFilterItemIndex);
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
                                    count: widget.filterMenuCount,
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
