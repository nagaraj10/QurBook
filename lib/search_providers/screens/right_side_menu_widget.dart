import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';

import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../constants/variable_constant.dart' as variable;

class FilteredSelectedModel {
  List<String> selectedGenderIndex;
  List<String> selectedLanguageIndex;
  List<String> selectedSpecializationeIndex;
  List<String> selectedStateIndex;
  List<String> selectedCityIndex;
  List<String> selectedHospitalIndex;
  List<String> selectedYOEIndex;

  FilteredSelectedModel({
    required this.selectedGenderIndex,
    required this.selectedLanguageIndex,
    required this.selectedSpecializationeIndex,
    required this.selectedStateIndex,
    required this.selectedCityIndex,
    required this.selectedHospitalIndex,
    required this.selectedYOEIndex,
  });
}

class RightSideMenuWidget extends StatefulWidget {
  final Function(
    Map<String, List<String>> selectedFilters,
    FilteredSelectedModel,
    String city,
    String state,
  ) selectedFilterOption;
  final List<String> filterOptions;
  final FilteredSelectedModel filterSelectdModel;
  final int selectedMenuIndex;
  final List<String> searchFilterOption;

  const RightSideMenuWidget({
    required this.selectedFilterOption,
    required this.filterOptions,
    required this.filterSelectdModel,
    required this.selectedMenuIndex,
    required this.searchFilterOption,
    Key? key,
  }) : super(key: key);

  @override
  State<RightSideMenuWidget> createState() => _RightSideMenuWidgetState();
}

class _RightSideMenuWidgetState extends State<RightSideMenuWidget> {
  List<String> selectedGenderItems = [];
  List<String> selectedLanguageItems = [];
  List<String> selectedSpecializationItems = [];
  List<String> selectedStateItems = [];
  List<String> selectedCityItems = [];
  List<String> selectedHospitalItems = [];
  List<String> selectedYOEItems = [];
  Map<String, List<String>> selectedFilters = {};
  TextEditingController searchController = TextEditingController();
  List<String> searchFilterOption = [];
  bool isSearch = false;
  Timer? _debounce;

  var createTicketController = CommonUtil().onInitCreateTicketController();

  @override
  void initState() {
    super.initState();
    selectedGenderItems = widget.filterSelectdModel.selectedGenderIndex;
    selectedLanguageItems = widget.filterSelectdModel.selectedLanguageIndex;
    selectedSpecializationItems = widget.filterSelectdModel.selectedSpecializationeIndex;
    selectedStateItems = widget.filterSelectdModel.selectedStateIndex;
    selectedCityItems = widget.filterSelectdModel.selectedCityIndex;
    selectedHospitalItems = widget.filterSelectdModel.selectedHospitalIndex;
    selectedYOEItems = widget.filterSelectdModel.selectedYOEIndex;
  }
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RightSideMenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filterOptions != oldWidget.filterOptions) {
      searchFilterOption.clear();
      searchController.clear();
      isSearch = false;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    selectedGenderItems = widget.filterSelectdModel.selectedGenderIndex;
    selectedLanguageItems = widget.filterSelectdModel.selectedLanguageIndex;
    selectedSpecializationItems = widget.filterSelectdModel.selectedSpecializationeIndex;
    selectedStateItems = widget.filterSelectdModel.selectedStateIndex;
    selectedCityItems = widget.filterSelectdModel.selectedCityIndex;
    selectedHospitalItems = widget.filterSelectdModel.selectedHospitalIndex;
    selectedYOEItems = widget.filterSelectdModel.selectedYOEIndex;
  }

  bool showEmptyScreen() {
    if (isSearch) {
      return searchFilterOption.isEmpty;
    } else {
      return widget.filterOptions.isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width / 1.8,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Visibility(
              visible: createTicketController.searchWord.value ==
                  CommonConstants.doctors?(widget.selectedMenuIndex == 1 || widget.selectedMenuIndex == 2 || widget.selectedMenuIndex == 3 || widget.selectedMenuIndex == 4 || widget.selectedMenuIndex == 5):(widget.selectedMenuIndex == 0 || widget.selectedMenuIndex == 1),
              child: SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    onChanged: (val) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        if (val.length >= 2) {
                          searchFilterOption.clear();
                          searchFilterOption = widget.filterOptions
                              .where(
                                (item) => item.toLowerCase().contains(val.toLowerCase()),
                              )
                              .toList();
                          isSearch = true;
                          setState(() {});
                        } else {
                          isSearch = false;
                          searchFilterOption.clear();
                          setState(() {});
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      suffixIcon: InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: const Icon(Icons.search)),
                      hintText: 'Search',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
                child: showEmptyScreen()
                    ? const Center(
                        child: Text(variable.strNodata),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        
                        itemCount: isSearch ? searchFilterOption.length : widget.filterOptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          final itemName = isSearch ? searchFilterOption[index] : widget.filterOptions[index];
                          return Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                    width: 1,
                                  ),
                                ),
                                checkColor: Colors.white,
                                activeColor: const Color(0xFF1A4CC0),
                                value: createTicketController.searchWord.value ==
                                    CommonConstants.doctors?(widget.selectedMenuIndex == 0
                                    ? selectedGenderItems.contains(itemName)
                                    : widget.selectedMenuIndex == 1
                                        ? selectedLanguageItems.contains(itemName)
                                        : widget.selectedMenuIndex == 2
                                            ? selectedSpecializationItems.contains(itemName)
                                            : widget.selectedMenuIndex == 3
                                                ? selectedStateItems.contains(itemName)
                                                : widget.selectedMenuIndex == 4
                                                    ? selectedCityItems.contains(itemName)
                                                    : widget.selectedMenuIndex == 5
                                                        ? selectedHospitalItems.contains(itemName)
                                                        : selectedYOEItems.contains(itemName)): (widget.selectedMenuIndex == 0
                                        ? selectedStateItems.contains(itemName)
                                        : selectedCityItems.contains(itemName)),
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    if(createTicketController.searchWord.value ==
                                        CommonConstants.doctors) {
                                      if (widget.selectedMenuIndex == 0) {
                                        if (!selectedGenderItems.contains(
                                            itemName)) {
                                          selectedGenderItems.clear();
                                          selectedGenderItems.add(itemName);
                                        } else {
                                          selectedGenderItems.remove(itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .gender] = selectedGenderItems;
                                      } else
                                      if (widget.selectedMenuIndex == 1) {
                                        if (selectedLanguageItems.isEmpty) {
                                          selectedLanguageItems.add(itemName);
                                        } else
                                        if (!selectedLanguageItems.contains(
                                            itemName)) {
                                          selectedLanguageItems.add(itemName);
                                        } else {
                                          selectedLanguageItems.remove(
                                              itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .languageSpoken] =
                                            selectedLanguageItems;
                                      } else
                                      if (widget.selectedMenuIndex == 2) {
                                        if (!selectedSpecializationItems
                                            .contains(itemName)) {
                                          selectedSpecializationItems.clear();
                                          selectedSpecializationItems.add(
                                              itemName);
                                        } else {
                                          selectedSpecializationItems.remove(
                                              itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .specialization] =
                                            selectedSpecializationItems;
                                      } else
                                      if (widget.selectedMenuIndex == 3) {
                                        if (!selectedStateItems.contains(
                                            itemName)) {
                                          selectedStateItems.clear();
                                          selectedStateItems.add(itemName);
                                        } else {
                                          selectedStateItems.remove(itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .state] = selectedStateItems;
                                      } else
                                      if (widget.selectedMenuIndex == 4) {
                                        if (!selectedCityItems.contains(
                                            itemName)) {
                                          selectedCityItems.clear();
                                          selectedCityItems.add(itemName);
                                        } else {
                                          selectedCityItems.remove(itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .city] = selectedCityItems;
                                      } else
                                      if (widget.selectedMenuIndex == 5) {
                                        if (selectedHospitalItems.isEmpty) {
                                          selectedHospitalItems.add(itemName);
                                        } else
                                        if (!selectedHospitalItems.contains(
                                            itemName)) {
                                          selectedHospitalItems.add(itemName);
                                        } else {
                                          selectedHospitalItems.remove(
                                              itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .hospital] = selectedHospitalItems;
                                      } else
                                      if (widget.selectedMenuIndex == 6) {
                                        if (!selectedYOEItems.contains(
                                            itemName)) {
                                          selectedYOEItems.clear();
                                          selectedYOEItems.add(itemName);
                                        } else {
                                          selectedYOEItems.remove(itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .experience] = selectedYOEItems;
                                      }
                                    } else {
                                      if (widget.selectedMenuIndex == 0) {
                                        if (!selectedStateItems
                                            .contains(itemName)) {
                                          selectedStateItems.clear();
                                          selectedStateItems.add(itemName);
                                        } else {
                                          selectedStateItems.remove(itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .state] = selectedStateItems;
                                      } else if (widget.selectedMenuIndex ==
                                          1) {
                                        if (!selectedCityItems
                                            .contains(itemName)) {
                                          selectedCityItems.clear();
                                          selectedCityItems.add(itemName);
                                        } else {
                                          selectedCityItems.remove(itemName);
                                        }
                                        selectedFilters[DoctorFilterConstants
                                            .city] = selectedCityItems;
                                      }
                                    }

                                    widget.selectedFilterOption(
                                      selectedFilters,
                                      FilteredSelectedModel(
                                        selectedGenderIndex: selectedGenderItems,
                                        selectedLanguageIndex: selectedLanguageItems,
                                        selectedSpecializationeIndex: selectedSpecializationItems,
                                        selectedStateIndex: selectedStateItems,
                                        selectedCityIndex: selectedCityItems,
                                        selectedHospitalIndex: selectedHospitalItems,
                                        selectedYOEIndex: selectedYOEItems,
                                      ),
                                      selectedCityItems.isNotEmpty ? selectedCityItems.first : '',
                                      selectedStateItems.isNotEmpty ? selectedStateItems.first : '',
                                    );

                                    setState(() {});
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  itemName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        }),
              ),
            ),
          ],
        ),
      );
}
