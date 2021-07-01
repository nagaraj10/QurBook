import '../../../constants/fhb_parameters.dart' as parameters;
import '../Category/catergory_result.dart';

class MediaResult {
  String id;
  String name;
  String description;
  String logo;
  bool isDisplay;
  bool isAiTranscription;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  CategoryResult healthRecordCategory;
  bool isChecked = false;
  MediaResult(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.isDisplay,
      this.isAiTranscription,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.healthRecordCategory,
      this.isChecked});

  MediaResult.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    description = json[parameters.strDescription];
    logo = json[parameters.strLogo];
    isDisplay = json[parameters.strIsDisplay];
    isAiTranscription = json[parameters.strIsAiTranscription];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    if (json.containsKey(parameters.strHealthRecordCategory)) {
      healthRecordCategory = json[parameters.strHealthRecordCategory] != null
          ? CategoryResult.fromJson(
              json[parameters.strHealthRecordCategory])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strDescription] = description;
    data[parameters.strLogo] = logo;
    data[parameters.strIsDisplay] = isDisplay;
    data[parameters.strIsAiTranscription] = isAiTranscription;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    if (data.containsKey(parameters.strHealthRecordCategory)) {
      if (healthRecordCategory != null) {
        data[parameters.strHealthRecordCategory] =
            healthRecordCategory.toJson();
      }
    }

    return data;
  }
}
