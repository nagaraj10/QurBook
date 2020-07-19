import 'package:myfhb/add_address/models/place.dart';
import 'package:myfhb/my_providers/models/DoctorModel.dart';
import 'package:myfhb/my_providers/models/HospitalModel.dart';
import 'package:myfhb/my_providers/models/LaborartoryModel.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/search_providers/models/doctors_data.dart';
import 'package:myfhb/search_providers/models/doctors_list_response.dart';
import 'package:myfhb/search_providers/models/hospital_data.dart';
import 'package:myfhb/search_providers/models/hospital_list_response.dart';
import 'package:myfhb/search_providers/models/lab_data.dart';
import 'package:myfhb/search_providers/models/labs_list_response.dart';

class AddProvidersArguments {
  DoctorsData data;
  HospitalData hospitalData;
  LabData labData;

  String searchKeyWord;
  bool hasData;
  String searchText;
  String fromClass;

  DoctorsModel doctorsModel;
  HospitalsModel hospitalsModel;
  LaboratoryModel labsModel;
  PlaceDetail placeDetail;
  Place place;
  String confirmAddressDescription;

  AddProvidersArguments(
      {this.data,
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
      this.confirmAddressDescription});
}
