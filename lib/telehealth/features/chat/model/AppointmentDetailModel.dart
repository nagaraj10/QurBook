
import 'package:myfhb/common/CommonUtil.dart';

class AppointmentDetailModel {
  bool? isSuccess;
  AppointmentResult? result;

  AppointmentDetailModel({this.isSuccess, this.result});

  AppointmentDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result = json['result'] != null
              ? AppointmentResult.fromJson(json['result'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class AppointmentResult {
  Upcoming? upcoming;
  Past? past;
  DeviceToken? deviceToken;
  bool? isCaregiver;
  bool? isPatient;
  ChatList? chatList;
  DoctorOrCarecoordinatorInfo? doctorOrCarecoordinatorInfo;

  AppointmentResult(
      {this.upcoming,
      this.past,
      this.deviceToken,
      this.isCaregiver,
      this.chatList});

  AppointmentResult.fromJson(Map<String, dynamic> json) {
    try {
      upcoming = json['upcoming'] != null
              ? Upcoming.fromJson(json['upcoming'])
              : null;
      past = json['past'] != null ? Past.fromJson(json['past']) : null;
      deviceToken = json['deviceToken'] != null
              ? DeviceToken.fromJson(json['deviceToken'])
              : null;
      isCaregiver = json['isCaregiver'];
      isPatient = json['isPatient'];
      chatList = json['chatList'] != null
              ? ChatList.fromJson(json['chatList'])
              : null;
      doctorOrCarecoordinatorInfo = json['doctorOrCarecoordinatorInfo'] != null
              ? DoctorOrCarecoordinatorInfo.fromJson(
                  json['doctorOrCarecoordinatorInfo'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming!.toJson();
    }
    if (this.past != null) {
      data['past'] = this.past!.toJson();
    }
    if (this.deviceToken != null) {
      data['deviceToken'] = this.deviceToken!.toJson();
    }
    data['isCaregiver'] = this.isCaregiver;
    data['isPatient'] = this.isPatient;

    if (this.chatList != null) {
      data['chatList'] = this.chatList!.toJson();
    }

    return data;
  }
}

class Upcoming {
  String? id;
  String? bookingId;
  String? doctorSessionId;
  String? plannedStartDateTime;
  String? plannedEndDateTime;
  String? actualStartDateTime;
  String? actualEndDateTime;
  int? slotNumber;
  bool? isHealthRecordShared;
  String? plannedFollowupDate;
  bool? isRefunded;
  bool? isFollowupFee;
  bool? isFollowup;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  //Null sharedHealthRecordMetadata;

  Upcoming(
      {this.id,
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
    try {
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
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    //sharedHealthRecordMetadata = json['sharedHealthRecordMetadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? id;
  String? bookingId;
  String? doctorSessionId;
  String? plannedStartDateTime;
  String? plannedEndDateTime;
  String? actualStartDateTime;
  String? actualEndDateTime;
  int? slotNumber;
  bool? isHealthRecordShared;
  String? plannedFollowupDate;
  bool? isRefunded;
  bool? isFollowupFee;
  bool? isFollowup;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  //SharedHealthRecordMetadata sharedHealthRecordMetadata;

  Past(
      {this.id,
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
    try {
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
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    /*sharedHealthRecordMetadata = json['sharedHealthRecordMetadata'] != null
        ? new SharedHealthRecordMetadata.fromJson(
        json['sharedHealthRecordMetadata'])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? id;
  Metadata? metadata;
  bool? isBookmarked;
  bool? isCompleted;
  bool? isDraft;
  bool? isVisible;
  bool? isClaimed;
  bool? isClaimRecord;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  SharedHealthRecordMetadata(
      {this.id,
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
    try {
      id = json['id'];
      metadata = json['metadata'] != null
              ? Metadata.fromJson(json['metadata'])
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
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
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
  MediaTypeInfo? mediaTypeInfo;
  CategoryInfo? categoryInfo;
  List<String>? healthRecordsReference;

  Metadata(
      {this.mediaTypeInfo, this.categoryInfo, this.healthRecordsReference});

  Metadata.fromJson(Map<String, dynamic> json) {
    try {
      mediaTypeInfo = json['mediaTypeInfo'] != null
              ? MediaTypeInfo.fromJson(json['mediaTypeInfo'])
              : null;
      categoryInfo = json['categoryInfo'] != null
              ? CategoryInfo.fromJson(json['categoryInfo'])
              : null;
      healthRecordsReference = json['healthRecordsReference'].cast<String>();
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.mediaTypeInfo != null) {
      data['mediaTypeInfo'] = this.mediaTypeInfo!.toJson();
    }
    if (this.categoryInfo != null) {
      data['categoryInfo'] = this.categoryInfo!.toJson();
    }
    data['healthRecordsReference'] = this.healthRecordsReference;
    return data;
  }
}

class MediaTypeInfo {
  String? id;
  String? name;
  String? description;
  String? logo;
  bool? isDisplay;
  bool? isAiTranscription;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  MediaTypeInfo(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.isDisplay,
      this.isAiTranscription,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  MediaTypeInfo.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      description = json['description'];
      logo = json['logo'];
      isDisplay = json['isDisplay'];
      isAiTranscription = json['isAiTranscription'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? id;
  String? categoryName;
  String? categoryDescription;
  String? logo;
  bool? isDisplay;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  CategoryInfo(
      {this.id,
      this.categoryName,
      this.categoryDescription,
      this.logo,
      this.isDisplay,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      categoryName = json['categoryName'];
      categoryDescription = json['categoryDescription'];
      logo = json['logo'];
      isDisplay = json['isDisplay'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  Doctor? doctor;
  Doctor? patient;
  Doctor? parentMember;

  DeviceToken({this.doctor, this.patient});

  DeviceToken.fromJson(Map<String, dynamic> json) {
    try {
      doctor =
              json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
      patient =
              json['patient'] != null ? Doctor.fromJson(json['patient']) : null;
      parentMember = json['parentMember'] != null
              ? Doctor.fromJson(json['parentMember'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    if (this.parentMember != null) {
      data['parentMember'] = this.parentMember!.toJson();
    }
    return data;
  }
}

class Doctor {
  bool? isSuccess;
  List<Payload>? payload;

  Doctor({this.isSuccess, this.payload});

  Doctor.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['payload'] != null) {
            payload = <Payload>[];
            json['payload'].forEach((v) {
              payload!.add(Payload.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  String? id;
  String? deviceTokenId;
  String? platformTypeCode;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  Payload(
      {this.id,
      this.deviceTokenId,
      this.platformTypeCode,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      deviceTokenId = json['deviceTokenId'];
      platformTypeCode = json['platformTypeCode'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

  bool? isDisable;

  String? deliveredOn;

  //var isMuted;

  ChatList({
    /*this.chatListId,

      this.peerId,

      this.userId,

      this.peerSocketId,

      this.userSocketId,

      this.actualUserId,*/

    this.isDisable,
    this.deliveredOn,

    /*this.isMuted*/
  });

  ChatList.fromJson(Map<String, dynamic> json) {
    /*chatListId = json['chatListId'];

    peerId = json['peerId'];

    userId = json['userId'];

    peerSocketId = json['peerSocketId'];

    userSocketId = json['userSocketId'];

    actualUserId = json['actualUserId'];*/

    try {
      isDisable = json['isDisable'] != null ? json['isDisable'] : false;
      deliveredOn = json['deliveredOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }

    //isMuted = json['isMuted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    /* data['chatListId'] = this.chatListId;

    data['peerId'] = this.peerId;

    data['userId'] = this.userId;

    data['peerSocketId'] = this.peerSocketId;

    data['userSocketId'] = this.userSocketId;

    data['actualUserId'] = this.actualUserId;*/

    data['isDisable'] = this.isDisable;
    data['deliveredOn'] = this.deliveredOn;

    //data['isMuted'] = this.isMuted;

    return data;
  }
}

class DoctorOrCarecoordinatorInfo {
  String? carecoordinatorfirstName;
  String? carecoordinatorMiddleName;
  String? carecoordinatorLastName;
  String? carecoordinatorProfilePicThumbnailUrl;
  bool? isCareCoordinator;

  DoctorOrCarecoordinatorInfo(
      {this.carecoordinatorfirstName,
      this.carecoordinatorMiddleName,
      this.carecoordinatorLastName,
      this.carecoordinatorProfilePicThumbnailUrl,
      this.isCareCoordinator});

  DoctorOrCarecoordinatorInfo.fromJson(Map<String, dynamic> json) {
    try {
      carecoordinatorfirstName = json['carecoordinatorfirstName'];
      carecoordinatorMiddleName = json['carecoordinatorMiddleName'];
      carecoordinatorLastName = json['carecoordinatorLastName'];
      carecoordinatorProfilePicThumbnailUrl =
              json['carecoordinatorProfilePicThumbnailUrl'];
      isCareCoordinator =
              json['isCareCoordinator'] != null ? json['isCareCoordinator'] : false;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['carecoordinatorfirstName'] = this.carecoordinatorfirstName;
    data['carecoordinatorMiddleName'] = this.carecoordinatorMiddleName;
    data['carecoordinatorLastName'] = this.carecoordinatorLastName;
    data['carecoordinatorProfilePicThumbnailUrl'] =
        this.carecoordinatorProfilePicThumbnailUrl;
    data['isCareCoordinator'] = this.isCareCoordinator;
    return data;
  }
}
