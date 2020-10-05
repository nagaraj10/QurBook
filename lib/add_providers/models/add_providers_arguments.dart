import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/my_providers/models/DoctorModel.dart';
import 'package:myfhb/my_providers/models/HospitalModel.dart';
import 'package:myfhb/my_providers/models/LaborartoryModel.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/search_providers/models/hospital_list_response_new.dart';
import 'package:myfhb/search_providers/models/labs_list_response_new.dart';

class AddProvidersArguments {
  DoctorsListResult data;
  HospitalsListResult hospitalData;
  LabListResult labData;

  String searchKeyWord;
  bool hasData;
  String searchText;
  String fromClass;

  DoctorsModel doctorsModel;
  Hospitals hospitalsModel;
  Hospitals labsModel;
  PlaceDetail placeDetail;
  Place place;
  String confirmAddressDescription;

  AddProvidersArguments({
    this.data,
    this.searchKeyWord,
    this.hospitalData,
    this.hasData,
    this.labData,
    this.searchText,
    this.fromClass,
    this.doctorsModel,
    this.hospitalsModel,
    this.labsModel,
    this.placeDetail,
    this.place,
    this.confirmAddressDescription,
  });
}
