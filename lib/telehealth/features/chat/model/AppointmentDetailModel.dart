class AppointmentDetailModel {
  bool isSuccess;
  AppointmentResult result;

  AppointmentDetailModel({this.isSuccess, this.result});

  AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result = json['result'] != null
        ? new AppointmentResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class AppointmentResult {
  Upcoming upcoming;
  Past past;
  DeviceToken deviceToken;
  bool isCaregiver;
  ChatList chatList;

  AppointmentResult(
      {this.upcoming, this.past, this.deviceToken, this.isCaregiver, this.chatList});

  AppointmentResult.fromJson(Map<String, dynamic> json) {
    upcoming = json['upcoming'] != null
        ? new Upcoming.fromJson(json['upcoming'])
        : null;
    past = json['past'] != null ? new Past.fromJson(json['past']) : null;
    deviceToken = json['deviceToken'] != null
        ? new DeviceToken.fromJson(json['deviceToken'])
        : null;
    isCaregiver = json['isCaregiver'];
    chatList = json['chatList'] != null
        ? new ChatList.fromJson(json['chatList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming.toJson();
    }
    if (this.past != null) {
      data['past'] = this.past.toJson();
    }
    if (this.deviceToken != null) {
      data['deviceToken'] = this.deviceToken.toJson();
    }
    data['isCaregiver'] = this.isCaregiver;

    if (this.chatList != null) {
      data['chatList'] = this.chatList.toJson();
    }

    return data;
  }
}

class Upcoming {
  String id;
  String bookingId;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  String actualStartDateTime;
  String actualEndDateTime;
  int slotNumber;
  bool isHealthRecordShared;
  String plannedFollowupDate;
  bool isRefunded;
  bool isFollowupFee;
  bool isFollowup;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  //Null sharedHealthRecordMetadata;

  Upcoming({this.id,
    this.bookingId,
    this.doctorSessionId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.slotNumber,
    this.isHealthRecordShared,
    this.plannedFollowupDate,
    this.isRefunded,
    this.isFollowupFee,
    this.isFollowup,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn
    //this.sharedHealthRecordMetadata
  });

  Upcoming.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    doctorSessionId = json['doctorSessionId'];
    plannedStartDateTime = json['plannedStartDateTime'];
    plannedEndDateTime = json['plannedEndDateTime'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
    slotNumber = json['slotNumber'];
    isHealthRecordShared = json['isHealthRecordShared'];
    plannedFollowupDate = json['plannedFollowupDate'];
    isRefunded = json['isRefunded'];
    isFollowupFee = json['isFollowupFee'];
    isFollowup = json['isFollowup'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    //sharedHealthRecordMetadata = json['sharedHealthRecordMetadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    data['doctorSessionId'] = this.doctorSessionId;
    data['plannedStartDateTime'] = this.plannedStartDateTime;
    data['plannedEndDateTime'] = this.plannedEndDateTime;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    data['slotNumber'] = this.slotNumber;
    data['isHealthRecordShared'] = this.isHealthRecordShared;
    data['plannedFollowupDate'] = this.plannedFollowupDate;
    data['isRefunded'] = this.isRefunded;
    data['isFollowupFee'] = this.isFollowupFee;
    data['isFollowup'] = this.isFollowup;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    //data['sharedHealthRecordMetadata'] = this.sharedHealthRecordMetadata;
    return data;
  }
}

class Past {
  String id;
  String bookingId;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  String actualStartDateTime;
  String actualEndDateTime;
  int slotNumber;
  bool isHealthRecordShared;
  String plannedFollowupDate;
  bool isRefunded;
  bool isFollowupFee;
  bool isFollowup;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  //SharedHealthRecordMetadata sharedHealthRecordMetadata;

  Past({this.id,
    this.bookingId,
    this.doctorSessionId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.slotNumber,
    this.isHealthRecordShared,
    this.plannedFollowupDate,
    this.isRefunded,
    this.isFollowupFee,
    this.isFollowup,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn
    //this.sharedHealthRecordMetadata
  });

  Past.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    doctorSessionId = json['doctorSessionId'];
    plannedStartDateTime = json['plannedStartDateTime'];
    plannedEndDateTime = json['plannedEndDateTime'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
    slotNumber = json['slotNumber'];
    isHealthRecordShared = json['isHealthRecordShared'];
    plannedFollowupDate = json['plannedFollowupDate'];
    isRefunded = json['isRefunded'];
    isFollowupFee = json['isFollowupFee'];
    isFollowup = json['isFollowup'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    /*sharedHealthRecordMetadata = json['sharedHealthRecordMetadata'] != null
        ? new SharedHealthRecordMetadata.fromJson(
        json['sharedHealthRecordMetadata'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    data['doctorSessionId'] = this.doctorSessionId;
    data['plannedStartDateTime'] = this.plannedStartDateTime;
    data['plannedEndDateTime'] = this.plannedEndDateTime;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    data['slotNumber'] = this.slotNumber;
    data['isHealthRecordShared'] = this.isHealthRecordShared;
    data['plannedFollowupDate'] = this.plannedFollowupDate;
    data['isRefunded'] = this.isRefunded;
    data['isFollowupFee'] = this.isFollowupFee;
    data['isFollowup'] = this.isFollowup;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    /*if (this.sharedHealthRecordMetadata != null) {
      data['sharedHealthRecordMetadata'] =
          this.sharedHealthRecordMetadata.toJson();
    }*/
    return data;
  }
}

class SharedHealthRecordMetadata {
  String id;
  Metadata metadata;
  bool isBookmarked;
  bool isCompleted;
  bool isDraft;
  bool isVisible;
  bool isClaimed;
  bool isClaimRecord;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  SharedHealthRecordMetadata({this.id,
    this.metadata,
    this.isBookmarked,
    this.isCompleted,
    this.isDraft,
    this.isVisible,
    this.isClaimed,
    this.isClaimRecord,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn});

  SharedHealthRecordMetadata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    isBookmarked = json['isBookmarked'];
    isCompleted = json['isCompleted'];
    isDraft = json['isDraft'];
    isVisible = json['isVisible'];
    isClaimed = json['isClaimed'];
    isClaimRecord = json['isClaimRecord'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['isBookmarked'] = this.isBookmarked;
    data['isCompleted'] = this.isCompleted;
    data['isDraft'] = this.isDraft;
    data['isVisible'] = this.isVisible;
    data['isClaimed'] = this.isClaimed;
    data['isClaimRecord'] = this.isClaimRecord;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class Metadata {
  MediaTypeInfo mediaTypeInfo;
  CategoryInfo categoryInfo;
  List<String> healthRecordsReference;

  Metadata(
      {this.mediaTypeInfo, this.categoryInfo, this.healthRecordsReference});

  Metadata.fromJson(Map<String, dynamic> json) {
    mediaTypeInfo = json['mediaTypeInfo'] != null
        ? new MediaTypeInfo.fromJson(json['mediaTypeInfo'])
        : null;
    categoryInfo = json['categoryInfo'] != null
        ? new CategoryInfo.fromJson(json['categoryInfo'])
        : null;
    healthRecordsReference = json['healthRecordsReference'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaTypeInfo != null) {
      data['mediaTypeInfo'] = this.mediaTypeInfo.toJson();
    }
    if (this.categoryInfo != null) {
      data['categoryInfo'] = this.categoryInfo.toJson();
    }
    data['healthRecordsReference'] = this.healthRecordsReference;
    return data;
  }
}

class MediaTypeInfo {
  String id;
  String name;
  String description;
  String logo;
  bool isDisplay;
  bool isAiTranscription;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  MediaTypeInfo({this.id,
    this.name,
    this.description,
    this.logo,
    this.isDisplay,
    this.isAiTranscription,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn});

  MediaTypeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    isDisplay = json['isDisplay'];
    isAiTranscription = json['isAiTranscription'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['isDisplay'] = this.isDisplay;
    data['isAiTranscription'] = this.isAiTranscription;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class CategoryInfo {
  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  bool isDisplay;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  CategoryInfo({this.id,
    this.categoryName,
    this.categoryDescription,
    this.logo,
    this.isDisplay,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
    logo = json['logo'];
    isDisplay = json['isDisplay'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryDescription'] = this.categoryDescription;
    data['logo'] = this.logo;
    data['isDisplay'] = this.isDisplay;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class DeviceToken {
  Doctor doctor;
  Doctor patient;
  Doctor parentMember;

  DeviceToken({this.doctor, this.patient});

  DeviceToken.fromJson(Map<String, dynamic> json) {
    doctor =
    json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    patient =
    json['patient'] != null ? new Doctor.fromJson(json['patient']) : null;
    parentMember = json['parentMember'] != null
        ? new Doctor.fromJson(json['parentMember'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient.toJson();
    }
    if (this.parentMember != null) {
      data['parentMember'] = this.parentMember.toJson();
    }
    return data;
  }
}

class Doctor {
  bool isSuccess;
  List<Payload> payload;

  Doctor({this.isSuccess, this.payload});

  Doctor.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['payload'] != null) {
      payload = new List<Payload>();
      json['payload'].forEach((v) {
        payload.add(new Payload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  String id;
  String deviceTokenId;
  String platformTypeCode;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  Payload({this.id,
    this.deviceTokenId,
    this.platformTypeCode,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceTokenId = json['deviceTokenId'];
    platformTypeCode = json['platformTypeCode'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deviceTokenId'] = this.deviceTokenId;
    data['platformTypeCode'] = this.platformTypeCode;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class ChatList {

  /* String chatListId;

  String peerId;

  String userId;

  var peerSocketId;

  var userSocketId;

  var actualUserId;*/

  bool isDisable;

  //var isMuted;


  ChatList({ /*this.chatListId,

      this.peerId,

      this.userId,

      this.peerSocketId,

      this.userSocketId,

      this.actualUserId,*/

    this.isDisable,

    /*this.isMuted*/
  });


  ChatList.fromJson(Map<String, dynamic> json) {

    /*chatListId = json['chatListId'];

    peerId = json['peerId'];

    userId = json['userId'];

    peerSocketId = json['peerSocketId'];

    userSocketId = json['userSocketId'];

    actualUserId = json['actualUserId'];*/

    isDisable = json['isDisable'] != null ? json['isDisable'] : false;

    //isMuted = json['isMuted'];

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    /* data['chatListId'] = this.chatListId;

    data['peerId'] = this.peerId;

    data['userId'] = this.userId;

    data['peerSocketId'] = this.peerSocketId;

    data['userSocketId'] = this.userSocketId;

    data['actualUserId'] = this.actualUserId;*/

    data['isDisable'] = this.isDisable;

    //data['isMuted'] = this.isMuted;

    return data;
  }

}
