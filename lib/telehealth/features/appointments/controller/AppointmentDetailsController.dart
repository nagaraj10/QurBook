import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/telehealth/features/appointments/model/appointmentDetailsModel.dart';
import 'package:myfhb/telehealth/features/appointments/services/fetch_appointments_service.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart'
    as constants;
import 'package:myfhb/telehealth/features/appointments/constants/appointments_constants.dart'
    as Constants;

class AppointmentDetailsController extends GetxController {
  var loadingData = false.obs;

  FetchAppointmentsService fetchAppointmentsService =
      FetchAppointmentsService();

  AppointmentDetailsModel? appointmentDetailsModel;

  var appointmentType = "".obs;
  var appointmentIconUrl = "".obs;
  var appointmentModeOfService = "".obs;
  var providerName = "".obs;
  var providerAddress = "".obs;
  var testName = "".obs;
  var description = "".obs;
  var pickUpAddress = "".obs;
  var dropAddress = "".obs;
  var scheduleDateTime = "".obs;
  var slotNumber = "".obs;
  var hospitalName = "".obs;
  List<String> list = [];

  var addressLine1 = "";
  var addressLine2 = "";
  var city = "";
  var state = "";
  var locationUrl = "";
  var appointmentId="";

  DateTime? endTimeForTransportation;
  DateTime? startTimeForTransportation;
  getAppointmentDetail(String appointmentId) async {
    try {
      onClear();
      loadingData.value = true;
      this.appointmentId=appointmentId;
      appointmentDetailsModel =
          await fetchAppointmentsService.getAppointmentDetail(appointmentId);

      if (appointmentDetailsModel != null &&
          appointmentDetailsModel?.result != null) {

          appointmentType.value = appointmentDetailsModel?.result?.serviceCategory?.name ?? "";

        appointmentIconUrl.value = appointmentDetailsModel!
                .result?.serviceCategory?.additionalInfo?.iconUrl ??
            "";

        appointmentModeOfService.value =appointmentDetailsModel?.result?.modeOfService?.name ?? "${appointmentDetailsModel?.result?.additionalInfo?.modeOfService?.name??""}";

        scheduleDateTime.value =
            "${constants.changeDateFormat(CommonUtil().validString(appointmentDetailsModel!.result?.plannedStartDateTime ?? ""))}";

        scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
            ? "${scheduleDateTime.value}, ${DateFormat(CommonUtil.REGION_CODE == 'IN' ? Constants.Appointments_time_format : Constants.Appointments_time_formatUS).format(DateTime.parse(appointmentDetailsModel!.result?.plannedStartDateTime ?? "")).toString()}"
            : "";

        bool showEndTime=true;

        if(CommonUtil.REGION_CODE == 'US' && appointmentDetailsModel?.result?.serviceCategory?.code!='CONSLTN'){
          showEndTime=!(appointmentDetailsModel?.result?.additionalInfo?.isEndTimeOptional??false);
        }

        if (appointmentType.value.toLowerCase() != strTransportation) {
          if(showEndTime){
            endTimeForTransportation=DateTime.parse(appointmentDetailsModel?.result?.plannedEndDateTime ?? "");
            scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
                ? "${scheduleDateTime.value} - ${DateFormat(CommonUtil.REGION_CODE == 'IN' ? Constants.Appointments_time_format : Constants.Appointments_time_formatUS).format(DateTime.parse(appointmentDetailsModel?.result?.plannedEndDateTime ?? "")).toString()}"
                : "";
          }else{
            scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
                ? "${scheduleDateTime.value}"
                : "";
          }

        }

        if (appointmentDetailsModel!.result?.healthOrganization != null) {
          if (appointmentType.value.toLowerCase() == strDoctorAppointment) {
            providerName.value = (appointmentDetailsModel!.result!.doctor != null
                ? toBeginningOfSentenceCase((appointmentDetailsModel!
                            .result!.doctor!.user!.firstName!) +
                    ' ' +
                    (appointmentDetailsModel!.result!.doctor!.user!.lastName!))
                : '')!;
          } else {
            providerName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel!.result!.healthOrganization!.name!)!;
          }
          if (appointmentDetailsModel!.result?.healthOrganization
                      ?.healthOrganizationAddressCollection !=
                  null &&
              appointmentDetailsModel!.result!.healthOrganization
                      !.healthOrganizationAddressCollection!.length >
                  0) {
            if (appointmentType.value.toLowerCase() == strLabAppointment ||
                appointmentType.value.toLowerCase() == strDoctorAppointment) {
              addressLine1 = appointmentDetailsModel?.result?.healthOrganization
                      ?.healthOrganizationAddressCollection![0].addressLine1 ??
                  "";

              addressLine2 = appointmentDetailsModel?.result?.healthOrganization
                      ?.healthOrganizationAddressCollection![0].addressLine2 ??
                  "";

              city = appointmentDetailsModel?.result?.healthOrganization
                      ?.healthOrganizationAddressCollection![0].city?.name ??
                  "";

              state = appointmentDetailsModel?.result?.healthOrganization
                      ?.healthOrganizationAddressCollection![0].state?.name ??
                  "";

              state = state +
                  " ${appointmentDetailsModel!.result!.healthOrganization?.healthOrganizationAddressCollection![0].pincode ?? ""}";
            } else {
              getAddress();
            }
          }
        } else {
          if (appointmentType.value.toLowerCase() == strLabAppointment) {
            providerName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel!.result!.additionalInfo!.labName!)!;
          } else {
            providerName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel!.result!.additionalInfo!.providerName)!;
          }
          getAddress();
        }

        switch (appointmentType.value.toLowerCase()) {
          case strLabAppointment:
            for (int i = 0;
                i <
                        (appointmentDetailsModel!.result!.serviceCategory!
                            .additionalInfo!.field!.length);
                i++) {
              Field field = appointmentDetailsModel!
                  .result!.serviceCategory!.additionalInfo!.field![i];
              if (field.key == "test_name") {
                final index = field.data?.indexWhere((element) =>
                    ((appointmentDetailsModel!.result?.additionalInfo!.testName ??
                            "") ==
                        (element.id ?? "")));
                if (index! >= 0) {
                  testName.value = field.data![index].name ?? "";
                  break;
                }
              }
            }
            break;
          case strHomecareService:
            getTitleDescription();
            break;
          case strTransportation:
            getTitleDescription();
            pickUpAddress.value =
                appointmentDetailsModel!.result?.additionalInfo!.from ?? "";
            dropAddress.value =
                appointmentDetailsModel!.result?.additionalInfo!.to ?? "";
            break;
          case strDoctorAppointment:
            slotNumber.value =
                appointmentDetailsModel!.result?.slotNumber?.toString() ?? "";
            hospitalName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel!.result!.healthOrganization!.name ?? "")!;
            break;
        }
      }

      if (addressLine1.trim().isNotEmpty) {
        list.add(addressLine1);
      }

      if (addressLine2.trim().isNotEmpty) {
        list.add(addressLine2);
      }

      if (city.trim().isNotEmpty) {
        list.add(city);
      }

      if (state.trim().isNotEmpty) {
        list.add(state);
      }

      providerAddress.value = list.join(',');

      if (providerAddress.value.trim().isEmpty) {
        providerAddress.value = "";
      }

      loadingData.value = false;
    } catch (e) {
      if (kDebugMode) {
        printError(info: "error in try: "+e.toString());
      }
    }
  }

  onClear() {
    try {
      appointmentType.value = "";
      appointmentIconUrl.value = "";
      appointmentModeOfService.value = "";
      providerName.value = "";
      providerAddress.value = "";
      testName.value = "";
      description.value = "";
      pickUpAddress.value = "";
      dropAddress.value = "";
      scheduleDateTime.value = "";
      slotNumber.value = "";
      hospitalName.value = "";
      list = [];
      addressLine1 = "";
      addressLine2 = "";
      city = "";
      state = "";
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  getTitleDescription() {
    try {
      testName.value =
          appointmentDetailsModel!.result?.additionalInfo!.title ?? "";
      description.value =
          appointmentDetailsModel!.result?.additionalInfo!.notes ?? "";
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  getAddress() {
    try {
      addressLine1 =
          appointmentDetailsModel!.result?.additionalInfo!.addressLine1 ?? "";

      addressLine2 =
          appointmentDetailsModel!.result?.additionalInfo!.addressLine2 ?? "";

      city = appointmentDetailsModel!.result?.additionalInfo!.city ?? "";

      state = appointmentDetailsModel!.result?.additionalInfo!.state ?? "";

      state = state +
          " ${appointmentDetailsModel!.result?.additionalInfo?.pinCode ?? ""}";

      locationUrl =
          appointmentDetailsModel!.result?.additionalInfo?.locationUrl ?? "";
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  acceptCareGiverTransportRequestReminder(String appointmentId,String patientId,bool isAccept) async {
    loadingData.value = true;
    FetchAppointmentsService fetchAppointmentsService = FetchAppointmentsService();
    var result=await fetchAppointmentsService.acceptOrDeclineAppointment(appointmentId,patientId,isAccept);
    getAppointmentDetail(appointmentId);
  }


  String checkIfEmptyString(String strText) {
    try {
      if (strText == null)
        return "--";
      else if (strText.trim().isEmpty)
        return "--";
      else
        return strText.trim();
    } catch (e) {
      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
    return "--";
  }
}
