class MyPlanDetailModel {
  bool isSuccess;
  String message;
  MyPlanDetailResult result;

  MyPlanDetailModel({this.isSuccess, this.message, this.result});

  MyPlanDetailModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
    json['result'] != null ? new MyPlanDetailResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class MyPlanDetailResult {
  String planPackage;
  String provider;
  String startDate;
  String endDate;
  List<Activities> activities;

  MyPlanDetailResult(
      {this.planPackage,
        this.provider,
        this.startDate,
        this.endDate,
        this.activities});

  MyPlanDetailResult.fromJson(Map<String, dynamic> json) {
    planPackage = json['planPackage'];
    provider = json['provider'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    if (json['Activities'] != null) {
      activities = new List<Activities>();
      json['Activities'].forEach((v) {
        activities.add(new Activities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planPackage'] = this.planPackage;
    data['provider'] = this.provider;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    if (this.activities != null) {
      data['Activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activities {
  String id;
  String title;
  String description;
  String activityId;
  List<ActivityFormData> activityFormData;
  String notes;
  bool mealRepeat;
  List<MealRepeatPattern> mealRepeatPattern;
  String repeatTime;
  int eventStartFromDay;
  int numberOfEventDays;
  bool weekRepeat;
  bool needPhoto;
  bool needFile;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool repeatEvery;
  bool remindValue;
  bool needAudio;
  bool needVideo;

  Activities(
      {this.id,
        this.title,
        this.description,
        this.activityId,
        this.activityFormData,
        this.notes,
        this.mealRepeat,
        this.mealRepeatPattern,
        this.repeatTime,
        this.eventStartFromDay,
        this.numberOfEventDays,
        this.weekRepeat,
        this.needPhoto,
        this.needFile,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.repeatEvery,
        this.remindValue,
        this.needAudio,
        this.needVideo});

  Activities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    activityId = json['activityId'];
    if (json['activityFormData'] != null) {
      activityFormData = new List<ActivityFormData>();
      json['activityFormData'].forEach((v) {
        activityFormData.add(new ActivityFormData.fromJson(v));
      });
    }
    notes = json['notes'];
    mealRepeat = json['mealRepeat'];
    if (json['mealRepeatPattern'] != null) {
      mealRepeatPattern = new List<MealRepeatPattern>();
      json['mealRepeatPattern'].forEach((v) {
        mealRepeatPattern.add(new MealRepeatPattern.fromJson(v));
      });
    }
    repeatTime = json['repeatTime'];
    eventStartFromDay = json['eventStartFromDay'];
    numberOfEventDays = json['numberOfEventDays'];
    weekRepeat = json['weekRepeat'];
    needPhoto = json['needPhoto'];
    needFile = json['needFile'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    repeatEvery = json['repeatEvery'];
    remindValue = json['remindValue'];
    needAudio = json['needAudio'];
    needVideo = json['needVideo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['activityId'] = this.activityId;
    if (this.activityFormData != null) {
      data['activityFormData'] =
          this.activityFormData.map((v) => v.toJson()).toList();
    }
    data['notes'] = this.notes;
    data['mealRepeat'] = this.mealRepeat;
    if (this.mealRepeatPattern != null) {
      data['mealRepeatPattern'] =
          this.mealRepeatPattern.map((v) => v.toJson()).toList();
    }
    data['repeatTime'] = this.repeatTime;
    data['eventStartFromDay'] = this.eventStartFromDay;
    data['numberOfEventDays'] = this.numberOfEventDays;
    data['weekRepeat'] = this.weekRepeat;
    data['needPhoto'] = this.needPhoto;
    data['needFile'] = this.needFile;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['repeatEvery'] = this.repeatEvery;
    data['remindValue'] = this.remindValue;
    data['needAudio'] = this.needAudio;
    data['needVideo'] = this.needVideo;
    return data;
  }
}

class ActivityFormData {
  List<ActivityDetails> activityDetails;
  List<FormDetails> formDetails;

  ActivityFormData({this.activityDetails, this.formDetails});

  ActivityFormData.fromJson(Map<String, dynamic> json) {
    if (json['activityDetails'] != null) {
      activityDetails = new List<ActivityDetails>();
      json['activityDetails'].forEach((v) {
        activityDetails.add(new ActivityDetails.fromJson(v));
      });
    }
    if (json['formDetails'] != null) {
      formDetails = new List<FormDetails>();
      json['formDetails'].forEach((v) {
        formDetails.add(new FormDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activityDetails != null) {
      data['activityDetails'] =
          this.activityDetails.map((v) => v.toJson()).toList();
    }
    if (this.formDetails != null) {
      data['formDetails'] = this.formDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityDetails {
  String id;
  String title;

  ActivityDetails({this.id, this.title});

  ActivityDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}

class FormDetails {
  String id;
  String type;
  String title;
  List<FormFieldCollection> formFieldCollection;

  FormDetails({this.id, this.type, this.title, this.formFieldCollection});

  FormDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    if (json['formFieldCollection'] != null) {
      formFieldCollection = new List<FormFieldCollection>();
      json['formFieldCollection'].forEach((v) {
        formFieldCollection.add(new FormFieldCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    if (this.formFieldCollection != null) {
      data['formFieldCollection'] =
          this.formFieldCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FormFieldCollection {
  String fieldInput;
  String fieldTitle;

  FormFieldCollection({this.fieldInput, this.fieldTitle});

  FormFieldCollection.fromJson(Map<String, dynamic> json) {
    fieldInput = json['fieldInput'];
    fieldTitle = json['fieldTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldInput'] = this.fieldInput;
    data['fieldTitle'] = this.fieldTitle;
    return data;
  }
}

class MealRepeatPattern {
  String fieldId;
  String fieldCode;
  bool fieldInput;
  String fieldTitle;

  MealRepeatPattern(
      {this.fieldId, this.fieldCode, this.fieldInput, this.fieldTitle});

  MealRepeatPattern.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    fieldCode = json['fieldCode'];
    fieldInput = json['fieldInput'];
    fieldTitle = json['fieldTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldId'] = this.fieldId;
    data['fieldCode'] = this.fieldCode;
    data['fieldInput'] = this.fieldInput;
    data['fieldTitle'] = this.fieldTitle;
    return data;
  }
}