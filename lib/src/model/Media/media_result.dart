import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/Category/catergory_result.dart';

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

  MediaResult({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.isDisplay,
    this.isAiTranscription,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.healthRecordCategory,
  });

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
    if(json.containsKey(parameters.strHealthRecordCategory)) {
      healthRecordCategory = json[parameters.strHealthRecordCategory] != null
          ? new CategoryResult.fromJson(
          json[parameters.strHealthRecordCategory])
          : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    data[parameters.strDescription] = this.description;
    data[parameters.strLogo] = this.logo;
    data[parameters.strIsDisplay] = this.isDisplay;
    data[parameters.strIsAiTranscription] = this.isAiTranscription;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    if(data.containsKey(parameters.strHealthRecordCategory)) {
      if (this.healthRecordCategory != null) {
        data[parameters.strHealthRecordCategory] =
            this.healthRecordCategory.toJson();
      }
    }

    return data;
  }
}