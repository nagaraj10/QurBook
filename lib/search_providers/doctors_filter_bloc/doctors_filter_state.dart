part of 'doctors_filter_bloc.dart';

@immutable
abstract class DoctorsFilterState {}

class DoctorsFilterInitial extends DoctorsFilterState {}

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

class ShowDoctorFilterList extends DoctorsFilterState {
  final List<DoctorsListResult> doctorFilterList;
  final int filterMenuCount;
  ShowDoctorFilterList({
    required this.doctorFilterList,
    required this.filterMenuCount,
  });
}
