import 'package:myfhb/feedback/Model/FeedbackTypeModel.dart';
import 'package:myfhb/feedback/Provider/FeedbackApiProvider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FeedbackController extends GetxController {
  final _apiProvider = FeedbackApiProvider();
  var loadingData = false.obs;
  FeedbackTypeModel feedbackType;
  var selectedType = HealthRecordTypeCollection.fromJson({}).obs;

  getFeedbacktypes() async {
    try {
      loadingData.value = true;
      http.Response response = await _apiProvider.getFeedbacktypes();
      if (response == null) {
        // failed to get the data
      } else {
        feedbackType = feedbackTypeModelFromJson(response.body);
        feedbackType.result.first.healthRecordTypeCollection
            .removeWhere((element) => element.name == 'Feedback');
        selectedType.value =
            feedbackType.result.first.healthRecordTypeCollection.first;
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }
}
