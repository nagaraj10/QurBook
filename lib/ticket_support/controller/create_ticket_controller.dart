
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/landing/model/membership_detail_response.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';
import 'package:myfhb/search_providers/models/labs_list_response_new.dart';
import 'package:myfhb/search_providers/screens/doctor_filter_request_model.dart';
import 'package:myfhb/search_providers/services/filter_doctor_api.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/services/ticket_service.dart';

class CreateTicketController extends GetxController {
  List<Hospitals>? labsList = [];
  List<Hospitals> hospitalList = [];
  List<Doctors?>? doctorsList = [];

  late ProvidersBloc _providersBloc;
  var isCTLoading = false.obs;
  var isPreferredLabDisable = false.obs;
  var labBookAppointment = false.obs;
  var selPrefLab = "Select".obs;
  var selPrefLabId = "".obs;

  var isPreferredDoctorDisable = false.obs;
  var doctorBookAppointment = false.obs;
  var selPrefDoctor = "Select".obs;
  var selPrefDoctorId = "".obs;

  //List<FieldData> modeOfServiceList = [];
  var dynamicTextFiledObj  = {};

  //populateAddressForPrefLab
  var strAddressLine = "".obs;
  var strCityName = "".obs;
  var strPincode = "".obs;
   var strStateName = "".obs;

   //doctor appointment
  var docSpecialization = "".obs;

  //Selected lab address
  var selLabAddress = ''.obs;


  UserTicketService userTicketService = UserTicketService();

  // Define a limit for the number of items to load per page
  int limit = 50;

  /// Create a PagingController for managing pagination of doctor data
  PagingController<int, DoctorsListResult> pagingController = PagingController(
    // Set the first page key, usually starting from 0 or 1
    firstPageKey: 0,

    // Set the threshold for the number of invisible items before triggering loading more
    invisibleItemsThreshold: 1,
  );

// Declare a DoctorFilterRequestModel variable for filtering doctors
  late DoctorFilterRequestModel doctorFilterRequestModel;

// Create a PagingController for managing pagination of lab data
  PagingController<int, LabListResult> labListResultPagingController = PagingController(
    firstPageKey: 0,
    invisibleItemsThreshold: 1,
  );

  // Declare a LabListFilterRequestModel variable for filtering labs
  late DoctorFilterRequestModel labListFilterRequestModel;



  // Declare a variable named 'searchWord' and use the '.obs' extension, indicating it's an observable
  var searchWord = "".obs;

// Declare a variable named 'strSearchText' and use the '.obs' extension, indicating it's an observable
  var strSearchText = "".obs;

  // Observable variable for sorting order of lab names.
  // Initially set to 0 (no sorting).
  var isLabNameAscendingOrder = 0.obs;

  // Observable variable for sorting order of doctors.
  // Initially set to 0 (no sorting).
  var isDoctorSort = 0.obs;





  @override
  void onClose() {
    try {
      super.onClose();
    } catch (e,stackTrace) {
      print(e);
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  @override
  void onInit() {
    try {
      super.onInit();
    } catch (e,stackTrace) {
      print(e);
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  getLabList({bool updateLab = false}) {
    try {
      if (!updateLab) {
        _providersBloc = ProvidersBloc();
        isCTLoading.value = true;

        _providersBloc.getMedicalPreferencesForHospital().then((value) {
          isCTLoading.value = false;
          if (value != null &&
              value.result != null &&
              value.result!.labs != null &&
              value.result!.labs!.isNotEmpty) {
            labsList = value.result!.labs;
            labsList!.sort((a, b) => CommonUtil()
                .validString(a.name.toString())
                .toLowerCase()
                .compareTo(
                    CommonUtil().validString(b.name.toString()).toLowerCase()));
            labsList!.insert(0, Hospitals(name: 'Select'));
            isPreferredLabDisable.value = false;
          } else {
            labsList = [];
            labsList!.insert(0, Hospitals(name: 'Select'));
            isPreferredLabDisable.value = true;
          }
        });
      } else {}
    } catch (e,stackTrace) {
      labsList = [];
      labsList!.insert(0, Hospitals(name: 'Select'));
      isCTLoading.value = false;
      isPreferredLabDisable.value = true;
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  getDoctorList({bool updateDoctor = false}) {
    try {
      if (!updateDoctor) {
        _providersBloc = ProvidersBloc();
        isCTLoading.value = true;

        _providersBloc.getMedicalPreferencesForDoctors().then((value) {
          isCTLoading.value = false;
          if (value != null &&
              value.result != null &&
              value.result!.doctors != null &&
              value.result!.doctors!.isNotEmpty) {
            doctorsList = value.result!.doctors;
            doctorsList!.sort((a, b) => CommonUtil()
                .validString(a!.user!.name.toString())
                .toLowerCase()
                .compareTo(CommonUtil()
                    .validString(b!.user!.name.toString())
                    .toLowerCase()));
            // ignore: unnecessary_new
            doctorsList!.insert(0, Doctors(user: User(name: 'Select')));
            isPreferredDoctorDisable.value = false;
          } else {
            doctorsList = [];
            doctorsList!.insert(0, Doctors(user: User(name: 'Select')));
            isPreferredDoctorDisable.value = true;
          }
        });
      } else {}
    } catch (e,stackTrace) {
      doctorsList = [];
      doctorsList!.insert(0, Doctors(user: User(name: 'Select')));
      isCTLoading.value = false;
      isPreferredDoctorDisable.value = true;
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  getProviderList(String type,Field field) async {
    try {
      isCTLoading.value = true;
      List<FieldData> providerList = [];

      MemberShipDetailResponse memberShipDetailResponse =
          await userTicketService.getProviderList(type);

      if (memberShipDetailResponse != null &&
          memberShipDetailResponse.result != null &&
          memberShipDetailResponse.result!.length > 0) {
        memberShipDetailResponse.result?.forEach((element) {
          providerList.add(FieldData.fromJson({
            id_sheela: element.healthOrganizationId,
            strName: element.healthOrganizationName,
          }));
        });
      }

      providerList.add(FieldData.fromJson({
        id_sheela: strOthers,
        strName: toBeginningOfSentenceCase(strOthers),
      }));

      field.setFieldData(providerList);

      isCTLoading.value = false;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // Function to fetch and paginate doctors list data
  fetchDoctorsListData(int pageKey) async {
    try {
      // Increment the page number in the doctor filter request model
      doctorFilterRequestModel
        ..page = (doctorFilterRequestModel?.page ?? 0) + 1
        ..searchText = strSearchText.value
        ..size = limit;

      if (doctorFilterRequestModel.sorts == null ||
          (doctorFilterRequestModel.sorts!.isEmpty??true)) {
        doctorFilterRequestModel.sorts = null;
      }

      // Fetch new data using the FilterDoctorApi based on the updated doctor filter request model
      final newData = await FilterDoctorApi().getFilterDoctorList(doctorFilterRequestModel);

      // Extract the new items from the fetched data
      final newItems = newData ?? [];

      // Check if it's the last page based on the length of the new items
      final isLastPage = newItems.length < limit;

      // Append the new items to the doctor paging controller
      if (isLastPage) {
        // If it's the last page, append it as the last page
        pagingController.appendLastPage(newItems);
      } else {
        // If there are more pages, calculate the next page key and append the new items
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e, stackTrace) {
      // Handle any errors that occur during the fetch process
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      pagingController.error = e;
    }
  }

  // Function to fetch and paginate lab list data
  fetchLabListData(int pageKey) async {
    try {

      // Ensure labListFilterRequestModel.filters is initialized as an empty list if null
      labListFilterRequestModel.filters ??= [];

      // Check if the health organization type filter is already added
      var isHealthOrganizationTypeAlreadyAdded = hasHealthOrgTypeFilter(labListFilterRequestModel.filters);

      // Increment the page number in the lab filter request model
      labListFilterRequestModel
        ..page = (labListFilterRequestModel?.page ?? 0) + 1 // Increment the page number by 1, or set to 1 if it's null
        ..size = limit // Set the number of items per page
        ..searchText = strSearchText.value; // Set the search text

      // Add health organization type filter if it's not already added
      if (!isHealthOrganizationTypeAlreadyAdded) {
        // Create a new filter instance for health organization type
        var labFilter = Filter()
          ..field = strHealthOrganizationType // Set the field to health organization type
          ..value = CommonConstants.keyLab.toUpperCase() // Set the value (assuming keyLab needs to be in uppercase)
          ..type = strString; // Set the type to string

        // Add the health organization type filter to the list of filters
        labListFilterRequestModel.filters?.add(labFilter);
      }


      if (labListFilterRequestModel.sorts == null ||
          (labListFilterRequestModel.sorts!.isEmpty??true)) {
        labListFilterRequestModel.sorts = null;
      }

      // Fetch new data using the FilterDoctorApi based on the updated lab filter request model
      final newData = await FilterDoctorApi().getFilterLabListResult(labListFilterRequestModel);

      // Extract the new items from the fetched data
      final newItems = newData ?? [];
      final isLastPage = newItems.length < limit;

      // Append the new items to the lab paging controller
      if (isLastPage) {
        // If it's the last page, append it as the last page
        labListResultPagingController.appendLastPage(newItems);
      } else {
        // If there are more pages, calculate the next page key and append the new items
        final nextPageKey = pageKey + newItems.length;
        labListResultPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e, stackTrace) {
      // Handle any errors that occur during the fetch process
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      labListResultPagingController.error = e;
    }
  }


  // Function to check if a health organization type filter is already added
  bool hasHealthOrgTypeFilter(List<Filter>? filters) {
    // Check if filters list contains any filter with health org type
    return filters?.any((filter) =>
    // Check if filter's field matches health org type
    filter.field == strHealthOrganizationType)
        // Default to false if filters is null
        ?? false;
  }

}
