import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/my_reports/model/report_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';

class ReportService {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<ReportModel> getReportList(String patientId) async {
    final response = await _helper.getReportList(qr_power_bi);
    return ReportModel.fromJson(response);
  }
}
