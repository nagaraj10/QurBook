// ignore_for_file: public_member_api_docs

part of 'doctors_filter_bloc.dart';

abstract class DoctorsFilterEvent {}

// Event class for fetching the list of doctor specializations
// Selected menu item
class GetDoctorSpecializationList extends DoctorsFilterEvent {
  GetDoctorSpecializationList({
    this.searchText = "", // Default value for searchText
    this.cityName = "", // Default value for cityName
    this.stateName = "", // Default value for stateName
    required this.selectedIndex, // Required index indicating
    // the type of specialization
    required this.selectedMenu, // Required selected menu item
  });
  final String searchText; // Text to search for doctor specializations
  final String cityName; // City name for location-based search
  final String stateName; // State name for location-based search
  final int selectedIndex; // Index indicating the type of doctor specialization
  final String selectedMenu;

  // Override props getter to compare equality of objects
  @override
  List<Object?> get props => [searchText, selectedIndex, selectedMenu];
}

// Event class for applying filters in the doctor search
class ApplyFilters extends DoctorsFilterEvent {
  // Selected filter items

  ApplyFilters({required this.selectedItems, required this.count});
  final Map<String, List<String>> selectedItems;
  final int count;

  // Override props getter to compare equality of objects
  @override
  List<Object?> get props => [selectedItems, count];
}
