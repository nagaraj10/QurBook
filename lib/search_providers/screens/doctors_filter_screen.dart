import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfhb/search_providers/screens/left_side_menu_screen.dart';
import 'package:myfhb/search_providers/screens/right_side_menu_widget.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import '../../src/utils/screenutils/size_extensions.dart';
import '../doctors_filter_bloc/doctors_filter_bloc.dart';

class DoctorsFilterScreen extends StatefulWidget {
  final Function() clearAllOnChange;
  final List<int> selectedBrandOption;
  final List<int> selectedCategoryOption;

  const DoctorsFilterScreen({
    super.key,
    required this.clearAllOnChange,
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

  Map<String, List<String>> selectedItems = {};

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
                title: const Text('Filter Doctors'),
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
                          filterOptions: menuItems,
                          selectedMenuIndex: selectedIndex,
                          filterSelectdModel: selectdFilterItemIndex,
                          selectedFilterOption: (
                            Map<String, List<String>> value,
                            FilteredSelectedModel selectedIndex,
                            String city,
                            String state,
                          ) {
                            selectedItems = value;
                            selectedState = state;
                            selectedCity = city;
                            selectdFilterItemIndex = selectedIndex;
                            setState(() {});
                          },
                          search: (String searchQuery, int index) {},
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
                                Navigator.pop(context);
                                // widget.filteredSelectedModel(
                                //   FilteredSelectedModel(
                                //     selectedBrandFilter: selectedBrandOption,
                                //     selectedCategoryFilter: selectedCategoryOption,
                                //     selectedBrandFilterId: selectedBrandOptionId,
                                //     selectedCategoryFilterId: selectedCategoryOptionId,
                                //   ),
                                // );
                              },
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFC8CED9),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Reset',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // Navigator.pop(context);
                                // widget.clearAllOnChange();
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
                                child: const Center(
                                  child: Text(
                                    'Apply Filters',
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

// filterMenuItemList(int selectedIndex, BuildContext context) {
//   if (selectedIndex == 0) {
//     return ["Any", "Male", "Female"];
//   } else if (selectedIndex == 1) {
//     return ["Tamil", "English", "Hindi"];
//   } else if (selectedIndex == 2) {
//     // BlocProvider.of<DoctorsFilterBloc>(context).add(GetDoctorSpecializationList());
//   } else if (selectedIndex == 3) {
//     return ["Tamil", "English", "Hindi"];
//   } else if (selectedIndex == 4) {
//     return ["Any", "Male", "Female"];
//   } else if (selectedIndex == 5) {
//     return ["Tamil", "English", "Hindi"];
//   } else if (selectedIndex == 6) {
//     return ["0 to 5 years", "5 to 10 years", "10 to 20 years", "20+ years"];
//   }
// }
