part of 'doctors_filter_bloc.dart';

@immutable
abstract class DoctorsFilterState {}

class DoctorsFilterInitial extends DoctorsFilterState {}

// State for showing progress bar
class ShowProgressBar extends DoctorsFilterState {}

// State for hiding progress bar
class HideProgressBar extends DoctorsFilterState {}

// State for showing list of left side menu items
class ShowMenuItemList extends DoctorsFilterState {
  final List<String> menuItemList;
  final String selectedMenu;
  final int selectedIndex;
  ShowMenuItemList({
    required this.menuItemList,
    required this.selectedMenu,
    required this.selectedIndex,
  });
}

// State for showing list of filter doctor
class ShowDoctorFilterList extends DoctorsFilterState {
  final List<DoctorsListResult> doctorFilterList;
  final int filterMenuCount;
  // Declare a final variable of type DoctorFilterRequestModel
  final DoctorFilterRequestModel doctorFilterRequestModel;

  ShowDoctorFilterList({
    required this.doctorFilterList,
    required this.filterMenuCount,
    required this.doctorFilterRequestModel,
  });
}
