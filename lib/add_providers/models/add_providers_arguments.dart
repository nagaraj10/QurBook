import '../../add_address/models/place.dart';
import '../../my_providers/models/Doctors.dart';
import '../../my_providers/models/Hospitals.dart';
import '../../search_providers/models/doctor_list_response_new.dart';
import '../../search_providers/models/hospital_list_response_new.dart';
import '../../search_providers/models/labs_list_response_new.dart';

class AddProvidersArguments {
  DoctorsListResult data;
  HospitalsListResult hospitalData;
  LabListResult labData;

  String searchKeyWord;
  bool hasData;
  String searchText;
  String fromClass;

  Doctors doctorsModel;
  Hospitals hospitalsModel;
  Hospitals labsModel;
  PlaceDetail placeDetail;
  Place place;
  String confirmAddressDescription;
  Function isRefresh;
  List<Hospitals> labsDataList;

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
    this.isRefresh,this.labsDataList
  });
}
