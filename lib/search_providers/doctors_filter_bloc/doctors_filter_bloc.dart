import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/language/repository/LanguageRepository.dart';
import 'package:myfhb/search_providers/models/doctors_list_response.dart';
import 'package:myfhb/search_providers/screens/doctor_filter_request_model.dart';
import 'package:myfhb/search_providers/screens/right_side_menu_widget.dart';
import 'package:myfhb/search_providers/services/filter_doctor_api.dart';
import '../../src/resources/network/ApiBaseHelper.dart';
part 'doctors_filter_event.dart';
part 'doctors_filter_state.dart';

class DoctorsFilterBloc extends Bloc<DoctorsFilterEvent, DoctorsFilterState> {
  DoctorsFilterBloc() : super(DoctorsFilterInitial()) {
    on<ApplyFilters>(_onApplyFilters);
    on<GetDoctorSpecializationList>(_onGetDoctorSpecializationList);
  }

  List<DoctorsListResponse> doctorSpecialization = [];

  Future<FutureOr<void>> _onApplyFilters(ApplyFilters event, emit) async {
    final filters = <Map<String, dynamic>>[];
    event.selectedItems.forEach((field, values) {
      if (field == "experience") {
        var min = 0;
        var max = 0;
        if (values.first == "20+ years") {
          min = 20;
          max = 99;
        } else {
          final parts = values.first.split(' to ');

          if (parts.length == 2) {
            min = int.tryParse(parts[0]) ?? 0;
            max = int.tryParse(parts[1].split(' ')[0]) ?? 0;
          } else if (parts.length == 1) {
            max = int.tryParse(parts[0].split(' ')[0]) ?? 0;
          }
        }
        final filter = <String, dynamic>{
          'field': field,
          'type': 'object',
        };
        filter['value'] = {"min": min, "max": max};
        filters.add(filter);
      } else if (field == "gender" && values.first == "Any") {
      } else {
        final filter = <String, dynamic>{
          'field': field,
          'type': field == 'hospital' || field == 'languageSpoken' ? 'array' : 'string',
        };
        if (values.length == 1) {
          filter['value'] = values.first;
        } else {
          filter['value'] = values;
        }
        filters.add(filter);
      }
    });

    final doctorFilterRequestModel = DoctorFilterRequestModel(
      page: 1,
      size: 10,
      searchText: '',
      filters: filters.map((json) => Filter.fromJson(json)).toList(),
    );
    final response = await ApiBaseHelper().doctorFilterList('doctor/service-request/list', json.encode(doctorFilterRequestModel));
    if (response['isSuccess']) {
      response['result'].forEach(
        (f) {
          doctorSpecialization.add(DoctorsListResponse.fromJson(f));
        },
      );
      print(doctorSpecialization);
    }
  }

  Future<FutureOr<void>> _onGetDoctorSpecializationList(GetDoctorSpecializationList event, emit) async {
    if (event.selectedIndex == 0) {
      emit(ShowMenuItemList(
        menuItemList: DoctorFilterConstants.genderList,
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    } else if (event.selectedIndex == 1) {
      var languageDropdownList = <String>[];
      try {
        var languageModelList = await LanguageRepository().getLanguage();
        if (languageModelList.result != null) {
          for (var languageResultObj in languageModelList.result!) {
            if (languageResultObj.referenceValueCollection != null && languageResultObj.referenceValueCollection!.isNotEmpty) {
              for (var referenceValueCollection in languageResultObj.referenceValueCollection!) {
                if (referenceValueCollection.name != null && referenceValueCollection.code != null) {
                  languageDropdownList.add(referenceValueCollection.name!);
                }
              }
            }
          }
        }
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }

      emit(ShowMenuItemList(
        menuItemList: languageDropdownList,
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    } else if (event.selectedIndex == 2) {
      final uniqueSpecializations = await FilterDoctorApi().getDoctorSpecializationList(event.searchText);
      emit(ShowMenuItemList(
        menuItemList: uniqueSpecializations.toList(),
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    } else if (event.selectedIndex == 3) {
      final stateList = await FilterDoctorApi().getStateList(event.cityName);
      emit(ShowMenuItemList(
        menuItemList: stateList,
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    } else if (event.selectedIndex == 4) {
      final cityList = await FilterDoctorApi().getCityList(event.stateName);
      emit(ShowMenuItemList(
        menuItemList: cityList.toList(),
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    } else if (event.selectedIndex == 5) {
      final hospitalList = await FilterDoctorApi().getHospitalList(
        event.stateName,
        event.cityName,
      );
      emit(ShowMenuItemList(
        menuItemList: hospitalList,
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    } else if (event.selectedIndex == 6) {
      emit(ShowMenuItemList(
        menuItemList: DoctorFilterConstants.yearOfExperienceList,
        selectedMenu: event.selectedMenu,
        selectedIndex: event.selectedIndex,
      ));
    }
  }
}
