part of 'doctors_filter_bloc.dart';

abstract class DoctorsFilterEvent {}

class InitializeFilters extends DoctorsFilterEvent {
  final Map<String, List<String>>? selectedItems;

  InitializeFilters({required this.selectedItems});

  @override
  List<Object?> get props => [selectedItems];
}

class UpdateFilters extends DoctorsFilterEvent {
  final Map<String, List<String>>? selectedItems;
  final FilteredSelectedModel selectdFilterItemIndex;

  UpdateFilters({required this.selectedItems, required this.selectdFilterItemIndex});

  @override
  List<Object?> get props => [selectedItems, selectdFilterItemIndex];
}

class GetDoctorSpecializationList extends DoctorsFilterEvent {
  final String searchText;
  final String cityName;
  final String stateName;
  final int selectedIndex;
  final String selectedMenu;

  GetDoctorSpecializationList({
    this.searchText = "",
    this.cityName = "",
    this.stateName = "",
    required this.selectedIndex,
    required this.selectedMenu,
  });

  @override
  List<Object?> get props => [searchText, selectedIndex, selectedMenu];
}

class ApplyFilters extends DoctorsFilterEvent {
  final Map<String, List<String>> selectedItems;

  ApplyFilters({required this.selectedItems});

  @override
  List<Object?> get props => [selectedItems];
}
