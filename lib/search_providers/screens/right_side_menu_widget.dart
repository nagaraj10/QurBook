import 'package:flutter/material.dart';

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
  final Function(String searchQuery, int index) search;

  const RightSideMenuWidget({
    required this.selectedFilterOption,
    required this.filterOptions,
    required this.filterSelectdModel,
    required this.selectedMenuIndex,
    required this.search,
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

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 16),
        width: MediaQuery.of(context).size.width / 1.8,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Visibility(
              visible: widget.selectedMenuIndex == 1 || widget.selectedMenuIndex == 2 || widget.selectedMenuIndex == 3 || widget.selectedMenuIndex == 4 || widget.selectedMenuIndex == 5,
              child: SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    // controller: searchController,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    onChanged: (val) {
                      if (val.length > 2) {
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
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      suffixIcon: Icon(Icons.search),
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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: isSearch ? searchFilterOption.length : widget.filterOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      String itemName = isSearch ? searchFilterOption[index] : widget.filterOptions[index];
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
                            value: widget.selectedMenuIndex == 0
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
                                                    : selectedYOEItems.contains(itemName),
                            onChanged: (bool? value) {
                              if (value != null) {
                                if (widget.selectedMenuIndex == 0) {
                                  selectedGenderItems.clear();
                                  selectedGenderItems.add(itemName);
                                  selectedFilters['gender'] = selectedGenderItems;
                                  print(selectedFilters);
                                } else if (widget.selectedMenuIndex == 1) {
                                  if (selectedLanguageItems.isEmpty) {
                                    selectedLanguageItems.add(itemName);
                                  } else if (!selectedLanguageItems.contains(itemName)) {
                                    selectedLanguageItems.add(itemName);
                                  } else {
                                    selectedLanguageItems.remove(itemName);
                                  }
                                  selectedFilters['languageSpoken'] = selectedLanguageItems;
                                } else if (widget.selectedMenuIndex == 2) {
                                  selectedSpecializationItems.clear();
                                  selectedSpecializationItems.add(itemName);
                                  selectedFilters['specialization'] = selectedSpecializationItems;
                                } else if (widget.selectedMenuIndex == 3) {
                                  selectedStateItems.clear();
                                  selectedStateItems.add(itemName);
                                  selectedFilters['state'] = selectedStateItems;
                                } else if (widget.selectedMenuIndex == 4) {
                                  selectedCityItems.clear();
                                  selectedCityItems.add(itemName);
                                  selectedFilters['city'] = selectedCityItems;
                                } else if (widget.selectedMenuIndex == 5) {
                                  if (selectedHospitalItems.isEmpty) {
                                    selectedHospitalItems.add(itemName);
                                  } else if (!selectedHospitalItems.contains(itemName)) {
                                    selectedHospitalItems.add(itemName);
                                  } else {
                                    selectedHospitalItems.remove(itemName);
                                  }
                                  selectedFilters['hospital'] = selectedHospitalItems;
                                } else if (widget.selectedMenuIndex == 6) {
                                  selectedYOEItems.clear();
                                  selectedYOEItems.add(itemName);
                                  selectedFilters['experience'] = selectedYOEItems;
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
