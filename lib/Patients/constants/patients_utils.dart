import 'package:intl/intl.dart';
import 'package:myfhb/Patients/constants/patients_constants.dart' as constants;
import 'package:shared_preferences/shared_preferences.dart';

patientAppointmentDate(String dateTime) {
  DateFormat format = DateFormat(constants.strDate_format);
  String date = format.format(DateTime.parse(dateTime));

  return date;
}

savePrefHealthOrganizationId(String healthOrganizationId) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.setString(
      constants.keyPrefHealthOrganizationId, healthOrganizationId);
}
