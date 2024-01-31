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
