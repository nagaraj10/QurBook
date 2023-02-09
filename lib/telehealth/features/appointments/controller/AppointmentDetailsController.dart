import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
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

  AppointmentDetailsModel appointmentDetailsModel;

  var appointmentType = "".obs;
  var appointmentIconUrl = "".obs;
  var appointmentModeOfService = "".obs;
  var providerName = "".obs;
  var providerAddress = "".obs;
  var testName = "--".obs;
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

  getAppointmentDetail(String appointmentId) async {
    try {
      onClear();
      loadingData.value = true;

      appointmentDetailsModel =
          await fetchAppointmentsService.getAppointmentDetail(appointmentId);

      if (appointmentDetailsModel != null &&
          appointmentDetailsModel.result != null) {
        appointmentType.value =
            appointmentDetailsModel.result?.serviceCategory?.name ?? "";

        appointmentIconUrl.value = appointmentDetailsModel
                .result?.serviceCategory?.additionalInfo?.iconUrl ??
            "";

        appointmentModeOfService.value =
            appointmentDetailsModel.result?.modeOfService?.name ?? "${appointmentDetailsModel.result?.additionalInfo?.modeOfService?.name??""}";

        scheduleDateTime.value =
            "${constants.changeDateFormat(CommonUtil().validString(appointmentDetailsModel.result?.plannedStartDateTime ?? ""))}";

        scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
            ? "${scheduleDateTime.value}, ${DateFormat(CommonUtil.REGION_CODE == 'IN' ? Constants.Appointments_time_format : Constants.Appointments_time_formatUS).format(DateTime.parse(appointmentDetailsModel.result?.plannedStartDateTime ?? "")).toString() ?? ''}"
            : "";

        scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
            ? "${scheduleDateTime.value} - ${DateFormat(CommonUtil.REGION_CODE == 'IN' ? Constants.Appointments_time_format : Constants.Appointments_time_formatUS).format(DateTime.parse(appointmentDetailsModel.result?.plannedEndDateTime ?? "")).toString() ?? ''}"
            : "--";

        if (appointmentDetailsModel.result?.healthOrganization != null) {
          if (appointmentType.value.toLowerCase() == "doctor appointment") {
            providerName.value = appointmentDetailsModel.result.doctor != null
                ? toBeginningOfSentenceCase(
                    (appointmentDetailsModel.result.doctor?.user.firstName ??
                            '') +
                        ' ' +
                        (appointmentDetailsModel.result.doctor?.user.lastName ??
                            ""))
                : '';
          } else {
            providerName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel.result?.healthOrganization?.name ?? "");
          }
          if (appointmentDetailsModel.result?.healthOrganization
                      ?.healthOrganizationAddressCollection !=
                  null &&
              appointmentDetailsModel.result?.healthOrganization
                      ?.healthOrganizationAddressCollection.length >
                  0) {
            if (appointmentType.value.toLowerCase() == "lab appointment" ||
                appointmentType.value.toLowerCase() == "doctor appointment") {
              addressLine1 = appointmentDetailsModel.result?.healthOrganization
                      ?.healthOrganizationAddressCollection[0].addressLine1 ??
                  "";

              addressLine2 = appointmentDetailsModel.result?.healthOrganization
                      ?.healthOrganizationAddressCollection[0].addressLine2 ??
                  "";

              city = appointmentDetailsModel.result?.healthOrganization
                      ?.healthOrganizationAddressCollection[0].city.name ??
                  "";

              state = appointmentDetailsModel.result?.healthOrganization
                      ?.healthOrganizationAddressCollection[0].state.name ??
                  "";

              state = state +
                  " ${appointmentDetailsModel.result?.healthOrganization?.healthOrganizationAddressCollection[0]?.pincode ?? ""}";
            } else {
              getAddress();
            }
          }
        } else {
          if (appointmentType.value.toLowerCase() == "lab appointment") {
            providerName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel.result?.additionalInfo?.labName ?? "");
            getAddress();
          } else {
            providerName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel.result?.additionalInfo?.providerName ??
                    "");
          }
        }

        switch (appointmentType.value.toLowerCase()) {
          case "lab appointment":
            for (int i = 0;
                i <
                        appointmentDetailsModel.result?.serviceCategory
                            ?.additionalInfo?.field?.length ??
                    0;
                i++) {
              Field field = appointmentDetailsModel
                  .result?.serviceCategory?.additionalInfo?.field[i];
              if (field.key == "test_name") {
                final index = field.data?.indexWhere((element) =>
                    ((appointmentDetailsModel.result?.additionalInfo.testName ??
                            "") ==
                        (element.id ?? "")));
                if (index >= 0) {
                  testName.value = field.data[index]?.name ?? "--";
                  break;
                }
              }
            }
            break;
          case "homecare service":
            getTitleDescription();
            break;
          case "transportation":
            getTitleDescription();
            pickUpAddress.value =
                appointmentDetailsModel.result?.additionalInfo.from ?? "--";
            dropAddress.value =
                appointmentDetailsModel.result?.additionalInfo.to ?? "--";
            break;
          case "doctor appointment":
            slotNumber.value =
                appointmentDetailsModel.result?.slotNumber?.toString() ?? "--";
            hospitalName.value = toBeginningOfSentenceCase(
                appointmentDetailsModel.result?.healthOrganization?.name ??
                    "--");
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
        providerAddress.value = "--";
      }

      loadingData.value = false;
    } catch (e) {}
  }

  onClear() {
    try {
      appointmentType.value = "";
      appointmentIconUrl.value = "";
      appointmentModeOfService.value = "";
      providerName.value = "";
      providerAddress.value = "";
      testName.value = "--";
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
    } catch (e) {}
  }

  getTitleDescription() {
    try {
      testName.value =
          appointmentDetailsModel.result?.additionalInfo.title ?? "--";
      description.value =
          appointmentDetailsModel.result?.additionalInfo.notes ?? "--";
    } catch (e) {}
  }

  getAddress() {
    try {
      addressLine1 =
          appointmentDetailsModel.result?.additionalInfo.addressLine1 ?? "";

      addressLine2 =
          appointmentDetailsModel.result?.additionalInfo.addressLine2 ?? "";

      city = appointmentDetailsModel.result?.additionalInfo.city ?? "";

      state = appointmentDetailsModel.result?.additionalInfo.state ?? "";

      state = state +
          " ${appointmentDetailsModel.result?.additionalInfo?.pinCode ?? ""}";
    } catch (e) {}
  }
}
