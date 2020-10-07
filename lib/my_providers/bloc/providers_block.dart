import 'dart:async';

import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/my_providers/services/providers_repository.dart';
import 'package:myfhb/src/blocs/Authentication/LoginBloc.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

class ProvidersBloc implements BaseBloc {
  ProvidersListRepository _providersListRepository;
  StreamController _providersListControlller;

  StreamSink<ApiResponse<MyProvidersResponse>> get providersListSink =>
      _providersListControlller.sink;
  Stream<ApiResponse<MyProvidersResponse>> get providersListStream =>
      _providersListControlller.stream;

  List<Doctors> doctors = new List();
  List<Hospitals> hospitals = new List();
  List<Hospitals> labs = new List();

  @override
  void dispose() {
    _providersListControlller?.close();
  }

  ProvidersBloc() {
    _providersListControlller =
        StreamController<ApiResponse<MyProvidersResponse>>();
    _providersListRepository = ProvidersListRepository();
  }

  Future<MyProvidersResponse> getMedicalPreferencesList() async {
    // providersListSink.add(ApiResponse.loading(variable.strFetchMedicalPrefernces));
    MyProvidersResponse myProvidersResponseList;
    try {
      myProvidersResponseList =
          await _providersListRepository.getMedicalPreferencesList();
      doctors = myProvidersResponseList.result.doctors;
      hospitals = myProvidersResponseList.result.hospitals;
      labs = myProvidersResponseList.result.labs;
    } catch (e) {
      providersListSink.add(ApiResponse.error(e.toString()));
    }

    return myProvidersResponseList;
  }

  List<Doctors> getFilterDoctorListNew(String doctorName) {
    List<Doctors> filterDoctorData = new List();
    for (Doctors doctorData in doctors) {
      if(doctorData.user.name!=null && doctorData.user.name!=''){
        if (doctorData.user.name
            .toLowerCase()
            .trim()
            .contains(doctorName.toLowerCase().trim()) /*||
          doctorData.specialization
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim())*/ /*||
          doctorData.city
              .toLowerCase()
              .trim()
              .contains(doctorName.toLowerCase().trim())*/) {
          filterDoctorData.add(doctorData);
        }
      }

    }
    return filterDoctorData;
  }
}
