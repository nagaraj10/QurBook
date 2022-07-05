class CaregiverPatientChatModel {
  bool isSuccess;
  List<Result> result;

  CaregiverPatientChatModel({this.isSuccess, this.result});

  CaregiverPatientChatModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String id;
  String firstName;
  String middleName;
  String lastName;
  String profilePicThumbnailUrl;
  String relationshipName;
  bool isCarecoordinator;
  String carecoordinatorfirstName;
  String carecoordinatorLastName;
  String carecoordinatorProfilePicThumbnailUrl;
  String carecoordinatorId;
  ChatListItem chatListItem;

  Result(
      {this.id,
        this.firstName,
        this.middleName,
        this.lastName,
        this.profilePicThumbnailUrl,
        this.relationshipName,
        this.isCarecoordinator,
        this.carecoordinatorfirstName,
        this.carecoordinatorLastName,
        this.carecoordinatorProfilePicThumbnailUrl,
        this.carecoordinatorId,
        this.chatListItem});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    relationshipName = json['relationshipName'];
    isCarecoordinator = json['isCarecoordinator'];
    carecoordinatorfirstName = json['carecoordinatorfirstName'];
    carecoordinatorLastName = json['carecoordinatorLastName'];
    carecoordinatorProfilePicThumbnailUrl = json['carecoordinatorProfilePicThumbnailUrl'];
    carecoordinatorId = json['carecoordinatorId'];
    chatListItem = json['chatListItem'] != null
        ? new ChatListItem.fromJson(json['chatListItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['profilePicThumbnailUrl'] = this.profilePicThumbnailUrl;
    data['relationshipName'] = this.relationshipName;
    data['isCarecoordinator'] = this.isCarecoordinator;
    data['carecoordinatorfirstName'] = this.carecoordinatorfirstName;
    data['carecoordinatorLastName'] = this.carecoordinatorLastName;
    data['carecoordinatorProfilePicThumbnailUrl'] = this.carecoordinatorProfilePicThumbnailUrl;
    data['carecoordinatorId'] = this.carecoordinatorId;
    if (this.chatListItem != null) {
      data['chatListItem'] = this.chatListItem.toJson();
    }
    return data;
  }
}

class ChatListItem {
  String id;
  String peerId;
  String userId;
  String createdOn;
  bool isActive;
  bool isDisable;
  bool isMuted;
  int unReadNotificationCount;
  String lastModifiedOn;

  ChatListItem(
      {this.id,
        this.peerId,
        this.userId,
        this.createdOn,
        this.isActive,
        this.isDisable,
        this.isMuted,
        this.unReadNotificationCount,
        this.lastModifiedOn});

  ChatListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    peerId = json['peerId'];
    userId = json['userId'];
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    isDisable = json['isDisable'];
    isMuted = json['isMuted'];
    unReadNotificationCount = json['unReadNotificationCount'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['peerId'] = this.peerId;
    data['userId'] = this.userId;
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['isDisable'] = this.isDisable;
    data['isMuted'] = this.isMuted;
    data['unReadNotificationCount'] = this.unReadNotificationCount;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}