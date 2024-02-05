import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:myfhb/common/CommonConstants.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../../language/repository/LanguageRepository.dart';
import '../models/doctor_list_response_new.dart';
import '../screens/doctor_filter_request_model.dart';
import '../services/filter_doctor_api.dart';
part 'doctors_filter_event.dart';
part 'doctors_filter_state.dart';

// Constants used for filtering
const _experience = 'experience';
const _twentyYears = '20+ years';
const _field = 'field';
const _type = 'type';
const _object = 'object';
const _value = 'value';
const _gender = 'gender';
const _any = 'Any';
const _hospital = 'hospital';
const _languageSpoken = 'languageSpoken';
const _array = 'array';
const _string = 'string';
const _min = 'min';
const _max = 'max';

// Bloc class for managing doctors filtering
class DoctorsFilterBloc extends Bloc<DoctorsFilterEvent, DoctorsFilterState> {
  DoctorsFilterBloc() : super(DoctorsFilterInitial()) {
    on<ApplyFilters>(_onApplyFilters);
    on<GetDoctorSpecializationList>(_onGetDoctorSpecializationList);
  }
  int filterMenuCount = 0;

  var createTicketController = CommonUtil().onInitCreateTicketController();

  // Handles the ApplyFilters event
  Future<FutureOr<void>> _onApplyFilters(ApplyFilters event, emit) async {
    emit(ShowProgressBar());
    final filters = <Map<String, dynamic>>[];

    event.selectedItems.forEach((field, values) {
      try {
        if (field == _experience) {
          // Handling experience filter
          var min = 0;
          var max = 0;
          if (values.first == _twentyYears) {
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
            _field: field,
            _type: _object,
          };
          filter[_value] = {_min: min, _max: max};
          filters.add(filter);
        } else if (field == _gender && values.first == _any) {
          // No gender filter selected
        } else {
          // Handling other filters
          final filter = <String, dynamic>{
            _field: field,
            _type: field == _hospital || field == _languageSpoken ? _array : _string,
          };
          if (values.length == 1) {
            filter[_value] = field == _hospital || field == _languageSpoken?values:values.first;
            filters.add(filter);
          }
        }
      } catch (e) {}
    });
    // Create DoctorFilterRequestModel based on selected filters
    final doctorFilterRequestModel = DoctorFilterRequestModel(
      page: 0,
      size: 10,
      searchText: '',
      filters: filters.map((json) => Filter.fromJson(json)).toList(),
    );

    // Fetch filtered doctor list
    filterMenuCount = event.count + filters.length;
    List<DoctorsListResult> doctorFilterList = [];
    doctorFilterList.clear();
    final List<bool> nonEmptyFirstValues = event.selectedItems.entries
        .map((entry) => entry.value.isNotEmpty && entry.value.first.isNotEmpty)
        .toList();

    try {
      //doctorFilterList = await FilterDoctorApi().getFilterDoctorList(doctorFilterRequestModel);
      emit(ShowDoctorFilterList(
        doctorFilterList: doctorFilterList,
        filterMenuCount: nonEmptyFirstValues.where((value) => value).length,
        doctorFilterRequestModel: doctorFilterRequestModel,
      ));
    } catch (e) {
      emit(ShowDoctorFilterList(
        doctorFilterList: [],
        filterMenuCount: nonEmptyFirstValues.where((value) => value).length,
        doctorFilterRequestModel: doctorFilterRequestModel,
      ));
    }
    emit(HideProgressBar());
  }

  // Handles the GetDoctorSpecializationList event
  Future<FutureOr<void>> _onGetDoctorSpecializationList(GetDoctorSpecializationList event, emit) async {
    emit(ShowProgressBar());

    if(createTicketController.searchWord.value == CommonConstants.doctors) {
      // Based on selected index, fetch and emit appropriate menu items
      if (event.selectedIndex == 0) {
        // Gender filter
        emit(ShowMenuItemList(
          menuItemList: DoctorFilterConstants.genderList,
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      } else if (event.selectedIndex == 1) {
        // Language spoken filter
        var languageDropdownList = <String>[];
        try {
          var languageModelList = await LanguageRepository().getLanguage();
          if (languageModelList.result != null) {
            for (final languageResultObj in languageModelList.result!) {
              if (languageResultObj.referenceValueCollection != null &&
                  languageResultObj.referenceValueCollection!.isNotEmpty) {
                for (final referenceValueCollection in languageResultObj
                    .referenceValueCollection!) {
                  if (referenceValueCollection.name != null &&
                      referenceValueCollection.code != null) {
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
        emit(HideProgressBar());
      } else if (event.selectedIndex == 2) {
        // Doctor specialization filter
        final uniqueSpecializations = await FilterDoctorApi()
            .getDoctorSpecializationList(event.searchText);
        emit(ShowMenuItemList(
          menuItemList: uniqueSpecializations.toList(),
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      } else if (event.selectedIndex == 3) {
        // State filter
        final stateList = await FilterDoctorApi().getStateList(event.cityName);
        emit(ShowMenuItemList(
          menuItemList: stateList,
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      } else if (event.selectedIndex == 4) {
        // City filter
        final cityList = await FilterDoctorApi().getCityList(event.stateName);
        emit(ShowMenuItemList(
          menuItemList: cityList.toList(),
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      } else if (event.selectedIndex == 5) {
        // Hospital filter
        final hospitalList = await FilterDoctorApi().getHospitalList(
          event.stateName,
          event.cityName,
        );
        emit(ShowMenuItemList(
          menuItemList: hospitalList,
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      } else if (event.selectedIndex == 6) {
        // Year of experience filter
        emit(ShowMenuItemList(
          menuItemList: DoctorFilterConstants.yearOfExperienceList,
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      }
    }else{
      if (event.selectedIndex == 0) {
        // State filter
        final stateList = await FilterDoctorApi().getStateList(event.cityName);
        emit(ShowMenuItemList(
          menuItemList: stateList,
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      } else if (event.selectedIndex == 1) {
        // City filter
        final cityList = await FilterDoctorApi().getCityList(event.stateName);
        emit(ShowMenuItemList(
          menuItemList: cityList.toList(),
          selectedMenu: event.selectedMenu,
          selectedIndex: event.selectedIndex,
        ));
        emit(HideProgressBar());
      }
    }


  }
}
