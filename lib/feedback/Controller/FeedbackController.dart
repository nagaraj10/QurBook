import 'package:myfhb/feedback/Model/FeedbackCategoriesTypeModel.dart';
import 'package:myfhb/feedback/Model/FeedbackTypeModel.dart';
import 'package:myfhb/feedback/Provider/FeedbackApiProvider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FeedbackController extends GetxController {
  final _apiProvider = FeedbackApiProvider();
  var loadingData = false.obs;
  FeedbackTypeModel feedbackType;
  FeedbackCategoryType categories;
  FeedbackCategoryModel selectedType;
  var catSelected = false.obs;

  getFeedbacktypes() async {
    try {
      loadingData.value = true;
      http.Response responseCat = await _apiProvider.getFeedbackCat();
      http.Response response = await _apiProvider.getFeedbacktypes();
      if (response == null || responseCat == null) {
        // failed to get the data, we are showing the error on UI
      } else {
        feedbackType = feedbackTypeModelFromJson(responseCat.body);
        categories = feedbackCategoryTypeFromJson(response.body);
      }
      loadingData.value = false;
    } catch (e) {
      print(e.toString());
      loadingData.value = false;
    }
  }

  setRecordType(FeedbackCategoryModel selected) {
    catSelected.value = false;
    selectedType = selected;
    catSelected.value = true;
  }

  removeSelectedType() {
    selectedType = null;
    catSelected.value = false;
  }
}
