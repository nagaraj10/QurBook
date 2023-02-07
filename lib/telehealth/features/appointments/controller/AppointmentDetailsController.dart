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
  var testName = "".obs;
  var scheduleDateTime = "".obs;

  getAppointmentDetail(String appointmentId) async {
    try {
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
            appointmentDetailsModel.result?.modeOfService?.name ?? "";

        scheduleDateTime.value =
            "${constants.changeDateFormat(CommonUtil().validString(appointmentDetailsModel.result?.plannedStartDateTime ?? ""))}";

        scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
            ? "${scheduleDateTime.value}, ${DateFormat(CommonUtil.REGION_CODE == 'IN' ? Constants.Appointments_time_format : Constants.Appointments_time_formatUS).format(DateTime.parse(appointmentDetailsModel.result?.plannedStartDateTime ?? "")).toString() ?? ''}"
            : "";

        scheduleDateTime.value = scheduleDateTime.value.trim().isNotEmpty
            ? "${scheduleDateTime.value} - ${DateFormat(CommonUtil.REGION_CODE == 'IN' ? Constants.Appointments_time_format : Constants.Appointments_time_formatUS).format(DateTime.parse(appointmentDetailsModel.result?.plannedEndDateTime ?? "")).toString() ?? ''}"
            : "";

        switch (appointmentType.value.toLowerCase()) {
          case "lab appointment":
            if (appointmentDetailsModel.result?.healthOrganization != null) {
              providerName.value =
                  appointmentDetailsModel.result?.healthOrganization?.name ??
                      "";
              if (appointmentDetailsModel.result?.healthOrganization
                          ?.healthOrganizationAddressCollection !=
                      null &&
                  appointmentDetailsModel.result?.healthOrganization
                          ?.healthOrganizationAddressCollection.length >
                      0) {
                List<String> list = [];

                var addressLine1 = "";
                var addressLine2 = "";
                var city = "";
                var state = "";

                addressLine1 = appointmentDetailsModel
                        .result
                        ?.healthOrganization
                        ?.healthOrganizationAddressCollection[0]
                        .addressLine1 ??
                    "";

                if (addressLine1.trim().isNotEmpty) {
                  list.add(addressLine1);
                }

                addressLine2 = appointmentDetailsModel
                        .result
                        ?.healthOrganization
                        ?.healthOrganizationAddressCollection[0]
                        .addressLine2 ??
                    "";

                if (addressLine2.trim().isNotEmpty) {
                  list.add(addressLine2);
                }

                city = appointmentDetailsModel.result?.healthOrganization
                        ?.healthOrganizationAddressCollection[0].city.name ??
                    "";

                if (city.trim().isNotEmpty) {
                  list.add(city);
                }

                state = appointmentDetailsModel.result?.healthOrganization
                        ?.healthOrganizationAddressCollection[0].state.name ??
                    "";

                state = state +
                    " ${appointmentDetailsModel.result?.healthOrganization?.healthOrganizationAddressCollection[0].pincode ?? ""}";

                if (state.trim().isNotEmpty) {
                  list.add(state);
                }

                providerAddress.value = list.join(',');
              }
            } else {
              providerName.value =
                  appointmentDetailsModel.result?.additionalInfo?.labName ?? "";
            }
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
                  testName.value = field.data[index]?.name ?? "";
                  break;
                }
              }
            }
            break;
          case "homecare service":
            //TODO
            break;
          case "transportation":
            //TODO
            break;
          case "doctor appointment":
            //TODO
            break;
        }
      }

      if(providerAddress.value.trim().isEmpty){
        providerAddress.value = "--";
      }

      loadingData.value = false;
    } catch (e) {
      //print(e);
    }
  }
}
