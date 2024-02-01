import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/search_providers/screens/left_side_menu_widget.dart';
import 'package:myfhb/search_providers/screens/right_side_menu_widget.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import '../../src/utils/screenutils/size_extensions.dart';
import '../doctors_filter_bloc/doctors_filter_bloc.dart';

class DoctorsFilterScreen extends StatefulWidget {
  final Function(
    int filterMenuCount,
    List<DoctorsListResult> doctorFilterList,
    FilteredSelectedModel selectdFilterItemIndex,
  ) filterApplied;
  final List<int> selectedBrandOption;
  final List<int> selectedCategoryOption;
  final FilteredSelectedModel selectedItems;

  const DoctorsFilterScreen({
    super.key,
    required this.filterApplied,
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
            } else if (state is ShowDoctorFilterList) {
              doctorFilterList = state.doctorFilterList;
              filterMenuCount = state.filterMenuCount;
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
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                    style: TextStyle(color: Colors.white),
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
